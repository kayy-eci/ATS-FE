import 'package:shared_preferences/shared_preferences.dart';

const String _defaultBaseUrl = String.fromEnvironment(
  'API_BASE',
  defaultValue: 'http://192.168.1.11:8000/api',
);

String _normalizeBaseUrl(String url) {
  return url.trim().replaceAll(RegExp(r'/+$'), '');
}

class ApiConfig {
  ApiConfig._();
  static const _prefsKey = 'api_base_override';
  static String? _override;

  static String get baseUrl {
    final storedOverride = _override?.trim() ?? '';
    if (storedOverride.isNotEmpty) return _normalizeBaseUrl(storedOverride);
    return _defaultBaseUrl;
  }

  static String? get override => _override;
  static bool get isOverridden =>
      _override != null && _override!.trim().isNotEmpty;

  static Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefsKey)?.trim() ?? '';
      _override = saved.isEmpty ? null : _normalizeBaseUrl(saved);
    } catch (_) {
      _override = null;
    }
  }

  static Future<void> setOverride(String url) async {
    final clean = _normalizeBaseUrl(url);
    if (clean.isEmpty) throw ArgumentError('URL server kosong');
    final uri = Uri.tryParse(clean);
    if (uri == null ||
        !(uri.isScheme('http') || uri.isScheme('https')) ||
        uri.host.isEmpty) {
      throw ArgumentError(
        'URL tidak valid (contoh: http://192.168.1.11:8000/api)',
      );
    }
    _override = clean;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, clean);
  }

  static Future<void> clearOverride() async {
    _override = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}

String get baseUrl => ApiConfig.baseUrl;

String friendlyNetworkError(Object networkError) {
  final errorText = networkError.toString();
  final isNet =
      errorText.contains('SocketException') ||
      errorText.contains('Connection refused') ||
      errorText.contains('Connection timed out') ||
      errorText.contains('ClientException') ||
      errorText.contains('Failed host lookup') ||
      errorText.contains('Network is unreachable');
  if (!isNet) return 'Tidak bisa terhubung ke server: $networkError';
  return 'Tidak bisa terhubung ke server ($baseUrl). '
      'Pastikan: 1) HP & laptop satu WiFi, '
      '2) backend jalan dengan --host=0.0.0.0 --port=8000, '
      '3) IP laptop masih benar (cek ipconfig, kalau beda ubah via ikon server di halaman login). '
      'Detail: $networkError';
}
