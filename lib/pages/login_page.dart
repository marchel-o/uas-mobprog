import 'package:flutter/material.dart';
import 'package:flutter_application_3/pages/main_screen.dart';
import 'package:flutter_application_3/services/auth_service.dart';
import 'package:flutter_application_3/theme/app_theme.dart';
import 'package:flutter_application_3/widgets/custom_text_field.dart';
import 'package:flutter_application_3/widgets/primary_button.dart';
import 'package:flutter_application_3/widgets/social_login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();

  bool _isRegister = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final err = _isRegister
        ? await _auth.register(
            name: _name.text,
            email: _email.text,
            password: _password.text,
          )
        : await _auth.login(email: _email.text, password: _password.text);
    if (!mounted) return;
    if (err != null) {
      setState(() {
        _loading = false;
        _error = err;
      });
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  void _toggleMode() {
    setState(() {
      _isRegister = !_isRegister;
      _error = null;
    });
    _formKey.currentState?.reset();
  }

  void _socialDemo(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login $provider belum tersedia di versi demo.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Wordmark teks sementara, bukan logo final.
                    Text(
                      kAppName,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isRegister
                          ? 'Buat akun untuk mulai mendengarkan.'
                          : 'Masuk untuk lanjut mendengarkan.',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    if (_isRegister) ...[
                      CustomTextField(
                        label: 'Nama',
                        controller: _name,
                        textInputAction: TextInputAction.next,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Nama wajib diisi.'
                            : null,
                      ),
                      const SizedBox(height: 16),
                    ],
                    CustomTextField(
                      label: 'Email',
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        final t = v?.trim() ?? '';
                        if (t.isEmpty) return 'Email wajib diisi.';
                        if (!t.contains('@') || !t.contains('.')) {
                          return 'Format email tidak valid.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Sandi',
                      controller: _password,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      validator: (v) => (v == null || v.length < 6)
                          ? 'Sandi minimal 6 karakter.'
                          : null,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          _error!,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: _isRegister ? 'Buat akun' : 'Masuk',
                      isLoading: _loading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        'atau',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SocialLoginButton(
                      label: 'Lanjutkan dengan Google',
                      icon: Icons.g_mobiledata,
                      onPressed: () => _socialDemo('Google'),
                    ),
                    const SizedBox(height: 12),
                    SocialLoginButton(
                      label: 'Lanjutkan dengan Facebook',
                      icon: Icons.facebook,
                      onPressed: () => _socialDemo('Facebook'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _loading ? null : _toggleMode,
                      child: Text(
                        _isRegister
                            ? 'Sudah punya akun? Masuk'
                            : 'Belum punya akun? Daftar',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}