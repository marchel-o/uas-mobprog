import 'package:flutter/material.dart';

/// Widget 3 — LibraryItemTile
/// Satu baris item di halaman Library, bisa untuk playlist, artis, atau album.
/// [type] menentukan bentuk cover: 'artist' -> bulat, selain itu -> kotak.
class LibraryItemTile extends StatelessWidget {
  final String title;
  final String subtitle; // contoh: "Playlist • 24 lagu" / "Artis"
  final String type; // 'playlist' | 'artist' | 'album' | 'downloaded'
  final Color coverColor;
  final bool isPinned;
  final VoidCallback? onTap;

  const LibraryItemTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.type,
    this.coverColor = const Color(0xFF282828),
    this.isPinned = false,
    this.onTap,
  });

  IconData get _fallbackIcon {
    switch (type) {
      case 'artist':
        return Icons.person;
      case 'album':
        return Icons.album;
      case 'downloaded':
        return Icons.download_done;
      default:
        return Icons.queue_music;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArtist = type == 'artist';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: coverColor,
                borderRadius: isArtist
                    ? null
                    : BorderRadius.circular(6),
                shape: isArtist ? BoxShape.circle : BoxShape.rectangle,
              ),
              child: Icon(_fallbackIcon, color: Colors.white70, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (isPinned) ...[
                        const Icon(Icons.push_pin, size: 12, color: Color(0xFF1DB954)),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
