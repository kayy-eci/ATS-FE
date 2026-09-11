import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontendats/auth_session.dart';
import 'package:frontendats/login.dart';

/// Header JSON standar. Jika ada token, sertakan `Authorization: Bearer`.
Map<String, String> authHeaders({bool withAuth = true}) {
  final headers = <String, String>{'Content-Type': 'application/json'};
  final token = AuthSession.instance.token;
  if (withAuth && token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }
  return headers;
}

bool isUnauthorized(http.Response response) {
  return response.statusCode == 401 || response.statusCode == 403;
}

/// Jika backend menjawab 401/403, bersihkan token dan paksa kembali ke Login.
/// Return true jika sudah di-handle (pemanggil sebaiknya stop proses).
Future<bool> handleAuthError(
  BuildContext context,
  http.Response response,
) async {
  if (!isUnauthorized(response)) return false;
  AuthSession.instance.clear();
  if (context.mounted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sesi habis / token tidak valid. Silakan login lagi.')),
    );
  }
  return true;
}

void forceLogout(BuildContext context) {
  AuthSession.instance.clear();
  if (context.mounted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }
}
