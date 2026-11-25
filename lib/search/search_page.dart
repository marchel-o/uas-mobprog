import 'package:flutter/material.dart';
import 'package:flutter_application_3/search/empty_search_state.dart';
import 'package:flutter_application_3/search/genre_grid.dart';
import 'package:flutter_application_3/search/recent_search_item.dart';
import 'package:flutter_application_3/search/search_bar_widget.dart';
import 'package:flutter_application_3/search/search_filter_tabs.dart';
import 'package:flutter_application_3/search/search_result_tile.dart';

/// SearchPage — halaman Search & Browse.
/// StatefulWidget karena menyimpan kata kunci, filter aktif, dan riwayat.
/// Kata kunci kosong  -> tampil riwayat + grid genre.
/// Kata kunci terisi  -> tampil filter tabs + hasil (atau EmptySearchState).
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  int _filterIndex = 0;

  final List<String> _filters = const ['Semua', 'Lagu', 'Artis', 'Album'];
  final List<SearchResultType?> _filterTypes = const [
    null,
    SearchResultType.song,
    SearchResultType.artist,
    SearchResultType.album,
  ];

  // Data dummy — nanti bisa diganti data asli / API.
  final List<String> _recent = ['Daft Punk', 'Eminem', 'Tulus'];

  final List<Map<String, dynamic>> _genres = const [
    {'title': 'Pop', 'color': Colors.pink},
    {'title': 'Rock', 'color': Colors.red},
    {'title': 'Hip-Hop', 'color': Colors.orange},
    {'title': 'Jazz', 'color': Colors.indigo},
    {'title': 'Indie', 'color': Colors.teal},
    {'title': 'Dangdut', 'color': Colors.purple},
  ];

  final List<Map<String, dynamic>> _allResults = const [
    {
      'title': 'Harder, Better, Faster, Stronger',
      'subtitle': 'Lagu • Daft Punk',
      'type': SearchResultType.song,
      'genre': 'Pop',
    },
    {
      'title': 'Daft Punk',
      'subtitle': 'Artis',
      'type': SearchResultType.artist,
      'genre': 'Pop',
    },
    {
      'title': 'Discovery',
      'subtitle': 'Album • Daft Punk',
      'type': SearchResultType.album,
      'genre': 'Pop',
    },
    {
      'title': 'Without Me',
      'subtitle': 'Lagu • Eminem',
      'type': SearchResultType.song,
      'genre': 'Hip-Hop',
    },
    {
      'title': 'Eminem',
      'subtitle': 'Artis',
      'type': SearchResultType.artist,
      'genre': 'Hip-Hop',
    },
    {
      'title': 'Bohemian Rhapsody',
      'subtitle': 'Lagu • Queen',
      'type': SearchResultType.song,
      'genre': 'Rock',
    },
    {
      'title': 'Pamit',
      'subtitle': 'Lagu • Tulus',
      'type': SearchResultType.song,
      'genre': 'Pop',
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _results {
    final q = _query.trim().toLowerCase();
    final type = _filterTypes[_filterIndex];
    return _allResults.where((item) {
      final matchQuery = (item['title'] as String).toLowerCase().contains(q) ||
          (item['subtitle'] as String).toLowerCase().contains(q) ||
          (item['genre'] as String).toLowerCase().contains(q);
      final matchFilter = type == null || item['type'] == type;
      return matchQuery && matchFilter;
    }).toList();
  }

  void _onQueryChanged(String value) {
    setState(() {
      _query = value;
      if (value.trim().isEmpty) _filterIndex = 0;
    });
  }

  // Dipakai saat riwayat / genre ditekan: isi kolom pencarian dari kode.
  void _setQuery(String text) {
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    _onQueryChanged(text);
  }

  void _onSubmitted(String value) {
    final text = value.trim();
    if (text.isEmpty) return;
    setState(() {
      _recent.remove(text);
      _recent.insert(0, text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Cari',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SearchBarWidget(
                controller: _controller,
                onChanged: _onQueryChanged,
                onSubmitted: _onSubmitted,
              ),
            ),
            Expanded(
              child: _query.trim().isEmpty ? _buildBrowse() : _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowse() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_recent.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              'Pencarian terakhir',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          for (final keyword in _recent.take(3))
            RecentSearchItem(
              keyword: keyword,
              onTap: () => _setQuery(keyword),
              onDelete: () => setState(() => _recent.remove(keyword)),
            ),
        ],
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            'Jelajahi semua',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: GenreGrid(
            genres: _genres,
            onGenreTap: _setQuery,
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final results = _results;
    return Column(
      children: [
        const SizedBox(height: 4),
        SearchFilterTabs(
          filters: _filters,
          initialIndex: _filterIndex,
          onChanged: (i) => setState(() => _filterIndex = i),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: results.isEmpty
              ? EmptySearchState(query: _query.trim())
              : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final item = results[index];
                    return SearchResultTile(
                      title: item['title'] as String,
                      subtitle: item['subtitle'] as String,
                      imageUrl: '',
                      type: item['type'] as SearchResultType,
                      onTap: () => debugPrint('Buka: ${item['title']}'),
                    );
                  },
                ),
        ),
      ],
    );
  }
}