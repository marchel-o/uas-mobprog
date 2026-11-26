import 'package:flutter/material.dart';

import '../dev/models.dart';
import '../player_provider.dart';
import '../player_theme.dart';
import '../widgets/album_art_display.dart';
import '../widgets/player_controls.dart';
import '../widgets/player_progress_bar.dart';
import '../widgets/shuffle_repeat_buttons.dart';
import '../widgets/song_info_header.dart';

class NowPlayingPage extends StatelessWidget {
  final bool Function(Song song)? isFavorite;
  final ValueChanged<Song>? onFavoriteToggle;

  const NowPlayingPage({super.key, this.isFavorite, this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    final provider = PlayerProvider.instance;
    return Scaffold(
      backgroundColor: PlayerTheme.background,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [PlayerTheme.gradientTop, PlayerTheme.background],
          ),
        ),
        child: SafeArea(
          child: ListenableBuilder(
            listenable: provider,
            builder: (context, _) {
              final song = provider.currentSong;
              return Column(
                children: [
                  _Header(albumTitle: song?.albumTitle),
                  if (song == null)
                    const Expanded(child: _EmptyState())
                  else
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        child: Column(
                          children: [
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final side =
                                      constraints.maxWidth <
                                          constraints.maxHeight
                                      ? constraints.maxWidth
                                      : constraints.maxHeight;
                                  return Center(
                                    child: SizedBox(
                                      width: side,
                                      height: side,
                                      child: AlbumArtDisplay(
                                        coverUrl: song.coverUrl,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            SongInfoHeader(
                              title: song.title,
                              artistName: song.artistName,
                              isFavorite: isFavorite?.call(song) ?? false,
                              onFavoriteToggle: () =>
                                  onFavoriteToggle?.call(song),
                            ),
                            if (provider.error != null)
                              _ErrorBanner(message: provider.error!),
                            const SizedBox(height: 8),
                            PlayerProgressBar(
                              position: provider.position,
                              duration: provider.duration,
                              onSeek: provider.seek,
                            ),
                            const SizedBox(height: 16),
                            ShuffleRepeatButtons(
                              shuffleOn: provider.shuffleOn,
                              repeatMode: provider.repeatMode,
                              onShuffle: provider.toggleShuffle,
                              onRepeat: provider.cycleRepeat,
                              centerControls: PlayerControls(
                                isPlaying: provider.isPlaying,
                                isBuffering: provider.isBuffering,
                                hasPrevious: provider.hasPrevious,
                                hasNext: provider.hasNext,
                                onPlayPause: provider.togglePlay,
                                onPrevious: provider.previous,
                                onNext: provider.next,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String? albumTitle;

  const _Header({required this.albumTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            tooltip: 'Tutup',
            iconSize: 32,
            color: PlayerTheme.white,
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'SEDANG DIPUTAR DARI',
                  style: TextStyle(
                    fontFamily: PlayerTheme.fontFamily,
                    color: PlayerTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                if (albumTitle != null)
                  Text(
                    albumTitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: PlayerTheme.fontFamily,
                      color: PlayerTheme.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            tooltip: 'Opsi lainnya',
            color: PlayerTheme.white,
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Belum ada lagu yang diputar',
        style: TextStyle(
          fontFamily: PlayerTheme.fontFamily,
          color: PlayerTheme.textSecondary,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            size: 18,
            color: PlayerTheme.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: PlayerTheme.fontFamily,
                color: PlayerTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
