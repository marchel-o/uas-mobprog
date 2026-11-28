import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/player/player_provider.dart';
import 'package:flutter_application_3/features/player/player_theme.dart';
import 'package:flutter_application_3/features/player/widgets/play_pause_button.dart';
import 'package:flutter_application_3/features/player/widgets/player_controls.dart';
import 'package:flutter_application_3/features/player/widgets/player_progress_bar.dart';
import 'package:flutter_application_3/features/player/widgets/shuffle_repeat_buttons.dart';
import 'package:flutter_test/flutter_test.dart';

Widget wrap(Widget child) {
  return MaterialApp(
    theme: ThemeData.dark(),
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(child: child),
      ),
    ),
  );
}

void main() {
  group('PlayerProgressBar', () {
    testWidgets('menampilkan waktu berjalan dan sisa waktu negatif', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          PlayerProgressBar(
            position: const Duration(seconds: 10),
            duration: const Duration(seconds: 30),
            onSeek: (_) {},
          ),
        ),
      );

      expect(find.text('0:10'), findsOneWidget);
      expect(find.text('-0:20'), findsOneWidget);
    });

    testWidgets('memformat menit dan detik saat durasi lebih dari satu menit', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          PlayerProgressBar(
            position: const Duration(seconds: 30),
            duration: const Duration(seconds: 200),
            onSeek: (_) {},
          ),
        ),
      );

      expect(find.text('0:30'), findsOneWidget);
      expect(find.text('-2:50'), findsOneWidget);
    });

    testWidgets('menonaktifkan slider saat durasi nol', (tester) async {
      await tester.pumpWidget(
        wrap(
          PlayerProgressBar(
            position: Duration.zero,
            duration: Duration.zero,
            onSeek: (_) {},
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.onChanged, isNull);
      expect(slider.onChangeEnd, isNull);
      expect(slider.value, 0);
      expect(find.text('0:00'), findsOneWidget);
      expect(find.text('-0:00'), findsOneWidget);
    });

    testWidgets('memanggil onSeek dengan durasi yang tepat saat digeser', (
      tester,
    ) async {
      Duration? seeked;
      await tester.pumpWidget(
        wrap(
          PlayerProgressBar(
            position: Duration.zero,
            duration: const Duration(seconds: 200),
            onSeek: (value) => seeked = value,
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.onChanged, isNotNull);
      expect(slider.onChangeEnd, isNotNull);

      slider.onChanged!(120000);
      await tester.pump();
      slider.onChangeEnd!(120000);
      await tester.pump();

      expect(seeked, const Duration(seconds: 120));
    });

    testWidgets('memicu onSeek saat slider benar-benar di-drag', (
      tester,
    ) async {
      Duration? seeked;
      await tester.pumpWidget(
        wrap(
          PlayerProgressBar(
            position: Duration.zero,
            duration: const Duration(seconds: 200),
            onSeek: (value) => seeked = value,
          ),
        ),
      );

      await tester.drag(find.byType(Slider), const Offset(120, 0));
      await tester.pump();

      expect(seeked, isNotNull);
      expect(seeked!.inMilliseconds, inInclusiveRange(1, 200000));
    });

    testWidgets('menampilkan posisi hasil drag sebelum dilepas', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          PlayerProgressBar(
            position: Duration.zero,
            duration: const Duration(seconds: 100),
            onSeek: (_) {},
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      slider.onChanged!(50000);
      await tester.pump();

      expect(find.text('0:50'), findsOneWidget);
      expect(find.text('-0:50'), findsOneWidget);
    });

    testWidgets('mereset posisi drag saat durasi menjadi nol', (tester) async {
      await tester.pumpWidget(
        wrap(
          PlayerProgressBar(
            position: Duration.zero,
            duration: const Duration(seconds: 100),
            onSeek: (_) {},
          ),
        ),
      );

      tester.widget<Slider>(find.byType(Slider)).onChanged!(50000);
      await tester.pump();
      expect(find.text('0:50'), findsOneWidget);

      await tester.pumpWidget(
        wrap(
          PlayerProgressBar(
            position: Duration.zero,
            duration: Duration.zero,
            onSeek: (_) {},
          ),
        ),
      );

      expect(find.text('0:50'), findsNothing);
      expect(find.text('0:00'), findsOneWidget);
      expect(find.text('-0:00'), findsOneWidget);

      await tester.pumpWidget(
        wrap(
          PlayerProgressBar(
            position: const Duration(seconds: 5),
            duration: const Duration(seconds: 100),
            onSeek: (_) {},
          ),
        ),
      );

      expect(find.text('0:05'), findsOneWidget);
      expect(find.text('-1:35'), findsOneWidget);
      expect(tester.widget<Slider>(find.byType(Slider)).value, 5000);
    });

    testWidgets('mereset posisi drag saat durasi berganti ke lagu baru', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          PlayerProgressBar(
            position: Duration.zero,
            duration: const Duration(seconds: 100),
            onSeek: (_) {},
          ),
        ),
      );

      tester.widget<Slider>(find.byType(Slider)).onChanged!(80000);
      await tester.pump();
      expect(find.text('1:20'), findsOneWidget);

      await tester.pumpWidget(
        wrap(
          PlayerProgressBar(
            position: const Duration(seconds: 3),
            duration: const Duration(seconds: 30),
            onSeek: (_) {},
          ),
        ),
      );

      expect(find.text('1:20'), findsNothing);
      expect(find.text('0:03'), findsOneWidget);
      expect(find.text('-0:27'), findsOneWidget);
      expect(tester.widget<Slider>(find.byType(Slider)).value, 3000);
    });

    testWidgets('mempertahankan posisi drag saat durasi tidak berubah', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          PlayerProgressBar(
            position: Duration.zero,
            duration: const Duration(seconds: 100),
            onSeek: (_) {},
          ),
        ),
      );

      tester.widget<Slider>(find.byType(Slider)).onChanged!(50000);
      await tester.pump();

      await tester.pumpWidget(
        wrap(
          PlayerProgressBar(
            position: const Duration(seconds: 2),
            duration: const Duration(seconds: 100),
            onSeek: (_) {},
          ),
        ),
      );

      expect(find.text('0:50'), findsOneWidget);
      expect(find.text('-0:50'), findsOneWidget);
    });
  });

  group('PlayPauseButton', () {
    testWidgets('menampilkan ikon play saat tidak sedang diputar', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          PlayPauseButton(
            isPlaying: false,
            isBuffering: false,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.pause), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('menampilkan ikon pause saat sedang diputar', (tester) async {
      await tester.pumpWidget(
        wrap(
          PlayPauseButton(
            isPlaying: true,
            isBuffering: false,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.pause), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsNothing);
    });

    testWidgets('menampilkan indikator progres saat buffering', (tester) async {
      await tester.pumpWidget(
        wrap(
          PlayPauseButton(isPlaying: true, isBuffering: true, onPressed: () {}),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.pause), findsNothing);
      expect(find.byIcon(Icons.play_arrow), findsNothing);
    });

    testWidgets('memicu onPressed saat ditekan', (tester) async {
      var pressed = 0;
      await tester.pumpWidget(
        wrap(
          PlayPauseButton(
            isPlaying: false,
            isBuffering: false,
            onPressed: () => pressed++,
          ),
        ),
      );

      await tester.tap(
        find.descendant(
          of: find.byType(PlayPauseButton),
          matching: find.byType(InkWell),
        ),
      );
      await tester.pump();

      expect(pressed, 1);
    });
  });

  group('PlayerControls', () {
    Widget controls({
      required bool hasPrevious,
      required bool hasNext,
      VoidCallback? onPrevious,
      VoidCallback? onNext,
    }) {
      return wrap(
        PlayerControls(
          isPlaying: false,
          isBuffering: false,
          hasPrevious: hasPrevious,
          hasNext: hasNext,
          onPlayPause: () {},
          onPrevious: onPrevious ?? () {},
          onNext: onNext ?? () {},
        ),
      );
    }

    testWidgets('memicu onPrevious dan onNext saat tombol aktif', (
      tester,
    ) async {
      var previous = 0;
      var next = 0;

      await tester.pumpWidget(
        controls(
          hasPrevious: true,
          hasNext: true,
          onPrevious: () => previous++,
          onNext: () => next++,
        ),
      );

      await tester.tap(find.byTooltip('Sebelumnya'));
      await tester.tap(find.byTooltip('Berikutnya'));
      await tester.pump();

      expect(previous, 1);
      expect(next, 1);
    });

    testWidgets('menonaktifkan tombol previous dan next sesuai flag', (
      tester,
    ) async {
      var previous = 0;
      var next = 0;

      await tester.pumpWidget(
        controls(
          hasPrevious: false,
          hasNext: false,
          onPrevious: () => previous++,
          onNext: () => next++,
        ),
      );

      await tester.tap(find.byTooltip('Sebelumnya'), warnIfMissed: false);
      await tester.tap(find.byTooltip('Berikutnya'), warnIfMissed: false);
      await tester.pump();

      expect(previous, 0);
      expect(next, 0);
    });

    testWidgets('merender tombol play pause di tengah', (tester) async {
      await tester.pumpWidget(controls(hasPrevious: true, hasNext: true));

      expect(find.byType(PlayPauseButton), findsOneWidget);
      expect(
        tester.getCenter(find.byType(PlayPauseButton)).dx,
        greaterThan(tester.getCenter(find.byTooltip('Sebelumnya')).dx),
      );
      expect(
        tester.getCenter(find.byType(PlayPauseButton)).dx,
        lessThan(tester.getCenter(find.byTooltip('Berikutnya')).dx),
      );
    });
  });

  group('ShuffleRepeatButtons', () {
    Widget buttons({
      bool shuffleOn = false,
      PlayerRepeatMode repeatMode = PlayerRepeatMode.off,
      VoidCallback? onShuffle,
      VoidCallback? onRepeat,
      Widget centerControls = const Text('senter'),
    }) {
      return wrap(
        SizedBox(
          width: 320,
          child: ShuffleRepeatButtons(
            shuffleOn: shuffleOn,
            repeatMode: repeatMode,
            onShuffle: onShuffle ?? () {},
            onRepeat: onRepeat ?? () {},
            centerControls: centerControls,
          ),
        ),
      );
    }

    Finder shuffleTap() => find.byType(InkResponse).first;
    Finder repeatTap() => find.byType(InkResponse).last;

    testWidgets('merender centerControls di antara shuffle dan repeat', (
      tester,
    ) async {
      await tester.pumpWidget(buttons());

      final shuffleX = tester.getCenter(find.byIcon(Icons.shuffle_rounded)).dx;
      final centerX = tester.getCenter(find.text('senter')).dx;
      final repeatX = tester.getCenter(find.byIcon(Icons.repeat_rounded)).dx;

      expect(shuffleX, lessThan(centerX));
      expect(centerX, lessThan(repeatX));
    });

    testWidgets('memicu onShuffle dan onRepeat saat ditekan', (tester) async {
      var shuffle = 0;
      var repeat = 0;

      await tester.pumpWidget(
        buttons(onShuffle: () => shuffle++, onRepeat: () => repeat++),
      );

      await tester.tap(shuffleTap());
      await tester.tap(repeatTap());
      await tester.pump();

      expect(shuffle, 1);
      expect(repeat, 1);
    });

    testWidgets('mode off menampilkan ikon repeat tidak aktif', (tester) async {
      await tester.pumpWidget(buttons(repeatMode: PlayerRepeatMode.off));

      expect(find.byIcon(Icons.repeat_rounded), findsOneWidget);
      expect(find.byIcon(Icons.repeat_one_rounded), findsNothing);
      expect(
        tester.widget<Icon>(find.byIcon(Icons.repeat_rounded)).color,
        PlayerTheme.white,
      );
    });

    testWidgets('mode all menampilkan ikon repeat aktif', (tester) async {
      await tester.pumpWidget(buttons(repeatMode: PlayerRepeatMode.all));

      expect(find.byIcon(Icons.repeat_rounded), findsOneWidget);
      expect(
        tester.widget<Icon>(find.byIcon(Icons.repeat_rounded)).color,
        PlayerTheme.green,
      );
    });

    testWidgets('mode one menampilkan ikon repeat one aktif', (tester) async {
      await tester.pumpWidget(buttons(repeatMode: PlayerRepeatMode.one));

      expect(find.byIcon(Icons.repeat_one_rounded), findsOneWidget);
      expect(
        tester.widget<Icon>(find.byIcon(Icons.repeat_one_rounded)).color,
        PlayerTheme.green,
      );
    });

    testWidgets('shuffle aktif berwarna aksen hijau', (tester) async {
      await tester.pumpWidget(buttons(shuffleOn: true));

      expect(
        tester.widget<Icon>(find.byIcon(Icons.shuffle_rounded)).color,
        PlayerTheme.green,
      );
    });

    testWidgets('shuffle mati berwarna putih', (tester) async {
      await tester.pumpWidget(buttons(shuffleOn: false));

      expect(
        tester.widget<Icon>(find.byIcon(Icons.shuffle_rounded)).color,
        PlayerTheme.white,
      );
    });
  });
}
