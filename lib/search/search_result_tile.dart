import 'package:flutter/material.dart';

enum SearchResultType { song, artist, album }

/// Widget 4 — SearchResultTile
/// Satu baris hasil pencarian (lagu / artis / album).
/// StatelessWidget: semua data dikirim dari parent lewat constructor.
class SearchResultTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final SearchResultType type;
  final VoidCallback? onTap;

  const SearchResultTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.type = SearchResultType.song,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isArtist = type == SearchResultType.artist;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(isArtist ? 28 : 4),
        child: Image.network(
          imageUrl,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            width: 56,
            height: 56,
            color: const Color(0xFF282828),
            child: const Icon(Icons.music_note, color: Colors.white54),
          ),
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 13),
      ),
    );
  }
}