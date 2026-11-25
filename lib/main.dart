import 'package:flutter/material.dart';
import 'package:flutter_application_3/home/screen.dart';

void main() {
  runApp(const SpotifyCloneApp());
}

class SpotifyCloneApp extends StatelessWidget {
  const SpotifyCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1DB954),
        ),
      ),
      home: const CurrentScreen(),
    );
  }
}

class CurrentScreen extends StatelessWidget {
  const CurrentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: HomeScreen()
      ),
    );
  }
}