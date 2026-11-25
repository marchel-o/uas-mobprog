import 'package:flutter/material.dart';

/// Widget 4 — PlaylistHeader
/// Cover besar + judul + info (pembuat, jumlah lagu, durasi) di PlaylistDetailPage.
class PlaylistHeader extends StatelessWidget {
  final String title;
  final String creator;
  final int songCount;
  final String totalDuration; // contoh: "1 j 12 mnt"
  final Color coverColor;

  const PlaylistHeader({
    super.key,
    required this.title,
    required this.creator,
    required this.songCount,
    required this.totalDuration,
    this.coverColor = const Color(0xFF3B3B98),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            height: 220,
            width: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [coverColor, coverColor.withValues(alpha: 0.4)],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.music_note,
              size: 80,
              color: Colors.white70,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Dibuat oleh $creator • $songCount lagu • $totalDuration',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
