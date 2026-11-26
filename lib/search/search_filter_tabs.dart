import 'package:flutter/material.dart';

/// Widget 7 — SearchFilterTabs
/// Baris chip filter hasil pencarian (Lagu, Artis, Album).
/// StatefulWidget karena chip yang aktif berubah saat ditekan.
class SearchFilterTabs extends StatefulWidget {
  final List<String> filters;
  final int initialIndex;
  final ValueChanged<int>? onChanged;

  const SearchFilterTabs({
    super.key,
    this.filters = const ['Semua', 'Lagu', 'Artis', 'Album'],
    this.initialIndex = 0,
    this.onChanged,
  });

  @override
  State<SearchFilterTabs> createState() => _SearchFilterTabsState();
}

class _SearchFilterTabsState extends State<SearchFilterTabs> {
  late int _selectedIndex = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: widget.filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedIndex;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onChanged?.call(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1DB954)
                    : const Color(0xFF282828),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.filters[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}