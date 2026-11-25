import 'package:flutter/material.dart';

import '../player_theme.dart';

class SongInfoHeader extends StatelessWidget {
  final String title;
  final String artistName;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const SongInfoHeader({
    super.key,
    required this.title,
    required this.artistName,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: PlayerTheme.fontFamily,
                  color: PlayerTheme.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                artistName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: PlayerTheme.fontFamily,
                  color: PlayerTheme.textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onFavoriteToggle,
          tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambahkan ke favorit',
          icon: _FavoriteIcon(isFavorite: isFavorite),
        ),
      ],
    );
  }
}

class _FavoriteIcon extends StatelessWidget {
  final bool isFavorite;

  const _FavoriteIcon({required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFavorite ? PlayerTheme.green : Colors.transparent,
        border: isFavorite
            ? null
            : Border.all(color: PlayerTheme.textSecondary, width: 2),
      ),
      child: Icon(
        isFavorite ? Icons.check : Icons.add,
        size: 18,
        color: isFavorite ? PlayerTheme.black : PlayerTheme.textSecondary,
      ),
    );
  }
}
