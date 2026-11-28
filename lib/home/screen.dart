import 'package:flutter/material.dart';
import 'package:flutter_application_3/home/made_for_you.dart';
import 'package:flutter_application_3/home/most_replayed.dart';
import 'package:flutter_application_3/home/recent_playlist.dart';
import 'package:flutter_application_3/home/topbar.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final recentPlaylists = [
      {'title': 'Liked Songs', 'color': Colors.deepPurple},
      {'title': 'Daily Mix 1', 'color': Colors.teal},
      {'title': 'Indo Pop Hits', 'color': Colors.redAccent},
      {'title': 'Top 50 Indonesia', 'color': Colors.blueGrey},
      {'title': 'Late Night Vibes', 'color': Colors.indigo},
      {'title': 'Top 50 Global', 'color': Colors.green},
    ];

    final madeForYou = [
      {'title': 'Discover Weekly', 'subtitle': 'Your weekly mixtape of fresh music.'},
      {'title': 'Release Radar', 'subtitle': 'Catch all the latest music from artists you follow.'},
      {'title': 'Daily Mix 2', 'subtitle': 'Tulus, Hindia, Nadin Amizah and more'},
      {'title': 'Chill Hits', 'subtitle': 'Kick back to the best new and recent chill hits.'},
    ];

    final categories = [
      {'title': 'Semua'},
      {'title': 'Musik'},
      {'title': 'Podcast'},
      {'title': 'Buku Audio'},
    ];

    final mostReplayed = [
      {'title': "A Sorrowful Reunion", 'artist': 'Reality Club', 'saved': false},
      {'title': "Anything You Want", 'artist': 'Reality Club', 'saved': true},
      {'title': "3008", 'artist': 'Childish Gambino', 'saved': true},
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      children: [
        HomeTopBar(categories: categories),

        HomeRecentPlaylist(recentPlaylists: recentPlaylists),

        const SizedBox(height: 28),

        const Text(
          'Made For You',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 14),

        HomeMadeForYou(madeForYou: madeForYou),

        const SizedBox(height: 28),

        const Text(
          'Sering Diputar',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        HomeMostReplayed(mostReplayed: mostReplayed),
      ],
    );
  }
}