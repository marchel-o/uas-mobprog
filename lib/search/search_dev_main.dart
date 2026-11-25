import 'package:flutter/material.dart';
import 'package:flutter_application_3/search/genre_card.dart';

void main() {
  runApp(const SearchDevApp());
}

class SearchDevApp extends StatelessWidget {
  const SearchDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(primary: Color(0xFF1DB954)),
      ),
      home: const Scaffold(
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: 180,
              height: 100,
              child: GenreCard(title: 'Pop', color: Colors.pink),
            ),
          ),
        ),
      ),
    );
  }
}