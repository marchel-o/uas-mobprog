import 'package:flutter/material.dart';

import '../dev/models.dart';
import '../player_theme.dart';

class MiniPlayer extends StatelessWidget {
  final Song song;
  final bool isPlaying;
  final bool isBuffering;
  final double progress;
  final VoidCallback onTap;
  final VoidCallback onPlayPause;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const MiniPlayer({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.isBuffering,
    required this.progress,
    required this.onTap,
    required this.onPlayPause,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: PlayerTheme.surfaceElevated,
          child: InkWell(
            onTap: onTap,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 4),
                    child: Row(
                      children: [
                        _MiniCover(coverUrl: song.coverUrl),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: PlayerTheme.fontFamily,
                                  color: PlayerTheme.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                song.artistName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: PlayerTheme.fontFamily,
                                  color: PlayerTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (onFavoriteToggle != null)
                          IconButton(
                            onPressed: onFavoriteToggle,
                            tooltip: isFavorite
                                ? 'Hapus dari favorit'
                                : 'Tambahkan ke favorit',
                            icon: _MiniFavoriteIcon(isFavorite: isFavorite),
                          ),
                        IconButton(
                          onPressed: onPlayPause,
                          tooltip: isPlaying ? 'Jeda' : 'Putar',
                          color: PlayerTheme.white,
                          iconSize: 32,
                          icon: isBuffering
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: PlayerTheme.white,
                                  ),
                                )
                              : Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 2,
                  color: PlayerTheme.white,
                  backgroundColor: PlayerTheme.inactiveTrack,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniCover extends StatelessWidget {
  final String coverUrl;

  const _MiniCover({required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        width: 42,
        height: 42,
        child: coverUrl.isEmpty
            ? const _MiniCoverPlaceholder()
            : Image.network(
                coverUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : const _MiniCoverPlaceholder(),
                errorBuilder: (context, error, stackTrace) =>
                    const _MiniCoverPlaceholder(),
              ),
      ),
    );
  }
}

class _MiniCoverPlaceholder extends StatelessWidget {
  const _MiniCoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: PlayerTheme.inactiveTrack,
      child: Icon(Icons.music_note, color: PlayerTheme.textSecondary, size: 22),
    );
  }
}

class _MiniFavoriteIcon extends StatelessWidget {
  final bool isFavorite;

  const _MiniFavoriteIcon({required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFavorite ? PlayerTheme.green : Colors.transparent,
        border: isFavorite
            ? null
            : Border.all(color: PlayerTheme.textSecondary, width: 2),
      ),
      child: Icon(
        isFavorite ? Icons.check : Icons.add,
        size: 16,
        color: isFavorite ? PlayerTheme.black : PlayerTheme.textSecondary,
      ),
    );
  }
}
