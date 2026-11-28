import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/pages/login_page.dart';
import 'package:flutter_application_3/services/auth_service.dart';
import 'package:flutter_application_3/theme/app_theme.dart';
import 'package:flutter_application_3/widgets/artist_avatar.dart';
import 'package:flutter_application_3/widgets/profile_header.dart';
import 'package:flutter_application_3/widgets/settings_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _kPhoto = 'profile_image_path';
  static const _kNotif = 'setting_notif';
  static const _kSaver = 'setting_data_saver';

  final _picker = ImagePicker();
  final _auth = AuthService();

  final List<String> _artists = ['Artis 1', 'Artis 2', 'Artis 3', 'Artis 4'];

  bool _loading = true;
  String _name = '';
  File? _photo;
  bool _notif = true;
  bool _dataSaver = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final name = await _auth.currentName();
    final path = p.getString(_kPhoto);
    final photo = (path != null && File(path).existsSync()) ? File(path) : null;
    if (!mounted) return;
    setState(() {
      _name = name;
      _photo = photo;
      _notif = p.getBool(_kNotif) ?? true;
      _dataSaver = p.getBool(_kSaver) ?? false;
      _loading = false;
    });
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, maxWidth: 800);
      if (picked == null) return;
      final p = await SharedPreferences.getInstance();
      await p.setString(_kPhoto, picked.path);
      if (!mounted) return;
      setState(() => _photo = File(picked.path));
      _snack('Foto profil diperbarui.');
    } catch (e) {
      if (!mounted) return;
      _snack('Gagal mengambil foto: $e');
    }
  }

  void _showPhotoSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(ctx);
                _pick(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(ctx);
                _pick(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setBool(String key, bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(key, value);
  }

  Future<void> _logout() async {
    await _auth.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ProfileHeader(
          name: _name,
          followingCount: _artists.length,
          image: _photo == null ? null : FileImage(_photo!),
          onAvatarTap: _showPhotoSheet,
        ),
        const SizedBox(height: 32),
        Text(
          'Artis yang diikuti',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        if (_artists.isEmpty)
          const Text(
            'Belum mengikuti artis.',
            style: TextStyle(color: AppColors.textSecondary),
          )
        else
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _artists.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => ArtistAvatar(name: _artists[i]),
            ),
          ),
        const SizedBox(height: 24),
        Text('Pengaturan', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SettingsTile(
          icon: Icons.notifications_none,
          title: 'Notifikasi',
          switchValue: _notif,
          onSwitchChanged: (v) {
            setState(() => _notif = v);
            _setBool(_kNotif, v);
          },
        ),
        SettingsTile(
          icon: Icons.data_saver_on,
          title: 'Hemat data',
          switchValue: _dataSaver,
          onSwitchChanged: (v) {
            setState(() => _dataSaver = v);
            _setBool(_kSaver, v);
          },
        ),
        SettingsTile(
          icon: Icons.logout,
          title: 'Keluar',
          onTap: _logout,
        ),
      ],
    );
  }
}