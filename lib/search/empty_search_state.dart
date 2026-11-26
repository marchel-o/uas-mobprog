import 'package:flutter/material.dart';

/// Widget 6 — EmptySearchState
/// Tampilan saat hasil pencarian kosong.
/// StatelessWidget: hanya menampilkan teks berdasarkan [query].
class EmptySearchState extends StatelessWidget {
  final String query;

  const EmptySearchState({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 64, color: Color(0xFFB3B3B3)),
            const SizedBox(height: 16),
            Text(
              'Tidak ada hasil untuk "$query"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coba kata kunci lain atau periksa ejaanmu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFB3B3B3)),
            ),
          ],
        ),
      ),
    );
  }
}