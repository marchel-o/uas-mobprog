import 'package:flutter/foundation.dart';
import 'package:flutter_application_3/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileStore {
  static const photoKey = 'profile_image_path';

  static final ValueNotifier<String> name = ValueNotifier('');
  static final ValueNotifier<String?> photoPath = ValueNotifier(null);

  static Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    name.value = await AuthService().currentName();
    photoPath.value = p.getString(photoKey);
  }
}