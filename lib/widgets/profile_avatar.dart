  import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/services/profile_store.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({super.key, this.radius = 23});

  final double radius;

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  @override
  void initState() {
    super.initState();
    ProfileStore.load();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: ProfileStore.name,
      builder: (context, name, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: ProfileStore.photoPath,
          builder: (context, path, _) {
            final file =
                (path != null && File(path).existsSync()) ? File(path) : null;
            final initial = name.isEmpty ? '?' : name[0].toUpperCase();
            return CircleAvatar(
              radius: widget.radius,
              backgroundColor: Colors.blue,
              backgroundImage: file == null ? null : FileImage(file),
              child: file == null
                  ? Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}