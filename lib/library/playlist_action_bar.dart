import 'package:flutter/material.dart';

/// Widget 6 — PlaylistActionBar
/// Baris tombol aksi di PlaylistDetailPage: download, shuffle, dan tombol
/// play besar berwarna hijau khas Spotify.
class PlaylistActionBar extends StatelessWidget {
  final bool isDownloaded;
  final bool isShuffleOn;
  final VoidCallback onDownloadTap;
  final VoidCallback onShuffleTap;
  final VoidCallback onPlayTap;

  const PlaylistActionBar({
    super.key,
    required this.isDownloaded,
    required this.isShuffleOn,
    required this.onDownloadTap,
    required this.onShuffleTap,
    required this.onPlayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isDownloaded ? Icons.check_circle : Icons.download_outlined,
            color: isDownloaded ? const Color(0xFF1DB954) : Colors.white70,
          ),
          iconSize: 24,
          onPressed: onDownloadTap,
        ),
        const Spacer(),
        IconButton(
          icon: Icon(
            Icons.shuffle,
            color: isShuffleOn ? const Color(0xFF1DB954) : Colors.white70,
          ),
          iconSize: 24,
          onPressed: onShuffleTap,
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: const Icon(Icons.play_circle_fill),
          iconSize: 56,
          color: const Color(0xFF1DB954),
          onPressed: onPlayTap,
        ),
      ],
    );
  }
}
