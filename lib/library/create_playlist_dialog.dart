import 'package:flutter/material.dart';

/// Widget 7 — CreatePlaylistDialog
/// Dialog untuk membuat playlist baru (nama + deskripsi opsional).
///
/// Catatan: input teks & tombol di sini sengaja dibuat sendiri (plain
/// TextField/ElevatedButton) supaya widget ini tidak bergantung pada
/// CustomTextField / PrimaryButton milik Anggota 5. Begitu widget mereka
/// sudah jadi, tinggal ganti TextField -> CustomTextField dan
/// ElevatedButton -> PrimaryButton tanpa mengubah logikanya.
class CreatePlaylistDialog extends StatefulWidget {
  /// Dipanggil saat tombol "Buat" ditekan dengan nama & deskripsi yang diisi.
  final void Function(String name, String description) onCreate;

  const CreatePlaylistDialog({
    super.key,
    required this.onCreate,
  });

  /// Helper supaya pemanggilan dialog ini singkat:
  /// `CreatePlaylistDialog.show(context, onCreate: (name, desc) { ... });`
  static Future<void> show(
    BuildContext context, {
    required void Function(String name, String description) onCreate,
  }) {
    return showDialog(
      context: context,
      builder: (_) => CreatePlaylistDialog(onCreate: onCreate),
    );
  }

  @override
  State<CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF282828),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buat Playlist Baru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: _decoration('Nama playlist'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              style: const TextStyle(color: Colors.white),
              decoration: _decoration('Deskripsi (opsional)'),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DB954),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    final name = _nameController.text.trim();
                    if (name.isEmpty) return;
                    widget.onCreate(name, _descController.text.trim());
                    Navigator.of(context).pop();
                  },
                  child: const Text('Buat'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
