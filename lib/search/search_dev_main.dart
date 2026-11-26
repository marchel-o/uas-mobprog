import 'package:flutter/material.dart';
import 'package:flutter_application_3/search/search_page.dart';

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
      home: const SearchPage(),
    );
  }
}