class Song {
  final String id;
  final String title;
  final String artistName;
  final String albumTitle;
  final String coverUrl;
  final String previewUrl;
  final int durationSec;

  const Song({
    required this.id,
    required this.title,
    required this.artistName,
    required this.albumTitle,
    required this.coverUrl,
    required this.previewUrl,
    required this.durationSec,
  });
}

class Artist {
  final String id;
  final String name;
  final String imageUrl;

  const Artist({required this.id, required this.name, required this.imageUrl});
}

class Album {
  final String id;
  final String title;
  final String coverUrl;
  final String artistName;

  const Album({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.artistName,
  });
}

class Playlist {
  final String id;
  final String name;
  final String coverUrl;
  final List<Song> songs;

  const Playlist({
    required this.id,
    required this.name,
    required this.coverUrl,
    required this.songs,
  });
}
