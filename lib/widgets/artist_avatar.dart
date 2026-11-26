import 'package:flutter/material.dart';
import 'package:flutter_application_3/theme/app_theme.dart';

class ArtistAvatar extends StatelessWidget {
  const ArtistAvatar({super.key, required this.name, this.imageUrl});

  final String name;
  final String? imageUrl; 

  @override
  Widget build(BuildContext context) {
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.surface,
            backgroundImage: imageUrl == null ? null : NetworkImage(imageUrl!),
            child: imageUrl == null
                ? Text(initial, style: const TextStyle(fontSize: 22))
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}