import 'package:flutter/material.dart' hide RepeatMode;

import '../player_provider.dart' show RepeatMode;
import '../player_theme.dart';

class ShuffleRepeatButtons extends StatelessWidget {
  final bool shuffleOn;
  final RepeatMode repeatMode;
  final VoidCallback onShuffle;
  final VoidCallback onRepeat;
  final Widget centerControls;

  const ShuffleRepeatButtons({
    super.key,
    required this.shuffleOn,
    required this.repeatMode,
    required this.onShuffle,
    required this.onRepeat,
    required this.centerControls,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ToggleIconButton(
          icon: Icons.shuffle_rounded,
          active: shuffleOn,
          tooltip: shuffleOn ? 'Matikan acak' : 'Aktifkan acak',
          onPressed: onShuffle,
        ),
        centerControls,
        _ToggleIconButton(
          icon: repeatMode == RepeatMode.one
              ? Icons.repeat_one_rounded
              : Icons.repeat_rounded,
          active: repeatMode != RepeatMode.off,
          tooltip: switch (repeatMode) {
            RepeatMode.off => 'Ulangi semua',
            RepeatMode.all => 'Ulangi satu lagu',
            RepeatMode.one => 'Matikan ulang',
          },
          onPressed: onRepeat,
        ),
      ],
    );
  }
}

class _ToggleIconButton extends StatelessWidget {
  final IconData icon;
  final bool active;
  final String tooltip;
  final VoidCallback onPressed;

  const _ToggleIconButton({
    required this.icon,
    required this.active,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onPressed,
      radius: 24,
      child: Semantics(
        button: true,
        label: tooltip,
        child: SizedBox(
          width: 40,
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 26,
                color: active ? PlayerTheme.green : PlayerTheme.white,
              ),
              const SizedBox(height: 3),
              SizedBox(
                height: 4,
                child: active
                    ? const DecoratedBox(
                        decoration: BoxDecoration(
                          color: PlayerTheme.green,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(width: 4, height: 4),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
