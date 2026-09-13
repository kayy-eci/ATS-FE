import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontendats/auth_session.dart';
import 'package:frontendats/login.dart';

Map<String, String> authHeaders({bool withAuth = true}) {
  final headers = <String, String>{'Content-Type': 'application/json'};
  final token = AuthSession.instance.token;
  if (withAuth && token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }
  return headers;
}

Map<String, String> authOnlyHeaders() {
  final token = AuthSession.instance.token;
  if (token != null && token.isNotEmpty) {
    return {'Authorization': 'Bearer $token'};
  }
  return {};
}

bool isUnauthorized(http.Response response) {
  return response.statusCode == 401 || response.statusCode == 403;
}

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
      const SnackBar(
        content: Text('Sesi habis / token tidak valid. Silakan login lagi.'),
      ),
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
