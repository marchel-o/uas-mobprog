import 'package:flutter/material.dart';

/// Widget 5 — SongTile
/// Satu baris lagu di dalam PlaylistDetailPage: nomor urut, judul, artis,
/// dan menu titik tiga (more options).
class SongTile extends StatelessWidget {
  final int number;
  final String title;
  final String artist;
  final bool isPlaying;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const SongTile({
    super.key,
    required this.number,
    required this.title,
    required this.artist,
    this.isPlaying = false,
    this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF1DB954);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: isPlaying
                  ? Icon(Icons.graphic_eq, size: 16, color: activeColor)
                  : Text(
                      '$number',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isPlaying ? activeColor : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              iconSize: 20,
              style: IconButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.all(4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: onMoreTap,
            ),
          ],
        ),
      ),
    );
  }
}
