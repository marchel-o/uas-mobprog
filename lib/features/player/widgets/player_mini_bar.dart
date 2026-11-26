import 'package:flutter/material.dart';

import '../dev/models.dart';
import '../pages/now_playing_page.dart';
import '../player_provider.dart';
import 'mini_player.dart';

class PlayerMiniBar extends StatefulWidget {
  final bool Function(Song song)? isFavorite;
  final ValueChanged<Song>? onFavoriteToggle;

  const PlayerMiniBar({super.key, this.isFavorite, this.onFavoriteToggle});

  @override
  State<PlayerMiniBar> createState() => _PlayerMiniBarState();
}

class _PlayerMiniBarState extends State<PlayerMiniBar> {
  final ValueNotifier<int> _widgetVersion = ValueNotifier(0);

  @override
  void didUpdateWidget(PlayerMiniBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _widgetVersion.value++;
    });
  }

  @override
  void dispose() {
    _widgetVersion.dispose();
    super.dispose();
  }

  void _openNowPlaying() {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ListenableBuilder(
              listenable: _widgetVersion,
              builder: (context, _) => NowPlayingPage(
                isFavorite: widget.isFavorite,
                onFavoriteToggle: widget.onFavoriteToggle,
              ),
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = PlayerProvider.instance;
    return ListenableBuilder(
      listenable: provider,
      builder: (context, _) {
        final song = provider.currentSong;
        if (song == null) return const SizedBox.shrink();
        final totalMs = provider.duration.inMilliseconds;
        final progress = totalMs > 0
            ? provider.position.inMilliseconds / totalMs
            : 0.0;
        return MiniPlayer(
          song: song,
          isPlaying: provider.isPlaying,
          isBuffering: provider.isBuffering,
          progress: progress,
          onTap: _openNowPlaying,
          onPlayPause: provider.togglePlay,
          isFavorite: widget.isFavorite?.call(song) ?? false,
          onFavoriteToggle: widget.onFavoriteToggle != null
              ? () => widget.onFavoriteToggle!(song)
              : null,
          errorMessage: provider.error,
        );
      },
    );
  }
}
