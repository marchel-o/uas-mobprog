import 'package:flutter/material.dart';

import '../player_theme.dart';
import 'play_pause_button.dart';

class PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const PlayerControls({
    super.key,
    required this.isPlaying,
    required this.isBuffering,
    required this.hasPrevious,
    required this.hasNext,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SkipButton(
          icon: Icons.skip_previous_rounded,
          tooltip: 'Sebelumnya',
          enabled: hasPrevious,
          onPressed: onPrevious,
        ),
        const SizedBox(width: 12),
        PlayPauseButton(
          isPlaying: isPlaying,
          isBuffering: isBuffering,
          onPressed: onPlayPause,
        ),
        const SizedBox(width: 12),
        _SkipButton(
          icon: Icons.skip_next_rounded,
          tooltip: 'Berikutnya',
          enabled: hasNext,
          onPressed: onNext,
        ),
      ],
    );
  }
}

class _SkipButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool enabled;
  final VoidCallback onPressed;

  const _SkipButton({
    required this.icon,
    required this.tooltip,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onPressed : null,
      tooltip: tooltip,
      iconSize: 44,
      color: PlayerTheme.white,
      disabledColor: PlayerTheme.white.withValues(alpha: 0.35),
      icon: Icon(icon),
    );
  }
}
