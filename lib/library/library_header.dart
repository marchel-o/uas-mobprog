import 'package:flutter/material.dart';

/// Widget 1 — LibraryHeader
/// Judul "Your Library" + tombol tambah (untuk membuat playlist baru).
class LibraryHeader extends StatelessWidget {
  final VoidCallback onAddTap;

  const LibraryHeader({
    super.key,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Your Library',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          iconSize: 26,
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFF282828),
            shape: const CircleBorder(),
          ),
          onPressed: onAddTap,
        ),
      ],
    );
  }
}
