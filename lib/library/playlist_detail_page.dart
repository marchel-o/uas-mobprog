import 'package:flutter/material.dart';
import 'package:flutter_application_3/library/playlist_action_bar.dart';
import 'package:flutter_application_3/library/playlist_header.dart';
import 'package:flutter_application_3/library/song_tile.dart';

/// PlaylistDetailPage — halaman detail satu playlist.
/// Dibuka dari LibraryItemTile (lihat LibraryPage) lewat Navigator.push,
/// jadi halaman ini punya Scaffold + AppBar sendiri (tombol back otomatis).
class PlaylistDetailPage extends StatefulWidget {
  final String title;

  const PlaylistDetailPage({
    super.key,
    required this.title,
  });

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  bool _isDownloaded = false;
  bool _isShuffleOn = false;
  int _playingIndex = -1;

  // Data dummy daftar lagu — nanti idealnya dioper dari LibraryPage atau
  // diambil dari sumber data bersama dengan Anggota 3 (Music Player).
  final List<Map<String, String>> _songs = const [
    {'title': 'A Sorrowful Reunion', 'artist': 'Reality Club'},
    {'title': 'Anything You Want', 'artist': 'Reality Club'},
    {'title': '3008', 'artist': 'Childish Gambino'},
    {'title': 'Hati-Hati di Jalan', 'artist': 'Tulus'},
    {'title': 'Pamungkas', 'artist': 'Ada Band'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            PlaylistHeader(
              title: widget.title,
              creator: 'Kamu',
              songCount: _songs.length,
              totalDuration: '${_songs.length * 3} mnt',
            ),
            const SizedBox(height: 20),
            PlaylistActionBar(
              isDownloaded: _isDownloaded,
              isShuffleOn: _isShuffleOn,
              onDownloadTap: () => setState(() => _isDownloaded = !_isDownloaded),
              onShuffleTap: () => setState(() => _isShuffleOn = !_isShuffleOn),
              onPlayTap: () => setState(() => _playingIndex = 0),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                final song = _songs[index];
                return SongTile(
                  number: index + 1,
                  title: song['title']!,
                  artist: song['artist']!,
                  isPlaying: index == _playingIndex,
                  onTap: () => setState(() => _playingIndex = index),
                  onMoreTap: () {
                    // TODO: integrasikan dengan menu aksi lagu (hapus,
                    // tambah ke playlist lain, dsb.) bila diperlukan.
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
