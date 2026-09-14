import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontendats/api.dart';
import 'package:frontendats/api_client.dart';
import 'package:frontendats/writly_theme.dart';
import 'package:frontendats/writly_widgets.dart';

class EditProfilePage extends StatefulWidget {
  final String username;
  final String email;
  const EditProfilePage({super.key, this.username = '', this.email = ''});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final usernameController = TextEditingController(text: widget.username);
  late final emailController = TextEditingController(text: widget.email);
  final passwordController = TextEditingController();
  bool isSaving = false;
  bool isLoading = false;
  int? userId;

  Future<void> resolveUser() async {
    setState(() => isLoading = true);
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/users'), headers: authHeaders())
          .timeout(const Duration(seconds: 10));
      if (!mounted) return;
      setState(() => isLoading = false);
      if (await handleAuthError(context, res)) return;
      if (res.statusCode == 200 || res.statusCode == 201) {
        final body = jsonDecode(res.body);
        final List<dynamic> users =
            (body is Map ? body['users'] ?? body['data'] : []) ?? [];
        for (final userEntry in users) {
          if (userEntry is Map &&
              userEntry['email']?.toString() == widget.email) {
            setState(() {
              userId = int.tryParse(userEntry['id'].toString());
              if ((usernameController.text.isEmpty) &&
                  userEntry['username'] != null) {
                usernameController.text = userEntry['username'].toString();
              }
            });
            break;
          }
        }
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> save() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (username.length < 4 || email.isEmpty || password.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username min 4, email valid, password min 4'),
        ),
      );
      return;
    }
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User tidak ditemukan')));
      return;
    }
    setState(() => isSaving = true);
    try {
      final res = await http
          .put(
            Uri.parse('$baseUrl/users/$userId'),
            headers: authHeaders(),
            body: jsonEncode({
              'username': username,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));
      if (!mounted) return;
      setState(() => isSaving = false);
      if (await handleAuthError(context, res)) return;
      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile berhasil diperbarui')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui: ${res.statusCode}')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa terhubung ke server')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    resolveUser();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: WritlyColors.primary),
              )
            : ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                children: [
                  const WritlyLabel(text: 'Username'),
                  TextField(controller: usernameController),
                  const SizedBox(height: 16),
                  const WritlyLabel(text: 'Email'),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  const WritlyLabel(text: 'Password (isi ulang, min 4)'),
                  TextField(controller: passwordController, obscureText: true),
                  const SizedBox(height: 28),
                  WritlyPrimaryButton(
                    text: 'Save Changes',
                    loading: isSaving,
                    onPressed: save,
                  ),
                ],
              ),
      ),
    );
  }
}
