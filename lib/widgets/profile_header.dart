import 'package:flutter/material.dart';
import 'package:flutter_application_3/theme/app_theme.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.followingCount,
    required this.onAvatarTap,
    this.image,
  });

  final String name;
  final int followingCount;
  final ImageProvider? image;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();
    return Row(
      children: [
        Semantics(
          button: true,
          label: 'Ganti foto profil',
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onAvatarTap,
            child: SizedBox(
              width: 92,
              height: 92,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.surface,
                    backgroundImage: image,
                    child: image == null
                        ? Text(initial, style: const TextStyle(fontSize: 32))
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '$followingCount artis diikuti',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}