import 'package:flutter/material.dart';

import '../player_theme.dart';

class PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final VoidCallback onPressed;
  final double size;

  const PlayPauseButton({
    super.key,
    required this.isPlaying,
    required this.isBuffering,
    required this.onPressed,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isPlaying ? 'Jeda' : 'Putar',
      child: SizedBox(
        width: size,
        height: size,
        child: Material(
          color: PlayerTheme.white,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Center(
              child: isBuffering
                  ? SizedBox(
                      width: size * 0.4,
                      height: size * 0.4,
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                        color: PlayerTheme.black,
                      ),
                    )
                  : Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: size * 0.55,
                      color: PlayerTheme.black,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
