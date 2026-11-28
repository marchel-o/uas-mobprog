import 'package:flutter/material.dart';
import 'package:flutter_application_3/home/screen.dart';
import 'package:flutter_application_3/library/library_page.dart';
import 'package:flutter_application_3/search/search_page.dart';
import 'package:flutter_application_3/pages/login_page.dart';
import 'package:flutter_application_3/pages/main_screen.dart';
import 'package:flutter_application_3/services/auth_service.dart';

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
      home: const _Gate(),
    );
  }
}

class _Gate extends StatelessWidget {
  const _Gate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snap.data == true ? const MainScreen() : const LoginPage();
      },
    );
  }
}

class CurrentScreen extends StatefulWidget {
  const CurrentScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CurrentScreenState();
}

class _CurrentScreenState extends State<CurrentScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: HomeScreen()),
    const Center(child: SearchPage()),
    const Center(child: LibraryPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
          ],
        ),
      ),
    );
  }
}