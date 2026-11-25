import 'package:flutter/material.dart';

/// Widget 2 — GenreCard
/// Kartu kategori berwarna (Pop, Rock, dst.) untuk halaman Search.
/// StatelessWidget karena tampilannya tetap; aksi tap dikirim ke parent.
class GenreCard extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback? onTap;

  const GenreCard({
    super.key,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}