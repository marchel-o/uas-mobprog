import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import 'dev/models.dart';
import 'services/audio_player_service.dart';
import 'services/deezer_track_service.dart';

enum PlayerRepeatMode { off, all, one }

class PlayerProvider extends ChangeNotifier {
  PlayerProvider._internal() {
    _subscriptions.addAll([
      _audio.positionStream.listen((value) {
        _position = value;
        notifyListeners();
      }),
      _audio.durationStream.listen((value) {
        _duration = value ?? Duration.zero;
        notifyListeners();
      }),
      _audio.playerStateStream.listen(_onPlayerState),
      _audio.errorStream.listen((_) {
        if (_loading) return;
        _error = 'Pemutaran terganggu, coba lagi';
        notifyListeners();
      }),
    ]);
  }

  static final PlayerProvider instance = PlayerProvider._internal();

  static const Duration _restartThreshold = Duration(seconds: 3);

  final AudioPlayerService _audio = AudioPlayerService();
  final DeezerTrackService _deezer = DeezerTrackService();
  final List<StreamSubscription<Object?>> _subscriptions = [];
  final Random _random = Random();
  final List<int> _history = [];
  final Set<int> _played = {};

  List<Song> _queue = [];
  int _index = -1;
  int _token = 0;
  bool _loading = false;
  bool _playing = false;
  bool _completionHandled = false;
  bool _shuffleOn = false;
  PlayerRepeatMode _repeatMode = PlayerRepeatMode.off;
  ProcessingState _processing = ProcessingState.idle;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String? _error;

  Song? get currentSong =>
      _index >= 0 && _index < _queue.length ? _queue[_index] : null;

  List<Song> get queue => UnmodifiableListView(_queue);

  bool get isPlaying => _playing;

  bool get isBuffering =>
      _loading ||
      _processing == ProcessingState.loading ||
      _processing == ProcessingState.buffering;

  Duration get position => _position;

  Duration get duration => _duration;

  bool get shuffleOn => _shuffleOn;

  PlayerRepeatMode get repeatMode => _repeatMode;

  String? get error => _error;

  bool get hasPrevious => _shuffleOn ? _history.isNotEmpty : _index > 0;

  bool get hasNext {
    if (_queue.isEmpty) return false;
    if (_repeatMode == PlayerRepeatMode.all) return true;
    return _shuffleOn ? _remaining().isNotEmpty : _index < _queue.length - 1;
  }

  Future<void> playSong(Song song, {List<Song> queue = const []}) async {
    final list = queue.isEmpty ? [song] : List<Song>.of(queue);
    var index = list.indexWhere((item) => item.id == song.id);
    if (index < 0) {
      list.insert(0, song);
      index = 0;
    }
    _queue = list;
    _history.clear();
    _played.clear();
    await _start(index);
  }

  Future<void> togglePlay() async {
    if (currentSong == null || _loading) return;
    if (_error != null) {
      await _start(_index);
      return;
    }
    if (_playing) {
      await _audio.pause();
      return;
    }
    if (_processing == ProcessingState.completed) {
      await seek(Duration.zero);
    }
    unawaited(_play(_token));
  }

  Future<void> next() async {
    if (!hasNext) return;
    final target = _nextIndex();
    if (_shuffleOn) _history.add(_index);
    await _start(target);
  }

  Future<void> previous() async {
    if (currentSong == null) return;
    if (_position > _restartThreshold || !hasPrevious) {
      await seek(Duration.zero);
      return;
    }
    await _start(_shuffleOn ? _history.removeLast() : _index - 1);
  }

  Future<void> seek(Duration target) async {
    if (currentSong == null) return;
    final clamped = target < Duration.zero
        ? Duration.zero
        : (target > _duration ? _duration : target);
    _completionHandled = false;
    _position = clamped;
    notifyListeners();
    await _audio.seek(clamped);
  }

  void toggleShuffle() {
    _shuffleOn = !_shuffleOn;
    _history.clear();
    _played
      ..clear()
      ..addAll(_index >= 0 ? [_index] : const []);
    notifyListeners();
  }

  void cycleRepeat() {
    _repeatMode = PlayerRepeatMode.values[(_repeatMode.index + 1) % 3];
    notifyListeners();
  }

  Future<void> stop() async {
    _token++;
    _loading = false;
    await _audio.stop();
    _queue = [];
    _index = -1;
    _history.clear();
    _played.clear();
    _playing = false;
    _processing = ProcessingState.idle;
    _completionHandled = false;
    _position = Duration.zero;
    _duration = Duration.zero;
    _error = null;
    notifyListeners();
  }

  List<int> _remaining() => [
    for (var i = 0; i < _queue.length; i++)
      if (i != _index && !_played.contains(i)) i,
  ];

  int _nextIndex() {
    if (_shuffleOn) {
      var candidates = _remaining();
      if (candidates.isEmpty) {
        _played.clear();
        candidates = _queue.length == 1
            ? [_index]
            : [
                for (var i = 0; i < _queue.length; i++)
                  if (i != _index) i,
              ];
      }
      return candidates[_random.nextInt(candidates.length)];
    }
    return _index < _queue.length - 1 ? _index + 1 : 0;
  }

  void _onPlayerState(PlayerState state) {
    _playing = state.playing;
    _processing = state.processingState;
    notifyListeners();
    if (_processing == ProcessingState.completed &&
        !_completionHandled &&
        !_loading &&
        currentSong != null) {
      _completionHandled = true;
      unawaited(_onCompleted());
    }
  }

  Future<void> _onCompleted() async {
    if (_repeatMode == PlayerRepeatMode.one) {
      await seek(Duration.zero);
      unawaited(_play(_token));
      return;
    }
    if (hasNext) {
      await next();
      return;
    }
    await _audio.pause();
    await seek(Duration.zero);
  }

  Future<void> _start(int index) async {
    final token = ++_token;
    final song = _queue[index];
    _index = index;
    _error = null;
    _loading = true;
    _completionHandled = false;
    _position = Duration.zero;
    _duration = Duration.zero;
    if (_shuffleOn) _played.add(index);
    notifyListeners();
    try {
      await _audio.stop();
      await _prepare(song, token);
      if (token != _token) return;
      unawaited(_play(token));
    } on PlayerInterruptedException {
      return;
    } on DeezerTrackException catch (e) {
      if (token == _token) _error = e.message;
    } on PlayerException {
      if (token == _token) _error = 'Lagu tidak dapat diputar';
    } on Exception {
      if (token == _token) _error = 'Gagal memutar lagu';
    } finally {
      if (token == _token) {
        _loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> _prepare(Song song, int token) async {
    if (song.previewUrl.isEmpty) {
      await _loadFresh(song, token);
      return;
    }
    if (token != _token) return;
    try {
      await _audio.load(song.previewUrl);
    } on PlayerException {
      await _loadFresh(song, token);
    }
  }

  Future<void> _loadFresh(Song song, int token) async {
    final url = await _deezer.fetchPreviewUrl(song.id);
    if (token != _token) return;
    await _audio.load(url);
  }

  Future<void> _play(int token) async {
    try {
      await _audio.play();
    } on PlayerException {
      if (token != _token) return;
      _error = 'Lagu tidak dapat diputar';
      notifyListeners();
    } on Exception {
      if (token != _token) return;
      _error = 'Gagal memutar lagu';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    unawaited(_audio.dispose());
    _deezer.dispose();
    super.dispose();
  }
}
