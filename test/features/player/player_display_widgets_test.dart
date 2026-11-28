import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/player/dev/models.dart';
import 'package:flutter_application_3/features/player/player_theme.dart';
import 'package:flutter_application_3/features/player/widgets/album_art_display.dart';
import 'package:flutter_application_3/features/player/widgets/mini_player.dart';
import 'package:flutter_application_3/features/player/widgets/song_info_header.dart';
import 'package:flutter_test/flutter_test.dart';

const Song sampleSong = Song(
  id: '916424',
  title: 'Without Me',
  artistName: 'Eminem',
  albumTitle: 'The Eminem Show',
  coverUrl: '',
  previewUrl: '',
  durationSec: 290,
);

Widget wrap(Widget child) {
  return MaterialApp(
    theme: ThemeData.dark(),
    home: Scaffold(
      body: Center(child: SizedBox(width: 360, child: child)),
    ),
  );
}

Widget miniPlayer({
  bool isPlaying = false,
  bool isBuffering = false,
  double progress = 0.4,
  bool isFavorite = false,
  VoidCallback? onFavoriteToggle,
  String? errorMessage,
  VoidCallback? onTap,
  VoidCallback? onPlayPause,
}) {
  return wrap(
    MiniPlayer(
      song: sampleSong,
      isPlaying: isPlaying,
      isBuffering: isBuffering,
      progress: progress,
      onTap: onTap ?? () {},
      onPlayPause: onPlayPause ?? () {},
      isFavorite: isFavorite,
      onFavoriteToggle: onFavoriteToggle,
      errorMessage: errorMessage,
    ),
  );
}

void main() {
  group('MiniPlayer', () {
    testWidgets('menampilkan judul lagu dan nama artis', (tester) async {
      await tester.pumpWidget(miniPlayer());

      expect(find.text('Without Me'), findsOneWidget);
      expect(find.text('Eminem'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsNothing);
    });

    testWidgets('mengganti nama artis dengan pesan error', (tester) async {
      await tester.pumpWidget(
        miniPlayer(errorMessage: 'Tidak ada koneksi internet'),
      );

      expect(find.text('Without Me'), findsOneWidget);
      expect(find.text('Tidak ada koneksi internet'), findsOneWidget);
      expect(find.text('Eminem'), findsNothing);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('menampilkan nama artis saat error string kosong', (
      tester,
    ) async {
      await tester.pumpWidget(miniPlayer(errorMessage: ''));

      expect(find.text('Eminem'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsNothing);
    });

    testWidgets('menyembunyikan tombol favorit tanpa callback', (tester) async {
      await tester.pumpWidget(miniPlayer());

      expect(find.byTooltip('Tambahkan ke favorit'), findsNothing);
      expect(find.byTooltip('Hapus dari favorit'), findsNothing);
    });

    testWidgets('menampilkan tombol favorit nonaktif saat callback tersedia', (
      tester,
    ) async {
      await tester.pumpWidget(miniPlayer(onFavoriteToggle: () {}));

      expect(find.byTooltip('Tambahkan ke favorit'), findsOneWidget);
      expect(find.byTooltip('Hapus dari favorit'), findsNothing);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('menampilkan tombol favorit aktif saat isFavorite true', (
      tester,
    ) async {
      await tester.pumpWidget(
        miniPlayer(isFavorite: true, onFavoriteToggle: () {}),
      );

      expect(find.byTooltip('Hapus dari favorit'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
    });

    testWidgets('memicu onFavoriteToggle saat tombol favorit ditekan', (
      tester,
    ) async {
      var toggled = 0;
      await tester.pumpWidget(miniPlayer(onFavoriteToggle: () => toggled++));

      await tester.tap(find.byTooltip('Tambahkan ke favorit'));
      await tester.pump();

      expect(toggled, 1);
    });

    testWidgets('memicu onTap saat kartu ditekan', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(miniPlayer(onTap: () => tapped++));

      await tester.tapAt(
        tester.getTopLeft(find.byType(MiniPlayer)) + const Offset(20, 20),
      );
      await tester.pump();

      expect(tapped, 1);
    });

    testWidgets('memicu onPlayPause saat tombol putar ditekan', (tester) async {
      var pressed = 0;
      await tester.pumpWidget(miniPlayer(onPlayPause: () => pressed++));

      await tester.tap(find.byTooltip('Putar'));
      await tester.pump();

      expect(pressed, 1);
    });

    testWidgets('menampilkan ikon jeda saat lagu diputar', (tester) async {
      await tester.pumpWidget(miniPlayer(isPlaying: true));

      expect(find.byIcon(Icons.pause), findsOneWidget);
      expect(find.byTooltip('Jeda'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsNothing);
    });

    testWidgets('menampilkan indikator loading saat buffering', (tester) async {
      await tester.pumpWidget(miniPlayer(isPlaying: true, isBuffering: true));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsNothing);
      expect(find.byIcon(Icons.pause), findsNothing);
    });

    testWidgets('menampilkan placeholder cover saat coverUrl kosong', (
      tester,
    ) async {
      await tester.pumpWidget(miniPlayer());

      expect(find.byIcon(Icons.music_note), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    for (final progress in <double>[double.nan, -0.5, 1.5, 0.25]) {
      testWidgets('meng-clamp progress $progress tanpa error', (tester) async {
        await tester.pumpWidget(miniPlayer(progress: progress));

        final bar = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );
        final expected = progress.isFinite
            ? progress.clamp(0.0, 1.0).toDouble()
            : 0.0;

        expect(bar.value, expected);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('SongInfoHeader', () {
    Widget header({bool isFavorite = false, VoidCallback? onFavoriteToggle}) {
      return wrap(
        SongInfoHeader(
          title: 'Without Me',
          artistName: 'Eminem',
          isFavorite: isFavorite,
          onFavoriteToggle: onFavoriteToggle ?? () {},
        ),
      );
    }

    testWidgets('menampilkan judul lagu dan nama artis', (tester) async {
      await tester.pumpWidget(header());

      expect(find.text('Without Me'), findsOneWidget);
      expect(find.text('Eminem'), findsOneWidget);
    });

    testWidgets('memicu onFavoriteToggle saat ikon ditekan', (tester) async {
      var toggled = 0;
      await tester.pumpWidget(header(onFavoriteToggle: () => toggled++));

      await tester.tap(find.byTooltip('Tambahkan ke favorit'));
      await tester.pump();

      expect(toggled, 1);
    });

    testWidgets('menampilkan tombol tambah saat belum favorit', (tester) async {
      await tester.pumpWidget(header(isFavorite: false));

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
      expect(find.byTooltip('Tambahkan ke favorit'), findsOneWidget);
    });

    testWidgets('menampilkan centang hijau saat favorit', (tester) async {
      await tester.pumpWidget(header(isFavorite: true));

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.byTooltip('Hapus dari favorit'), findsOneWidget);

      final container = tester.widget<Container>(
        find
            .ancestor(
              of: find.byIcon(Icons.check),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;

      expect(decoration.color, const Color(0xFF1DB954));
      expect(decoration.color, PlayerTheme.green);
    });
  });

  group('AlbumArtDisplay', () {
    testWidgets('menampilkan placeholder saat coverUrl kosong', (tester) async {
      await tester.pumpWidget(wrap(const AlbumArtDisplay(coverUrl: '')));

      expect(find.byIcon(Icons.music_note), findsOneWidget);
      expect(tester.takeException(), isNull);

      final box = tester.widget<ColoredBox>(
        find
            .ancestor(
              of: find.byIcon(Icons.music_note),
              matching: find.byType(ColoredBox),
            )
            .first,
      );
      expect(box.color, const Color(0xFF282828));
      expect(box.color, PlayerTheme.surfaceElevated);
    });

    testWidgets('mempertahankan rasio persegi 1:1', (tester) async {
      await tester.pumpWidget(wrap(const AlbumArtDisplay(coverUrl: '')));

      final aspect = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(aspect.aspectRatio, 1);
      expect(
        tester.getSize(find.byType(AspectRatio)).width,
        tester.getSize(find.byType(AspectRatio)).height,
      );
    });
  });
}
