import 'package:flutter/material.dart';

import '../player_provider.dart';
import '../player_theme.dart';
import '../widgets/player_mini_bar.dart';
import 'dummy_songs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PlayerDevApp());
}

class PlayerDevApp extends StatelessWidget {
  const PlayerDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: PlayerTheme.background,
        colorScheme: const ColorScheme.dark(primary: PlayerTheme.green),
      ),
      home: const _DevHome(),
    );
  }
}

class _DevHome extends StatefulWidget {
  const _DevHome();

  @override
  State<_DevHome> createState() => _DevHomeState();
}

class _DevHomeState extends State<_DevHome> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PlayerTheme.background,
        title: const Text('Lagu dummy'),
      ),
      body: ListView.builder(
        itemCount: dummySongs.length,
        itemBuilder: (context, index) {
          final song = dummySongs[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                song.coverUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  width: 48,
                  height: 48,
                  child: ColoredBox(color: PlayerTheme.surfaceElevated),
                ),
              ),
            ),
            title: Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              song.artistName,
              style: const TextStyle(color: PlayerTheme.textSecondary),
            ),
            onTap: () =>
                PlayerProvider.instance.playSong(song, queue: dummySongs),
          );
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlayerMiniBar(
            isFavorite: _isFavorite,
            onFavoriteToggle: () => setState(() => _isFavorite = !_isFavorite),
          ),
          const SizedBox(height: 4),
          BottomNavigationBar(
            backgroundColor: PlayerTheme.background,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: PlayerTheme.white,
            unselectedItemColor: PlayerTheme.textSecondary,
            currentIndex: 0,
            onTap: (_) {},
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: 'Koleksi Kamu',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
