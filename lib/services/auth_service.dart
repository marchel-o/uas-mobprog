import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  static const _kName = 'user_name';
  static const _kEmail = 'user_email';
  static const _kPass = 'user_password';
  static const _kSession = 'is_logged_in';

  Future<bool> isLoggedIn() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kSession) ?? false;
  }

  Future<String> currentName() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kName) ?? '';
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500)); 
    final p = await SharedPreferences.getInstance();
    await p.setString(_kName, name.trim());
    await p.setString(_kEmail, email.trim().toLowerCase());
    await p.setString(_kPass, password);
    await p.setBool(_kSession, true);
    return null;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500)); 
    final p = await SharedPreferences.getInstance();
    final savedEmail = p.getString(_kEmail);
    if (savedEmail == null) {
      return 'Belum ada akun di perangkat ini. Buat akun dulu.';
    }
    if (savedEmail != email.trim().toLowerCase() ||
        p.getString(_kPass) != password) {
      return 'Email atau sandi salah.';
    }
    await p.setBool(_kSession, true);
    return null;
  }

  Future<void> logout() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kSession, false);
  }
}