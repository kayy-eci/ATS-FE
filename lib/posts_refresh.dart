import 'package:flutter/foundation.dart';

// Bus refresh terpusat: MainShell + semua list page (Home, Discover,
// MyArticles) mendengarkan notifier ini. Setiap mutasi (create/update/
// delete) memanggil PostsRefresh.bump() agar semua tab refresh otomatis
// tanpa pull-to-refresh manual. IndexedStack membuat tiap tab hidup terus,
// jadi callback .then() saja tidak cukup.
class PostsRefresh {
  PostsRefresh._();
  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);

  static void bump() => notifier.value++;
}

// ---- Helper baca Map backend secara aman (anti layar hitam) ----
// Backend kadang mengembalikan field null / tipe campuran (int vs String).
// Semua akses map di build() wajib lewat helper ini, jangan .toString()
// langsung di atas nilai yang bisa null.

/// Ambil string aman dari map. Tidak pernah throw.
String strOf(dynamic m, String key) {
  if (m is! Map) return '';
  final v = m[key];
  if (v == null) return '';
  return v.toString();
}

/// Parse id aman (int / "1" / null).
int? idOf(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  return int.tryParse(v.toString());
}

/// Nama kategori aman dari list categories.
String catNameOf(List cats, dynamic id) {
  if (id == null) return '';
  final needle = id.toString();
  for (final c in cats) {
    if (c is Map && c['id']?.toString() == needle) {
      return c['name']?.toString() ?? '';
    }
  }
  return '';
}

/// Cek kepemilikan artikel: banding case-insensitive + trim agar
/// "Budi" vs "budi " tetap dianggap milik sendiri.
bool isMine(Map post, String username) {
  final author = strOf(post, 'author').trim().toLowerCase();
  final me = username.trim().toLowerCase();
  if (author.isEmpty || me.isEmpty) return false;
  return author == me;
}
