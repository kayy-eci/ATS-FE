import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontendats/api.dart';
import 'package:frontendats/auth_session.dart';
import 'package:frontendats/main_shell.dart';
import 'package:frontendats/register.dart';
import 'package:frontendats/scribblr_theme.dart';
import 'package:frontendats/scribblr_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isSaving = false;
  bool obscure = true;

  static final _emailRx = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  Future<String> resolveUsername(String token, String email) async {
    try {
      final res = await http
          .get(
            Uri.parse('$baseUrl/users'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final List<dynamic> users =
            (body is Map ? body['users'] ?? body['data'] : []) ?? [];
        for (final userEntry in users) {
          if (userEntry is Map &&
              userEntry['email']?.toString().trim().toLowerCase() ==
                  email.trim().toLowerCase() &&
              userEntry['username'] != null &&
              userEntry['username'].toString().isNotEmpty) {
            return userEntry['username'].toString();
          }
        }
      }
    } catch (_) {}
    return email.split('@').first;
  }

  Future<void> login() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password wajib diisi')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (response.statusCode == 200) {
        String token = '';
        try {
          final body = jsonDecode(response.body);
          token = (body is Map ? body['token']?.toString() : null) ?? '';
        } catch (_) {}
        if (token.isEmpty) {
          setState(() => isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login gagal: token kosong dari server'),
            ),
          );
          return;
        }

        final username = await resolveUsername(token, email);
        if (!mounted) return;
        setState(() => isSaving = false);
        AuthSession.instance.setSession(
          token: token,
          username: username,
          email: email,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainShell(
              username: AuthSession.instance.username ?? '',
              email: AuthSession.instance.email ?? '',
            ),
          ),
        );
      } else {
        setState(() => isSaving = false);
        String msg = 'Email atau password salah';
        try {
          final body = jsonDecode(response.body);
          if (body is Map && body['message'] != null) {
            msg = body['message'].toString();
          }
        } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$msg (${response.statusCode})')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(friendlyNetworkError(error)),
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  Future<void> openServerSettings() async {
    final controller = TextEditingController(text: baseUrl);
    final formKey = GlobalKey<FormState>();
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ScribblrColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Server Backend',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HP fisik harus satu WiFi dengan laptop. Cek IP terbaru via ipconfig.',
                  style: TextStyle(fontSize: 12, color: ScribblrColors.muted),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    hintText: 'http://192.168.1.11:8000/api',
                    labelText: 'Base URL',
                  ),
                  validator: (value) {
                    final trimmed = (value ?? '').trim();
                    if (trimmed.isEmpty) return 'Wajib diisi';
                    final uri = Uri.tryParse(trimmed);
                    if (uri == null ||
                        !(uri.isScheme('http') || uri.isScheme('https')) ||
                        uri.host.isEmpty) {
                      return 'Contoh valid: http://192.168.1.11:8000/api';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            if (ApiConfig.isOverridden)
              TextButton(
                onPressed: () async {
                  await ApiConfig.clearOverride();
                  if (context.mounted) Navigator.pop(context, true);
                },
                child: const Text('Reset'),
              ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() != true) return;
                try {
                  await ApiConfig.setOverride(controller.text);
                  if (context.mounted) Navigator.pop(context, true);
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menyimpan: $error')),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (saved == true && mounted) setState(() {});
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScribblrColors.bg,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AuthHeader(
                title: 'Hello there,\nwelcome back.',
                subtitle: 'Sign in to continue writing your stories.',
              ),
              AuthCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const ScribblrLabel(text: 'Email'),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'nama@email.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          final trimmed = (value ?? '').trim();
                          if (trimmed.isEmpty) return 'Email wajib diisi';
                          if (!_emailRx.hasMatch(trimmed)) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const ScribblrLabel(text: 'Password'),
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscure,
                        decoration: InputDecoration(
                          hintText:
                              '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => obscure = !obscure),
                            icon: Icon(
                              obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if ((value ?? '').isEmpty) {
                            return 'Password wajib diisi';
                          }
                          if ((value ?? '').length < 4) {
                            return 'Password minimal 4 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ScribblrPrimaryButton(
                        text: 'Sign In',
                        loading: isSaving,
                        onPressed: isSaving ? null : login,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 13,
                              color: ScribblrColors.muted,
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: isSaving
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage(),
                                      ),
                                    );
                                  },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      InkWell(
                        onTap: isSaving ? null : openServerSettings,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.dns_outlined,
                                size: 14,
                                color: ScribblrColors.muted,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  baseUrl,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: ScribblrColors.muted,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Ubah',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: ScribblrColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
