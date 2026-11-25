import 'package:flutter/material.dart';
import 'package:flutter_application_3/search/empty_search_state.dart';
import 'package:flutter_application_3/search/genre_grid.dart';
import 'package:flutter_application_3/search/recent_search_item.dart';
import 'package:flutter_application_3/search/search_bar_widget.dart';
import 'package:flutter_application_3/search/search_filter_tabs.dart';
import 'package:flutter_application_3/search/search_result_tile.dart';

void main() {
  runApp(const SearchDevApp());
}

class SearchDevApp extends StatelessWidget {
  const SearchDevApp({super.key});

  static const List<Map<String, dynamic>> _genres = [
    {'title': 'Pop', 'color': Colors.pink},
    {'title': 'Rock', 'color': Colors.red},
    {'title': 'Hip-Hop', 'color': Colors.orange},
    {'title': 'Jazz', 'color': Colors.indigo},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(primary: Color(0xFF1DB954)),
      ),
      home: Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: SearchBarWidget(),
              ),
              SearchFilterTabs(onChanged: (i) => debugPrint('Filter: $i')),
              SizedBox(
                height: 230,
                child: GenreGrid(
                  genres: _genres,
                  onGenreTap: (name) => debugPrint('Genre: $name'),
                ),
              ),
              RecentSearchItem(
                keyword: 'Daft Punk',
                onTap: () => debugPrint('Tap riwayat'),
                onDelete: () => debugPrint('Hapus riwayat'),
              ),
              const SearchResultTile(
                title: 'Harder, Better, Faster, Stronger',
                subtitle: 'Lagu • Daft Punk',
                imageUrl: '',
              ),
              const SearchResultTile(
                title: 'Daft Punk',
                subtitle: 'Artis',
                imageUrl: '',
                type: SearchResultType.artist,
              ),
              const SizedBox(
                height: 260,
                child: EmptySearchState(query: 'xyz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}