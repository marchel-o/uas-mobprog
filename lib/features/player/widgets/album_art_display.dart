import 'package:flutter/material.dart';

import '../player_theme.dart';

class AlbumArtDisplay extends StatelessWidget {
  final String coverUrl;

  const AlbumArtDisplay({super.key, required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: coverUrl.isEmpty
              ? const _CoverPlaceholder()
              : Image.network(
                  coverUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) =>
                      progress == null ? child : const _CoverPlaceholder(),
                  errorBuilder: (context, error, stackTrace) =>
                      const _CoverPlaceholder(),
                ),
        ),
      ),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: PlayerTheme.surfaceElevated,
      child: Center(
        child: Icon(
          Icons.music_note,
          color: PlayerTheme.textSecondary,
          size: 72,
        ),
      ),
    );
  }
}
