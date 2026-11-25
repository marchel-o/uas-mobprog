import 'package:flutter/material.dart';

import '../player_theme.dart';

class PlayerProgressBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;

  const PlayerProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  @override
  State<PlayerProgressBar> createState() => _PlayerProgressBarState();
}

class _PlayerProgressBarState extends State<PlayerProgressBar> {
  double? _dragMs;

  @override
  Widget build(BuildContext context) {
    final totalMs = widget.duration.inMilliseconds;
    final enabled = totalMs > 0;
    final maxMs = enabled ? totalMs.toDouble() : 1.0;
    final currentMs = (_dragMs ?? widget.position.inMilliseconds.toDouble())
        .clamp(0.0, maxMs);
    final elapsed = Duration(milliseconds: currentMs.round());
    final remaining = Duration(milliseconds: (maxMs - currentMs).round());

    const timeStyle = TextStyle(
      fontFamily: PlayerTheme.fontFamily,
      color: PlayerTheme.textSecondary,
      fontSize: 12,
      fontFeatures: [FontFeature.tabularFigures()],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            activeTrackColor: PlayerTheme.white,
            inactiveTrackColor: PlayerTheme.inactiveTrack,
            disabledActiveTrackColor: PlayerTheme.white,
            disabledInactiveTrackColor: PlayerTheme.inactiveTrack,
            thumbColor: PlayerTheme.white,
            disabledThumbColor: PlayerTheme.white,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6,
              disabledThumbRadius: 6,
              elevation: 0,
              pressedElevation: 0,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            overlayColor: PlayerTheme.white.withValues(alpha: 0.12),
            trackShape: const _FullWidthTrackShape(),
          ),
          child: Slider(
            value: enabled ? currentMs : 0,
            min: 0,
            max: maxMs,
            onChanged: enabled
                ? (value) => setState(() => _dragMs = value)
                : null,
            onChangeEnd: enabled
                ? (value) {
                    widget.onSeek(Duration(milliseconds: value.round()));
                    setState(() => _dragMs = null);
                  }
                : null,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_format(elapsed), style: timeStyle),
            Text('-${_format(remaining)}', style: timeStyle),
          ],
        ),
      ],
    );
  }

  String _format(Duration value) {
    final minutes = value.inMinutes;
    final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _FullWidthTrackShape extends RoundedRectSliderTrackShape {
  const _FullWidthTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final height = sliderTheme.trackHeight ?? 4;
    final top = offset.dy + (parentBox.size.height - height) / 2;
    return Rect.fromLTWH(offset.dx, top, parentBox.size.width, height);
  }
}
