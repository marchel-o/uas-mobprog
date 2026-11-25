import 'package:flutter/material.dart';
import 'package:flutter_application_3/library/create_playlist_dialog.dart';
import 'package:flutter_application_3/library/library_filter_chips.dart';
import 'package:flutter_application_3/library/library_header.dart';
import 'package:flutter_application_3/library/library_item_tile.dart';
import 'package:flutter_application_3/library/playlist_detail_page.dart';

/// LibraryPage — halaman "Your Library".
/// Butuh StatefulWidget karena filter chip & daftar playlist bisa berubah
/// (misal setelah user membuat playlist baru lewat CreatePlaylistDialog).
class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int _selectedFilter = 0;

  final List<String> _filters = const ['Playlist', 'Artis', 'Album', 'Downloaded'];

  // Data dummy — nanti bisa diganti dengan data asli dari Anggota 3 (player)
  // atau backend.
  final List<Map<String, dynamic>> _items = [
    {
      'title': 'Liked Songs',
      'subtitle': 'Playlist • 128 lagu',
      'type': 'playlist',
      'color': Colors.deepPurple,
      'pinned': true,
    },
    {
      'title': 'Tulus',
      'subtitle': 'Artis',
      'type': 'artist',
      'color': Colors.teal,
      'pinned': false,
    },
    {
      'title': 'Reality Club',
      'subtitle': 'Artis',
      'type': 'artist',
      'color': Colors.redAccent,
      'pinned': false,
    },
    {
      'title': 'Indo Pop Hits',
      'subtitle': 'Playlist • 42 lagu',
      'type': 'playlist',
      'color': Colors.blueGrey,
      'pinned': false,
    },
    {
      'title': 'Lost in Translation',
      'subtitle': 'Album • Reality Club',
      'type': 'album',
      'color': Colors.indigo,
      'pinned': false,
    },
    {
      'title': 'Late Night Vibes',
      'subtitle': 'Playlist • 60 lagu',
      'type': 'playlist',
      'color': Colors.green,
      'pinned': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    final filterType = switch (_selectedFilter) {
      1 => 'artist',
      2 => 'album',
      3 => 'downloaded',
      _ => null, // index 0 = Playlist tab tapi kita tetap tampilkan semua jenis
    };
    if (filterType == null) return _items;
    return _items.where((item) => item['type'] == filterType).toList();
  }

  void _handleAddPlaylist() {
    CreatePlaylistDialog.show(
      context,
      onCreate: (name, description) {
        setState(() {
          _items.insert(0, {
            'title': name,
            'subtitle': 'Playlist • 0 lagu',
            'type': 'playlist',
            'color': Colors.blueGrey,
            'pinned': false,
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        LibraryHeader(onAddTap: _handleAddPlaylist),
        const SizedBox(height: 16),
        LibraryFilterChips(
          filters: _filters,
          selectedIndex: _selectedFilter,
          onSelected: (index) => setState(() => _selectedFilter = index),
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'Belum ada item di kategori ini',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ...items.map(
            (item) => LibraryItemTile(
              title: item['title'] as String,
              subtitle: item['subtitle'] as String,
              type: item['type'] as String,
              coverColor: item['color'] as Color,
              isPinned: item['pinned'] as bool,
              onTap: () {
                if (item['type'] == 'playlist') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaylistDetailPage(
                        title: item['title'] as String,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
      ],
    );
  }
}
