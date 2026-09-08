import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontendats/api.dart';
import 'package:frontendats/homepage.dart';
import 'package:frontendats/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isSaving = false;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email dan password wajib diisi')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/users'))
          .timeout(const Duration(seconds: 10));

      setState(() => isSaving = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        List users = [];
        if (body is Map && body['users'] is List) {
          users = body['users'];
        } else if (body is Map && body['data'] is List) {
          users = body['data'];
        } else if (body is List) {
          users = body;
        }

        Map? found;
        for (final u in users) {
          if (u['email'] == emailController.text &&
              u['password'] == passwordController.text) {
            found = u;
            break;
          }
        }

        if (found != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomePage(username: found!['username']?.toString() ?? ''),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email atau password salah')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal login: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa terhubung ke server')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Masuk')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSaving ? null : login,
              child: isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Masuk'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text('Belum punya akun? Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
