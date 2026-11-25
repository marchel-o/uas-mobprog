import 'package:flutter/material.dart';

/// Widget 2 — LibraryFilterChips
/// Baris chip untuk memfilter isi Library (Playlist, Artis, Album, Downloaded).
/// State "chip mana yang aktif" disimpan oleh parent (LibraryPage),
/// jadi widget ini murni StatelessWidget yang menerima [selectedIndex]
/// dan melaporkan balik lewat [onSelected].
class LibraryFilterChips extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const LibraryFilterChips({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1DB954)
                    : const Color(0xFF282828),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                filters[index],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.black : Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
