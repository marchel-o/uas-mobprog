import 'package:flutter/material.dart';

/// Widget 5 — RecentSearchItem
/// Satu baris riwayat pencarian dengan tombol hapus.
/// StatelessWidget: daftar riwayat disimpan parent, widget ini hanya
/// melapor lewat [onTap] dan [onDelete].
class RecentSearchItem extends StatelessWidget {
  final String keyword;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const RecentSearchItem({
    super.key,
    required this.keyword,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: const Icon(Icons.history, color: Color(0xFFB3B3B3)),
      title: Text(
        keyword,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close, color: Color(0xFFB3B3B3)),
        onPressed: onDelete,
      ),
    );
  }
}