import 'package:flutter/material.dart';
import 'package:flutter_application_3/search/genre_card.dart';

/// Widget 3 — GenreGrid
/// Grid 2 kolom berisi daftar GenreCard.
/// StatelessWidget: datanya (nama + warna genre) dikirim dari parent.
class GenreGrid extends StatelessWidget {
  final List<Map<String, dynamic>> genres;
  final ValueChanged<String>? onGenreTap;

  const GenreGrid({
    super.key,
    required this.genres,
    this.onGenreTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.7,
      ),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        final genre = genres[index];
        return GenreCard(
          title: genre['title'] as String,
          color: genre['color'] as Color,
          onTap: () => onGenreTap?.call(genre['title'] as String),
        );
      },
    );
  }
}