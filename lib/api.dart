// Base URL backend. Bisa dioverride saat run/build:
//   flutter run --dart-define=API_BASE=http://192.168.1.10:8000/api
//
// Panduan (backend tetap di port 8000, path /api):
// - Chrome / Windows desktop : http://localhost:8000/api
// - Android Emulator         : http://10.0.2.2:8000/api
// - HP fisik (1 WiFi)        : http://<IP-LAN-laptop>:8000/api
const String baseUrl = String.fromEnvironment(
  'API_BASE',
  defaultValue: 'http://10.0.2.2:8000/api',
);
