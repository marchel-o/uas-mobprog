import 'package:flutter/material.dart';

import '../pages/now_playing_page.dart';
import '../player_provider.dart';
import '../player_theme.dart';
import 'dummy_songs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PlayerDevApp());
  PlayerProvider.instance.playSong(dummySongs.first, queue: dummySongs);
}

class PlayerDevApp extends StatefulWidget {
  const PlayerDevApp({super.key});

  @override
  State<PlayerDevApp> createState() => _PlayerDevAppState();
}

class _PlayerDevAppState extends State<PlayerDevApp> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: PlayerTheme.background,
        colorScheme: const ColorScheme.dark(primary: PlayerTheme.green),
      ),
      home: NowPlayingPage(
        isFavorite: _isFavorite,
        onFavoriteToggle: () => setState(() => _isFavorite = !_isFavorite),
      ),
    );
  }
}
