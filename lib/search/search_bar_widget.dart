import 'package:flutter/material.dart';

/// Widget 1 — SearchBarWidget
/// Kolom pencarian dengan ikon search dan tombol hapus teks.
/// StatefulWidget karena tombol "x" hanya muncul saat ada teks.
class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Apa yang ingin kamu dengarkan?',
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        widget.onChanged?.call(value);
        setState(() {});
      },
      onSubmitted: widget.onSubmitted,
      style: const TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.black54),
        prefixIcon: const Icon(Icons.search, color: Colors.black87),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close, color: Colors.black87),
                onPressed: _clear,
              ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}