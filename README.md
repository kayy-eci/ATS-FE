# Dokumentasi Kode Folder `lib/`

Dokumentasi ini dibuat dari seluruh file Dart di folder `lib/`. Setiap baris kode dipertahankan dalam tabel per file agar penelusuran kode dapat dilakukan berdasarkan nomor baris. Penjelasan baris bersifat ringkas dan mengikuti konteks sintaks Dart/Flutter.

## Daftar Isi

- [addpost.dart](#addpost) â€” 678 baris
- [api.dart](#api) â€” 77 baris
- [api_client.dart](#api-client) â€” 57 baris
- [auth_session.dart](#auth-session) â€” 22 baris
- [detailpost.dart](#detailpost) â€” 244 baris
- [discover.dart](#discover) â€” 680 baris
- [edit_profile.dart](#edit-profile) â€” 166 baris
- [editpost.dart](#editpost) â€” 593 baris
- [homepage.dart](#homepage) â€” 408 baris
- [login.dart](#login) â€” 386 baris
- [main.dart](#main) â€” 26 baris
- [main_shell.dart](#main-shell) â€” 182 baris
- [my_articles.dart](#my-articles) â€” 351 baris
- [posts_refresh.dart](#posts-refresh) â€” 107 baris
- [profile.dart](#profile) â€” 181 baris
- [register.dart](#register) â€” 214 baris
- [scribblr_theme.dart](#scribblr-theme) â€” 85 baris
- [scribblr_widgets.dart](#scribblr-widgets) â€” 255 baris

## Gambaran Arsitektur

- **Entry point:** `main.dart` memulai aplikasi dan menghubungkan konfigurasi global.
- **Navigasi dan shell:** `main_shell.dart` mengatur kerangka navigasi utama serta perpindahan halaman.
- **Autentikasi:** `login.dart`, `register.dart`, dan `auth_session.dart` menangani login, pendaftaran, serta sesi pengguna.
- **Data/API:** `api.dart` dan `api_client.dart` menjadi lapisan komunikasi backend.
- **Fitur konten:** halaman homepage, discover, detail/edit/add post, artikel pengguna, dan refresh postingan.
- **Profil dan UI bersama:** `profile.dart`, `edit_profile.dart`, `scribblr_theme.dart`, dan `scribblr_widgets.dart`.

> Catatan: Nomor baris mengikuti isi file saat README ini dibuat. Regenerasikan dokumentasi jika kode berubah.

## `addpost.dart`

Path: [`lib/addpost.dart`](lib/addpost.dart)
Jumlah baris: **678**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'dart:typed_data';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 3 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 4 | ``import 'package:http/http.dart' as http;`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 5 | ``import 'package:http_parser/http_parser.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 6 | ``import 'dart:convert';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 7 | ``import 'package:image_picker/image_picker.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 8 | ``import 'package:frontendats/api.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 9 | ``import 'package:frontendats/api_client.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 10 | ``import 'package:frontendats/posts_refresh.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 11 | ``import 'package:frontendats/scribblr_theme.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 12 | ``import 'package:frontendats/scribblr_widgets.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 13 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 14 | ``class AddPostPage extends StatefulWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 15 | ``  final String username;`` | Mendeklarasikan variabel atau konstanta. |
| 16 | ``  final VoidCallback? onSaved;`` | Mendeklarasikan variabel atau konstanta. |
| 17 | ``  const AddPostPage({super.key, this.username = '', this.onSaved});`` | Mendeklarasikan variabel atau konstanta. |
| 18 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 19 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 20 | ``  State<AddPostPage> createState() => _AddPostPageState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 21 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 22 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 23 | ``class _AddPostPageState extends State<AddPostPage> {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 24 | ``  final _formKey = GlobalKey<FormState>();`` | Mendeklarasikan variabel atau konstanta. |
| 25 | ``  final titleController = TextEditingController();`` | Mendeklarasikan variabel atau konstanta. |
| 26 | ``  final contentController = TextEditingController();`` | Mendeklarasikan variabel atau konstanta. |
| 27 | ``  final excerptController = TextEditingController();`` | Mendeklarasikan variabel atau konstanta. |
| 28 | ``  late final authorController = TextEditingController(text: widget.username);`` | Mendeklarasikan variabel atau konstanta. |
| 29 | ``  List<dynamic> categories = [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 30 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 31 | ``  final Set<int> selectedCategories = {};`` | Mendeklarasikan variabel atau konstanta. |
| 32 | ``  String? categoryError;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 33 | ``  String selectedStatus = 'published';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 34 | ``  bool isSaving = false;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 35 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 36 | ``  XFile? _pickedCover;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 37 | ``  Uint8List? _pickedBytes;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 38 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 39 | ``  Future<void> fetchCategories() async {`` | Mendefinisikan operasi asynchronous. |
| 40 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 41 | ``      final data = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 42 | ``          .get(Uri.parse('$baseUrl/categories'), headers: authHeaders())`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 43 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 44 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 45 | ``      if (await handleAuthError(context, data)) return;`` | Mengatur percabangan logika. |
| 46 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 47 | ``      if (data.statusCode == 200) {`` | Mengatur percabangan logika. |
| 48 | ``        final body = jsonDecode(data.body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 49 | ``        final list = (body is Map ? body['data'] : null) ?? [];`` | Mendeklarasikan variabel atau konstanta. |
| 50 | ``        setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 51 | ``          categories = list is List ? list : [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 52 | ``          if (categories.isNotEmpty && selectedCategories.isEmpty) {`` | Mengatur percabangan logika. |
| 53 | ``            final first = idOf(categories[0]['id']);`` | Mendeklarasikan variabel atau konstanta. |
| 54 | ``            if (first != null) selectedCategories.add(first);`` | Mengatur percabangan logika. |
| 55 | ``          }`` | Menutup blok, widget, atau pemanggilan method. |
| 56 | ``          categoryError = null;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 57 | ``        });`` | Menutup blok, widget, atau pemanggilan method. |
| 58 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 59 | ``        debugPrint('Gagal mengambil data: ${data.statusCode}');`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 60 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 61 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 62 | ``      debugPrint('fetchCategories error: $error');`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 63 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 64 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 65 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 66 | ``  Future<void> createCategoryInline() async {`` | Mendefinisikan operasi asynchronous. |
| 67 | ``    final nameController = TextEditingController();`` | Mendeklarasikan variabel atau konstanta. |
| 68 | ``    final descController = TextEditingController();`` | Mendeklarasikan variabel atau konstanta. |
| 69 | ``    final formKey = GlobalKey<FormState>();`` | Mendeklarasikan variabel atau konstanta. |
| 70 | ``    final created = await showDialog<bool>(`` | Mendeklarasikan variabel atau konstanta. |
| 71 | ``      context: context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 72 | ``      builder: (context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 73 | ``        return AlertDialog(`` | Mengembalikan nilai dari fungsi atau widget. |
| 74 | ``          backgroundColor: ScribblrColors.surface,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 75 | ``          shape: RoundedRectangleBorder(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 76 | ``            borderRadius: BorderRadius.circular(20),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 77 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 78 | ``          title: const Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 79 | ``            'New Topic',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 80 | ``            style: TextStyle(fontWeight: FontWeight.w700),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 81 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 82 | ``          content: Form(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 83 | ``            key: formKey,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 84 | ``            child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 85 | ``              mainAxisSize: MainAxisSize.min,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 86 | ``              children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 87 | ``                TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 88 | ``                  controller: nameController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 89 | ``                  decoration: const InputDecoration(hintText: 'Topic name'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 90 | ``                  validator: (value) => (value == null \|\| value.trim().isEmpty)`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 91 | ``                      ? 'Wajib diisi'`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 92 | ``                      : null,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 93 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 94 | ``                const SizedBox(height: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 95 | ``                TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 96 | ``                  controller: descController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 97 | ``                  decoration: const InputDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 98 | ``                    hintText: 'Description (opsional)',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 99 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 100 | ``                  maxLines: 2,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 101 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 102 | ``              ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 103 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 104 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 105 | ``          actions: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 106 | ``            TextButton(`` | Menyusun elemen antarmuka Flutter. |
| 107 | ``              onPressed: () => Navigator.pop(context, false),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 108 | ``              child: const Text('Cancel'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 109 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 110 | ``            ElevatedButton(`` | Menyusun elemen antarmuka Flutter. |
| 111 | ``              style: ElevatedButton.styleFrom(minimumSize: const Size(100, 44)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 112 | ``              onPressed: () {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 113 | ``                if (formKey.currentState?.validate() != true) return;`` | Mengatur percabangan logika. |
| 114 | ``                Navigator.pop(context, true);`` | Menyusun elemen antarmuka Flutter. |
| 115 | ``              },`` | Menutup blok, widget, atau pemanggilan method. |
| 116 | ``              child: const Text('Save'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 117 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 118 | ``          ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 119 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 120 | ``      },`` | Menutup blok, widget, atau pemanggilan method. |
| 121 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 122 | ``    if (created != true \|\| !mounted) return;`` | Mengatur percabangan logika. |
| 123 | ``    final name = nameController.text.trim();`` | Mendeklarasikan variabel atau konstanta. |
| 124 | ``    final slug = makeCategorySlug(name);`` | Mendeklarasikan variabel atau konstanta. |
| 125 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 126 | ``      final res = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 127 | ``          .post(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 128 | ``            Uri.parse('$baseUrl/categories'),`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 129 | ``            headers: authHeaders(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 130 | ``            body: jsonEncode({`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 131 | ``              'name': name,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 132 | ``              'slug': slug.isEmpty ? name.toLowerCase() : slug,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 133 | ``              'description': descController.text.isEmpty`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 134 | ``                  ? null`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 135 | ``                  : descController.text,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 136 | ``            }),`` | Menutup blok, widget, atau pemanggilan method. |
| 137 | ``          )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 138 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 139 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 140 | ``      if (await handleAuthError(context, res)) return;`` | Mengatur percabangan logika. |
| 141 | ``      if (res.statusCode == 200 \|\| res.statusCode == 201) {`` | Mengatur percabangan logika. |
| 142 | ``        ScaffoldMessenger.of(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 143 | ``          context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 144 | ``        ).showSnackBar(const SnackBar(content: Text('Topik baru tersimpan')));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 145 | ``        await fetchCategories();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 146 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 147 | ``        for (final categoryItem in categories) {`` | Melakukan iterasi atas data. |
| 148 | ``          if (strOf(categoryItem, 'name') == name) {`` | Mengatur percabangan logika. |
| 149 | ``            final id = idOf((categoryItem as Map)['id']);`` | Mendeklarasikan variabel atau konstanta. |
| 150 | ``            if (id != null) {`` | Mengatur percabangan logika. |
| 151 | ``              setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 152 | ``                selectedCategories.add(id);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 153 | ``                categoryError = null;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 154 | ``              });`` | Menutup blok, widget, atau pemanggilan method. |
| 155 | ``            }`` | Menutup blok, widget, atau pemanggilan method. |
| 156 | ``            break;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 157 | ``          }`` | Menutup blok, widget, atau pemanggilan method. |
| 158 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 159 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 160 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 161 | ``          SnackBar(content: Text('Gagal bikin topik: ${res.statusCode}')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 162 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 163 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 164 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 165 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 166 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 167 | ``        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 168 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 169 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 170 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 171 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 172 | ``  Future<void> pickCover() async {`` | Mendefinisikan operasi asynchronous. |
| 173 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 174 | ``      final file = await ImagePicker().pickImage(`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 175 | ``        source: ImageSource.gallery,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 176 | ``        maxWidth: 1600,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 177 | ``        imageQuality: 85,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 178 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 179 | ``      if (file == null \|\| !mounted) return;`` | Mengatur percabangan logika. |
| 180 | ``      final bytes = await file.readAsBytes();`` | Mendeklarasikan variabel atau konstanta. |
| 181 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 182 | ``      setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 183 | ``        _pickedCover = file;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 184 | ``        _pickedBytes = bytes;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 185 | ``      });`` | Menutup blok, widget, atau pemanggilan method. |
| 186 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 187 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 188 | ``      ScaffoldMessenger.of(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 189 | ``        context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 190 | ``      ).showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $error')));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 191 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 192 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 193 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 194 | ``  void clearPickedCover() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 195 | ``    setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 196 | ``      _pickedCover = null;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 197 | ``      _pickedBytes = null;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 198 | ``    });`` | Menutup blok, widget, atau pemanggilan method. |
| 199 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 200 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 201 | ``  MediaType _guessImageType(String filename) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 202 | ``    final lower = filename.toLowerCase();`` | Mendeklarasikan variabel atau konstanta. |
| 203 | ``    if (lower.endsWith('.png')) return MediaType('image', 'png');`` | Mengatur percabangan logika. |
| 204 | ``    if (lower.endsWith('.webp')) return MediaType('image', 'webp');`` | Mengatur percabangan logika. |
| 205 | ``    if (lower.endsWith('.gif')) return MediaType('image', 'gif');`` | Mengatur percabangan logika. |
| 206 | ``    return MediaType('image', 'jpeg');`` | Mengembalikan nilai dari fungsi atau widget. |
| 207 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 208 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 209 | ``  void _showSaveError(int status, String body) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 210 | ``    debugPrint('POST /posts gagal: $status $body');`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 211 | ``    String msg = 'Gagal menyimpan artikel: $status';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 212 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 213 | ``      final decodedBody = jsonDecode(body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 214 | ``      if (decodedBody is Map) {`` | Mengatur percabangan logika. |
| 215 | ``        if (decodedBody['message'] != null) {`` | Mengatur percabangan logika. |
| 216 | ``          msg = '$msg - ${decodedBody['message']}';`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 217 | ``        } else if (decodedBody['errors'] != null) {`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 218 | ``          msg = '$msg - ${decodedBody['errors']}';`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 219 | ``        } else if (decodedBody['error'] != null) {`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 220 | ``          msg = '$msg - ${decodedBody['error']}';`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 221 | ``        } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 222 | ``          msg = '$msg - $body';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 223 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 224 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 225 | ``        msg = '$msg - $body';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 226 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 227 | ``    } catch (_) {`` | Menutup blok, widget, atau pemanggilan method. |
| 228 | ``      if (body.isNotEmpty) msg = '$msg - $body';`` | Mengatur percabangan logika. |
| 229 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 230 | ``    if (msg.length > 500) msg = '${msg.substring(0, 500)}...';`` | Mengatur percabangan logika. |
| 231 | ``    ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 232 | ``      SnackBar(content: Text(msg), duration: const Duration(seconds: 6)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 233 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 234 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 235 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 236 | ``  Future<void> addPost() async {`` | Mendefinisikan operasi asynchronous. |
| 237 | ``    FocusScope.of(context).unfocus();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 238 | ``    final valid = _formKey.currentState?.validate() ?? false;`` | Mendeklarasikan variabel atau konstanta. |
| 239 | ``    if (selectedCategories.isEmpty) {`` | Mengatur percabangan logika. |
| 240 | ``      setState(() => categoryError = 'Pilih minimal 1 kategori');`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 241 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 242 | ``    if (!valid \|\| selectedCategories.isEmpty) {`` | Mengatur percabangan logika. |
| 243 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 244 | ``        const SnackBar(content: Text('Periksa lagi isian yang ditandai')),`` | Mendeklarasikan variabel atau konstanta. |
| 245 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 246 | ``      return;`` | Mengembalikan nilai dari fungsi atau widget. |
| 247 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 248 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 249 | ``    setState(() => isSaving = true);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 250 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 251 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 252 | ``      var slug = makeCategorySlug(titleController.text);`` | Mendeklarasikan variabel atau konstanta. |
| 253 | ``      if (slug.isEmpty) {`` | Mengatur percabangan logika. |
| 254 | ``        slug = 'post-${DateTime.now().millisecondsSinceEpoch}';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 255 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 256 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 257 | ``      final author = authorController.text.trim().isEmpty`` | Mendeklarasikan variabel atau konstanta. |
| 258 | ``          ? (widget.username.trim().isEmpty ? null : widget.username.trim())`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 259 | ``          : authorController.text.trim();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 260 | ``      final hasImage = _pickedCover != null && _pickedBytes != null;`` | Mendeklarasikan variabel atau konstanta. |
| 261 | ``      final excerpt = excerptController.text.isEmpty`` | Mendeklarasikan variabel atau konstanta. |
| 262 | ``          ? null`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 263 | ``          : excerptController.text;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 264 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 265 | ``      final catList = selectedCategories.toList();`` | Mendeklarasikan variabel atau konstanta. |
| 266 | ``      final primaryCat = catList.first;`` | Mendeklarasikan variabel atau konstanta. |
| 267 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 268 | ``      http.Response response;`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 269 | ``      if (!hasImage) {`` | Mengatur percabangan logika. |
| 270 | ``        response = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 271 | ``            .post(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 272 | ``              Uri.parse('$baseUrl/posts'),`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 273 | ``              headers: authHeaders(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 274 | ``              body: jsonEncode({`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 275 | ``                'title': titleController.text.trim(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 276 | ``                'slug': slug,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 277 | ``                'content': contentController.text,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 278 | ``                'excerpt': excerpt,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 279 | ``                'category_id': primaryCat,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 280 | ``                'category_ids': catList,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 281 | ``                'author': author,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 282 | ``                'status': selectedStatus,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 283 | ``              }),`` | Menutup blok, widget, atau pemanggilan method. |
| 284 | ``            )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 285 | ``            .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 286 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 287 | ``        final req = http.MultipartRequest('POST', Uri.parse('$baseUrl/posts'))`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 288 | ``          ..headers.addAll(authOnlyHeaders());`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 289 | ``        req.fields['title'] = titleController.text.trim();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 290 | ``        req.fields['slug'] = slug;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 291 | ``        req.fields['content'] = contentController.text;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 292 | ``        if (excerpt != null) req.fields['excerpt'] = excerpt;`` | Mengatur percabangan logika. |
| 293 | ``        req.fields['category_id'] = primaryCat.toString();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 294 | ``        req.fields['category_ids'] = jsonEncode(catList);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 295 | ``        if (author != null && author.isNotEmpty) {`` | Mengatur percabangan logika. |
| 296 | ``          req.fields['author'] = author;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 297 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 298 | ``        req.fields['status'] = selectedStatus;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 299 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 300 | ``        final picked = _pickedCover!;`` | Mendeklarasikan variabel atau konstanta. |
| 301 | ``        req.files.add(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 302 | ``          http.MultipartFile.fromBytes(`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 303 | ``            'cover_image',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 304 | ``            _pickedBytes!,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 305 | ``            filename: picked.name.isEmpty ? 'cover.jpg' : picked.name,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 306 | ``            contentType: _guessImageType(picked.name),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 307 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 308 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 309 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 310 | ``        final streamed = await req.send().timeout(const Duration(seconds: 20));`` | Mendeklarasikan variabel atau konstanta. |
| 311 | ``        response = await http.Response.fromStream(streamed);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 312 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 313 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 314 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 315 | ``      if (await handleAuthError(context, response)) return;`` | Mengatur percabangan logika. |
| 316 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 317 | ``      if (response.statusCode == 200 \|\| response.statusCode == 201) {`` | Mengatur percabangan logika. |
| 318 | ``        PostsRefresh.bump();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 319 | ``        final inShell = widget.onSaved != null;`` | Mendeklarasikan variabel atau konstanta. |
| 320 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 321 | ``          SnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 322 | ``            content: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 323 | ``              selectedStatus == 'draft'`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 324 | ``                  ? 'Draft tersimpan, cek tab Draft di My Article'`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 325 | ``                  : 'Artikel terbit, cek tab Published di My Article',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 326 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 327 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 328 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 329 | ``        if (inShell) {`` | Mengatur percabangan logika. |
| 330 | ``          _formKey.currentState?.reset();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 331 | ``          titleController.clear();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 332 | ``          contentController.clear();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 333 | ``          excerptController.clear();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 334 | ``          clearPickedCover();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 335 | ``          widget.onSaved?.call();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 336 | ``        } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 337 | ``          Navigator.pop(context, true);`` | Menyusun elemen antarmuka Flutter. |
| 338 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 339 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 340 | ``        _showSaveError(response.statusCode, response.body);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 341 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 342 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 343 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 344 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 345 | ``        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 346 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 347 | ``    } finally {`` | Menutup blok, widget, atau pemanggilan method. |
| 348 | ``      if (mounted) setState(() => isSaving = false);`` | Mengatur percabangan logika. |
| 349 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 350 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 351 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 352 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 353 | ``  void initState() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 354 | ``    super.initState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 355 | ``    fetchCategories();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 356 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 357 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 358 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 359 | ``  void didUpdateWidget(AddPostPage oldWidget) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 360 | ``    super.didUpdateWidget(oldWidget);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 361 | ``    if (authorController.text.isEmpty && widget.username.isNotEmpty) {`` | Mengatur percabangan logika. |
| 362 | ``      authorController.text = widget.username;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 363 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 364 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 365 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 366 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 367 | ``  void dispose() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 368 | ``    titleController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 369 | ``    contentController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 370 | ``    excerptController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 371 | ``    authorController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 372 | ``    super.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 373 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 374 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 375 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 376 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 377 | ``    final authorLocked = widget.username.isNotEmpty;`` | Mendeklarasikan variabel atau konstanta. |
| 378 | ``    return Scaffold(`` | Mengembalikan nilai dari fungsi atau widget. |
| 379 | ``      appBar: AppBar(`` | Menyusun elemen antarmuka Flutter. |
| 380 | ``        automaticallyImplyLeading: widget.onSaved == null,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 381 | ``        title: const Text('Create'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 382 | ``        actions: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 383 | ``          Padding(`` | Menyusun elemen antarmuka Flutter. |
| 384 | ``            padding: const EdgeInsets.only(right: 12),`` | Menyusun elemen antarmuka Flutter. |
| 385 | ``            child: Center(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 386 | ``              child: Container(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 387 | ``                padding: const EdgeInsets.symmetric(`` | Menyusun elemen antarmuka Flutter. |
| 388 | ``                  horizontal: 12,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 389 | ``                  vertical: 6,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 390 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 391 | ``                decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 392 | ``                  color: ScribblrColors.chipBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 393 | ``                  borderRadius: BorderRadius.circular(20),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 394 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 395 | ``                child: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 396 | ``                  selectedStatus == 'draft' ? 'Draft' : 'Publish',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 397 | ``                  style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 398 | ``                    fontSize: 12,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 399 | ``                    fontWeight: FontWeight.w700,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 400 | ``                    color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 401 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 402 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 403 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 404 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 405 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 406 | ``        ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 407 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 408 | ``      body: SafeArea(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 409 | ``        child: Form(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 410 | ``          key: _formKey,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 411 | ``          child: ListView(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 412 | ``            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),`` | Menyusun elemen antarmuka Flutter. |
| 413 | ``            children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 414 | ``              const ScribblrLabel(text: 'Cover image (opsional, dari galeri)'),`` | Mendeklarasikan variabel atau konstanta. |
| 415 | ``              _coverPreview(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 416 | ``              const SizedBox(height: 8),`` | Mendeklarasikan variabel atau konstanta. |
| 417 | ``              Row(`` | Menyusun elemen antarmuka Flutter. |
| 418 | ``                children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 419 | ``                  TextButton.icon(`` | Menyusun elemen antarmuka Flutter. |
| 420 | ``                    onPressed: isSaving ? null : pickCover,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 421 | ``                    icon: const Icon(Icons.photo_library_outlined, size: 18),`` | Menyusun elemen antarmuka Flutter. |
| 422 | ``                    label: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 423 | ``                      _pickedCover == null ? 'Pilih gambar' : 'Ganti gambar',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 424 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 425 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 426 | ``                  if (_pickedCover != null)`` | Mengatur percabangan logika. |
| 427 | ``                    TextButton.icon(`` | Menyusun elemen antarmuka Flutter. |
| 428 | ``                      onPressed: isSaving ? null : clearPickedCover,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 429 | ``                      icon: const Icon(Icons.close, size: 18),`` | Menyusun elemen antarmuka Flutter. |
| 430 | ``                      label: const Text('Hapus'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 431 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 432 | ``                ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 433 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 434 | ``              if (_pickedCover != null)`` | Mengatur percabangan logika. |
| 435 | ``                Text(`` | Menyusun elemen antarmuka Flutter. |
| 436 | ``                  _pickedCover!.name,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 437 | ``                  style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 438 | ``                    fontSize: 12,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 439 | ``                    color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 440 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 441 | ``                  overflow: TextOverflow.ellipsis,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 442 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 443 | ``              const SizedBox(height: 14),`` | Mendeklarasikan variabel atau konstanta. |
| 444 | ``              const ScribblrLabel(text: 'Title'),`` | Mendeklarasikan variabel atau konstanta. |
| 445 | ``              TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 446 | ``                controller: titleController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 447 | ``                decoration: const InputDecoration(hintText: 'Article title'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 448 | ``                validator: (value) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 449 | ``                  if ((value ?? '').trim().length < 3) {`` | Mengatur percabangan logika. |
| 450 | ``                    return 'Judul minimal 3 karakter';`` | Mengembalikan nilai dari fungsi atau widget. |
| 451 | ``                  }`` | Menutup blok, widget, atau pemanggilan method. |
| 452 | ``                  return null;`` | Mengembalikan nilai dari fungsi atau widget. |
| 453 | ``                },`` | Menutup blok, widget, atau pemanggilan method. |
| 454 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 455 | ``              const SizedBox(height: 14),`` | Mendeklarasikan variabel atau konstanta. |
| 456 | ``              const ScribblrLabel(text: 'Article'),`` | Mendeklarasikan variabel atau konstanta. |
| 457 | ``              TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 458 | ``                controller: contentController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 459 | ``                maxLines: 6,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 460 | ``                decoration: const InputDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 461 | ``                  hintText: 'Tell your story...',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 462 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 463 | ``                validator: (value) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 464 | ``                  if ((value ?? '').trim().length < 10) {`` | Mengatur percabangan logika. |
| 465 | ``                    return 'Isi artikel minimal 10 karakter';`` | Mengembalikan nilai dari fungsi atau widget. |
| 466 | ``                  }`` | Menutup blok, widget, atau pemanggilan method. |
| 467 | ``                  return null;`` | Mengembalikan nilai dari fungsi atau widget. |
| 468 | ``                },`` | Menutup blok, widget, atau pemanggilan method. |
| 469 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 470 | ``              const SizedBox(height: 14),`` | Mendeklarasikan variabel atau konstanta. |
| 471 | ``              const ScribblrLabel(text: 'Excerpt'),`` | Mendeklarasikan variabel atau konstanta. |
| 472 | ``              TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 473 | ``                controller: excerptController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 474 | ``                maxLines: 2,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 475 | ``                decoration: const InputDecoration(hintText: 'Short summary...'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 476 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 477 | ``              const SizedBox(height: 14),`` | Mendeklarasikan variabel atau konstanta. |
| 478 | ``              const ScribblrLabel(text: 'Author (akun kamu, terkunci)'),`` | Mendeklarasikan variabel atau konstanta. |
| 479 | ``              TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 480 | ``                controller: authorController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 481 | ``                readOnly: authorLocked,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 482 | ``                decoration: InputDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 483 | ``                  hintText: 'Your name',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 484 | ``                  suffixIcon: authorLocked`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 485 | ``                      ? const Icon(Icons.lock_outline, size: 18)`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 486 | ``                      : null,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 487 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 488 | ``                validator: (value) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 489 | ``                  if ((value ?? '').trim().isEmpty &&`` | Mengatur percabangan logika. |
| 490 | ``                      widget.username.trim().isEmpty) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 491 | ``                    return 'Author wajib diisi';`` | Mengembalikan nilai dari fungsi atau widget. |
| 492 | ``                  }`` | Menutup blok, widget, atau pemanggilan method. |
| 493 | ``                  return null;`` | Mengembalikan nilai dari fungsi atau widget. |
| 494 | ``                },`` | Menutup blok, widget, atau pemanggilan method. |
| 495 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 496 | ``              const SizedBox(height: 18),`` | Mendeklarasikan variabel atau konstanta. |
| 497 | ``              Row(`` | Menyusun elemen antarmuka Flutter. |
| 498 | ``                children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 499 | ``                  Text(`` | Menyusun elemen antarmuka Flutter. |
| 500 | ``                    'Select Topics${selectedCategories.isEmpty ? '' : ' (${selectedCategories.length})'}',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 501 | ``                    style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 502 | ``                      fontSize: 15,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 503 | ``                      fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 504 | ``                      color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 505 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 506 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 507 | ``                  const Spacer(),`` | Mendeklarasikan variabel atau konstanta. |
| 508 | ``                  if (selectedCategories.isNotEmpty)`` | Mengatur percabangan logika. |
| 509 | ``                    TextButton(`` | Menyusun elemen antarmuka Flutter. |
| 510 | ``                      onPressed: isSaving`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 511 | ``                          ? null`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 512 | ``                          : () => setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 513 | ``                              selectedCategories.clear();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 514 | ``                              categoryError = null;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 515 | ``                            }),`` | Menutup blok, widget, atau pemanggilan method. |
| 516 | ``                      child: const Text('Clear'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 517 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 518 | ``                  TextButton.icon(`` | Menyusun elemen antarmuka Flutter. |
| 519 | ``                    onPressed: isSaving ? null : createCategoryInline,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 520 | ``                    icon: const Icon(Icons.add, size: 16),`` | Menyusun elemen antarmuka Flutter. |
| 521 | ``                    label: const Text('New'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 522 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 523 | ``                ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 524 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 525 | ``              const Row(`` | Mendeklarasikan variabel atau konstanta. |
| 526 | ``                children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 527 | ``                  Icon(`` | Menyusun elemen antarmuka Flutter. |
| 528 | ``                    Icons.touch_app_outlined,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 529 | ``                    size: 14,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 530 | ``                    color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 531 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 532 | ``                  SizedBox(width: 4),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 533 | ``                  Text(`` | Menyusun elemen antarmuka Flutter. |
| 534 | ``                    'Bisa pilih lebih dari 1 topik.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 535 | ``                    style: TextStyle(fontSize: 12, color: ScribblrColors.muted),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 536 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 537 | ``                ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 538 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 539 | ``              const SizedBox(height: 8),`` | Mendeklarasikan variabel atau konstanta. |
| 540 | ``              if (categories.isEmpty)`` | Mengatur percabangan logika. |
| 541 | ``                const Text(`` | Mendeklarasikan variabel atau konstanta. |
| 542 | ``                  'Belum ada topik. Bikin baru lewat tombol New.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 543 | ``                  style: TextStyle(color: ScribblrColors.muted, fontSize: 13),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 544 | ``                )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 545 | ``              else`` | Mengatur percabangan logika. |
| 546 | ``                Wrap(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 547 | ``                  spacing: 8,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 548 | ``                  runSpacing: 8,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 549 | ``                  children: categories.map<Widget>((categoryItem) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 550 | ``                    final id = idOf((categoryItem as Map)['id']);`` | Mendeklarasikan variabel atau konstanta. |
| 551 | ``                    final selected =`` | Mendeklarasikan variabel atau konstanta. |
| 552 | ``                        id != null && selectedCategories.contains(id);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 553 | ``                    return FilterChip(`` | Mengembalikan nilai dari fungsi atau widget. |
| 554 | ``                      label: Text(strOf(categoryItem, 'name')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 555 | ``                      avatar: CircleAvatar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 556 | ``                        radius: 11,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 557 | ``                        backgroundColor: selected`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 558 | ``                            ? Colors.white24`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 559 | ``                            : ScribblrColors.chipBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 560 | ``                        backgroundImage: const AssetImage('assets/logokpi.png'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 561 | ``                        onBackgroundImageError: (_, _) {},`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 562 | ``                        child: const SizedBox.shrink(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 563 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 564 | ``                      selected: selected,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 565 | ``                      onSelected: (_) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 566 | ``                        if (id == null) return;`` | Mengatur percabangan logika. |
| 567 | ``                        setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 568 | ``                          if (selected) {`` | Mengatur percabangan logika. |
| 569 | ``                            selectedCategories.remove(id);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 570 | ``                          } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 571 | ``                            selectedCategories.add(id);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 572 | ``                          }`` | Menutup blok, widget, atau pemanggilan method. |
| 573 | ``                          categoryError = null;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 574 | ``                        });`` | Menutup blok, widget, atau pemanggilan method. |
| 575 | ``                      },`` | Menutup blok, widget, atau pemanggilan method. |
| 576 | ``                      selectedColor: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 577 | ``                      labelStyle: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 578 | ``                        color: selected ? Colors.white : ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 579 | ``                        fontWeight: FontWeight.w600,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 580 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 581 | ``                      shape: const StadiumBorder(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 582 | ``                        side: BorderSide(color: ScribblrColors.line),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 583 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 584 | ``                    );`` | Menutup blok, widget, atau pemanggilan method. |
| 585 | ``                  }).toList(),`` | Menutup blok, widget, atau pemanggilan method. |
| 586 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 587 | ``              if (categoryError != null) ...[`` | Mengatur percabangan logika. |
| 588 | ``                const SizedBox(height: 6),`` | Mendeklarasikan variabel atau konstanta. |
| 589 | ``                Text(`` | Menyusun elemen antarmuka Flutter. |
| 590 | ``                  categoryError!,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 591 | ``                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 592 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 593 | ``              ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 594 | ``              const SizedBox(height: 18),`` | Mendeklarasikan variabel atau konstanta. |
| 595 | ``              const ScribblrLabel(text: 'Status'),`` | Mendeklarasikan variabel atau konstanta. |
| 596 | ``              Container(`` | Menyusun elemen antarmuka Flutter. |
| 597 | ``                padding: const EdgeInsets.all(4),`` | Menyusun elemen antarmuka Flutter. |
| 598 | ``                decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 599 | ``                  color: ScribblrColors.chipBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 600 | ``                  borderRadius: BorderRadius.circular(30),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 601 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 602 | ``                child: Row(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 603 | ``                  children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 604 | ``                    _statusButton('published', 'Publish'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 605 | ``                    _statusButton('draft', 'Draft'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 606 | ``                  ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 607 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 608 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 609 | ``              const SizedBox(height: 24),`` | Mendeklarasikan variabel atau konstanta. |
| 610 | ``              ScribblrPrimaryButton(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 611 | ``                text: selectedStatus == 'draft' ? 'Save Draft' : 'Publish',`` | Menyusun elemen antarmuka Flutter. |
| 612 | ``                loading: isSaving,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 613 | ``                onPressed: isSaving ? null : addPost,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 614 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 615 | ``              const SizedBox(height: 24),`` | Mendeklarasikan variabel atau konstanta. |
| 616 | ``            ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 617 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 618 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 619 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 620 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 621 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 622 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 623 | ``  Widget _coverPreview() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 624 | ``    if (_pickedBytes != null) {`` | Mengatur percabangan logika. |
| 625 | ``      return ClipRRect(`` | Mengembalikan nilai dari fungsi atau widget. |
| 626 | ``        borderRadius: BorderRadius.circular(20),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 627 | ``        child: Image.memory(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 628 | ``          _pickedBytes!,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 629 | ``          height: 180,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 630 | ``          fit: BoxFit.cover,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 631 | ``          errorBuilder: (_, _, _) => _coverPlaceholder(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 632 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 633 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 634 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 635 | ``    return _coverPlaceholder();`` | Mengembalikan nilai dari fungsi atau widget. |
| 636 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 637 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 638 | ``  Widget _coverPlaceholder() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 639 | ``    return Container(`` | Mengembalikan nilai dari fungsi atau widget. |
| 640 | ``      height: 150,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 641 | ``      decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 642 | ``        color: ScribblrColors.placeholderBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 643 | ``        borderRadius: BorderRadius.circular(20),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 644 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 645 | ``      alignment: Alignment.center,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 646 | ``      child: const Icon(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 647 | ``        Icons.image_outlined,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 648 | ``        size: 40,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 649 | ``        color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 650 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 651 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 652 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 653 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 654 | ``  Widget _statusButton(String value, String label) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 655 | ``    final active = selectedStatus == value;`` | Mendeklarasikan variabel atau konstanta. |
| 656 | ``    return Expanded(`` | Mengembalikan nilai dari fungsi atau widget. |
| 657 | ``      child: GestureDetector(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 658 | ``        onTap: isSaving ? null : () => setState(() => selectedStatus = value),`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 659 | ``        child: Container(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 660 | ``          padding: const EdgeInsets.symmetric(vertical: 10),`` | Menyusun elemen antarmuka Flutter. |
| 661 | ``          decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 662 | ``            color: active ? ScribblrColors.surface : Colors.transparent,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 663 | ``            borderRadius: BorderRadius.circular(26),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 664 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 665 | ``          alignment: Alignment.center,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 666 | ``          child: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 667 | ``            label,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 668 | ``            style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 669 | ``              fontSize: 13,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 670 | ``              fontWeight: FontWeight.w700,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 671 | ``              color: active ? ScribblrColors.primary : ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 672 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 673 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 674 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 675 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 676 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 677 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 678 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `api.dart`

Path: [`lib/api.dart`](lib/api.dart)
Jumlah baris: **77**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:shared_preferences/shared_preferences.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 3 | ``const String _defaultBaseUrl = String.fromEnvironment(`` | Mendeklarasikan variabel atau konstanta. |
| 4 | ``  'API_BASE',`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 5 | ``  defaultValue: 'http://192.168.1.11:8000/api',`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 6 | ``);`` | Menutup blok, widget, atau pemanggilan method. |
| 7 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 8 | ``String _normalizeBaseUrl(String url) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 9 | ``  return url.trim().replaceAll(RegExp(r'/+$'), '');`` | Mengembalikan nilai dari fungsi atau widget. |
| 10 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 11 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 12 | ``class ApiConfig {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 13 | ``  ApiConfig._();`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 14 | ``  static const _prefsKey = 'api_base_override';`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 15 | ``  static String? _override;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 16 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 17 | ``  static String get baseUrl {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 18 | ``    final storedOverride = _override?.trim() ?? '';`` | Mendeklarasikan variabel atau konstanta. |
| 19 | ``    if (storedOverride.isNotEmpty) return _normalizeBaseUrl(storedOverride);`` | Mengatur percabangan logika. |
| 20 | ``    return _defaultBaseUrl;`` | Mengembalikan nilai dari fungsi atau widget. |
| 21 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 22 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 23 | ``  static String? get override => _override;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 24 | ``  static bool get isOverridden =>`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 25 | ``      _override != null && _override!.trim().isNotEmpty;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 26 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 27 | ``  static Future<void> load() async {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 28 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 29 | ``      final prefs = await SharedPreferences.getInstance();`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 30 | ``      final saved = prefs.getString(_prefsKey)?.trim() ?? '';`` | Mendeklarasikan variabel atau konstanta. |
| 31 | ``      _override = saved.isEmpty ? null : _normalizeBaseUrl(saved);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 32 | ``    } catch (_) {`` | Menutup blok, widget, atau pemanggilan method. |
| 33 | ``      _override = null;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 34 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 35 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 36 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 37 | ``  static Future<void> setOverride(String url) async {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 38 | ``    final clean = _normalizeBaseUrl(url);`` | Mendeklarasikan variabel atau konstanta. |
| 39 | ``    if (clean.isEmpty) throw ArgumentError('URL server kosong');`` | Mengatur percabangan logika. |
| 40 | ``    final uri = Uri.tryParse(clean);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 41 | ``    if (uri == null \|\|`` | Mengatur percabangan logika. |
| 42 | ``        !(uri.isScheme('http') \|\| uri.isScheme('https')) \|\|`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 43 | ``        uri.host.isEmpty) {`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 44 | ``      throw ArgumentError(`` | Menangani atau meneruskan error/exception. |
| 45 | ``        'URL tidak valid (contoh: http://192.168.1.11:8000/api)',`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 46 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 47 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 48 | ``    _override = clean;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 49 | ``    final prefs = await SharedPreferences.getInstance();`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 50 | ``    await prefs.setString(_prefsKey, clean);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 51 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 52 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 53 | ``  static Future<void> clearOverride() async {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 54 | ``    _override = null;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 55 | ``    final prefs = await SharedPreferences.getInstance();`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 56 | ``    await prefs.remove(_prefsKey);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 57 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 58 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 59 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 60 | ``String get baseUrl => ApiConfig.baseUrl;`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 61 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 62 | ``String friendlyNetworkError(Object networkError) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 63 | ``  final errorText = networkError.toString();`` | Mendeklarasikan variabel atau konstanta. |
| 64 | ``  final isNet =`` | Mendeklarasikan variabel atau konstanta. |
| 65 | ``      errorText.contains('SocketException') \|\|`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 66 | ``      errorText.contains('Connection refused') \|\|`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 67 | ``      errorText.contains('Connection timed out') \|\|`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 68 | ``      errorText.contains('ClientException') \|\|`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 69 | ``      errorText.contains('Failed host lookup') \|\|`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 70 | ``      errorText.contains('Network is unreachable');`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 71 | ``  if (!isNet) return 'Tidak bisa terhubung ke server: $networkError';`` | Mengatur percabangan logika. |
| 72 | ``  return 'Tidak bisa terhubung ke server ($baseUrl). '`` | Mengembalikan nilai dari fungsi atau widget. |
| 73 | ``      'Pastikan: 1) HP & laptop satu WiFi, '`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 74 | ``      '2) backend jalan dengan --host=0.0.0.0 --port=8000, '`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 75 | ``      '3) IP laptop masih benar (cek ipconfig, kalau beda ubah via ikon server di halaman login). '`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 76 | ``      'Detail: $networkError';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 77 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `api_client.dart`

Path: [`lib/api_client.dart`](lib/api_client.dart)
Jumlah baris: **57**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ``import 'package:http/http.dart' as http;`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 3 | ``import 'package:frontendats/auth_session.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 4 | ``import 'package:frontendats/login.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 5 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 6 | ``Map<String, String> authHeaders({bool withAuth = true}) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 7 | ``  final headers = <String, String>{'Content-Type': 'application/json'};`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 8 | ``  final token = AuthSession.instance.token;`` | Mendeklarasikan variabel atau konstanta. |
| 9 | ``  if (withAuth && token != null && token.isNotEmpty) {`` | Mengatur percabangan logika. |
| 10 | ``    headers['Authorization'] = 'Bearer $token';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 11 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 12 | ``  return headers;`` | Mengembalikan nilai dari fungsi atau widget. |
| 13 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 14 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 15 | ``Map<String, String> authOnlyHeaders() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 16 | ``  final token = AuthSession.instance.token;`` | Mendeklarasikan variabel atau konstanta. |
| 17 | ``  if (token != null && token.isNotEmpty) {`` | Mengatur percabangan logika. |
| 18 | ``    return {'Authorization': 'Bearer $token'};`` | Mengembalikan nilai dari fungsi atau widget. |
| 19 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 20 | ``  return {};`` | Mengembalikan nilai dari fungsi atau widget. |
| 21 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 22 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 23 | ``bool isUnauthorized(http.Response response) {`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 24 | ``  return response.statusCode == 401 \|\| response.statusCode == 403;`` | Mengembalikan nilai dari fungsi atau widget. |
| 25 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 26 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 27 | ``Future<bool> handleAuthError(`` | Mendefinisikan operasi asynchronous. |
| 28 | ``  BuildContext context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 29 | ``  http.Response response,`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 30 | ``) async {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 31 | ``  if (!isUnauthorized(response)) return false;`` | Mengatur percabangan logika. |
| 32 | ``  AuthSession.instance.clear();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 33 | ``  if (context.mounted) {`` | Mengatur percabangan logika. |
| 34 | ``    Navigator.pushAndRemoveUntil(`` | Menyusun elemen antarmuka Flutter. |
| 35 | ``      context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 36 | ``      MaterialPageRoute(builder: (_) => const LoginPage()),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 37 | ``      (_) => false,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 38 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 39 | ``    ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 40 | ``      const SnackBar(`` | Mendeklarasikan variabel atau konstanta. |
| 41 | ``        content: Text('Sesi habis / token tidak valid. Silakan login lagi.'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 42 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 43 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 44 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 45 | ``  return true;`` | Mengembalikan nilai dari fungsi atau widget. |
| 46 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 47 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 48 | ``void forceLogout(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 49 | ``  AuthSession.instance.clear();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 50 | ``  if (context.mounted) {`` | Mengatur percabangan logika. |
| 51 | ``    Navigator.pushAndRemoveUntil(`` | Menyusun elemen antarmuka Flutter. |
| 52 | ``      context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 53 | ``      MaterialPageRoute(builder: (_) => const LoginPage()),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 54 | ``      (_) => false,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 55 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 56 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 57 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `auth_session.dart`

Path: [`lib/auth_session.dart`](lib/auth_session.dart)
Jumlah baris: **22**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``class AuthSession {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 2 | ``  AuthSession._();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 3 | ``  static final AuthSession instance = AuthSession._();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 4 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 5 | ``  String? token;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 6 | ``  String? username;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 7 | ``  String? email;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 8 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 9 | ``  bool get isLoggedIn => token != null && token!.isNotEmpty;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 10 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 11 | ``  void setSession({required String token, String? username, String? email}) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 12 | ``    this.token = token;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 13 | ``    if (username != null) this.username = username;`` | Mengatur percabangan logika. |
| 14 | ``    if (email != null) this.email = email;`` | Mengatur percabangan logika. |
| 15 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 16 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 17 | ``  void clear() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 18 | ``    token = null;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 19 | ``    username = null;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 20 | ``    email = null;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 21 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 22 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `detailpost.dart`

Path: [`lib/detailpost.dart`](lib/detailpost.dart)
Jumlah baris: **244**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ``import 'package:http/http.dart' as http;`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 3 | ``import 'package:frontendats/api.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 4 | ``import 'package:frontendats/api_client.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 5 | ``import 'package:frontendats/editpost.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 6 | ``import 'package:frontendats/posts_refresh.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 7 | ``import 'package:frontendats/scribblr_theme.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 8 | ``import 'package:frontendats/scribblr_widgets.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 9 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 10 | ``class DetailPostPage extends StatefulWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 11 | ``  final Map post;`` | Mendeklarasikan variabel atau konstanta. |
| 12 | ``  final String category;`` | Mendeklarasikan variabel atau konstanta. |
| 13 | ``  final List<dynamic> categories;`` | Mendeklarasikan variabel atau konstanta. |
| 14 | ``  final String currentUsername;`` | Mendeklarasikan variabel atau konstanta. |
| 15 | ``  const DetailPostPage({`` | Mendeklarasikan variabel atau konstanta. |
| 16 | ``    super.key,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 17 | ``    required this.post,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 18 | ``    this.category = '',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 19 | ``    this.categories = const [],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 20 | ``    this.currentUsername = '',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 21 | ``  });`` | Menutup blok, widget, atau pemanggilan method. |
| 22 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 23 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 24 | ``  State<DetailPostPage> createState() => _DetailPostPageState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 25 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 26 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 27 | ``class _DetailPostPageState extends State<DetailPostPage> {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 28 | ``  bool isSaving = false;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 29 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 30 | ``  bool get _isMine =>`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 31 | ``      widget.currentUsername.isEmpty \|\|`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 32 | ``      isMine(widget.post, widget.currentUsername);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 33 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 34 | ``  Future<void> deletePost() async {`` | Mendefinisikan operasi asynchronous. |
| 35 | ``    if (!_isMine) {`` | Mengatur percabangan logika. |
| 36 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 37 | ``        const SnackBar(`` | Mendeklarasikan variabel atau konstanta. |
| 38 | ``          content: Text('Kamu hanya bisa menghapus artikelmu sendiri'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 39 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 40 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 41 | ``      return;`` | Mengembalikan nilai dari fungsi atau widget. |
| 42 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 43 | ``    final postId = strOf(widget.post, 'id');`` | Mendeklarasikan variabel atau konstanta. |
| 44 | ``    if (postId.isEmpty) {`` | Mengatur percabangan logika. |
| 45 | ``      ScaffoldMessenger.of(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 46 | ``        context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 47 | ``      ).showSnackBar(const SnackBar(content: Text('ID artikel tidak valid')));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 48 | ``      return;`` | Mengembalikan nilai dari fungsi atau widget. |
| 49 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 50 | ``    setState(() => isSaving = true);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 51 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 52 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 53 | ``      final data = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 54 | ``          .delete(Uri.parse('$baseUrl/posts/$postId'), headers: authHeaders())`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 55 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 56 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 57 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 58 | ``      if (await handleAuthError(context, data)) return;`` | Mengatur percabangan logika. |
| 59 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 60 | ``      if (data.statusCode == 200) {`` | Mengatur percabangan logika. |
| 61 | ``        PostsRefresh.bump();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 62 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 63 | ``          SnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 64 | ``            content: Text('Artikel berhasil dihapus: ${data.statusCode}'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 65 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 66 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 67 | ``        Navigator.pop(context, true);`` | Menyusun elemen antarmuka Flutter. |
| 68 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 69 | ``        debugPrint('Gagal menghapus artikel: ${data.statusCode} ${data.body}');`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 70 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 71 | ``          SnackBar(content: Text('Gagal menghapus: ${data.statusCode}')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 72 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 73 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 74 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 75 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 76 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 77 | ``        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 78 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 79 | ``    } finally {`` | Menutup blok, widget, atau pemanggilan method. |
| 80 | ``      if (mounted) setState(() => isSaving = false);`` | Mengatur percabangan logika. |
| 81 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 82 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 83 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 84 | ``  Future<void> askDelete() async {`` | Mendefinisikan operasi asynchronous. |
| 85 | ``    final ok = await confirmDeleteArticle(context);`` | Mendeklarasikan variabel atau konstanta. |
| 86 | ``    if (ok && mounted) deletePost();`` | Mengatur percabangan logika. |
| 87 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 88 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 89 | ``  void openEdit() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 90 | ``    if (!_isMine) {`` | Mengatur percabangan logika. |
| 91 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 92 | ``        const SnackBar(`` | Mendeklarasikan variabel atau konstanta. |
| 93 | ``          content: Text('Kamu hanya bisa mengedit artikelmu sendiri'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 94 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 95 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 96 | ``      return;`` | Mengembalikan nilai dari fungsi atau widget. |
| 97 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 98 | ``    Navigator.push(`` | Menyusun elemen antarmuka Flutter. |
| 99 | ``      context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 100 | ``      MaterialPageRoute(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 101 | ``        builder: (context) => EditPostPage(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 102 | ``          post: widget.post,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 103 | ``          categories: widget.categories,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 104 | ``          currentUsername: widget.currentUsername,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 105 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 106 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 107 | ``    ).then((ok) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 108 | ``      if (ok == true && mounted) Navigator.pop(context, true);`` | Mengatur percabangan logika. |
| 109 | ``    });`` | Menutup blok, widget, atau pemanggilan method. |
| 110 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 111 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 112 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 113 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 114 | ``    final post = widget.post;`` | Mendeklarasikan variabel atau konstanta. |
| 115 | ``    final cover = resolveCoverUrl(strOf(post, 'cover_image'));`` | Mendeklarasikan variabel atau konstanta. |
| 116 | ``    final author = strOf(post, 'author');`` | Mendeklarasikan variabel atau konstanta. |
| 117 | ``    final date = strOf(post, 'created_at');`` | Mendeklarasikan variabel atau konstanta. |
| 118 | ``    final title = strOf(post, 'title');`` | Mendeklarasikan variabel atau konstanta. |
| 119 | ``    final excerpt = strOf(post, 'excerpt');`` | Mendeklarasikan variabel atau konstanta. |
| 120 | ``    final content = strOf(post, 'content');`` | Mendeklarasikan variabel atau konstanta. |
| 121 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 122 | ``    return Scaffold(`` | Mengembalikan nilai dari fungsi atau widget. |
| 123 | ``      appBar: AppBar(`` | Menyusun elemen antarmuka Flutter. |
| 124 | ``        leading: const BackButton(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 125 | ``        title: const Text('Article'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 126 | ``        actions: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 127 | ``          if (_isMine) ...[`` | Mengatur percabangan logika. |
| 128 | ``            IconButton(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 129 | ``              onPressed: openEdit,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 130 | ``              icon: const Icon(Icons.edit_outlined),`` | Menyusun elemen antarmuka Flutter. |
| 131 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 132 | ``            IconButton(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 133 | ``              onPressed: isSaving ? null : askDelete,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 134 | ``              icon: const Icon(Icons.delete_outline),`` | Menyusun elemen antarmuka Flutter. |
| 135 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 136 | ``          ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 137 | ``        ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 138 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 139 | ``      body: ListView(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 140 | ``        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),`` | Menyusun elemen antarmuka Flutter. |
| 141 | ``        children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 142 | ``          if (widget.category.isNotEmpty)`` | Mengatur percabangan logika. |
| 143 | ``            Container(`` | Menyusun elemen antarmuka Flutter. |
| 144 | ``              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),`` | Menyusun elemen antarmuka Flutter. |
| 145 | ``              decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 146 | ``                color: ScribblrColors.chipBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 147 | ``                borderRadius: BorderRadius.circular(20),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 148 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 149 | ``              child: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 150 | ``                widget.category,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 151 | ``                style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 152 | ``                  fontSize: 11,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 153 | ``                  fontWeight: FontWeight.w700,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 154 | ``                  color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 155 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 156 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 157 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 158 | ``          const SizedBox(height: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 159 | ``          Text(`` | Menyusun elemen antarmuka Flutter. |
| 160 | ``            title.isEmpty ? '(Tanpa judul)' : title,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 161 | ``            style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 162 | ``              fontSize: 24,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 163 | ``              fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 164 | ``              height: 1.3,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 165 | ``              color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 166 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 167 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 168 | ``          const SizedBox(height: 10),`` | Mendeklarasikan variabel atau konstanta. |
| 169 | ``          Row(`` | Menyusun elemen antarmuka Flutter. |
| 170 | ``            children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 171 | ``              const CircleAvatar(`` | Mendeklarasikan variabel atau konstanta. |
| 172 | ``                radius: 16,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 173 | ``                backgroundColor: ScribblrColors.chipBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 174 | ``                child: Icon(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 175 | ``                  Icons.person,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 176 | ``                  size: 16,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 177 | ``                  color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 178 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 179 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 180 | ``              const SizedBox(width: 8),`` | Mendeklarasikan variabel atau konstanta. |
| 181 | ``              Expanded(`` | Menyusun elemen antarmuka Flutter. |
| 182 | ``                child: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 183 | ``                  [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 184 | ``                    if (author.isNotEmpty) author,`` | Mengatur percabangan logika. |
| 185 | ``                    if (date.isNotEmpty) date,`` | Mengatur percabangan logika. |
| 186 | ``                  ].join('  \u2022  '),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 187 | ``                  style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 188 | ``                    fontSize: 12,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 189 | ``                    color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 190 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 191 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 192 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 193 | ``            ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 194 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 195 | ``          const SizedBox(height: 16),`` | Mendeklarasikan variabel atau konstanta. |
| 196 | ``          ClipRRect(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 197 | ``            borderRadius: BorderRadius.circular(20),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 198 | ``            child: Container(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 199 | ``              height: 200,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 200 | ``              color: ScribblrColors.placeholderBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 201 | ``              child: cover.isEmpty`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 202 | ``                  ? const Icon(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 203 | ``                      Icons.image_outlined,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 204 | ``                      size: 44,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 205 | ``                      color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 206 | ``                    )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 207 | ``                  : Image.network(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 208 | ``                      cover,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 209 | ``                      fit: BoxFit.cover,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 210 | ``                      errorBuilder: (_, _, _) => const Icon(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 211 | ``                        Icons.image_outlined,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 212 | ``                        size: 44,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 213 | ``                        color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 214 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 215 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 216 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 217 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 218 | ``          const SizedBox(height: 16),`` | Mendeklarasikan variabel atau konstanta. |
| 219 | ``          if (excerpt.isNotEmpty) ...[`` | Mengatur percabangan logika. |
| 220 | ``            Text(`` | Menyusun elemen antarmuka Flutter. |
| 221 | ``              excerpt,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 222 | ``              style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 223 | ``                fontSize: 14,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 224 | ``                fontStyle: FontStyle.italic,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 225 | ``                color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 226 | ``                height: 1.6,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 227 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 228 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 229 | ``            const SizedBox(height: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 230 | ``          ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 231 | ``          Text(`` | Menyusun elemen antarmuka Flutter. |
| 232 | ``            content.isEmpty ? 'Tidak ada isi.' : content,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 233 | ``            style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 234 | ``              fontSize: 15,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 235 | ``              height: 1.7,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 236 | ``              color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 237 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 238 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 239 | ``          const SizedBox(height: 32),`` | Mendeklarasikan variabel atau konstanta. |
| 240 | ``        ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 241 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 242 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 243 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 244 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `discover.dart`

Path: [`lib/discover.dart`](lib/discover.dart)
Jumlah baris: **680**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ``import 'package:http/http.dart' as http;`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 3 | ``import 'dart:convert';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 4 | ``import 'package:frontendats/api.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 5 | ``import 'package:frontendats/api_client.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 6 | ``import 'package:frontendats/detailpost.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 7 | ``import 'package:frontendats/posts_refresh.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 8 | ``import 'package:frontendats/scribblr_theme.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 9 | ``import 'package:frontendats/scribblr_widgets.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 10 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 11 | ``class DiscoverPage extends StatefulWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 12 | ``  final String username;`` | Mendeklarasikan variabel atau konstanta. |
| 13 | ``  const DiscoverPage({super.key, this.username = ''});`` | Mendeklarasikan variabel atau konstanta. |
| 14 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 15 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 16 | ``  State<DiscoverPage> createState() => _DiscoverPageState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 17 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 18 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 19 | ``class _DiscoverPageState extends State<DiscoverPage> {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 20 | ``  List<dynamic> posts = [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 21 | ``  List<dynamic> categories = [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 22 | ``  bool isLoading = false;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 23 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 24 | ``  final Set<String> selectedIds = {};`` | Mendeklarasikan variabel atau konstanta. |
| 25 | ``  final searchController = TextEditingController();`` | Mendeklarasikan variabel atau konstanta. |
| 26 | ``  String query = '';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 27 | ``  int _seenVersion = -1;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 28 | ``  bool _catSaving = false;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 29 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 30 | ``  String categoryName(dynamic id) => catNameOf(categories, id);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 31 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 32 | ``  int categoryUsage(String id) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 33 | ``    var usageCount = 0;`` | Mendeklarasikan variabel atau konstanta. |
| 34 | ``    for (final postItem in posts) {`` | Melakukan iterasi atas data. |
| 35 | ``      if (postItem is Map && postCategoryIds(postItem).contains(id))`` | Mengatur percabangan logika. |
| 36 | ``        usageCount++;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 37 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 38 | ``    return usageCount;`` | Mengembalikan nilai dari fungsi atau widget. |
| 39 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 40 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 41 | ``  Future<void> fetchDiscoverData() async {`` | Mendefinisikan operasi asynchronous. |
| 42 | ``    setState(() => isLoading = true);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 43 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 44 | ``      final postRes = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 45 | ``          .get(Uri.parse('$baseUrl/posts'), headers: authHeaders())`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 46 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 47 | ``      final catRes = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 48 | ``          .get(Uri.parse('$baseUrl/categories'), headers: authHeaders())`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 49 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 50 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 51 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 52 | ``      setState(() => isLoading = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 53 | ``      if (isUnauthorized(postRes) \|\| isUnauthorized(catRes)) {`` | Mengatur percabangan logika. |
| 54 | ``        await handleAuthError(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 55 | ``          context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 56 | ``          postRes.statusCode == 401 \|\| postRes.statusCode == 403`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 57 | ``              ? postRes`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 58 | ``              : catRes,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 59 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 60 | ``        return;`` | Mengembalikan nilai dari fungsi atau widget. |
| 61 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 62 | ``      if (postRes.statusCode == 200) {`` | Mengatur percabangan logika. |
| 63 | ``        try {`` | Menangani atau meneruskan error/exception. |
| 64 | ``          final body = jsonDecode(postRes.body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 65 | ``          final list = (body is Map ? body['data'] : null) ?? [];`` | Mendeklarasikan variabel atau konstanta. |
| 66 | ``          setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 67 | ``            posts = list is List ? list : [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 68 | ``          });`` | Menutup blok, widget, atau pemanggilan method. |
| 69 | ``        } catch (_) {}`` | Menutup blok, widget, atau pemanggilan method. |
| 70 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 71 | ``      if (catRes.statusCode == 200) {`` | Mengatur percabangan logika. |
| 72 | ``        try {`` | Menangani atau meneruskan error/exception. |
| 73 | ``          final body = jsonDecode(catRes.body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 74 | ``          final list = (body is Map ? body['data'] : null) ?? [];`` | Mendeklarasikan variabel atau konstanta. |
| 75 | ``          setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 76 | ``            categories = list is List ? list : [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 77 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 78 | ``            final alive = categories`` | Mendeklarasikan variabel atau konstanta. |
| 79 | ``                .whereType<Map>()`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 80 | ``                .map((categoryItem) => categoryItem['id']?.toString() ?? '')`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 81 | ``                .toSet();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 82 | ``            selectedIds.retainWhere(alive.contains);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 83 | ``          });`` | Menutup blok, widget, atau pemanggilan method. |
| 84 | ``        } catch (_) {}`` | Menutup blok, widget, atau pemanggilan method. |
| 85 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 86 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 87 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 88 | ``      setState(() => isLoading = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 89 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 90 | ``        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 91 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 92 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 93 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 94 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 95 | ``  Future<void> openManageCategory(Map cat) async {`` | Mendefinisikan operasi asynchronous. |
| 96 | ``    final id = cat['id']?.toString() ?? '';`` | Mendeklarasikan variabel atau konstanta. |
| 97 | ``    if (id.isEmpty) return;`` | Mengatur percabangan logika. |
| 98 | ``    final name = strOf(cat, 'name');`` | Mendeklarasikan variabel atau konstanta. |
| 99 | ``    final used = categoryUsage(id);`` | Mendeklarasikan variabel atau konstanta. |
| 100 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 101 | ``    await showModalBottomSheet(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 102 | ``      context: context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 103 | ``      backgroundColor: ScribblrColors.surface,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 104 | ``      shape: const RoundedRectangleBorder(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 105 | ``        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 106 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 107 | ``      builder: (ctx) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 108 | ``        return SafeArea(`` | Mengembalikan nilai dari fungsi atau widget. |
| 109 | ``          child: Padding(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 110 | ``            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),`` | Menyusun elemen antarmuka Flutter. |
| 111 | ``            child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 112 | ``              mainAxisSize: MainAxisSize.min,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 113 | ``              children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 114 | ``                Container(`` | Menyusun elemen antarmuka Flutter. |
| 115 | ``                  width: 40,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 116 | ``                  height: 4,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 117 | ``                  decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 118 | ``                    color: ScribblrColors.line,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 119 | ``                    borderRadius: BorderRadius.circular(4),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 120 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 121 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 122 | ``                const SizedBox(height: 14),`` | Mendeklarasikan variabel atau konstanta. |
| 123 | ``                Row(`` | Menyusun elemen antarmuka Flutter. |
| 124 | ``                  children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 125 | ``                    ClipRRect(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 126 | ``                      borderRadius: BorderRadius.circular(14),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 127 | ``                      child: Image.asset(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 128 | ``                        'assets/logokpi.png',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 129 | ``                        width: 44,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 130 | ``                        height: 44,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 131 | ``                        fit: BoxFit.cover,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 132 | ``                        errorBuilder: (_, _, _) => Container(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 133 | ``                          width: 44,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 134 | ``                          height: 44,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 135 | ``                          color: ScribblrColors.chipBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 136 | ``                          child: const Icon(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 137 | ``                            Icons.label_outline,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 138 | ``                            color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 139 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 140 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 141 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 142 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 143 | ``                    const SizedBox(width: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 144 | ``                    Expanded(`` | Menyusun elemen antarmuka Flutter. |
| 145 | ``                      child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 146 | ``                        crossAxisAlignment: CrossAxisAlignment.start,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 147 | ``                        children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 148 | ``                          Text(`` | Menyusun elemen antarmuka Flutter. |
| 149 | ``                            name.isEmpty ? 'Tanpa nama' : name,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 150 | ``                            style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 151 | ``                              fontSize: 16,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 152 | ``                              fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 153 | ``                              color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 154 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 155 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 156 | ``                          Text(`` | Menyusun elemen antarmuka Flutter. |
| 157 | ``                            used == 0`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 158 | ``                                ? 'Belum dipakai artikel'`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 159 | ``                                : 'Dipakai $used artikel',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 160 | ``                            style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 161 | ``                              fontSize: 12,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 162 | ``                              color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 163 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 164 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 165 | ``                        ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 166 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 167 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 168 | ``                  ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 169 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 170 | ``                const SizedBox(height: 16),`` | Mendeklarasikan variabel atau konstanta. |
| 171 | ``                Row(`` | Menyusun elemen antarmuka Flutter. |
| 172 | ``                  children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 173 | ``                    Expanded(`` | Menyusun elemen antarmuka Flutter. |
| 174 | ``                      child: OutlinedButton.icon(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 175 | ``                        onPressed: () {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 176 | ``                          Navigator.pop(ctx);`` | Menyusun elemen antarmuka Flutter. |
| 177 | ``                          openEditCategory(cat);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 178 | ``                        },`` | Menutup blok, widget, atau pemanggilan method. |
| 179 | ``                        icon: const Icon(Icons.edit_outlined, size: 18),`` | Menyusun elemen antarmuka Flutter. |
| 180 | ``                        label: const Text('Edit'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 181 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 182 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 183 | ``                    const SizedBox(width: 10),`` | Mendeklarasikan variabel atau konstanta. |
| 184 | ``                    Expanded(`` | Menyusun elemen antarmuka Flutter. |
| 185 | ``                      child: OutlinedButton.icon(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 186 | ``                        onPressed: () {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 187 | ``                          Navigator.pop(ctx);`` | Menyusun elemen antarmuka Flutter. |
| 188 | ``                          confirmDeleteCategory(cat, used);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 189 | ``                        },`` | Menutup blok, widget, atau pemanggilan method. |
| 190 | ``                        icon: const Icon(`` | Menyusun elemen antarmuka Flutter. |
| 191 | ``                          Icons.delete_outline,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 192 | ``                          size: 18,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 193 | ``                          color: Colors.redAccent,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 194 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 195 | ``                        label: const Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 196 | ``                          'Hapus',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 197 | ``                          style: TextStyle(color: Colors.redAccent),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 198 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 199 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 200 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 201 | ``                  ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 202 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 203 | ``              ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 204 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 205 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 206 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 207 | ``      },`` | Menutup blok, widget, atau pemanggilan method. |
| 208 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 209 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 210 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 211 | ``  Future<void> openEditCategory(Map cat) async {`` | Mendefinisikan operasi asynchronous. |
| 212 | ``    final id = cat['id']?.toString() ?? '';`` | Mendeklarasikan variabel atau konstanta. |
| 213 | ``    if (id.isEmpty) return;`` | Mengatur percabangan logika. |
| 214 | ``    final nameController = TextEditingController(text: strOf(cat, 'name'));`` | Mendeklarasikan variabel atau konstanta. |
| 215 | ``    final descController = TextEditingController(`` | Mendeklarasikan variabel atau konstanta. |
| 216 | ``      text: strOf(cat, 'description'),`` | Menyusun elemen antarmuka Flutter. |
| 217 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 218 | ``    final formKey = GlobalKey<FormState>();`` | Mendeklarasikan variabel atau konstanta. |
| 219 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 220 | ``    final save = await showDialog<bool>(`` | Mendeklarasikan variabel atau konstanta. |
| 221 | ``      context: context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 222 | ``      builder: (ctx) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 223 | ``        return AlertDialog(`` | Mengembalikan nilai dari fungsi atau widget. |
| 224 | ``          backgroundColor: ScribblrColors.surface,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 225 | ``          shape: RoundedRectangleBorder(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 226 | ``            borderRadius: BorderRadius.circular(20),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 227 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 228 | ``          title: const Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 229 | ``            'Edit Topic',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 230 | ``            style: TextStyle(fontWeight: FontWeight.w700),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 231 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 232 | ``          content: Form(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 233 | ``            key: formKey,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 234 | ``            child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 235 | ``              mainAxisSize: MainAxisSize.min,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 236 | ``              children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 237 | ``                TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 238 | ``                  controller: nameController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 239 | ``                  decoration: const InputDecoration(hintText: 'Topic name'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 240 | ``                  validator: (value) => (value == null \|\| value.trim().isEmpty)`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 241 | ``                      ? 'Wajib diisi'`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 242 | ``                      : null,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 243 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 244 | ``                const SizedBox(height: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 245 | ``                TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 246 | ``                  controller: descController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 247 | ``                  decoration: const InputDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 248 | ``                    hintText: 'Description (opsional)',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 249 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 250 | ``                  maxLines: 2,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 251 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 252 | ``              ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 253 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 254 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 255 | ``          actions: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 256 | ``            TextButton(`` | Menyusun elemen antarmuka Flutter. |
| 257 | ``              onPressed: () => Navigator.pop(ctx, false),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 258 | ``              child: const Text('Cancel'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 259 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 260 | ``            ElevatedButton(`` | Menyusun elemen antarmuka Flutter. |
| 261 | ``              style: ElevatedButton.styleFrom(minimumSize: const Size(100, 44)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 262 | ``              onPressed: () {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 263 | ``                if (formKey.currentState?.validate() != true) return;`` | Mengatur percabangan logika. |
| 264 | ``                Navigator.pop(ctx, true);`` | Menyusun elemen antarmuka Flutter. |
| 265 | ``              },`` | Menutup blok, widget, atau pemanggilan method. |
| 266 | ``              child: const Text('Save'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 267 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 268 | ``          ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 269 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 270 | ``      },`` | Menutup blok, widget, atau pemanggilan method. |
| 271 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 272 | ``    if (save != true \|\| !mounted) return;`` | Mengatur percabangan logika. |
| 273 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 274 | ``    final name = nameController.text.trim();`` | Mendeklarasikan variabel atau konstanta. |
| 275 | ``    var slug = makeCategorySlug(name);`` | Mendeklarasikan variabel atau konstanta. |
| 276 | ``    if (slug.isEmpty) slug = 'topic-$id';`` | Mengatur percabangan logika. |
| 277 | ``    setState(() => _catSaving = true);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 278 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 279 | ``      final res = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 280 | ``          .put(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 281 | ``            Uri.parse('$baseUrl/categories/$id'),`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 282 | ``            headers: authHeaders(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 283 | ``            body: jsonEncode({`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 284 | ``              'name': name,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 285 | ``              'slug': slug,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 286 | ``              'description': descController.text.trim().isEmpty`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 287 | ``                  ? null`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 288 | ``                  : descController.text.trim(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 289 | ``            }),`` | Menutup blok, widget, atau pemanggilan method. |
| 290 | ``          )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 291 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 292 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 293 | ``      if (await handleAuthError(context, res)) return;`` | Mengatur percabangan logika. |
| 294 | ``      if (res.statusCode == 200) {`` | Mengatur percabangan logika. |
| 295 | ``        ScaffoldMessenger.of(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 296 | ``          context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 297 | ``        ).showSnackBar(const SnackBar(content: Text('Topik diperbarui')));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 298 | ``        PostsRefresh.bump();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 299 | ``        await fetchDiscoverData();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 300 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 301 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 302 | ``          SnackBar(content: Text('Gagal update topik: ${res.statusCode}')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 303 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 304 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 305 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 306 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 307 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 308 | ``        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 309 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 310 | ``    } finally {`` | Menutup blok, widget, atau pemanggilan method. |
| 311 | ``      if (mounted) setState(() => _catSaving = false);`` | Mengatur percabangan logika. |
| 312 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 313 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 314 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 315 | ``  Future<void> confirmDeleteCategory(Map cat, int used) async {`` | Mendefinisikan operasi asynchronous. |
| 316 | ``    final id = cat['id']?.toString() ?? '';`` | Mendeklarasikan variabel atau konstanta. |
| 317 | ``    if (id.isEmpty) return;`` | Mengatur percabangan logika. |
| 318 | ``    final name = strOf(cat, 'name');`` | Mendeklarasikan variabel atau konstanta. |
| 319 | ``    final ok = await showDialog<bool>(`` | Mendeklarasikan variabel atau konstanta. |
| 320 | ``      context: context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 321 | ``      builder: (ctx) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 322 | ``        return AlertDialog(`` | Mengembalikan nilai dari fungsi atau widget. |
| 323 | ``          backgroundColor: ScribblrColors.surface,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 324 | ``          shape: RoundedRectangleBorder(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 325 | ``            borderRadius: BorderRadius.circular(20),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 326 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 327 | ``          title: const Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 328 | ``            'Delete Topic',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 329 | ``            style: TextStyle(fontWeight: FontWeight.w700),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 330 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 331 | ``          content: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 332 | ``            used == 0`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 333 | ``                ? 'Hapus topik "$name"? Tindakan ini tidak bisa dibatalkan.'`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 334 | ``                : 'Topik "$name" dipakai $used artikel. '`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 335 | ``                      'Artikel tersebut akan kehilangan kategori ini. '`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 336 | ``                      'Tetap hapus?',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 337 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 338 | ``          actions: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 339 | ``            TextButton(`` | Menyusun elemen antarmuka Flutter. |
| 340 | ``              onPressed: () => Navigator.pop(ctx, false),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 341 | ``              child: const Text('Cancel'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 342 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 343 | ``            ElevatedButton(`` | Menyusun elemen antarmuka Flutter. |
| 344 | ``              style: ElevatedButton.styleFrom(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 345 | ``                backgroundColor: Colors.redAccent,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 346 | ``                minimumSize: const Size(110, 44),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 347 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 348 | ``              onPressed: () => Navigator.pop(ctx, true),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 349 | ``              child: const Text('Yes, Delete'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 350 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 351 | ``          ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 352 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 353 | ``      },`` | Menutup blok, widget, atau pemanggilan method. |
| 354 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 355 | ``    if (ok != true \|\| !mounted) return;`` | Mengatur percabangan logika. |
| 356 | ``    setState(() => _catSaving = true);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 357 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 358 | ``      final res = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 359 | ``          .delete(Uri.parse('$baseUrl/categories/$id'), headers: authHeaders())`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 360 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 361 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 362 | ``      if (await handleAuthError(context, res)) return;`` | Mengatur percabangan logika. |
| 363 | ``      if (res.statusCode == 200 \|\| res.statusCode == 204) {`` | Mengatur percabangan logika. |
| 364 | ``        setState(() => selectedIds.remove(id));`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 365 | ``        ScaffoldMessenger.of(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 366 | ``          context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 367 | ``        ).showSnackBar(const SnackBar(content: Text('Topik dihapus')));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 368 | ``        PostsRefresh.bump();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 369 | ``        await fetchDiscoverData();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 370 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 371 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 372 | ``          SnackBar(content: Text('Gagal hapus topik: ${res.statusCode}')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 373 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 374 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 375 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 376 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 377 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 378 | ``        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 379 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 380 | ``    } finally {`` | Menutup blok, widget, atau pemanggilan method. |
| 381 | ``      if (mounted) setState(() => _catSaving = false);`` | Mengatur percabangan logika. |
| 382 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 383 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 384 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 385 | ``  void _onRefreshBus() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 386 | ``    if (PostsRefresh.notifier.value != _seenVersion) {`` | Mengatur percabangan logika. |
| 387 | ``      _seenVersion = PostsRefresh.notifier.value;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 388 | ``      fetchDiscoverData();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 389 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 390 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 391 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 392 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 393 | ``  void initState() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 394 | ``    super.initState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 395 | ``    _seenVersion = PostsRefresh.notifier.value;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 396 | ``    PostsRefresh.notifier.addListener(_onRefreshBus);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 397 | ``    fetchDiscoverData();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 398 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 399 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 400 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 401 | ``  void dispose() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 402 | ``    PostsRefresh.notifier.removeListener(_onRefreshBus);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 403 | ``    searchController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 404 | ``    super.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 405 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 406 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 407 | ``  Widget _catAvatar(bool selected) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 408 | ``    return CircleAvatar(`` | Mengembalikan nilai dari fungsi atau widget. |
| 409 | ``      radius: 11,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 410 | ``      backgroundColor: selected ? Colors.white24 : ScribblrColors.chipBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 411 | ``      backgroundImage: const AssetImage('assets/logokpi.png'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 412 | ``      onBackgroundImageError: (_, _) {},`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 413 | ``      child: const SizedBox.shrink(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 414 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 415 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 416 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 417 | ``  Widget _topicChip(Map categoryItem) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 418 | ``    final id = categoryItem['id']?.toString() ?? '';`` | Mendeklarasikan variabel atau konstanta. |
| 419 | ``    final selected = selectedIds.contains(id);`` | Mendeklarasikan variabel atau konstanta. |
| 420 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 421 | ``    return GestureDetector(`` | Mengembalikan nilai dari fungsi atau widget. |
| 422 | ``      onLongPress: () => openManageCategory(categoryItem),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 423 | ``      child: FilterChip(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 424 | ``        label: Text(strOf(categoryItem, 'name')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 425 | ``        avatar: _catAvatar(selected),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 426 | ``        selected: selected,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 427 | ``        onSelected: (_) => setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 428 | ``          if (selected) {`` | Mengatur percabangan logika. |
| 429 | ``            selectedIds.remove(id);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 430 | ``          } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 431 | ``            selectedIds.add(id);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 432 | ``          }`` | Menutup blok, widget, atau pemanggilan method. |
| 433 | ``        }),`` | Menutup blok, widget, atau pemanggilan method. |
| 434 | ``        selectedColor: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 435 | ``        labelStyle: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 436 | ``          color: selected ? Colors.white : ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 437 | ``          fontWeight: FontWeight.w600,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 438 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 439 | ``        shape: const StadiumBorder(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 440 | ``          side: BorderSide(color: ScribblrColors.line),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 441 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 442 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 443 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 444 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 445 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 446 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 447 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 448 | ``    final normalizedQuery = query.trim().toLowerCase();`` | Mendeklarasikan variabel atau konstanta. |
| 449 | ``    final filtered = posts.where((postItem) {`` | Mendeklarasikan variabel atau konstanta. |
| 450 | ``      if (postItem is! Map) return false;`` | Mengatur percabangan logika. |
| 451 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 452 | ``      if (selectedIds.isNotEmpty) {`` | Mengatur percabangan logika. |
| 453 | ``        final ids = postCategoryIds(postItem);`` | Mendeklarasikan variabel atau konstanta. |
| 454 | ``        if (ids.intersection(selectedIds).isEmpty) return false;`` | Mengatur percabangan logika. |
| 455 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 456 | ``      if (normalizedQuery.isNotEmpty &&`` | Mengatur percabangan logika. |
| 457 | ``          !strOf(postItem, 'title').toLowerCase().contains(normalizedQuery)) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 458 | ``        return false;`` | Mengembalikan nilai dari fungsi atau widget. |
| 459 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 460 | ``      return true;`` | Mengembalikan nilai dari fungsi atau widget. |
| 461 | ``    }).toList();`` | Menutup blok, widget, atau pemanggilan method. |
| 462 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 463 | ``    final selectionLabel = selectedIds.isEmpty`` | Mendeklarasikan variabel atau konstanta. |
| 464 | ``        ? 'All Articles (${filtered.length})'`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 465 | ``        : selectedIds.length == 1`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 466 | ``        ? '${categoryName(selectedIds.first)} (${filtered.length})'`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 467 | ``        : '${selectedIds.length} topik (${filtered.length})';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 468 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 469 | ``    return Scaffold(`` | Mengembalikan nilai dari fungsi atau widget. |
| 470 | ``      body: SafeArea(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 471 | ``        child: isLoading \|\| _catSaving`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 472 | ``            ? const Center(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 473 | ``                child: CircularProgressIndicator(color: ScribblrColors.primary),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 474 | ``              )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 475 | ``            : RefreshIndicator(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 476 | ``                color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 477 | ``                onRefresh: fetchDiscoverData,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 478 | ``                child: ListView(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 479 | ``                  padding: const EdgeInsets.symmetric(`` | Menyusun elemen antarmuka Flutter. |
| 480 | ``                    horizontal: 20,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 481 | ``                    vertical: 16,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 482 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 483 | ``                  children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 484 | ``                    const ScribblrHeader(`` | Mendeklarasikan variabel atau konstanta. |
| 485 | ``                      title: 'Discover',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 486 | ``                      subtitle: 'Browse topics and articles.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 487 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 488 | ``                    const SizedBox(height: 16),`` | Mendeklarasikan variabel atau konstanta. |
| 489 | ``                    TextField(`` | Menyusun elemen antarmuka Flutter. |
| 490 | ``                      controller: searchController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 491 | ``                      textInputAction: TextInputAction.search,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 492 | ``                      onChanged: (value) => setState(() => query = value),`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 493 | ``                      decoration: InputDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 494 | ``                        hintText: 'Search by title...',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 495 | ``                        prefixIcon: const Icon(Icons.search),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 496 | ``                        suffixIcon: query.isEmpty`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 497 | ``                            ? null`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 498 | ``                            : IconButton(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 499 | ``                                onPressed: () {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 500 | ``                                  searchController.clear();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 501 | ``                                  setState(() => query = '');`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 502 | ``                                },`` | Menutup blok, widget, atau pemanggilan method. |
| 503 | ``                                icon: const Icon(Icons.close),`` | Menyusun elemen antarmuka Flutter. |
| 504 | ``                              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 505 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 506 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 507 | ``                    const SizedBox(height: 16),`` | Mendeklarasikan variabel atau konstanta. |
| 508 | ``                    Row(`` | Menyusun elemen antarmuka Flutter. |
| 509 | ``                      children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 510 | ``                        const Text(`` | Mendeklarasikan variabel atau konstanta. |
| 511 | ``                          'Explore by Topics',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 512 | ``                          style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 513 | ``                            fontSize: 16,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 514 | ``                            fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 515 | ``                            color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 516 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 517 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 518 | ``                        const Spacer(),`` | Mendeklarasikan variabel atau konstanta. |
| 519 | ``                        if (selectedIds.isNotEmpty)`` | Mengatur percabangan logika. |
| 520 | ``                          TextButton(`` | Menyusun elemen antarmuka Flutter. |
| 521 | ``                            onPressed: () =>`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 522 | ``                                setState(() => selectedIds.clear()),`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 523 | ``                            child: Text('Clear (${selectedIds.length})'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 524 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 525 | ``                      ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 526 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 527 | ``                    const Row(`` | Mendeklarasikan variabel atau konstanta. |
| 528 | ``                      children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 529 | ``                        Icon(`` | Menyusun elemen antarmuka Flutter. |
| 530 | ``                          Icons.touch_app_outlined,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 531 | ``                          size: 14,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 532 | ``                          color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 533 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 534 | ``                        SizedBox(width: 4),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 535 | ``                        Text(`` | Menyusun elemen antarmuka Flutter. |
| 536 | ``                          'Tap untuk filter banyak, tahan lama untuk kelola.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 537 | ``                          style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 538 | ``                            fontSize: 12,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 539 | ``                            color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 540 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 541 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 542 | ``                      ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 543 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 544 | ``                    const SizedBox(height: 10),`` | Mendeklarasikan variabel atau konstanta. |
| 545 | ``                    if (categories.isEmpty)`` | Mengatur percabangan logika. |
| 546 | ``                      const Text(`` | Mendeklarasikan variabel atau konstanta. |
| 547 | ``                        'Belum ada kategori.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 548 | ``                        style: TextStyle(color: ScribblrColors.muted),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 549 | ``                      )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 550 | ``                    else`` | Mengatur percabangan logika. |
| 551 | ``                      SingleChildScrollView(`` | Menyusun elemen antarmuka Flutter. |
| 552 | ``                        scrollDirection: Axis.horizontal,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 553 | ``                        child: Row(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 554 | ``                          children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 555 | ``                            ChoiceChip(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 556 | ``                              label: const Text('All'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 557 | ``                              selected: selectedIds.isEmpty,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 558 | ``                              onSelected: (_) =>`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 559 | ``                                  setState(() => selectedIds.clear()),`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 560 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 561 | ``                            const SizedBox(width: 8),`` | Mendeklarasikan variabel atau konstanta. |
| 562 | ``                            ...categories.map((categoryItem) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 563 | ``                              return Padding(`` | Mengembalikan nilai dari fungsi atau widget. |
| 564 | ``                                padding: const EdgeInsets.only(right: 8),`` | Menyusun elemen antarmuka Flutter. |
| 565 | ``                                child: _topicChip(categoryItem as Map),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 566 | ``                              );`` | Menutup blok, widget, atau pemanggilan method. |
| 567 | ``                            }),`` | Menutup blok, widget, atau pemanggilan method. |
| 568 | ``                          ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 569 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 570 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 571 | ``                    const SizedBox(height: 20),`` | Mendeklarasikan variabel atau konstanta. |
| 572 | ``                    Text(`` | Menyusun elemen antarmuka Flutter. |
| 573 | ``                      selectionLabel,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 574 | ``                      style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 575 | ``                        fontSize: 16,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 576 | ``                        fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 577 | ``                        color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 578 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 579 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 580 | ``                    const SizedBox(height: 10),`` | Mendeklarasikan variabel atau konstanta. |
| 581 | ``                    if (filtered.isEmpty)`` | Mengatur percabangan logika. |
| 582 | ``                      Padding(`` | Menyusun elemen antarmuka Flutter. |
| 583 | ``                        padding: const EdgeInsets.symmetric(vertical: 24),`` | Menyusun elemen antarmuka Flutter. |
| 584 | ``                        child: Center(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 585 | ``                          child: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 586 | ``                            normalizedQuery.isNotEmpty`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 587 | ``                                ? 'Tidak ketemu artikel berjudul "$query".'`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 588 | ``                                : 'Tidak ada artikel di kategori ini.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 589 | ``                            style: const TextStyle(color: ScribblrColors.muted),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 590 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 591 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 592 | ``                      )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 593 | ``                    else`` | Mengatur percabangan logika. |
| 594 | ``                      ...filtered.map(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 595 | ``                        (postItem) => Padding(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 596 | ``                          padding: const EdgeInsets.only(bottom: 10),`` | Menyusun elemen antarmuka Flutter. |
| 597 | ``                          child: ScribblrCard(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 598 | ``                            onTap: () {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 599 | ``                              Navigator.push(`` | Menyusun elemen antarmuka Flutter. |
| 600 | ``                                context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 601 | ``                                MaterialPageRoute(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 602 | ``                                  builder: (context) => DetailPostPage(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 603 | ``                                    post: postItem,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 604 | ``                                    category: categoryName(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 605 | ``                                      primaryCategoryId(postItem),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 606 | ``                                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 607 | ``                                    categories: categories,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 608 | ``                                    currentUsername: widget.username,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 609 | ``                                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 610 | ``                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 611 | ``                              ).then((ok) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 612 | ``                                if (ok == true) fetchDiscoverData();`` | Mengatur percabangan logika. |
| 613 | ``                              });`` | Menutup blok, widget, atau pemanggilan method. |
| 614 | ``                            },`` | Menutup blok, widget, atau pemanggilan method. |
| 615 | ``                            child: Row(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 616 | ``                              children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 617 | ``                                ScribblrThumb(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 618 | ``                                  cover: (postItem as Map)['cover_image'],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 619 | ``                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 620 | ``                                const SizedBox(width: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 621 | ``                                Expanded(`` | Menyusun elemen antarmuka Flutter. |
| 622 | ``                                  child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 623 | ``                                    crossAxisAlignment:`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 624 | ``                                        CrossAxisAlignment.start,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 625 | ``                                    children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 626 | ``                                      Text(`` | Menyusun elemen antarmuka Flutter. |
| 627 | ``                                        categoryLabelOf(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 628 | ``                                          categories,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 629 | ``                                          postItem,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 630 | ``                                        ).toUpperCase(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 631 | ``                                        style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 632 | ``                                          fontSize: 10,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 633 | ``                                          fontWeight: FontWeight.w700,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 634 | ``                                          color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 635 | ``                                          letterSpacing: 0.8,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 636 | ``                                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 637 | ``                                        maxLines: 1,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 638 | ``                                        overflow: TextOverflow.ellipsis,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 639 | ``                                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 640 | ``                                      const SizedBox(height: 2),`` | Mendeklarasikan variabel atau konstanta. |
| 641 | ``                                      Text(`` | Menyusun elemen antarmuka Flutter. |
| 642 | ``                                        strOf(postItem, 'title'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 643 | ``                                        style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 644 | ``                                          fontSize: 14,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 645 | ``                                          fontWeight: FontWeight.w700,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 646 | ``                                          color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 647 | ``                                          height: 1.35,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 648 | ``                                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 649 | ``                                        maxLines: 2,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 650 | ``                                        overflow: TextOverflow.ellipsis,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 651 | ``                                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 652 | ``                                      const SizedBox(height: 4),`` | Mendeklarasikan variabel atau konstanta. |
| 653 | ``                                      Text(`` | Menyusun elemen antarmuka Flutter. |
| 654 | ``                                        strOf(postItem, 'author'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 655 | ``                                        style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 656 | ``                                          fontSize: 11,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 657 | ``                                          color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 658 | ``                                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 659 | ``                                        maxLines: 1,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 660 | ``                                        overflow: TextOverflow.ellipsis,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 661 | ``                                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 662 | ``                                    ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 663 | ``                                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 664 | ``                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 665 | ``                                const Icon(`` | Mendeklarasikan variabel atau konstanta. |
| 666 | ``                                  Icons.chevron_right,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 667 | ``                                  color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 668 | ``                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 669 | ``                              ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 670 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 671 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 672 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 673 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 674 | ``                  ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 675 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 676 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 677 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 678 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 679 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 680 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `edit_profile.dart`

Path: [`lib/edit_profile.dart`](lib/edit_profile.dart)
Jumlah baris: **166**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ``import 'package:http/http.dart' as http;`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 3 | ``import 'dart:convert';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 4 | ``import 'package:frontendats/api.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 5 | ``import 'package:frontendats/api_client.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 6 | ``import 'package:frontendats/scribblr_theme.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 7 | ``import 'package:frontendats/scribblr_widgets.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 8 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 9 | ``class EditProfilePage extends StatefulWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 10 | ``  final String username;`` | Mendeklarasikan variabel atau konstanta. |
| 11 | ``  final String email;`` | Mendeklarasikan variabel atau konstanta. |
| 12 | ``  const EditProfilePage({super.key, this.username = '', this.email = ''});`` | Mendeklarasikan variabel atau konstanta. |
| 13 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 14 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 15 | ``  State<EditProfilePage> createState() => _EditProfilePageState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 16 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 17 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 18 | ``class _EditProfilePageState extends State<EditProfilePage> {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 19 | ``  late final usernameController = TextEditingController(text: widget.username);`` | Mendeklarasikan variabel atau konstanta. |
| 20 | ``  late final emailController = TextEditingController(text: widget.email);`` | Mendeklarasikan variabel atau konstanta. |
| 21 | ``  final passwordController = TextEditingController();`` | Mendeklarasikan variabel atau konstanta. |
| 22 | ``  bool isSaving = false;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 23 | ``  bool isLoading = false;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 24 | ``  int? userId;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 25 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 26 | ``  Future<void> resolveUser() async {`` | Mendefinisikan operasi asynchronous. |
| 27 | ``    setState(() => isLoading = true);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 28 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 29 | ``      final res = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 30 | ``          .get(Uri.parse('$baseUrl/users'), headers: authHeaders())`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 31 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 32 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 33 | ``      setState(() => isLoading = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 34 | ``      if (await handleAuthError(context, res)) return;`` | Mengatur percabangan logika. |
| 35 | ``      if (res.statusCode == 200 \|\| res.statusCode == 201) {`` | Mengatur percabangan logika. |
| 36 | ``        final body = jsonDecode(res.body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 37 | ``        final List<dynamic> users =`` | Mendeklarasikan variabel atau konstanta. |
| 38 | ``            (body is Map ? body['users'] ?? body['data'] : []) ?? [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 39 | ``        for (final userEntry in users) {`` | Melakukan iterasi atas data. |
| 40 | ``          if (userEntry is Map &&`` | Mengatur percabangan logika. |
| 41 | ``              userEntry['email']?.toString() == widget.email) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 42 | ``            setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 43 | ``              userId = int.tryParse(userEntry['id'].toString());`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 44 | ``              if ((usernameController.text.isEmpty) &&`` | Mengatur percabangan logika. |
| 45 | ``                  userEntry['username'] != null) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 46 | ``                usernameController.text = userEntry['username'].toString();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 47 | ``              }`` | Menutup blok, widget, atau pemanggilan method. |
| 48 | ``            });`` | Menutup blok, widget, atau pemanggilan method. |
| 49 | ``            break;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 50 | ``          }`` | Menutup blok, widget, atau pemanggilan method. |
| 51 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 52 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 53 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 54 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 55 | ``      setState(() => isLoading = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 56 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 57 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 58 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 59 | ``  Future<void> save() async {`` | Mendefinisikan operasi asynchronous. |
| 60 | ``    final username = usernameController.text.trim();`` | Mendeklarasikan variabel atau konstanta. |
| 61 | ``    final email = emailController.text.trim();`` | Mendeklarasikan variabel atau konstanta. |
| 62 | ``    final password = passwordController.text;`` | Mendeklarasikan variabel atau konstanta. |
| 63 | ``    if (username.length < 4 \|\| email.isEmpty \|\| password.length < 4) {`` | Mengatur percabangan logika. |
| 64 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 65 | ``        const SnackBar(`` | Mendeklarasikan variabel atau konstanta. |
| 66 | ``          content: Text('Username min 4, email valid, password min 4'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 67 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 68 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 69 | ``      return;`` | Mengembalikan nilai dari fungsi atau widget. |
| 70 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 71 | ``    if (userId == null) {`` | Mengatur percabangan logika. |
| 72 | ``      ScaffoldMessenger.of(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 73 | ``        context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 74 | ``      ).showSnackBar(const SnackBar(content: Text('User tidak ditemukan')));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 75 | ``      return;`` | Mengembalikan nilai dari fungsi atau widget. |
| 76 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 77 | ``    setState(() => isSaving = true);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 78 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 79 | ``      final res = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 80 | ``          .put(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 81 | ``            Uri.parse('$baseUrl/users/$userId'),`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 82 | ``            headers: authHeaders(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 83 | ``            body: jsonEncode({`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 84 | ``              'username': username,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 85 | ``              'email': email,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 86 | ``              'password': password,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 87 | ``            }),`` | Menutup blok, widget, atau pemanggilan method. |
| 88 | ``          )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 89 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 90 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 91 | ``      setState(() => isSaving = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 92 | ``      if (await handleAuthError(context, res)) return;`` | Mengatur percabangan logika. |
| 93 | ``      if (res.statusCode == 200 \|\| res.statusCode == 201) {`` | Mengatur percabangan logika. |
| 94 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 95 | ``          const SnackBar(content: Text('Profile berhasil diperbarui')),`` | Mendeklarasikan variabel atau konstanta. |
| 96 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 97 | ``        Navigator.pop(context, true);`` | Menyusun elemen antarmuka Flutter. |
| 98 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 99 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 100 | ``          SnackBar(content: Text('Gagal memperbarui: ${res.statusCode}')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 101 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 102 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 103 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 104 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 105 | ``      setState(() => isSaving = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 106 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 107 | ``        const SnackBar(content: Text('Tidak bisa terhubung ke server')),`` | Mendeklarasikan variabel atau konstanta. |
| 108 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 109 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 110 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 111 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 112 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 113 | ``  void initState() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 114 | ``    super.initState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 115 | ``    resolveUser();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 116 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 117 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 118 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 119 | ``  void dispose() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 120 | ``    usernameController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 121 | ``    emailController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 122 | ``    passwordController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 123 | ``    super.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 124 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 125 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 126 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 127 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 128 | ``    return Scaffold(`` | Mengembalikan nilai dari fungsi atau widget. |
| 129 | ``      appBar: AppBar(`` | Menyusun elemen antarmuka Flutter. |
| 130 | ``        leading: const BackButton(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 131 | ``        title: const Text('Edit Profile'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 132 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 133 | ``      body: SafeArea(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 134 | ``        child: isLoading`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 135 | ``            ? const Center(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 136 | ``                child: CircularProgressIndicator(color: ScribblrColors.primary),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 137 | ``              )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 138 | ``            : ListView(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 139 | ``                padding: const EdgeInsets.symmetric(`` | Menyusun elemen antarmuka Flutter. |
| 140 | ``                  horizontal: 24,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 141 | ``                  vertical: 16,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 142 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 143 | ``                children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 144 | ``                  const ScribblrLabel(text: 'Username'),`` | Mendeklarasikan variabel atau konstanta. |
| 145 | ``                  TextField(controller: usernameController),`` | Menyusun elemen antarmuka Flutter. |
| 146 | ``                  const SizedBox(height: 16),`` | Mendeklarasikan variabel atau konstanta. |
| 147 | ``                  const ScribblrLabel(text: 'Email'),`` | Mendeklarasikan variabel atau konstanta. |
| 148 | ``                  TextField(`` | Menyusun elemen antarmuka Flutter. |
| 149 | ``                    controller: emailController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 150 | ``                    keyboardType: TextInputType.emailAddress,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 151 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 152 | ``                  const SizedBox(height: 16),`` | Mendeklarasikan variabel atau konstanta. |
| 153 | ``                  const ScribblrLabel(text: 'Password (isi ulang, min 4)'),`` | Mendeklarasikan variabel atau konstanta. |
| 154 | ``                  TextField(controller: passwordController, obscureText: true),`` | Menyusun elemen antarmuka Flutter. |
| 155 | ``                  const SizedBox(height: 28),`` | Mendeklarasikan variabel atau konstanta. |
| 156 | ``                  ScribblrPrimaryButton(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 157 | ``                    text: 'Save Changes',`` | Menyusun elemen antarmuka Flutter. |
| 158 | ``                    loading: isSaving,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 159 | ``                    onPressed: save,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 160 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 161 | ``                ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 162 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 163 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 164 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 165 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 166 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `editpost.dart`

Path: [`lib/editpost.dart`](lib/editpost.dart)
Jumlah baris: **593**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'dart:typed_data';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 3 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 4 | ``import 'package:http/http.dart' as http;`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 5 | ``import 'package:http_parser/http_parser.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 6 | ``import 'dart:convert';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 7 | ``import 'package:image_picker/image_picker.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 8 | ``import 'package:frontendats/api.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 9 | ``import 'package:frontendats/api_client.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 10 | ``import 'package:frontendats/posts_refresh.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 11 | ``import 'package:frontendats/scribblr_theme.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 12 | ``import 'package:frontendats/scribblr_widgets.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 13 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 14 | ``class EditPostPage extends StatefulWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 15 | ``  final Map post;`` | Mendeklarasikan variabel atau konstanta. |
| 16 | ``  final List<dynamic> categories;`` | Mendeklarasikan variabel atau konstanta. |
| 17 | ``  final String currentUsername;`` | Mendeklarasikan variabel atau konstanta. |
| 18 | ``  const EditPostPage({`` | Mendeklarasikan variabel atau konstanta. |
| 19 | ``    super.key,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 20 | ``    required this.post,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 21 | ``    this.categories = const [],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 22 | ``    this.currentUsername = '',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 23 | ``  });`` | Menutup blok, widget, atau pemanggilan method. |
| 24 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 25 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 26 | ``  State<EditPostPage> createState() => _EditPostPageState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 27 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 28 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 29 | ``class _EditPostPageState extends State<EditPostPage> {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 30 | ``  final _formKey = GlobalKey<FormState>();`` | Mendeklarasikan variabel atau konstanta. |
| 31 | ``  late final titleController = TextEditingController(`` | Mendeklarasikan variabel atau konstanta. |
| 32 | ``    text: strOf(widget.post, 'title'),`` | Menyusun elemen antarmuka Flutter. |
| 33 | ``  );`` | Menutup blok, widget, atau pemanggilan method. |
| 34 | ``  late final contentController = TextEditingController(`` | Mendeklarasikan variabel atau konstanta. |
| 35 | ``    text: strOf(widget.post, 'content'),`` | Menyusun elemen antarmuka Flutter. |
| 36 | ``  );`` | Menutup blok, widget, atau pemanggilan method. |
| 37 | ``  late final excerptController = TextEditingController(`` | Mendeklarasikan variabel atau konstanta. |
| 38 | ``    text: strOf(widget.post, 'excerpt'),`` | Menyusun elemen antarmuka Flutter. |
| 39 | ``  );`` | Menutup blok, widget, atau pemanggilan method. |
| 40 | ``  late final authorController = TextEditingController(`` | Mendeklarasikan variabel atau konstanta. |
| 41 | ``    text: strOf(widget.post, 'author'),`` | Menyusun elemen antarmuka Flutter. |
| 42 | ``  );`` | Menutup blok, widget, atau pemanggilan method. |
| 43 | ``  List<dynamic> categories = [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 44 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 45 | ``  final Set<int> selectedCategories = {};`` | Mendeklarasikan variabel atau konstanta. |
| 46 | ``  String? categoryError;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 47 | ``  late String selectedStatus;`` | Mendeklarasikan variabel atau konstanta. |
| 48 | ``  bool isSaving = false;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 49 | ``  bool isLoadingCats = false;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 50 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 51 | ``  XFile? _pickedCover;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 52 | ``  Uint8List? _pickedBytes;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 53 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 54 | ``  bool get _isMine =>`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 55 | ``      widget.currentUsername.isEmpty \|\|`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 56 | ``      isMine(widget.post, widget.currentUsername);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 57 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 58 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 59 | ``  void initState() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 60 | ``    super.initState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 61 | ``    categories = widget.categories;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 62 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 63 | ``    for (final categoryIdText in postCategoryIds(widget.post)) {`` | Melakukan iterasi atas data. |
| 64 | ``      final id = int.tryParse(categoryIdText);`` | Mendeklarasikan variabel atau konstanta. |
| 65 | ``      if (id != null) selectedCategories.add(id);`` | Mengatur percabangan logika. |
| 66 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 67 | ``    final statusValue = strOf(widget.post, 'status');`` | Mendeklarasikan variabel atau konstanta. |
| 68 | ``    selectedStatus = statusValue.isEmpty ? 'published' : statusValue;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 69 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 70 | ``    if (categories.isEmpty) fetchCategories();`` | Mengatur percabangan logika. |
| 71 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 72 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 73 | ``  Future<void> fetchCategories() async {`` | Mendefinisikan operasi asynchronous. |
| 74 | ``    setState(() => isLoadingCats = true);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 75 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 76 | ``      final res = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 77 | ``          .get(Uri.parse('$baseUrl/categories'), headers: authHeaders())`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 78 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 79 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 80 | ``      if (await handleAuthError(context, res)) return;`` | Mengatur percabangan logika. |
| 81 | ``      if (res.statusCode == 200) {`` | Mengatur percabangan logika. |
| 82 | ``        final body = jsonDecode(res.body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 83 | ``        final list = (body is Map ? body['data'] : null) ?? [];`` | Mendeklarasikan variabel atau konstanta. |
| 84 | ``        setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 85 | ``          categories = list is List ? list : [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 86 | ``        });`` | Menutup blok, widget, atau pemanggilan method. |
| 87 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 88 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 89 | ``      debugPrint('fetchCategories error: $error');`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 90 | ``    } finally {`` | Menutup blok, widget, atau pemanggilan method. |
| 91 | ``      if (mounted) setState(() => isLoadingCats = false);`` | Mengatur percabangan logika. |
| 92 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 93 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 94 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 95 | ``  Future<void> pickCover() async {`` | Mendefinisikan operasi asynchronous. |
| 96 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 97 | ``      final file = await ImagePicker().pickImage(`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 98 | ``        source: ImageSource.gallery,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 99 | ``        maxWidth: 1600,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 100 | ``        imageQuality: 85,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 101 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 102 | ``      if (file == null \|\| !mounted) return;`` | Mengatur percabangan logika. |
| 103 | ``      final bytes = await file.readAsBytes();`` | Mendeklarasikan variabel atau konstanta. |
| 104 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 105 | ``      setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 106 | ``        _pickedCover = file;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 107 | ``        _pickedBytes = bytes;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 108 | ``      });`` | Menutup blok, widget, atau pemanggilan method. |
| 109 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 110 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 111 | ``      ScaffoldMessenger.of(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 112 | ``        context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 113 | ``      ).showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $error')));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 114 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 115 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 116 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 117 | ``  Future<void> updatePost() async {`` | Mendefinisikan operasi asynchronous. |
| 118 | ``    FocusScope.of(context).unfocus();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 119 | ``    if (!_isMine) {`` | Mengatur percabangan logika. |
| 120 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 121 | ``        const SnackBar(`` | Mendeklarasikan variabel atau konstanta. |
| 122 | ``          content: Text('Kamu hanya bisa mengedit artikelmu sendiri'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 123 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 124 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 125 | ``      return;`` | Mengembalikan nilai dari fungsi atau widget. |
| 126 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 127 | ``    final valid = _formKey.currentState?.validate() ?? false;`` | Mendeklarasikan variabel atau konstanta. |
| 128 | ``    if (selectedCategories.isEmpty) {`` | Mengatur percabangan logika. |
| 129 | ``      setState(() => categoryError = 'Kategori belum dipilih');`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 130 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 131 | ``    if (!valid \|\| selectedCategories.isEmpty) {`` | Mengatur percabangan logika. |
| 132 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 133 | ``        const SnackBar(content: Text('Periksa lagi isian yang ditandai')),`` | Mendeklarasikan variabel atau konstanta. |
| 134 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 135 | ``      return;`` | Mengembalikan nilai dari fungsi atau widget. |
| 136 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 137 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 138 | ``    setState(() => isSaving = true);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 139 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 140 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 141 | ``      var slug = makeCategorySlug(titleController.text);`` | Mendeklarasikan variabel atau konstanta. |
| 142 | ``      if (slug.isEmpty) {`` | Mengatur percabangan logika. |
| 143 | ``        slug = 'post-${DateTime.now().millisecondsSinceEpoch}';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 144 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 145 | ``      final postId = strOf(widget.post, 'id');`` | Mendeklarasikan variabel atau konstanta. |
| 146 | ``      if (postId.isEmpty) {`` | Mengatur percabangan logika. |
| 147 | ``        if (!mounted) return;`` | Mengatur percabangan logika. |
| 148 | ``        ScaffoldMessenger.of(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 149 | ``          context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 150 | ``        ).showSnackBar(const SnackBar(content: Text('ID artikel tidak valid')));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 151 | ``        return;`` | Mengembalikan nilai dari fungsi atau widget. |
| 152 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 153 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 154 | ``      Map<String, String> buildFields() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 155 | ``        final catList = selectedCategories.toList();`` | Mendeklarasikan variabel atau konstanta. |
| 156 | ``        final fields = <String, String>{`` | Mendeklarasikan variabel atau konstanta. |
| 157 | ``          'title': titleController.text.trim(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 158 | ``          'slug': slug,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 159 | ``          'content': contentController.text,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 160 | ``          'category_id': catList.first.toString(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 161 | ``          'category_ids': jsonEncode(catList),`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 162 | ``          'status': selectedStatus,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 163 | ``        };`` | Menutup blok, widget, atau pemanggilan method. |
| 164 | ``        if (excerptController.text.isNotEmpty) {`` | Mengatur percabangan logika. |
| 165 | ``          fields['excerpt'] = excerptController.text;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 166 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 167 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 168 | ``        if (authorController.text.trim().isNotEmpty) {`` | Mengatur percabangan logika. |
| 169 | ``          fields['author'] = authorController.text.trim();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 170 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 171 | ``        return fields;`` | Mengembalikan nilai dari fungsi atau widget. |
| 172 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 173 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 174 | ``      MediaType guessImageType(String filename) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 175 | ``        final lower = filename.toLowerCase();`` | Mendeklarasikan variabel atau konstanta. |
| 176 | ``        if (lower.endsWith('.png')) return MediaType('image', 'png');`` | Mengatur percabangan logika. |
| 177 | ``        if (lower.endsWith('.webp')) return MediaType('image', 'webp');`` | Mengatur percabangan logika. |
| 178 | ``        if (lower.endsWith('.gif')) return MediaType('image', 'gif');`` | Mengatur percabangan logika. |
| 179 | ``        return MediaType('image', 'jpeg');`` | Mengembalikan nilai dari fungsi atau widget. |
| 180 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 181 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 182 | ``      void attachFile(http.MultipartRequest request) {`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 183 | ``        final picked = _pickedCover;`` | Mendeklarasikan variabel atau konstanta. |
| 184 | ``        final bytes = _pickedBytes;`` | Mendeklarasikan variabel atau konstanta. |
| 185 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 186 | ``        if (picked != null && bytes != null) {`` | Mengatur percabangan logika. |
| 187 | ``          request.files.add(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 188 | ``            http.MultipartFile.fromBytes(`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 189 | ``              'cover_image',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 190 | ``              bytes,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 191 | ``              filename: picked.name.isEmpty ? 'cover.jpg' : picked.name,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 192 | ``              contentType: guessImageType(picked.name),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 193 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 194 | ``          );`` | Menutup blok, widget, atau pemanggilan method. |
| 195 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 196 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 197 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 198 | ``      Future<http.Response> sendJsonPut() async {`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 199 | ``        final catList = selectedCategories.toList();`` | Mendeklarasikan variabel atau konstanta. |
| 200 | ``        return http`` | Mengembalikan nilai dari fungsi atau widget. |
| 201 | ``            .put(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 202 | ``              Uri.parse('$baseUrl/posts/$postId'),`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 203 | ``              headers: authHeaders(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 204 | ``              body: jsonEncode({`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 205 | ``                'title': titleController.text.trim(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 206 | ``                'slug': slug,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 207 | ``                'content': contentController.text,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 208 | ``                'excerpt': excerptController.text.isEmpty`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 209 | ``                    ? null`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 210 | ``                    : excerptController.text,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 211 | ``                'category_id': catList.first,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 212 | ``                'category_ids': catList,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 213 | ``                'author': authorController.text.trim().isEmpty`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 214 | ``                    ? null`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 215 | ``                    : authorController.text.trim(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 216 | ``                'status': selectedStatus,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 217 | ``              }),`` | Menutup blok, widget, atau pemanggilan method. |
| 218 | ``            )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 219 | ``            .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 220 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 221 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 222 | ``      Future<http.Response> sendPutMultipart() async {`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 223 | ``        final req = http.MultipartRequest(`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 224 | ``          'PUT',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 225 | ``          Uri.parse('$baseUrl/posts/$postId'),`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 226 | ``        )..headers.addAll(authOnlyHeaders());`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 227 | ``        req.fields.addAll(buildFields());`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 228 | ``        attachFile(req);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 229 | ``        final streamed = await req.send().timeout(const Duration(seconds: 20));`` | Mendeklarasikan variabel atau konstanta. |
| 230 | ``        return http.Response.fromStream(streamed);`` | Mengembalikan nilai dari fungsi atau widget. |
| 231 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 232 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 233 | ``      Future<http.Response> sendPostSpoofedPut() async {`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 234 | ``        final req = http.MultipartRequest(`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 235 | ``          'POST',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 236 | ``          Uri.parse('$baseUrl/posts/$postId'),`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 237 | ``        )..headers.addAll(authOnlyHeaders());`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 238 | ``        req.fields['_method'] = 'PUT';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 239 | ``        req.fields.addAll(buildFields());`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 240 | ``        attachFile(req);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 241 | ``        final streamed = await req.send().timeout(const Duration(seconds: 20));`` | Mendeklarasikan variabel atau konstanta. |
| 242 | ``        return http.Response.fromStream(streamed);`` | Mengembalikan nilai dari fungsi atau widget. |
| 243 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 244 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 245 | ``      final hasNewImage = _pickedCover != null && _pickedBytes != null;`` | Mendeklarasikan variabel atau konstanta. |
| 246 | ``      http.Response response;`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 247 | ``      if (!hasNewImage) {`` | Mengatur percabangan logika. |
| 248 | ``        response = await sendJsonPut();`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 249 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 250 | ``        response = await sendPutMultipart();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 251 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 252 | ``        if (response.statusCode == 404 \|\| response.statusCode == 405) {`` | Mengatur percabangan logika. |
| 253 | ``          debugPrint(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 254 | ``            'PUT multipart ditolak (${response.statusCode}), coba POST + _method=PUT',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 255 | ``          );`` | Menutup blok, widget, atau pemanggilan method. |
| 256 | ``          response = await sendPostSpoofedPut();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 257 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 258 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 259 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 260 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 261 | ``      if (await handleAuthError(context, response)) return;`` | Mengatur percabangan logika. |
| 262 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 263 | ``      if (response.statusCode == 200) {`` | Mengatur percabangan logika. |
| 264 | ``        PostsRefresh.bump();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 265 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 266 | ``          SnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 267 | ``            content: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 268 | ``              'Berhasil memperbarui artikel: ${response.statusCode}',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 269 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 270 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 271 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 272 | ``        Navigator.pop(context, true);`` | Menyusun elemen antarmuka Flutter. |
| 273 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 274 | ``        debugPrint(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 275 | ``          'PUT /posts/$postId gagal: ${response.statusCode} ${response.body}',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 276 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 277 | ``        String msg = 'Gagal memperbarui artikel: ${response.statusCode}';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 278 | ``        try {`` | Menangani atau meneruskan error/exception. |
| 279 | ``          final decodedBody = jsonDecode(response.body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 280 | ``          if (decodedBody is Map) {`` | Mengatur percabangan logika. |
| 281 | ``            if (decodedBody['message'] != null) {`` | Mengatur percabangan logika. |
| 282 | ``              msg = '$msg - ${decodedBody['message']}';`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 283 | ``            } else if (decodedBody['errors'] != null) {`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 284 | ``              msg = '$msg - ${decodedBody['errors']}';`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 285 | ``            } else if (decodedBody['error'] != null) {`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 286 | ``              msg = '$msg - ${decodedBody['error']}';`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 287 | ``            } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 288 | ``              msg = '$msg - ${response.body}';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 289 | ``            }`` | Menutup blok, widget, atau pemanggilan method. |
| 290 | ``          } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 291 | ``            msg = '$msg - ${response.body}';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 292 | ``          }`` | Menutup blok, widget, atau pemanggilan method. |
| 293 | ``        } catch (_) {`` | Menutup blok, widget, atau pemanggilan method. |
| 294 | ``          if (response.body.isNotEmpty) {`` | Mengatur percabangan logika. |
| 295 | ``            msg = '$msg - ${response.body}';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 296 | ``          }`` | Menutup blok, widget, atau pemanggilan method. |
| 297 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 298 | ``        if (msg.length > 500) msg = '${msg.substring(0, 500)}...';`` | Mengatur percabangan logika. |
| 299 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 300 | ``          SnackBar(content: Text(msg), duration: const Duration(seconds: 6)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 301 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 302 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 303 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 304 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 305 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 306 | ``        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 307 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 308 | ``    } finally {`` | Menutup blok, widget, atau pemanggilan method. |
| 309 | ``      if (mounted) setState(() => isSaving = false);`` | Mengatur percabangan logika. |
| 310 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 311 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 312 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 313 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 314 | ``  void dispose() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 315 | ``    titleController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 316 | ``    contentController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 317 | ``    excerptController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 318 | ``    authorController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 319 | ``    super.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 320 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 321 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 322 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 323 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 324 | ``    return Scaffold(`` | Mengembalikan nilai dari fungsi atau widget. |
| 325 | ``      appBar: AppBar(`` | Menyusun elemen antarmuka Flutter. |
| 326 | ``        leading: const BackButton(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 327 | ``        title: const Text('Edit Article'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 328 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 329 | ``      body: SafeArea(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 330 | ``        child: Form(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 331 | ``          key: _formKey,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 332 | ``          child: ListView(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 333 | ``            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),`` | Menyusun elemen antarmuka Flutter. |
| 334 | ``            children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 335 | ``              if (!_isMine)`` | Mengatur percabangan logika. |
| 336 | ``                Container(`` | Menyusun elemen antarmuka Flutter. |
| 337 | ``                  margin: const EdgeInsets.only(bottom: 12),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 338 | ``                  padding: const EdgeInsets.all(12),`` | Menyusun elemen antarmuka Flutter. |
| 339 | ``                  decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 340 | ``                    color: const Color(0xFFFDECEA),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 341 | ``                    borderRadius: BorderRadius.circular(14),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 342 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 343 | ``                  child: const Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 344 | ``                    'Artikel ini milik penulis lain. Kamu tidak bisa mengubahnya.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 345 | ``                    style: TextStyle(color: Colors.redAccent, fontSize: 13),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 346 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 347 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 348 | ``              const ScribblrLabel(text: 'Cover image (dari galeri)'),`` | Mendeklarasikan variabel atau konstanta. |
| 349 | ``              _coverPreview(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 350 | ``              const SizedBox(height: 8),`` | Mendeklarasikan variabel atau konstanta. |
| 351 | ``              Row(`` | Menyusun elemen antarmuka Flutter. |
| 352 | ``                children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 353 | ``                  TextButton.icon(`` | Menyusun elemen antarmuka Flutter. |
| 354 | ``                    onPressed: (!_isMine \|\| isSaving) ? null : pickCover,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 355 | ``                    icon: const Icon(Icons.photo_library_outlined, size: 18),`` | Menyusun elemen antarmuka Flutter. |
| 356 | ``                    label: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 357 | ``                      _pickedCover == null && _existingCover().isEmpty`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 358 | ``                          ? 'Pilih gambar'`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 359 | ``                          : 'Ganti gambar',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 360 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 361 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 362 | ``                  if (_pickedCover != null)`` | Mengatur percabangan logika. |
| 363 | ``                    TextButton.icon(`` | Menyusun elemen antarmuka Flutter. |
| 364 | ``                      onPressed: isSaving`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 365 | ``                          ? null`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 366 | ``                          : () => setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 367 | ``                              _pickedCover = null;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 368 | ``                              _pickedBytes = null;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 369 | ``                            }),`` | Menutup blok, widget, atau pemanggilan method. |
| 370 | ``                      icon: const Icon(Icons.close, size: 18),`` | Menyusun elemen antarmuka Flutter. |
| 371 | ``                      label: const Text('Batalkan ganti'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 372 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 373 | ``                ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 374 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 375 | ``              if (_pickedCover != null)`` | Mengatur percabangan logika. |
| 376 | ``                Text(`` | Menyusun elemen antarmuka Flutter. |
| 377 | ``                  _pickedCover!.name,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 378 | ``                  style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 379 | ``                    fontSize: 12,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 380 | ``                    color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 381 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 382 | ``                  overflow: TextOverflow.ellipsis,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 383 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 384 | ``              const SizedBox(height: 14),`` | Mendeklarasikan variabel atau konstanta. |
| 385 | ``              const ScribblrLabel(text: 'Title'),`` | Mendeklarasikan variabel atau konstanta. |
| 386 | ``              TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 387 | ``                controller: titleController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 388 | ``                enabled: _isMine,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 389 | ``                validator: (value) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 390 | ``                  if ((value ?? '').trim().length < 3) {`` | Mengatur percabangan logika. |
| 391 | ``                    return 'Judul minimal 3 karakter';`` | Mengembalikan nilai dari fungsi atau widget. |
| 392 | ``                  }`` | Menutup blok, widget, atau pemanggilan method. |
| 393 | ``                  return null;`` | Mengembalikan nilai dari fungsi atau widget. |
| 394 | ``                },`` | Menutup blok, widget, atau pemanggilan method. |
| 395 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 396 | ``              const SizedBox(height: 14),`` | Mendeklarasikan variabel atau konstanta. |
| 397 | ``              const ScribblrLabel(text: 'Article'),`` | Mendeklarasikan variabel atau konstanta. |
| 398 | ``              TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 399 | ``                controller: contentController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 400 | ``                maxLines: 6,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 401 | ``                enabled: _isMine,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 402 | ``                validator: (value) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 403 | ``                  if ((value ?? '').trim().length < 10) {`` | Mengatur percabangan logika. |
| 404 | ``                    return 'Isi artikel minimal 10 karakter';`` | Mengembalikan nilai dari fungsi atau widget. |
| 405 | ``                  }`` | Menutup blok, widget, atau pemanggilan method. |
| 406 | ``                  return null;`` | Mengembalikan nilai dari fungsi atau widget. |
| 407 | ``                },`` | Menutup blok, widget, atau pemanggilan method. |
| 408 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 409 | ``              const SizedBox(height: 14),`` | Mendeklarasikan variabel atau konstanta. |
| 410 | ``              const ScribblrLabel(text: 'Excerpt'),`` | Mendeklarasikan variabel atau konstanta. |
| 411 | ``              TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 412 | ``                controller: excerptController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 413 | ``                maxLines: 2,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 414 | ``                enabled: _isMine,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 415 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 416 | ``              const SizedBox(height: 14),`` | Mendeklarasikan variabel atau konstanta. |
| 417 | ``              const ScribblrLabel(text: 'Author (terkunci)'),`` | Mendeklarasikan variabel atau konstanta. |
| 418 | ``              TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 419 | ``                controller: authorController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 420 | ``                readOnly: true,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 421 | ``                decoration: const InputDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 422 | ``                  suffixIcon: Icon(Icons.lock_outline, size: 18),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 423 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 424 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 425 | ``              const SizedBox(height: 18),`` | Mendeklarasikan variabel atau konstanta. |
| 426 | ``              Text(`` | Menyusun elemen antarmuka Flutter. |
| 427 | ``                'Select Topics${selectedCategories.isEmpty ? '' : ' (${selectedCategories.length})'}',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 428 | ``                style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 429 | ``                  fontSize: 15,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 430 | ``                  fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 431 | ``                  color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 432 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 433 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 434 | ``              const SizedBox(height: 4),`` | Mendeklarasikan variabel atau konstanta. |
| 435 | ``              const Text(`` | Mendeklarasikan variabel atau konstanta. |
| 436 | ``                'Bisa pilih lebih dari 1 topik.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 437 | ``                style: TextStyle(fontSize: 12, color: ScribblrColors.muted),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 438 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 439 | ``              const SizedBox(height: 8),`` | Mendeklarasikan variabel atau konstanta. |
| 440 | ``              if (isLoadingCats)`` | Mengatur percabangan logika. |
| 441 | ``                const Center(`` | Mendeklarasikan variabel atau konstanta. |
| 442 | ``                  child: CircularProgressIndicator(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 443 | ``                    color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 444 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 445 | ``                )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 446 | ``              else if (categories.isNotEmpty)`` | Mengatur percabangan logika. |
| 447 | ``                Wrap(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 448 | ``                  spacing: 8,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 449 | ``                  runSpacing: 8,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 450 | ``                  children: categories.map<Widget>((categoryItem) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 451 | ``                    final id = idOf((categoryItem as Map)['id']);`` | Mendeklarasikan variabel atau konstanta. |
| 452 | ``                    final selected =`` | Mendeklarasikan variabel atau konstanta. |
| 453 | ``                        id != null && selectedCategories.contains(id);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 454 | ``                    return FilterChip(`` | Mengembalikan nilai dari fungsi atau widget. |
| 455 | ``                      label: Text(strOf(categoryItem, 'name')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 456 | ``                      avatar: CircleAvatar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 457 | ``                        radius: 11,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 458 | ``                        backgroundColor: selected`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 459 | ``                            ? Colors.white24`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 460 | ``                            : ScribblrColors.chipBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 461 | ``                        backgroundImage: const AssetImage('assets/logokpi.png'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 462 | ``                        onBackgroundImageError: (_, _) {},`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 463 | ``                        child: const SizedBox.shrink(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 464 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 465 | ``                      selected: selected,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 466 | ``                      onSelected: !_isMine`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 467 | ``                          ? null`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 468 | ``                          : (_) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 469 | ``                              if (id == null) return;`` | Mengatur percabangan logika. |
| 470 | ``                              setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 471 | ``                                if (selected) {`` | Mengatur percabangan logika. |
| 472 | ``                                  selectedCategories.remove(id);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 473 | ``                                } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 474 | ``                                  selectedCategories.add(id);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 475 | ``                                }`` | Menutup blok, widget, atau pemanggilan method. |
| 476 | ``                                categoryError = null;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 477 | ``                              });`` | Menutup blok, widget, atau pemanggilan method. |
| 478 | ``                            },`` | Menutup blok, widget, atau pemanggilan method. |
| 479 | ``                      selectedColor: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 480 | ``                      labelStyle: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 481 | ``                        color: selected ? Colors.white : ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 482 | ``                        fontWeight: FontWeight.w600,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 483 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 484 | ``                      shape: const StadiumBorder(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 485 | ``                        side: BorderSide(color: ScribblrColors.line),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 486 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 487 | ``                    );`` | Menutup blok, widget, atau pemanggilan method. |
| 488 | ``                  }).toList(),`` | Menutup blok, widget, atau pemanggilan method. |
| 489 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 490 | ``              if (categoryError != null) ...[`` | Mengatur percabangan logika. |
| 491 | ``                const SizedBox(height: 6),`` | Mendeklarasikan variabel atau konstanta. |
| 492 | ``                Text(`` | Menyusun elemen antarmuka Flutter. |
| 493 | ``                  categoryError!,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 494 | ``                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 495 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 496 | ``              ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 497 | ``              const SizedBox(height: 18),`` | Mendeklarasikan variabel atau konstanta. |
| 498 | ``              const ScribblrLabel(text: 'Status'),`` | Mendeklarasikan variabel atau konstanta. |
| 499 | ``              Container(`` | Menyusun elemen antarmuka Flutter. |
| 500 | ``                padding: const EdgeInsets.all(4),`` | Menyusun elemen antarmuka Flutter. |
| 501 | ``                decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 502 | ``                  color: ScribblrColors.chipBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 503 | ``                  borderRadius: BorderRadius.circular(30),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 504 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 505 | ``                child: Row(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 506 | ``                  children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 507 | ``                    _statusButton('published', 'Publish'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 508 | ``                    _statusButton('draft', 'Draft'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 509 | ``                  ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 510 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 511 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 512 | ``              const SizedBox(height: 24),`` | Mendeklarasikan variabel atau konstanta. |
| 513 | ``              ScribblrPrimaryButton(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 514 | ``                text: 'Save Changes',`` | Menyusun elemen antarmuka Flutter. |
| 515 | ``                loading: isSaving,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 516 | ``                onPressed: (!_isMine \|\| isSaving) ? null : updatePost,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 517 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 518 | ``              const SizedBox(height: 24),`` | Mendeklarasikan variabel atau konstanta. |
| 519 | ``            ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 520 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 521 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 522 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 523 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 524 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 525 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 526 | ``  String _existingCover() => resolveCoverUrl(strOf(widget.post, 'cover_image'));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 527 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 528 | ``  Widget _coverPreview() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 529 | ``    if (_pickedBytes != null) {`` | Mengatur percabangan logika. |
| 530 | ``      return ClipRRect(`` | Mengembalikan nilai dari fungsi atau widget. |
| 531 | ``        borderRadius: BorderRadius.circular(20),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 532 | ``        child: Image.memory(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 533 | ``          _pickedBytes!,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 534 | ``          height: 180,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 535 | ``          fit: BoxFit.cover,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 536 | ``          errorBuilder: (_, _, _) => _coverPlaceholder(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 537 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 538 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 539 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 540 | ``    final url = _existingCover();`` | Mendeklarasikan variabel atau konstanta. |
| 541 | ``    if (url.isEmpty) return _coverPlaceholder();`` | Mengatur percabangan logika. |
| 542 | ``    return ClipRRect(`` | Mengembalikan nilai dari fungsi atau widget. |
| 543 | ``      borderRadius: BorderRadius.circular(20),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 544 | ``      child: Image.network(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 545 | ``        url,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 546 | ``        height: 180,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 547 | ``        fit: BoxFit.cover,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 548 | ``        errorBuilder: (_, _, _) => _coverPlaceholder(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 549 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 550 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 551 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 552 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 553 | ``  Widget _coverPlaceholder() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 554 | ``    return Container(`` | Mengembalikan nilai dari fungsi atau widget. |
| 555 | ``      height: 150,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 556 | ``      decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 557 | ``        color: ScribblrColors.placeholderBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 558 | ``        borderRadius: BorderRadius.circular(20),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 559 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 560 | ``      alignment: Alignment.center,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 561 | ``      child: const Icon(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 562 | ``        Icons.image_outlined,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 563 | ``        size: 40,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 564 | ``        color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 565 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 566 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 567 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 568 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 569 | ``  Widget _statusButton(String value, String label) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 570 | ``    final active = selectedStatus == value;`` | Mendeklarasikan variabel atau konstanta. |
| 571 | ``    return Expanded(`` | Mengembalikan nilai dari fungsi atau widget. |
| 572 | ``      child: GestureDetector(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 573 | ``        onTap: !_isMine ? null : () => setState(() => selectedStatus = value),`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 574 | ``        child: Container(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 575 | ``          padding: const EdgeInsets.symmetric(vertical: 10),`` | Menyusun elemen antarmuka Flutter. |
| 576 | ``          decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 577 | ``            color: active ? ScribblrColors.surface : Colors.transparent,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 578 | ``            borderRadius: BorderRadius.circular(26),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 579 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 580 | ``          alignment: Alignment.center,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 581 | ``          child: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 582 | ``            label,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 583 | ``            style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 584 | ``              fontSize: 13,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 585 | ``              fontWeight: FontWeight.w700,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 586 | ``              color: active ? ScribblrColors.primary : ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 587 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 588 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 589 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 590 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 591 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 592 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 593 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `homepage.dart`

Path: [`lib/homepage.dart`](lib/homepage.dart)
Jumlah baris: **408**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ``import 'package:frontendats/detailpost.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 3 | ``import 'package:frontendats/api.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 4 | ``import 'package:frontendats/api_client.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 5 | ``import 'package:frontendats/posts_refresh.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 6 | ``import 'package:http/http.dart' as http;`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 7 | ``import 'dart:convert';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 8 | ``import 'package:frontendats/scribblr_theme.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 9 | ``import 'package:frontendats/scribblr_widgets.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 10 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 11 | ``class HomePage extends StatefulWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 12 | ``  final String username;`` | Mendeklarasikan variabel atau konstanta. |
| 13 | ``  const HomePage({super.key, this.username = ''});`` | Mendeklarasikan variabel atau konstanta. |
| 14 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 15 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 16 | ``  State<HomePage> createState() => _HomePageState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 17 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 18 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 19 | ``class _HomePageState extends State<HomePage> {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 20 | ``  List<dynamic> posts = [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 21 | ``  List<dynamic> categories = [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 22 | ``  bool isLoading = false;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 23 | ``  int _seenVersion = -1;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 24 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 25 | ``  String categoryName(dynamic id) => catNameOf(categories, id);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 26 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 27 | ``  Future<void> fetchPosts() async {`` | Mendefinisikan operasi asynchronous. |
| 28 | ``    setState(() => isLoading = true);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 29 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 30 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 31 | ``      final postRes = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 32 | ``          .get(Uri.parse('$baseUrl/posts'), headers: authHeaders())`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 33 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 34 | ``      final catRes = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 35 | ``          .get(Uri.parse('$baseUrl/categories'), headers: authHeaders())`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 36 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 37 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 38 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 39 | ``      setState(() => isLoading = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 40 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 41 | ``      if (isUnauthorized(postRes) \|\| isUnauthorized(catRes)) {`` | Mengatur percabangan logika. |
| 42 | ``        await handleAuthError(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 43 | ``          context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 44 | ``          postRes.statusCode == 401 \|\| postRes.statusCode == 403`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 45 | ``              ? postRes`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 46 | ``              : catRes,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 47 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 48 | ``        return;`` | Mengembalikan nilai dari fungsi atau widget. |
| 49 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 50 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 51 | ``      if (postRes.statusCode == 200) {`` | Mengatur percabangan logika. |
| 52 | ``        try {`` | Menangani atau meneruskan error/exception. |
| 53 | ``          final body = jsonDecode(postRes.body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 54 | ``          final list = (body is Map ? body['data'] : null) ?? [];`` | Mendeklarasikan variabel atau konstanta. |
| 55 | ``          setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 56 | ``            posts = list is List ? list : [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 57 | ``          });`` | Menutup blok, widget, atau pemanggilan method. |
| 58 | ``        } catch (_) {`` | Menutup blok, widget, atau pemanggilan method. |
| 59 | ``          if (mounted) {`` | Mengatur percabangan logika. |
| 60 | ``            ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 61 | ``              const SnackBar(content: Text('Respon server tidak valid')),`` | Mendeklarasikan variabel atau konstanta. |
| 62 | ``            );`` | Menutup blok, widget, atau pemanggilan method. |
| 63 | ``          }`` | Menutup blok, widget, atau pemanggilan method. |
| 64 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 65 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 66 | ``        debugPrint(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 67 | ``          'Gagal mengambil data: ${postRes.statusCode} ${postRes.body}',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 68 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 69 | ``        if (mounted) {`` | Mengatur percabangan logika. |
| 70 | ``          ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 71 | ``            SnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 72 | ``              content: Text('Gagal ambil artikel: ${postRes.statusCode}'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 73 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 74 | ``          );`` | Menutup blok, widget, atau pemanggilan method. |
| 75 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 76 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 77 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 78 | ``      if (catRes.statusCode == 200) {`` | Mengatur percabangan logika. |
| 79 | ``        try {`` | Menangani atau meneruskan error/exception. |
| 80 | ``          final body = jsonDecode(catRes.body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 81 | ``          final list = (body is Map ? body['data'] : null) ?? [];`` | Mendeklarasikan variabel atau konstanta. |
| 82 | ``          setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 83 | ``            categories = list is List ? list : [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 84 | ``          });`` | Menutup blok, widget, atau pemanggilan method. |
| 85 | ``        } catch (_) {}`` | Menutup blok, widget, atau pemanggilan method. |
| 86 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 87 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 88 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 89 | ``      setState(() => isLoading = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 90 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 91 | ``        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 92 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 93 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 94 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 95 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 96 | ``  Future<void> deletePost(dynamic rawId) async {`` | Mendefinisikan operasi asynchronous. |
| 97 | ``    final id = rawId?.toString() ?? '';`` | Mendeklarasikan variabel atau konstanta. |
| 98 | ``    if (id.isEmpty) return;`` | Mengatur percabangan logika. |
| 99 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 100 | ``      final data = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 101 | ``          .delete(Uri.parse('$baseUrl/posts/$id'), headers: authHeaders())`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 102 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 103 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 104 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 105 | ``      if (await handleAuthError(context, data)) return;`` | Mengatur percabangan logika. |
| 106 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 107 | ``      if (data.statusCode == 200) {`` | Mengatur percabangan logika. |
| 108 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 109 | ``          SnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 110 | ``            content: Text('Artikel berhasil dihapus: ${data.statusCode}'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 111 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 112 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 113 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 114 | ``        setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 115 | ``          posts.removeWhere(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 116 | ``            (post) => post is Map && post['id']?.toString() == id,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 117 | ``          );`` | Menutup blok, widget, atau pemanggilan method. |
| 118 | ``        });`` | Menutup blok, widget, atau pemanggilan method. |
| 119 | ``        PostsRefresh.bump();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 120 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 121 | ``        debugPrint('Gagal menghapus artikel: ${data.statusCode} ${data.body}');`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 122 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 123 | ``          SnackBar(content: Text('Gagal menghapus: ${data.statusCode}')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 124 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 125 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 126 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 127 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 128 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 129 | ``        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 130 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 131 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 132 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 133 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 134 | ``  void _onRefreshBus() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 135 | ``    if (PostsRefresh.notifier.value != _seenVersion) {`` | Mengatur percabangan logika. |
| 136 | ``      _seenVersion = PostsRefresh.notifier.value;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 137 | ``      fetchPosts();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 138 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 139 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 140 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 141 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 142 | ``  void initState() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 143 | ``    super.initState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 144 | ``    _seenVersion = PostsRefresh.notifier.value;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 145 | ``    PostsRefresh.notifier.addListener(_onRefreshBus);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 146 | ``    fetchPosts();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 147 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 148 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 149 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 150 | ``  void dispose() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 151 | ``    PostsRefresh.notifier.removeListener(_onRefreshBus);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 152 | ``    super.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 153 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 154 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 155 | ``  void openDetail(Map post) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 156 | ``    Navigator.push(`` | Menyusun elemen antarmuka Flutter. |
| 157 | ``      context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 158 | ``      MaterialPageRoute(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 159 | ``        builder: (context) => DetailPostPage(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 160 | ``          post: post,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 161 | ``          category: categoryLabelOf(categories, post),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 162 | ``          categories: categories,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 163 | ``          currentUsername: widget.username,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 164 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 165 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 166 | ``    ).then((ok) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 167 | ``      if (ok == true) fetchPosts();`` | Mengatur percabangan logika. |
| 168 | ``    });`` | Menutup blok, widget, atau pemanggilan method. |
| 169 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 170 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 171 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 172 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 173 | ``    final published = posts`` | Mendeklarasikan variabel atau konstanta. |
| 174 | ``        .where(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 175 | ``          (postItem) =>`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 176 | ``              postItem is Map &&`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 177 | ``              (strOf(postItem, 'status').isEmpty \|\|`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 178 | ``                  strOf(postItem, 'status') == 'published'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 179 | ``        )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 180 | ``        .toList();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 181 | ``    final featured = published.isNotEmpty ? published.first as Map : null;`` | Mendeklarasikan variabel atau konstanta. |
| 182 | ``    final recent = published.length > 1`` | Mendeklarasikan variabel atau konstanta. |
| 183 | ``        ? published.sublist(1, published.length > 6 ? 6 : published.length)`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 184 | ``        : <dynamic>[];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 185 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 186 | ``    return Scaffold(`` | Mengembalikan nilai dari fungsi atau widget. |
| 187 | ``      body: SafeArea(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 188 | ``        child: isLoading`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 189 | ``            ? const Center(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 190 | ``                child: CircularProgressIndicator(color: ScribblrColors.primary),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 191 | ``              )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 192 | ``            : RefreshIndicator(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 193 | ``                color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 194 | ``                onRefresh: fetchPosts,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 195 | ``                child: ListView(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 196 | ``                  padding: const EdgeInsets.symmetric(`` | Menyusun elemen antarmuka Flutter. |
| 197 | ``                    horizontal: 20,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 198 | ``                    vertical: 16,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 199 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 200 | ``                  children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 201 | ``                    Row(`` | Menyusun elemen antarmuka Flutter. |
| 202 | ``                      children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 203 | ``                        Expanded(`` | Menyusun elemen antarmuka Flutter. |
| 204 | ``                          child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 205 | ``                            crossAxisAlignment: CrossAxisAlignment.start,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 206 | ``                            children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 207 | ``                              const Text(`` | Mendeklarasikan variabel atau konstanta. |
| 208 | ``                                'Writly',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 209 | ``                                style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 210 | ``                                  fontSize: 20,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 211 | ``                                  fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 212 | ``                                  color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 213 | ``                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 214 | ``                              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 215 | ``                              Text(`` | Menyusun elemen antarmuka Flutter. |
| 216 | ``                                widget.username.isEmpty`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 217 | ``                                    ? 'Welcome back!'`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 218 | ``                                    : 'Welcome back, ${widget.username}!',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 219 | ``                                style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 220 | ``                                  fontSize: 12,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 221 | ``                                  color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 222 | ``                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 223 | ``                              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 224 | ``                            ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 225 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 226 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 227 | ``                        CircleAvatar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 228 | ``                          backgroundColor: ScribblrColors.chipBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 229 | ``                          child: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 230 | ``                            widget.username.isEmpty`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 231 | ``                                ? 'S'`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 232 | ``                                : widget.username[0].toUpperCase(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 233 | ``                            style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 234 | ``                              color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 235 | ``                              fontWeight: FontWeight.w700,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 236 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 237 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 238 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 239 | ``                      ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 240 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 241 | ``                    const SizedBox(height: 20),`` | Mendeklarasikan variabel atau konstanta. |
| 242 | ``                    if (featured != null) ...[`` | Mengatur percabangan logika. |
| 243 | ``                      GestureDetector(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 244 | ``                        onTap: () =>`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 245 | ``                            openDetail(Map<String, dynamic>.from(featured)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 246 | ``                        child: Container(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 247 | ``                          padding: const EdgeInsets.all(18),`` | Menyusun elemen antarmuka Flutter. |
| 248 | ``                          decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 249 | ``                            color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 250 | ``                            borderRadius: BorderRadius.circular(22),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 251 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 252 | ``                          child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 253 | ``                            crossAxisAlignment: CrossAxisAlignment.start,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 254 | ``                            children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 255 | ``                              Text(`` | Menyusun elemen antarmuka Flutter. |
| 256 | ``                                categoryLabelOf(categories, featured).isEmpty`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 257 | ``                                    ? 'Featured'`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 258 | ``                                    : categoryLabelOf(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 259 | ``                                        categories,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 260 | ``                                        featured,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 261 | ``                                      ).toUpperCase(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 262 | ``                                style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 263 | ``                                  fontSize: 11,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 264 | ``                                  fontWeight: FontWeight.w700,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 265 | ``                                  color: Colors.white70,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 266 | ``                                  letterSpacing: 1.1,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 267 | ``                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 268 | ``                              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 269 | ``                              const SizedBox(height: 8),`` | Mendeklarasikan variabel atau konstanta. |
| 270 | ``                              Text(`` | Menyusun elemen antarmuka Flutter. |
| 271 | ``                                strOf(featured, 'title'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 272 | ``                                style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 273 | ``                                  fontSize: 19,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 274 | ``                                  fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 275 | ``                                  color: Colors.white,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 276 | ``                                  height: 1.3,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 277 | ``                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 278 | ``                                maxLines: 3,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 279 | ``                                overflow: TextOverflow.ellipsis,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 280 | ``                              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 281 | ``                              const SizedBox(height: 8),`` | Mendeklarasikan variabel atau konstanta. |
| 282 | ``                              Text(`` | Menyusun elemen antarmuka Flutter. |
| 283 | ``                                _metaLine(featured),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 284 | ``                                style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 285 | ``                                  fontSize: 12,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 286 | ``                                  color: Colors.white70,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 287 | ``                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 288 | ``                              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 289 | ``                            ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 290 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 291 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 292 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 293 | ``                      const SizedBox(height: 22),`` | Mendeklarasikan variabel atau konstanta. |
| 294 | ``                    ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 295 | ``                    const Text(`` | Mendeklarasikan variabel atau konstanta. |
| 296 | ``                      'Recent Articles',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 297 | ``                      style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 298 | ``                        fontSize: 17,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 299 | ``                        fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 300 | ``                        color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 301 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 302 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 303 | ``                    const SizedBox(height: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 304 | ``                    if (published.isEmpty)`` | Mengatur percabangan logika. |
| 305 | ``                      const Padding(`` | Mendeklarasikan variabel atau konstanta. |
| 306 | ``                        padding: EdgeInsets.symmetric(vertical: 32),`` | Menyusun elemen antarmuka Flutter. |
| 307 | ``                        child: Center(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 308 | ``                          child: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 309 | ``                            'Belum ada artikel.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 310 | ``                            style: TextStyle(color: ScribblrColors.muted),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 311 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 312 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 313 | ``                      )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 314 | ``                    else if (recent.isEmpty && featured != null)`` | Mengatur percabangan logika. |
| 315 | ``                      _articleTile(featured)`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 316 | ``                    else`` | Mengatur percabangan logika. |
| 317 | ``                      ...recent.map((postItem) => _articleTile(postItem)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 318 | ``                    const SizedBox(height: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 319 | ``                    const Text(`` | Mendeklarasikan variabel atau konstanta. |
| 320 | ``                      'Your Articles',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 321 | ``                      style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 322 | ``                        fontSize: 17,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 323 | ``                        fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 324 | ``                        color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 325 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 326 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 327 | ``                    const SizedBox(height: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 328 | ``                    ...posts`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 329 | ``                        .where(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 330 | ``                          (postItem) =>`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 331 | ``                              postItem is Map &&`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 332 | ``                              isMine(postItem, widget.username),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 333 | ``                        )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 334 | ``                        .take(3)`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 335 | ``                        .map((postItem) => _articleTile(postItem)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 336 | ``                  ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 337 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 338 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 339 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 340 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 341 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 342 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 343 | ``  String _metaLine(Map post) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 344 | ``    final author = strOf(post, 'author');`` | Mendeklarasikan variabel atau konstanta. |
| 345 | ``    final cat = categoryLabelOf(categories, post);`` | Mendeklarasikan variabel atau konstanta. |
| 346 | ``    final parts = <String>[`` | Mendeklarasikan variabel atau konstanta. |
| 347 | ``      if (cat.isNotEmpty) cat,`` | Mengatur percabangan logika. |
| 348 | ``      if (author.isNotEmpty) author,`` | Mengatur percabangan logika. |
| 349 | ``    ];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 350 | ``    return parts.join('  \u2022  ');`` | Mengembalikan nilai dari fungsi atau widget. |
| 351 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 352 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 353 | ``  Widget _articleTile(Map post) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 354 | ``    final cat = categoryLabelOf(categories, post);`` | Mendeklarasikan variabel atau konstanta. |
| 355 | ``    return Padding(`` | Mengembalikan nilai dari fungsi atau widget. |
| 356 | ``      padding: const EdgeInsets.only(bottom: 10),`` | Menyusun elemen antarmuka Flutter. |
| 357 | ``      child: ScribblrCard(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 358 | ``        onTap: () => openDetail(Map<String, dynamic>.from(post)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 359 | ``        child: Row(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 360 | ``          children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 361 | ``            ScribblrThumb(cover: post['cover_image']),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 362 | ``            const SizedBox(width: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 363 | ``            Expanded(`` | Menyusun elemen antarmuka Flutter. |
| 364 | ``              child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 365 | ``                crossAxisAlignment: CrossAxisAlignment.start,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 366 | ``                children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 367 | ``                  if (cat.isNotEmpty)`` | Mengatur percabangan logika. |
| 368 | ``                    Text(`` | Menyusun elemen antarmuka Flutter. |
| 369 | ``                      cat.toUpperCase(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 370 | ``                      style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 371 | ``                        fontSize: 10,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 372 | ``                        fontWeight: FontWeight.w700,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 373 | ``                        color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 374 | ``                        letterSpacing: 0.8,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 375 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 376 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 377 | ``                  const SizedBox(height: 4),`` | Mendeklarasikan variabel atau konstanta. |
| 378 | ``                  Text(`` | Menyusun elemen antarmuka Flutter. |
| 379 | ``                    strOf(post, 'title'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 380 | ``                    style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 381 | ``                      fontSize: 14,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 382 | ``                      fontWeight: FontWeight.w700,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 383 | ``                      color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 384 | ``                      height: 1.35,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 385 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 386 | ``                    maxLines: 2,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 387 | ``                    overflow: TextOverflow.ellipsis,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 388 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 389 | ``                  const SizedBox(height: 4),`` | Mendeklarasikan variabel atau konstanta. |
| 390 | ``                  Text(`` | Menyusun elemen antarmuka Flutter. |
| 391 | ``                    _metaLine(post),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 392 | ``                    style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 393 | ``                      fontSize: 11,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 394 | ``                      color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 395 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 396 | ``                    maxLines: 1,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 397 | ``                    overflow: TextOverflow.ellipsis,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 398 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 399 | ``                ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 400 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 401 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 402 | ``            const Icon(Icons.chevron_right, color: ScribblrColors.muted),`` | Mendeklarasikan variabel atau konstanta. |
| 403 | ``          ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 404 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 405 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 406 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 407 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 408 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `login.dart`

Path: [`lib/login.dart`](lib/login.dart)
Jumlah baris: **386**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ``import 'package:http/http.dart' as http;`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 3 | ``import 'dart:convert';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 4 | ``import 'package:frontendats/api.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 5 | ``import 'package:frontendats/auth_session.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 6 | ``import 'package:frontendats/main_shell.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 7 | ``import 'package:frontendats/register.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 8 | ``import 'package:frontendats/scribblr_theme.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 9 | ``import 'package:frontendats/scribblr_widgets.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 10 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 11 | ``class LoginPage extends StatefulWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 12 | ``  const LoginPage({super.key});`` | Mendeklarasikan variabel atau konstanta. |
| 13 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 14 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 15 | ``  State<LoginPage> createState() => _LoginPageState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 16 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 17 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 18 | ``class _LoginPageState extends State<LoginPage> {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 19 | ``  final _formKey = GlobalKey<FormState>();`` | Mendeklarasikan variabel atau konstanta. |
| 20 | ``  final emailController = TextEditingController();`` | Mendeklarasikan variabel atau konstanta. |
| 21 | ``  final passwordController = TextEditingController();`` | Mendeklarasikan variabel atau konstanta. |
| 22 | ``  bool isSaving = false;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 23 | ``  bool obscure = true;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 24 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 25 | ``  static final _emailRx = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 26 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 27 | ``  Future<String> resolveUsername(String token, String email) async {`` | Mendefinisikan operasi asynchronous. |
| 28 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 29 | ``      final res = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 30 | ``          .get(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 31 | ``            Uri.parse('$baseUrl/users'),`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 32 | ``            headers: {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 33 | ``              'Content-Type': 'application/json',`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 34 | ``              'Authorization': 'Bearer $token',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 35 | ``            },`` | Menutup blok, widget, atau pemanggilan method. |
| 36 | ``          )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 37 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 38 | ``      if (res.statusCode == 200) {`` | Mengatur percabangan logika. |
| 39 | ``        final body = jsonDecode(res.body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 40 | ``        final List<dynamic> users =`` | Mendeklarasikan variabel atau konstanta. |
| 41 | ``            (body is Map ? body['users'] ?? body['data'] : []) ?? [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 42 | ``        for (final userEntry in users) {`` | Melakukan iterasi atas data. |
| 43 | ``          if (userEntry is Map &&`` | Mengatur percabangan logika. |
| 44 | ``              userEntry['email']?.toString().trim().toLowerCase() ==`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 45 | ``                  email.trim().toLowerCase() &&`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 46 | ``              userEntry['username'] != null &&`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 47 | ``              userEntry['username'].toString().isNotEmpty) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 48 | ``            return userEntry['username'].toString();`` | Mengembalikan nilai dari fungsi atau widget. |
| 49 | ``          }`` | Menutup blok, widget, atau pemanggilan method. |
| 50 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 51 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 52 | ``    } catch (_) {}`` | Menutup blok, widget, atau pemanggilan method. |
| 53 | ``    return email.split('@').first;`` | Mengembalikan nilai dari fungsi atau widget. |
| 54 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 55 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 56 | ``  Future<void> login() async {`` | Mendefinisikan operasi asynchronous. |
| 57 | ``    FocusScope.of(context).unfocus();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 58 | ``    if (!(_formKey.currentState?.validate() ?? false)) return;`` | Mengatur percabangan logika. |
| 59 | ``    final email = emailController.text.trim();`` | Mendeklarasikan variabel atau konstanta. |
| 60 | ``    final password = passwordController.text;`` | Mendeklarasikan variabel atau konstanta. |
| 61 | ``    if (email.isEmpty \|\| password.isEmpty) {`` | Mengatur percabangan logika. |
| 62 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 63 | ``        const SnackBar(content: Text('Email dan password wajib diisi')),`` | Mendeklarasikan variabel atau konstanta. |
| 64 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 65 | ``      return;`` | Mengembalikan nilai dari fungsi atau widget. |
| 66 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 67 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 68 | ``    setState(() => isSaving = true);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 69 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 70 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 71 | ``      final response = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 72 | ``          .post(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 73 | ``            Uri.parse('$baseUrl/auth/login'),`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 74 | ``            headers: {'Content-Type': 'application/json'},`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 75 | ``            body: jsonEncode({'email': email, 'password': password}),`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 76 | ``          )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 77 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 78 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 79 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 80 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 81 | ``      if (response.statusCode == 200) {`` | Mengatur percabangan logika. |
| 82 | ``        String token = '';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 83 | ``        try {`` | Menangani atau meneruskan error/exception. |
| 84 | ``          final body = jsonDecode(response.body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 85 | ``          token = (body is Map ? body['token']?.toString() : null) ?? '';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 86 | ``        } catch (_) {}`` | Menutup blok, widget, atau pemanggilan method. |
| 87 | ``        if (token.isEmpty) {`` | Mengatur percabangan logika. |
| 88 | ``          setState(() => isSaving = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 89 | ``          ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 90 | ``            const SnackBar(`` | Mendeklarasikan variabel atau konstanta. |
| 91 | ``              content: Text('Login gagal: token kosong dari server'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 92 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 93 | ``          );`` | Menutup blok, widget, atau pemanggilan method. |
| 94 | ``          return;`` | Mengembalikan nilai dari fungsi atau widget. |
| 95 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 96 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 97 | ``        final username = await resolveUsername(token, email);`` | Mendeklarasikan variabel atau konstanta. |
| 98 | ``        if (!mounted) return;`` | Mengatur percabangan logika. |
| 99 | ``        setState(() => isSaving = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 100 | ``        AuthSession.instance.setSession(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 101 | ``          token: token,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 102 | ``          username: username,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 103 | ``          email: email,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 104 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 105 | ``        Navigator.pushReplacement(`` | Menyusun elemen antarmuka Flutter. |
| 106 | ``          context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 107 | ``          MaterialPageRoute(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 108 | ``            builder: (context) => MainShell(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 109 | ``              username: AuthSession.instance.username ?? '',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 110 | ``              email: AuthSession.instance.email ?? '',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 111 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 112 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 113 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 114 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 115 | ``        setState(() => isSaving = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 116 | ``        String msg = 'Email atau password salah';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 117 | ``        try {`` | Menangani atau meneruskan error/exception. |
| 118 | ``          final body = jsonDecode(response.body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 119 | ``          if (body is Map && body['message'] != null) {`` | Mengatur percabangan logika. |
| 120 | ``            msg = body['message'].toString();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 121 | ``          }`` | Menutup blok, widget, atau pemanggilan method. |
| 122 | ``        } catch (_) {}`` | Menutup blok, widget, atau pemanggilan method. |
| 123 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 124 | ``          SnackBar(content: Text('$msg (${response.statusCode})')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 125 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 126 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 127 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 128 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 129 | ``      setState(() => isSaving = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 130 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 131 | ``        SnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 132 | ``          content: Text(friendlyNetworkError(error)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 133 | ``          duration: const Duration(seconds: 6),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 134 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 135 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 136 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 137 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 138 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 139 | ``  Future<void> openServerSettings() async {`` | Mendefinisikan operasi asynchronous. |
| 140 | ``    final controller = TextEditingController(text: baseUrl);`` | Mendeklarasikan variabel atau konstanta. |
| 141 | ``    final formKey = GlobalKey<FormState>();`` | Mendeklarasikan variabel atau konstanta. |
| 142 | ``    final saved = await showDialog<bool>(`` | Mendeklarasikan variabel atau konstanta. |
| 143 | ``      context: context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 144 | ``      builder: (context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 145 | ``        return AlertDialog(`` | Mengembalikan nilai dari fungsi atau widget. |
| 146 | ``          backgroundColor: ScribblrColors.surface,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 147 | ``          shape: RoundedRectangleBorder(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 148 | ``            borderRadius: BorderRadius.circular(20),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 149 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 150 | ``          title: const Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 151 | ``            'Server Backend',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 152 | ``            style: TextStyle(fontWeight: FontWeight.w700),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 153 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 154 | ``          content: Form(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 155 | ``            key: formKey,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 156 | ``            child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 157 | ``              mainAxisSize: MainAxisSize.min,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 158 | ``              crossAxisAlignment: CrossAxisAlignment.start,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 159 | ``              children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 160 | ``                const Text(`` | Mendeklarasikan variabel atau konstanta. |
| 161 | ``                  'HP fisik harus satu WiFi dengan laptop. Cek IP terbaru via ipconfig.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 162 | ``                  style: TextStyle(fontSize: 12, color: ScribblrColors.muted),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 163 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 164 | ``                const SizedBox(height: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 165 | ``                TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 166 | ``                  controller: controller,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 167 | ``                  keyboardType: TextInputType.url,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 168 | ``                  decoration: const InputDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 169 | ``                    hintText: 'http://192.168.1.11:8000/api',`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 170 | ``                    labelText: 'Base URL',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 171 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 172 | ``                  validator: (value) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 173 | ``                    final trimmed = (value ?? '').trim();`` | Mendeklarasikan variabel atau konstanta. |
| 174 | ``                    if (trimmed.isEmpty) return 'Wajib diisi';`` | Mengatur percabangan logika. |
| 175 | ``                    final uri = Uri.tryParse(trimmed);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 176 | ``                    if (uri == null \|\|`` | Mengatur percabangan logika. |
| 177 | ``                        !(uri.isScheme('http') \|\| uri.isScheme('https')) \|\|`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 178 | ``                        uri.host.isEmpty) {`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 179 | ``                      return 'Contoh valid: http://192.168.1.11:8000/api';`` | Mengembalikan nilai dari fungsi atau widget. |
| 180 | ``                    }`` | Menutup blok, widget, atau pemanggilan method. |
| 181 | ``                    return null;`` | Mengembalikan nilai dari fungsi atau widget. |
| 182 | ``                  },`` | Menutup blok, widget, atau pemanggilan method. |
| 183 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 184 | ``              ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 185 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 186 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 187 | ``          actions: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 188 | ``            TextButton(`` | Menyusun elemen antarmuka Flutter. |
| 189 | ``              onPressed: () => Navigator.pop(context, false),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 190 | ``              child: const Text('Batal'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 191 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 192 | ``            if (ApiConfig.isOverridden)`` | Mengatur percabangan logika. |
| 193 | ``              TextButton(`` | Menyusun elemen antarmuka Flutter. |
| 194 | ``                onPressed: () async {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 195 | ``                  await ApiConfig.clearOverride();`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 196 | ``                  if (context.mounted) Navigator.pop(context, true);`` | Mengatur percabangan logika. |
| 197 | ``                },`` | Menutup blok, widget, atau pemanggilan method. |
| 198 | ``                child: const Text('Reset'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 199 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 200 | ``            ElevatedButton(`` | Menyusun elemen antarmuka Flutter. |
| 201 | ``              onPressed: () async {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 202 | ``                if (formKey.currentState?.validate() != true) return;`` | Mengatur percabangan logika. |
| 203 | ``                try {`` | Menangani atau meneruskan error/exception. |
| 204 | ``                  await ApiConfig.setOverride(controller.text);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 205 | ``                  if (context.mounted) Navigator.pop(context, true);`` | Mengatur percabangan logika. |
| 206 | ``                } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 207 | ``                  if (context.mounted) {`` | Mengatur percabangan logika. |
| 208 | ``                    ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 209 | ``                      SnackBar(content: Text('Gagal menyimpan: $error')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 210 | ``                    );`` | Menutup blok, widget, atau pemanggilan method. |
| 211 | ``                  }`` | Menutup blok, widget, atau pemanggilan method. |
| 212 | ``                }`` | Menutup blok, widget, atau pemanggilan method. |
| 213 | ``              },`` | Menutup blok, widget, atau pemanggilan method. |
| 214 | ``              child: const Text('Simpan'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 215 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 216 | ``          ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 217 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 218 | ``      },`` | Menutup blok, widget, atau pemanggilan method. |
| 219 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 220 | ``    controller.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 221 | ``    if (saved == true && mounted) setState(() {});`` | Mengatur percabangan logika. |
| 222 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 223 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 224 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 225 | ``  void dispose() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 226 | ``    emailController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 227 | ``    passwordController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 228 | ``    super.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 229 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 230 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 231 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 232 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 233 | ``    return Scaffold(`` | Mengembalikan nilai dari fungsi atau widget. |
| 234 | ``      backgroundColor: ScribblrColors.bg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 235 | ``      body: SafeArea(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 236 | ``        top: false,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 237 | ``        child: SingleChildScrollView(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 238 | ``          child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 239 | ``            children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 240 | ``              const AuthHeader(`` | Mendeklarasikan variabel atau konstanta. |
| 241 | ``                title: 'Hello there,\nwelcome back.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 242 | ``                subtitle: 'Sign in to continue writing your stories.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 243 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 244 | ``              AuthCard(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 245 | ``                child: Form(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 246 | ``                  key: _formKey,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 247 | ``                  child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 248 | ``                    crossAxisAlignment: CrossAxisAlignment.stretch,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 249 | ``                    children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 250 | ``                      const ScribblrLabel(text: 'Email'),`` | Mendeklarasikan variabel atau konstanta. |
| 251 | ``                      TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 252 | ``                        controller: emailController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 253 | ``                        keyboardType: TextInputType.emailAddress,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 254 | ``                        decoration: const InputDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 255 | ``                          hintText: 'nama@email.com',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 256 | ``                          prefixIcon: Icon(Icons.email_outlined),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 257 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 258 | ``                        validator: (value) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 259 | ``                          final trimmed = (value ?? '').trim();`` | Mendeklarasikan variabel atau konstanta. |
| 260 | ``                          if (trimmed.isEmpty) return 'Email wajib diisi';`` | Mengatur percabangan logika. |
| 261 | ``                          if (!_emailRx.hasMatch(trimmed)) {`` | Mengatur percabangan logika. |
| 262 | ``                            return 'Format email tidak valid';`` | Mengembalikan nilai dari fungsi atau widget. |
| 263 | ``                          }`` | Menutup blok, widget, atau pemanggilan method. |
| 264 | ``                          return null;`` | Mengembalikan nilai dari fungsi atau widget. |
| 265 | ``                        },`` | Menutup blok, widget, atau pemanggilan method. |
| 266 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 267 | ``                      const SizedBox(height: 16),`` | Mendeklarasikan variabel atau konstanta. |
| 268 | ``                      const ScribblrLabel(text: 'Password'),`` | Mendeklarasikan variabel atau konstanta. |
| 269 | ``                      TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 270 | ``                        controller: passwordController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 271 | ``                        obscureText: obscure,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 272 | ``                        decoration: InputDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 273 | ``                          hintText:`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 274 | ``                              '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 275 | ``                          prefixIcon: const Icon(Icons.lock_outline),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 276 | ``                          suffixIcon: IconButton(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 277 | ``                            onPressed: () => setState(() => obscure = !obscure),`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 278 | ``                            icon: Icon(`` | Menyusun elemen antarmuka Flutter. |
| 279 | ``                              obscure`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 280 | ``                                  ? Icons.visibility_off_outlined`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 281 | ``                                  : Icons.visibility_outlined,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 282 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 283 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 284 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 285 | ``                        validator: (value) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 286 | ``                          if ((value ?? '').isEmpty) {`` | Mengatur percabangan logika. |
| 287 | ``                            return 'Password wajib diisi';`` | Mengembalikan nilai dari fungsi atau widget. |
| 288 | ``                          }`` | Menutup blok, widget, atau pemanggilan method. |
| 289 | ``                          if ((value ?? '').length < 4) {`` | Mengatur percabangan logika. |
| 290 | ``                            return 'Password minimal 4 karakter';`` | Mengembalikan nilai dari fungsi atau widget. |
| 291 | ``                          }`` | Menutup blok, widget, atau pemanggilan method. |
| 292 | ``                          return null;`` | Mengembalikan nilai dari fungsi atau widget. |
| 293 | ``                        },`` | Menutup blok, widget, atau pemanggilan method. |
| 294 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 295 | ``                      const SizedBox(height: 24),`` | Mendeklarasikan variabel atau konstanta. |
| 296 | ``                      ScribblrPrimaryButton(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 297 | ``                        text: 'Sign In',`` | Menyusun elemen antarmuka Flutter. |
| 298 | ``                        loading: isSaving,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 299 | ``                        onPressed: isSaving ? null : login,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 300 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 301 | ``                      const SizedBox(height: 16),`` | Mendeklarasikan variabel atau konstanta. |
| 302 | ``                      Row(`` | Menyusun elemen antarmuka Flutter. |
| 303 | ``                        mainAxisAlignment: MainAxisAlignment.center,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 304 | ``                        children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 305 | ``                          const Text(`` | Mendeklarasikan variabel atau konstanta. |
| 306 | ``                            "Don't have an account? ",`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 307 | ``                            style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 308 | ``                              fontSize: 13,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 309 | ``                              color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 310 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 311 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 312 | ``                          TextButton(`` | Menyusun elemen antarmuka Flutter. |
| 313 | ``                            style: TextButton.styleFrom(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 314 | ``                              padding: EdgeInsets.zero,`` | Menyusun elemen antarmuka Flutter. |
| 315 | ``                              minimumSize: Size.zero,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 316 | ``                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 317 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 318 | ``                            onPressed: isSaving`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 319 | ``                                ? null`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 320 | ``                                : () {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 321 | ``                                    Navigator.push(`` | Menyusun elemen antarmuka Flutter. |
| 322 | ``                                      context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 323 | ``                                      MaterialPageRoute(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 324 | ``                                        builder: (context) =>`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 325 | ``                                            const RegisterPage(),`` | Mendeklarasikan variabel atau konstanta. |
| 326 | ``                                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 327 | ``                                    );`` | Menutup blok, widget, atau pemanggilan method. |
| 328 | ``                                  },`` | Menutup blok, widget, atau pemanggilan method. |
| 329 | ``                            child: const Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 330 | ``                              'Sign Up',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 331 | ``                              style: TextStyle(fontWeight: FontWeight.w700),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 332 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 333 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 334 | ``                        ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 335 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 336 | ``                      const SizedBox(height: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 337 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 338 | ``                      InkWell(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 339 | ``                        onTap: isSaving ? null : openServerSettings,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 340 | ``                        borderRadius: BorderRadius.circular(8),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 341 | ``                        child: Padding(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 342 | ``                          padding: const EdgeInsets.symmetric(vertical: 4),`` | Menyusun elemen antarmuka Flutter. |
| 343 | ``                          child: Row(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 344 | ``                            mainAxisAlignment: MainAxisAlignment.center,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 345 | ``                            children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 346 | ``                              const Icon(`` | Mendeklarasikan variabel atau konstanta. |
| 347 | ``                                Icons.dns_outlined,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 348 | ``                                size: 14,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 349 | ``                                color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 350 | ``                              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 351 | ``                              const SizedBox(width: 6),`` | Mendeklarasikan variabel atau konstanta. |
| 352 | ``                              Flexible(`` | Menyusun elemen antarmuka Flutter. |
| 353 | ``                                child: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 354 | ``                                  baseUrl,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 355 | ``                                  style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 356 | ``                                    fontSize: 11,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 357 | ``                                    color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 358 | ``                                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 359 | ``                                  overflow: TextOverflow.ellipsis,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 360 | ``                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 361 | ``                              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 362 | ``                              const SizedBox(width: 6),`` | Mendeklarasikan variabel atau konstanta. |
| 363 | ``                              const Text(`` | Mendeklarasikan variabel atau konstanta. |
| 364 | ``                                'Ubah',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 365 | ``                                style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 366 | ``                                  fontSize: 11,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 367 | ``                                  fontWeight: FontWeight.w700,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 368 | ``                                  color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 369 | ``                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 370 | ``                              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 371 | ``                            ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 372 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 373 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 374 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 375 | ``                    ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 376 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 377 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 378 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 379 | ``              const SizedBox(height: 8),`` | Mendeklarasikan variabel atau konstanta. |
| 380 | ``            ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 381 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 382 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 383 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 384 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 385 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 386 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `main.dart`

Path: [`lib/main.dart`](lib/main.dart)
Jumlah baris: **26**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ``import 'package:frontendats/api.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 3 | ``import 'package:frontendats/login.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 4 | ``import 'package:frontendats/scribblr_theme.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 5 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 6 | ``void main() async {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 7 | ``  WidgetsFlutterBinding.ensureInitialized();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 8 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 9 | ``  await ApiConfig.load();`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 10 | ``  runApp(const MyApp());`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 11 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 12 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 13 | ``class MyApp extends StatelessWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 14 | ``  const MyApp({super.key});`` | Mendeklarasikan variabel atau konstanta. |
| 15 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 16 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 17 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 18 | ``    return MaterialApp(`` | Mengembalikan nilai dari fungsi atau widget. |
| 19 | ``      debugShowCheckedModeBanner: false,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 20 | ``      title: 'Writly',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 21 | ``      theme: scribblrTheme(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 22 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 23 | ``      home: const LoginPage(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 24 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 25 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 26 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `main_shell.dart`

Path: [`lib/main_shell.dart`](lib/main_shell.dart)
Jumlah baris: **182**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ``import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 3 | ``import 'package:frontendats/addpost.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 4 | ``import 'package:frontendats/discover.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 5 | ``import 'package:frontendats/homepage.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 6 | ``import 'package:frontendats/my_articles.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 7 | ``import 'package:frontendats/posts_refresh.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 8 | ``import 'package:frontendats/profile.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 9 | ``import 'package:frontendats/scribblr_theme.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 10 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 11 | ``class MainShell extends StatefulWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 12 | ``  final String username;`` | Mendeklarasikan variabel atau konstanta. |
| 13 | ``  final String email;`` | Mendeklarasikan variabel atau konstanta. |
| 14 | ``  const MainShell({super.key, this.username = '', this.email = ''});`` | Mendeklarasikan variabel atau konstanta. |
| 15 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 16 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 17 | ``  State<MainShell> createState() => _MainShellState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 18 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 19 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 20 | ``class _MainShellState extends State<MainShell> {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 21 | ``  int index = 0;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 22 | ``  late final List<Widget> pages;`` | Mendeklarasikan variabel atau konstanta. |
| 23 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 24 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 25 | ``  void initState() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 26 | ``    super.initState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 27 | ``    pages = [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 28 | ``      HomePage(username: widget.username),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 29 | ``      DiscoverPage(username: widget.username),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 30 | ``      AddPostPage(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 31 | ``        username: widget.username,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 32 | ``        onSaved: () {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 33 | ``          setState(() => index = 3);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 34 | ``          PostsRefresh.bump();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 35 | ``        },`` | Menutup blok, widget, atau pemanggilan method. |
| 36 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 37 | ``      MyArticlesPage(username: widget.username),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 38 | ``      ProfilePage(username: widget.username, email: widget.email),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 39 | ``    ];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 40 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 41 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 42 | ``  void _onTap(int tappedIndex) => setState(() => index = tappedIndex);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 43 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 44 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 45 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 46 | ``    return Scaffold(`` | Mengembalikan nilai dari fungsi atau widget. |
| 47 | ``      body: BottomBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 48 | ``        layout: const BottomBarLayout.adaptive(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 49 | ``          maxWidth: 440,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 50 | ``          offset: 16,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 51 | ``          borderRadius: BorderRadius.all(Radius.circular(28)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 52 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 53 | ``        motion: const BottomBarMotion.cupertino(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 54 | ``          preset: BottomBarCupertinoMotion.snappy,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 55 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 56 | ``        scrollBehavior: const BottomBarScrollBehavior(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 57 | ``          hideOnScroll: true,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 58 | ``          showOnScrollEnd: true,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 59 | ``          showAtStart: true,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 60 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 61 | ``        theme: BottomBarThemeData(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 62 | ``          barDecoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 63 | ``            color: ScribblrColors.surface,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 64 | ``            borderRadius: BorderRadius.circular(28),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 65 | ``            border: Border.all(color: ScribblrColors.line),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 66 | ``            boxShadow: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 67 | ``              BoxShadow(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 68 | ``                color: ScribblrColors.ink.withValues(alpha: 0.12),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 69 | ``                blurRadius: 28,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 70 | ``                offset: const Offset(0, 12),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 71 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 72 | ``            ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 73 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 74 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 75 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 76 | ``        showIcon: false,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 77 | ``        body: BottomBarBodyPadding(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 78 | ``          child: IndexedStack(index: index, children: pages),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 79 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 80 | ``        child: Padding(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 81 | ``          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),`` | Menyusun elemen antarmuka Flutter. |
| 82 | ``          child: Row(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 83 | ``            children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 84 | ``              _navItem(0, Icons.home_outlined, Icons.home, 'Home'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 85 | ``              _navItem(1, Icons.explore_outlined, Icons.explore, 'Discover'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 86 | ``              _createItem(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 87 | ``              _navItem(3, Icons.article_outlined, Icons.article, 'My Article'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 88 | ``              _navItem(4, Icons.person_outline, Icons.person, 'Profile'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 89 | ``            ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 90 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 91 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 92 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 93 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 94 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 95 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 96 | ``  Widget _navItem(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 97 | ``    int tabIndex,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 98 | ``    IconData icon,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 99 | ``    IconData activeIcon,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 100 | ``    String label,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 101 | ``  ) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 102 | ``    final selected = index == tabIndex;`` | Mendeklarasikan variabel atau konstanta. |
| 103 | ``    final color = selected ? ScribblrColors.primary : ScribblrColors.muted;`` | Mendeklarasikan variabel atau konstanta. |
| 104 | ``    return Expanded(`` | Mengembalikan nilai dari fungsi atau widget. |
| 105 | ``      child: InkWell(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 106 | ``        borderRadius: BorderRadius.circular(20),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 107 | ``        onTap: () => _onTap(tabIndex),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 108 | ``        child: Padding(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 109 | ``          padding: const EdgeInsets.symmetric(vertical: 6),`` | Menyusun elemen antarmuka Flutter. |
| 110 | ``          child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 111 | ``            mainAxisSize: MainAxisSize.min,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 112 | ``            children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 113 | ``              Icon(selected ? activeIcon : icon, color: color, size: 24),`` | Menyusun elemen antarmuka Flutter. |
| 114 | ``              const SizedBox(height: 2),`` | Mendeklarasikan variabel atau konstanta. |
| 115 | ``              Text(`` | Menyusun elemen antarmuka Flutter. |
| 116 | ``                label,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 117 | ``                style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 118 | ``                  fontSize: 10,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 119 | ``                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 120 | ``                  color: color,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 121 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 122 | ``                maxLines: 1,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 123 | ``                overflow: TextOverflow.ellipsis,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 124 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 125 | ``            ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 126 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 127 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 128 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 129 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 130 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 131 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 132 | ``  Widget _createItem() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 133 | ``    final selected = index == 2;`` | Mendeklarasikan variabel atau konstanta. |
| 134 | ``    return Expanded(`` | Mengembalikan nilai dari fungsi atau widget. |
| 135 | ``      child: InkWell(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 136 | ``        borderRadius: BorderRadius.circular(24),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 137 | ``        onTap: () => _onTap(2),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 138 | ``        child: Padding(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 139 | ``          padding: const EdgeInsets.symmetric(vertical: 2),`` | Menyusun elemen antarmuka Flutter. |
| 140 | ``          child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 141 | ``            mainAxisSize: MainAxisSize.min,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 142 | ``            children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 143 | ``              Container(`` | Menyusun elemen antarmuka Flutter. |
| 144 | ``                width: 52,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 145 | ``                height: 52,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 146 | ``                decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 147 | ``                  color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 148 | ``                  shape: BoxShape.circle,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 149 | ``                  border: selected`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 150 | ``                      ? Border.all(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 151 | ``                          color: ScribblrColors.primaryDark,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 152 | ``                          width: 2.5,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 153 | ``                        )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 154 | ``                      : null,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 155 | ``                  boxShadow: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 156 | ``                    BoxShadow(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 157 | ``                      color: ScribblrColors.primary.withValues(alpha: 0.4),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 158 | ``                      blurRadius: 12,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 159 | ``                      offset: const Offset(0, 4),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 160 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 161 | ``                  ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 162 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 163 | ``                child: const Icon(Icons.add, color: Colors.white, size: 28),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 164 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 165 | ``              const SizedBox(height: 2),`` | Mendeklarasikan variabel atau konstanta. |
| 166 | ``              Text(`` | Menyusun elemen antarmuka Flutter. |
| 167 | ``                'Create',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 168 | ``                style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 169 | ``                  fontSize: 10,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 170 | ``                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 171 | ``                  color: selected`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 172 | ``                      ? ScribblrColors.primary`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 173 | ``                      : ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 174 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 175 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 176 | ``            ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 177 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 178 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 179 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 180 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 181 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 182 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `my_articles.dart`

Path: [`lib/my_articles.dart`](lib/my_articles.dart)
Jumlah baris: **351**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ``import 'package:http/http.dart' as http;`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 3 | ``import 'dart:convert';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 4 | ``import 'package:frontendats/api.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 5 | ``import 'package:frontendats/api_client.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 6 | ``import 'package:frontendats/detailpost.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 7 | ``import 'package:frontendats/editpost.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 8 | ``import 'package:frontendats/posts_refresh.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 9 | ``import 'package:frontendats/scribblr_theme.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 10 | ``import 'package:frontendats/scribblr_widgets.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 11 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 12 | ``class MyArticlesPage extends StatefulWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 13 | ``  final String username;`` | Mendeklarasikan variabel atau konstanta. |
| 14 | ``  const MyArticlesPage({super.key, this.username = ''});`` | Mendeklarasikan variabel atau konstanta. |
| 15 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 16 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 17 | ``  State<MyArticlesPage> createState() => _MyArticlesPageState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 18 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 19 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 20 | ``class _MyArticlesPageState extends State<MyArticlesPage> {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 21 | ``  List<dynamic> posts = [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 22 | ``  List<dynamic> categories = [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 23 | ``  bool isLoading = false;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 24 | ``  String tab = 'published';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 25 | ``  int _seenVersion = -1;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 26 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 27 | ``  String categoryName(dynamic id) => catNameOf(categories, id);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 28 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 29 | ``  Future<void> fetchPosts() async {`` | Mendefinisikan operasi asynchronous. |
| 30 | ``    setState(() => isLoading = true);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 31 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 32 | ``      final postRes = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 33 | ``          .get(Uri.parse('$baseUrl/posts'), headers: authHeaders())`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 34 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 35 | ``      final catRes = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 36 | ``          .get(Uri.parse('$baseUrl/categories'), headers: authHeaders())`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 37 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 38 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 39 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 40 | ``      setState(() => isLoading = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 41 | ``      if (isUnauthorized(postRes) \|\| isUnauthorized(catRes)) {`` | Mengatur percabangan logika. |
| 42 | ``        await handleAuthError(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 43 | ``          context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 44 | ``          postRes.statusCode == 401 \|\| postRes.statusCode == 403`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 45 | ``              ? postRes`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 46 | ``              : catRes,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 47 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 48 | ``        return;`` | Mengembalikan nilai dari fungsi atau widget. |
| 49 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 50 | ``      if (postRes.statusCode == 200) {`` | Mengatur percabangan logika. |
| 51 | ``        try {`` | Menangani atau meneruskan error/exception. |
| 52 | ``          final body = jsonDecode(postRes.body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 53 | ``          final list = (body is Map ? body['data'] : null) ?? [];`` | Mendeklarasikan variabel atau konstanta. |
| 54 | ``          setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 55 | ``            posts = list is List ? list : [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 56 | ``          });`` | Menutup blok, widget, atau pemanggilan method. |
| 57 | ``        } catch (_) {}`` | Menutup blok, widget, atau pemanggilan method. |
| 58 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 59 | ``      if (catRes.statusCode == 200) {`` | Mengatur percabangan logika. |
| 60 | ``        try {`` | Menangani atau meneruskan error/exception. |
| 61 | ``          final body = jsonDecode(catRes.body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 62 | ``          final list = (body is Map ? body['data'] : null) ?? [];`` | Mendeklarasikan variabel atau konstanta. |
| 63 | ``          setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 64 | ``            categories = list is List ? list : [];`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 65 | ``          });`` | Menutup blok, widget, atau pemanggilan method. |
| 66 | ``        } catch (_) {}`` | Menutup blok, widget, atau pemanggilan method. |
| 67 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 68 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 69 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 70 | ``      setState(() => isLoading = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 71 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 72 | ``        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 73 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 74 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 75 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 76 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 77 | ``  Future<void> deletePost(dynamic rawId) async {`` | Mendefinisikan operasi asynchronous. |
| 78 | ``    final id = rawId?.toString() ?? '';`` | Mendeklarasikan variabel atau konstanta. |
| 79 | ``    if (id.isEmpty) return;`` | Mengatur percabangan logika. |
| 80 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 81 | ``      final data = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 82 | ``          .delete(Uri.parse('$baseUrl/posts/$id'), headers: authHeaders())`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 83 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 84 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 85 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 86 | ``      if (await handleAuthError(context, data)) return;`` | Mengatur percabangan logika. |
| 87 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 88 | ``      if (data.statusCode == 200) {`` | Mengatur percabangan logika. |
| 89 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 90 | ``          SnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 91 | ``            content: Text('Artikel berhasil dihapus: ${data.statusCode}'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 92 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 93 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 94 | ``        setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 95 | ``          posts.removeWhere(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 96 | ``            (post) => post is Map && post['id']?.toString() == id,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 97 | ``          );`` | Menutup blok, widget, atau pemanggilan method. |
| 98 | ``        });`` | Menutup blok, widget, atau pemanggilan method. |
| 99 | ``        PostsRefresh.bump();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 100 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 101 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 102 | ``          SnackBar(content: Text('Gagal menghapus: ${data.statusCode}')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 103 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 104 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 105 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 106 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 107 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 108 | ``        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 109 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 110 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 111 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 112 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 113 | ``  void _onRefreshBus() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 114 | ``    if (PostsRefresh.notifier.value != _seenVersion) {`` | Mengatur percabangan logika. |
| 115 | ``      _seenVersion = PostsRefresh.notifier.value;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 116 | ``      fetchPosts();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 117 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 118 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 119 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 120 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 121 | ``  void initState() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 122 | ``    super.initState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 123 | ``    _seenVersion = PostsRefresh.notifier.value;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 124 | ``    PostsRefresh.notifier.addListener(_onRefreshBus);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 125 | ``    fetchPosts();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 126 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 127 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 128 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 129 | ``  void dispose() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 130 | ``    PostsRefresh.notifier.removeListener(_onRefreshBus);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 131 | ``    super.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 132 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 133 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 134 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 135 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 136 | ``    final myPosts = posts`` | Mendeklarasikan variabel atau konstanta. |
| 137 | ``        .where(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 138 | ``          (postItem) => postItem is Map && isMine(postItem, widget.username),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 139 | ``        )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 140 | ``        .toList();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 141 | ``    final mine = myPosts.where((postItem) {`` | Mendeklarasikan variabel atau konstanta. |
| 142 | ``      final statusValue = strOf(postItem, 'status');`` | Mendeklarasikan variabel atau konstanta. |
| 143 | ``      return (statusValue.isEmpty ? 'published' : statusValue) == tab;`` | Mengembalikan nilai dari fungsi atau widget. |
| 144 | ``    }).toList();`` | Menutup blok, widget, atau pemanggilan method. |
| 145 | ``    final draftCount = myPosts`` | Mendeklarasikan variabel atau konstanta. |
| 146 | ``        .where((postItem) => strOf(postItem, 'status') == 'draft')`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 147 | ``        .length;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 148 | ``    final pubCount = myPosts.where((postItem) {`` | Mendeklarasikan variabel atau konstanta. |
| 149 | ``      final statusValue = strOf(postItem, 'status');`` | Mendeklarasikan variabel atau konstanta. |
| 150 | ``      return statusValue.isEmpty \|\| statusValue == 'published';`` | Mengembalikan nilai dari fungsi atau widget. |
| 151 | ``    }).length;`` | Menutup blok, widget, atau pemanggilan method. |
| 152 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 153 | ``    return Scaffold(`` | Mengembalikan nilai dari fungsi atau widget. |
| 154 | ``      body: SafeArea(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 155 | ``        child: isLoading`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 156 | ``            ? const Center(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 157 | ``                child: CircularProgressIndicator(color: ScribblrColors.primary),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 158 | ``              )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 159 | ``            : RefreshIndicator(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 160 | ``                color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 161 | ``                onRefresh: fetchPosts,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 162 | ``                child: ListView(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 163 | ``                  padding: const EdgeInsets.symmetric(`` | Menyusun elemen antarmuka Flutter. |
| 164 | ``                    horizontal: 20,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 165 | ``                    vertical: 16,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 166 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 167 | ``                  children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 168 | ``                    ScribblrHeader(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 169 | ``                      title: 'My Articles',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 170 | ``                      subtitle:`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 171 | ``                          '$pubCount Published  \u2022  $draftCount Drafts',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 172 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 173 | ``                    const SizedBox(height: 14),`` | Mendeklarasikan variabel atau konstanta. |
| 174 | ``                    Container(`` | Menyusun elemen antarmuka Flutter. |
| 175 | ``                      padding: const EdgeInsets.all(4),`` | Menyusun elemen antarmuka Flutter. |
| 176 | ``                      decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 177 | ``                        color: ScribblrColors.chipBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 178 | ``                        borderRadius: BorderRadius.circular(30),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 179 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 180 | ``                      child: Row(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 181 | ``                        children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 182 | ``                          _tabButton('published', 'Published'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 183 | ``                          _tabButton('draft', 'Draft'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 184 | ``                        ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 185 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 186 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 187 | ``                    const SizedBox(height: 14),`` | Mendeklarasikan variabel atau konstanta. |
| 188 | ``                    if (mine.isEmpty)`` | Mengatur percabangan logika. |
| 189 | ``                      const Padding(`` | Mendeklarasikan variabel atau konstanta. |
| 190 | ``                        padding: EdgeInsets.symmetric(vertical: 32),`` | Menyusun elemen antarmuka Flutter. |
| 191 | ``                        child: Center(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 192 | ``                          child: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 193 | ``                            'Belum ada artikel di tab ini.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 194 | ``                            style: TextStyle(color: ScribblrColors.muted),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 195 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 196 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 197 | ``                      )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 198 | ``                    else`` | Mengatur percabangan logika. |
| 199 | ``                      ...mine.map(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 200 | ``                        (postItem) => Padding(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 201 | ``                          padding: const EdgeInsets.only(bottom: 10),`` | Menyusun elemen antarmuka Flutter. |
| 202 | ``                          child: ScribblrCard(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 203 | ``                            onTap: () {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 204 | ``                              Navigator.push(`` | Menyusun elemen antarmuka Flutter. |
| 205 | ``                                context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 206 | ``                                MaterialPageRoute(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 207 | ``                                  builder: (context) => DetailPostPage(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 208 | ``                                    post: postItem,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 209 | ``                                    category: categoryLabelOf(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 210 | ``                                      categories,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 211 | ``                                      postItem as Map,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 212 | ``                                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 213 | ``                                    categories: categories,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 214 | ``                                    currentUsername: widget.username,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 215 | ``                                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 216 | ``                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 217 | ``                              ).then((ok) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 218 | ``                                if (ok == true) fetchPosts();`` | Mengatur percabangan logika. |
| 219 | ``                              });`` | Menutup blok, widget, atau pemanggilan method. |
| 220 | ``                            },`` | Menutup blok, widget, atau pemanggilan method. |
| 221 | ``                            child: Row(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 222 | ``                              children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 223 | ``                                ScribblrThumb(cover: postItem['cover_image']),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 224 | ``                                const SizedBox(width: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 225 | ``                                Expanded(`` | Menyusun elemen antarmuka Flutter. |
| 226 | ``                                  child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 227 | ``                                    crossAxisAlignment:`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 228 | ``                                        CrossAxisAlignment.start,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 229 | ``                                    children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 230 | ``                                      Text(`` | Menyusun elemen antarmuka Flutter. |
| 231 | ``                                        strOf(postItem, 'title'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 232 | ``                                        style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 233 | ``                                          fontSize: 14,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 234 | ``                                          fontWeight: FontWeight.w700,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 235 | ``                                          color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 236 | ``                                          height: 1.35,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 237 | ``                                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 238 | ``                                        maxLines: 2,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 239 | ``                                        overflow: TextOverflow.ellipsis,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 240 | ``                                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 241 | ``                                      const SizedBox(height: 6),`` | Mendeklarasikan variabel atau konstanta. |
| 242 | ``                                      Row(`` | Menyusun elemen antarmuka Flutter. |
| 243 | ``                                        children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 244 | ``                                          InkWell(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 245 | ``                                            onTap: () {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 246 | ``                                              Navigator.push(`` | Menyusun elemen antarmuka Flutter. |
| 247 | ``                                                context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 248 | ``                                                MaterialPageRoute(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 249 | ``                                                  builder: (context) =>`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 250 | ``                                                      EditPostPage(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 251 | ``                                                        post: postItem,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 252 | ``                                                        categories: categories,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 253 | ``                                                        currentUsername:`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 254 | ``                                                            widget.username,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 255 | ``                                                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 256 | ``                                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 257 | ``                                              ).then((ok) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 258 | ``                                                if (ok == true) fetchPosts();`` | Mengatur percabangan logika. |
| 259 | ``                                              });`` | Menutup blok, widget, atau pemanggilan method. |
| 260 | ``                                            },`` | Menutup blok, widget, atau pemanggilan method. |
| 261 | ``                                            child: const Row(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 262 | ``                                              children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 263 | ``                                                Icon(`` | Menyusun elemen antarmuka Flutter. |
| 264 | ``                                                  Icons.edit_outlined,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 265 | ``                                                  size: 15,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 266 | ``                                                  color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 267 | ``                                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 268 | ``                                                SizedBox(width: 4),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 269 | ``                                                Text(`` | Menyusun elemen antarmuka Flutter. |
| 270 | ``                                                  'Edit',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 271 | ``                                                  style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 272 | ``                                                    fontSize: 12,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 273 | ``                                                    color:`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 274 | ``                                                        ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 275 | ``                                                    fontWeight: FontWeight.w600,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 276 | ``                                                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 277 | ``                                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 278 | ``                                              ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 279 | ``                                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 280 | ``                                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 281 | ``                                          const SizedBox(width: 16),`` | Mendeklarasikan variabel atau konstanta. |
| 282 | ``                                          InkWell(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 283 | ``                                            onTap: () async {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 284 | ``                                              final ok =`` | Mendeklarasikan variabel atau konstanta. |
| 285 | ``                                                  await confirmDeleteArticle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 286 | ``                                                    context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 287 | ``                                                  );`` | Menutup blok, widget, atau pemanggilan method. |
| 288 | ``                                              if (!ok) return;`` | Mengatur percabangan logika. |
| 289 | ``                                              deletePost(postItem['id']);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 290 | ``                                            },`` | Menutup blok, widget, atau pemanggilan method. |
| 291 | ``                                            child: const Row(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 292 | ``                                              children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 293 | ``                                                Icon(`` | Menyusun elemen antarmuka Flutter. |
| 294 | ``                                                  Icons.delete_outline,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 295 | ``                                                  size: 15,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 296 | ``                                                  color: Colors.redAccent,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 297 | ``                                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 298 | ``                                                SizedBox(width: 4),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 299 | ``                                                Text(`` | Menyusun elemen antarmuka Flutter. |
| 300 | ``                                                  'Delete',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 301 | ``                                                  style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 302 | ``                                                    fontSize: 12,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 303 | ``                                                    color: Colors.redAccent,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 304 | ``                                                    fontWeight: FontWeight.w600,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 305 | ``                                                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 306 | ``                                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 307 | ``                                              ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 308 | ``                                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 309 | ``                                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 310 | ``                                        ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 311 | ``                                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 312 | ``                                    ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 313 | ``                                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 314 | ``                                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 315 | ``                              ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 316 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 317 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 318 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 319 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 320 | ``                  ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 321 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 322 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 323 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 324 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 325 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 326 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 327 | ``  Widget _tabButton(String value, String label) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 328 | ``    final active = tab == value;`` | Mendeklarasikan variabel atau konstanta. |
| 329 | ``    return Expanded(`` | Mengembalikan nilai dari fungsi atau widget. |
| 330 | ``      child: GestureDetector(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 331 | ``        onTap: () => setState(() => tab = value),`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 332 | ``        child: Container(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 333 | ``          padding: const EdgeInsets.symmetric(vertical: 10),`` | Menyusun elemen antarmuka Flutter. |
| 334 | ``          decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 335 | ``            color: active ? ScribblrColors.surface : Colors.transparent,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 336 | ``            borderRadius: BorderRadius.circular(26),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 337 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 338 | ``          alignment: Alignment.center,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 339 | ``          child: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 340 | ``            label,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 341 | ``            style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 342 | ``              fontSize: 13,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 343 | ``              fontWeight: FontWeight.w700,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 344 | ``              color: active ? ScribblrColors.primary : ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 345 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 346 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 347 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 348 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 349 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 350 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 351 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `posts_refresh.dart`

Path: [`lib/posts_refresh.dart`](lib/posts_refresh.dart)
Jumlah baris: **107**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:flutter/foundation.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ``import 'package:frontendats/api.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 3 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 4 | ``class PostsRefresh {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 5 | ``  PostsRefresh._();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 6 | ``  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 7 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 8 | ``  static void bump() => notifier.value++;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 9 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 10 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 11 | ``String strOf(dynamic source, String key) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 12 | ``  if (source is! Map) return '';`` | Mengatur percabangan logika. |
| 13 | ``  final value = source[key];`` | Mendeklarasikan variabel atau konstanta. |
| 14 | ``  if (value == null) return '';`` | Mengatur percabangan logika. |
| 15 | ``  return value.toString();`` | Mengembalikan nilai dari fungsi atau widget. |
| 16 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 17 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 18 | ``int? idOf(dynamic value) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 19 | ``  if (value == null) return null;`` | Mengatur percabangan logika. |
| 20 | ``  if (value is int) return value;`` | Mengatur percabangan logika. |
| 21 | ``  return int.tryParse(value.toString());`` | Mengembalikan nilai dari fungsi atau widget. |
| 22 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 23 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 24 | ``String catNameOf(List cats, dynamic id) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 25 | ``  if (id == null) return '';`` | Mengatur percabangan logika. |
| 26 | ``  final needle = id.toString();`` | Mendeklarasikan variabel atau konstanta. |
| 27 | ``  for (final categoryItem in cats) {`` | Melakukan iterasi atas data. |
| 28 | ``    if (categoryItem is Map && categoryItem['id']?.toString() == needle) {`` | Mengatur percabangan logika. |
| 29 | ``      return categoryItem['name']?.toString() ?? '';`` | Mengembalikan nilai dari fungsi atau widget. |
| 30 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 31 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 32 | ``  return '';`` | Mengembalikan nilai dari fungsi atau widget. |
| 33 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 34 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 35 | ``Set<String> postCategoryIds(Map post) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 36 | ``  final out = <String>{};`` | Mendeklarasikan variabel atau konstanta. |
| 37 | ``  void add(dynamic value) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 38 | ``    if (value == null) return;`` | Mengatur percabangan logika. |
| 39 | ``    final idText = value.toString().trim();`` | Mendeklarasikan variabel atau konstanta. |
| 40 | ``    if (idText.isNotEmpty && idText != 'null') out.add(idText);`` | Mengatur percabangan logika. |
| 41 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 42 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 43 | ``  add(post['category_id']);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 44 | ``  final ids = post['category_ids'];`` | Mendeklarasikan variabel atau konstanta. |
| 45 | ``  if (ids is List) {`` | Mengatur percabangan logika. |
| 46 | ``    for (final value in ids) {`` | Melakukan iterasi atas data. |
| 47 | ``      if (value is Map) {`` | Mengatur percabangan logika. |
| 48 | ``        add(value['id']);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 49 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 50 | ``        add(value);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 51 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 52 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 53 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 54 | ``  final cats = post['categories'];`` | Mendeklarasikan variabel atau konstanta. |
| 55 | ``  if (cats is List) {`` | Mengatur percabangan logika. |
| 56 | ``    for (final value in cats) {`` | Melakukan iterasi atas data. |
| 57 | ``      if (value is Map) {`` | Mengatur percabangan logika. |
| 58 | ``        add(value['id'] ?? value['category_id']);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 59 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 60 | ``        add(value);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 61 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 62 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 63 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 64 | ``  return out;`` | Mengembalikan nilai dari fungsi atau widget. |
| 65 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 66 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 67 | ``String primaryCategoryId(Map post) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 68 | ``  final ids = postCategoryIds(post);`` | Mendeklarasikan variabel atau konstanta. |
| 69 | ``  return ids.isEmpty ? '' : ids.first;`` | Mengembalikan nilai dari fungsi atau widget. |
| 70 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 71 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 72 | ``String categoryLabelOf(List cats, Map post) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 73 | ``  final ids = postCategoryIds(post).toList();`` | Mendeklarasikan variabel atau konstanta. |
| 74 | ``  if (ids.isEmpty) return '';`` | Mengatur percabangan logika. |
| 75 | ``  final first = catNameOf(cats, ids.first);`` | Mendeklarasikan variabel atau konstanta. |
| 76 | ``  if (ids.length <= 1) return first;`` | Mengatur percabangan logika. |
| 77 | ``  if (first.isEmpty) return '+${ids.length} topik';`` | Mengatur percabangan logika. |
| 78 | ``  return '$first +${ids.length - 1} lainnya';`` | Mengembalikan nilai dari fungsi atau widget. |
| 79 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 80 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 81 | ``String makeCategorySlug(String name) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 82 | ``  var slugBuffer = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s-]'), '');`` | Mendeklarasikan variabel atau konstanta. |
| 83 | ``  slugBuffer = slugBuffer`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 84 | ``      .trim()`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 85 | ``      .replaceAll(RegExp(r'\s+'), '-')`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 86 | ``      .replaceAll(RegExp(r'-+'), '-');`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 87 | ``  slugBuffer = slugBuffer.replaceAll(RegExp(r'^-+\|-+$'), '');`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 88 | ``  return slugBuffer;`` | Mengembalikan nilai dari fungsi atau widget. |
| 89 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 90 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 91 | ``bool isMine(Map post, String username) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 92 | ``  final author = strOf(post, 'author').trim().toLowerCase();`` | Mendeklarasikan variabel atau konstanta. |
| 93 | ``  final me = username.trim().toLowerCase();`` | Mendeklarasikan variabel atau konstanta. |
| 94 | ``  if (author.isEmpty \|\| me.isEmpty) return false;`` | Mengatur percabangan logika. |
| 95 | ``  return author == me;`` | Mengembalikan nilai dari fungsi atau widget. |
| 96 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 97 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 98 | ``String resolveCoverUrl(dynamic raw) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 99 | ``  final url = (raw?.toString() ?? '').trim();`` | Mendeklarasikan variabel atau konstanta. |
| 100 | ``  if (url.isEmpty) return '';`` | Mengatur percabangan logika. |
| 101 | ``  if (url.startsWith('http')) return url;`` | Mengatur percabangan logika. |
| 102 | ``  final origin = Uri.parse(`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 103 | ``    baseUrl,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 104 | ``  ).replace(path: '').toString().replaceAll(RegExp(r'/+$'), '');`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 105 | ``  if (url.startsWith('/')) return '$origin$url';`` | Mengatur percabangan logika. |
| 106 | ``  return '$origin/$url';`` | Mengembalikan nilai dari fungsi atau widget. |
| 107 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `profile.dart`

Path: [`lib/profile.dart`](lib/profile.dart)
Jumlah baris: **181**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ``import 'package:http/http.dart' as http;`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 3 | ``import 'dart:convert';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 4 | ``import 'package:frontendats/api.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 5 | ``import 'package:frontendats/api_client.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 6 | ``import 'package:frontendats/edit_profile.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 7 | ``import 'package:frontendats/posts_refresh.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 8 | ``import 'package:frontendats/scribblr_theme.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 9 | ``import 'package:frontendats/scribblr_widgets.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 10 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 11 | ``class ProfilePage extends StatefulWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 12 | ``  final String username;`` | Mendeklarasikan variabel atau konstanta. |
| 13 | ``  final String email;`` | Mendeklarasikan variabel atau konstanta. |
| 14 | ``  const ProfilePage({super.key, this.username = '', this.email = ''});`` | Mendeklarasikan variabel atau konstanta. |
| 15 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 16 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 17 | ``  State<ProfilePage> createState() => _ProfilePageState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 18 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 19 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 20 | ``class _ProfilePageState extends State<ProfilePage> {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 21 | ``  int articleCount = 0;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 22 | ``  bool isLoading = false;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 23 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 24 | ``  Future<void> fetchArticleCount() async {`` | Mendefinisikan operasi asynchronous. |
| 25 | ``    setState(() => isLoading = true);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 26 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 27 | ``      final res = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 28 | ``          .get(Uri.parse('$baseUrl/posts'), headers: authHeaders())`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 29 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 30 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 31 | ``      setState(() => isLoading = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 32 | ``      if (await handleAuthError(context, res)) return;`` | Mengatur percabangan logika. |
| 33 | ``      if (res.statusCode == 200) {`` | Mengatur percabangan logika. |
| 34 | ``        final List<dynamic> data = jsonDecode(res.body)['data'] ?? [];`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 35 | ``        setState(() {`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 36 | ``          articleCount = data`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 37 | ``              .where(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 38 | ``                (postItem) =>`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 39 | ``                    postItem is Map && isMine(postItem, widget.username),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 40 | ``              )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 41 | ``              .length;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 42 | ``        });`` | Menutup blok, widget, atau pemanggilan method. |
| 43 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 44 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 45 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 46 | ``      setState(() => isLoading = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 47 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 48 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 49 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 50 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 51 | ``  void initState() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 52 | ``    super.initState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 53 | ``    fetchArticleCount();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 54 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 55 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 56 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 57 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 58 | ``    return Scaffold(`` | Mengembalikan nilai dari fungsi atau widget. |
| 59 | ``      body: SafeArea(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 60 | ``        child: RefreshIndicator(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 61 | ``          color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 62 | ``          onRefresh: fetchArticleCount,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 63 | ``          child: ListView(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 64 | ``            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),`` | Menyusun elemen antarmuka Flutter. |
| 65 | ``            children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 66 | ``              const ScribblrHeader(title: 'Profile'),`` | Mendeklarasikan variabel atau konstanta. |
| 67 | ``              const SizedBox(height: 20),`` | Mendeklarasikan variabel atau konstanta. |
| 68 | ``              Center(`` | Menyusun elemen antarmuka Flutter. |
| 69 | ``                child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 70 | ``                  children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 71 | ``                    CircleAvatar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 72 | ``                      radius: 44,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 73 | ``                      backgroundColor: ScribblrColors.chipBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 74 | ``                      child: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 75 | ``                        widget.username.isEmpty`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 76 | ``                            ? 'S'`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 77 | ``                            : widget.username[0].toUpperCase(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 78 | ``                        style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 79 | ``                          fontSize: 32,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 80 | ``                          fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 81 | ``                          color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 82 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 83 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 84 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 85 | ``                    const SizedBox(height: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 86 | ``                    Text(`` | Menyusun elemen antarmuka Flutter. |
| 87 | ``                      widget.username.isEmpty ? '-' : widget.username,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 88 | ``                      style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 89 | ``                        fontSize: 19,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 90 | ``                        fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 91 | ``                        color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 92 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 93 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 94 | ``                    const SizedBox(height: 4),`` | Mendeklarasikan variabel atau konstanta. |
| 95 | ``                    Text(`` | Menyusun elemen antarmuka Flutter. |
| 96 | ``                      widget.email.isEmpty ? '-' : widget.email,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 97 | ``                      style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 98 | ``                        fontSize: 13,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 99 | ``                        color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 100 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 101 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 102 | ``                  ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 103 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 104 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 105 | ``              const SizedBox(height: 20),`` | Mendeklarasikan variabel atau konstanta. |
| 106 | ``              ScribblrCard(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 107 | ``                child: Row(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 108 | ``                  mainAxisAlignment: MainAxisAlignment.center,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 109 | ``                  children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 110 | ``                    const Icon(`` | Mendeklarasikan variabel atau konstanta. |
| 111 | ``                      Icons.article_outlined,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 112 | ``                      color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 113 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 114 | ``                    const SizedBox(width: 10),`` | Mendeklarasikan variabel atau konstanta. |
| 115 | ``                    Text(`` | Menyusun elemen antarmuka Flutter. |
| 116 | ``                      isLoading ? '...' : '$articleCount',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 117 | ``                      style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 118 | ``                        fontSize: 18,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 119 | ``                        fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 120 | ``                        color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 121 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 122 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 123 | ``                    const SizedBox(width: 6),`` | Mendeklarasikan variabel atau konstanta. |
| 124 | ``                    const Text(`` | Mendeklarasikan variabel atau konstanta. |
| 125 | ``                      'Articles',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 126 | ``                      style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 127 | ``                        fontSize: 13,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 128 | ``                        color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 129 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 130 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 131 | ``                  ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 132 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 133 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 134 | ``              const SizedBox(height: 12),`` | Mendeklarasikan variabel atau konstanta. |
| 135 | ``              ScribblrCard(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 136 | ``                child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 137 | ``                  children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 138 | ``                    ListTile(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 139 | ``                      leading: const Icon(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 140 | ``                        Icons.edit_outlined,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 141 | ``                        color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 142 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 143 | ``                      title: const Text('Edit Profile'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 144 | ``                      trailing: const Icon(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 145 | ``                        Icons.chevron_right,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 146 | ``                        color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 147 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 148 | ``                      onTap: () {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 149 | ``                        Navigator.push(`` | Menyusun elemen antarmuka Flutter. |
| 150 | ``                          context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 151 | ``                          MaterialPageRoute(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 152 | ``                            builder: (context) => EditProfilePage(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 153 | ``                              username: widget.username,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 154 | ``                              email: widget.email,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 155 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 156 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 157 | ``                        );`` | Menutup blok, widget, atau pemanggilan method. |
| 158 | ``                      },`` | Menutup blok, widget, atau pemanggilan method. |
| 159 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 160 | ``                    const Divider(height: 1, color: ScribblrColors.line),`` | Mendeklarasikan variabel atau konstanta. |
| 161 | ``                    ListTile(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 162 | ``                      leading: const Icon(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 163 | ``                        Icons.logout,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 164 | ``                        color: Colors.redAccent,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 165 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 166 | ``                      title: const Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 167 | ``                        'Logout',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 168 | ``                        style: TextStyle(color: Colors.redAccent),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 169 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 170 | ``                      onTap: () => forceLogout(context),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 171 | ``                    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 172 | ``                  ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 173 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 174 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 175 | ``            ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 176 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 177 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 178 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 179 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 180 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 181 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `register.dart`

Path: [`lib/register.dart`](lib/register.dart)
Jumlah baris: **214**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ``import 'package:http/http.dart' as http;`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 3 | ``import 'dart:convert';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 4 | ``import 'package:frontendats/api.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 5 | ``import 'package:frontendats/scribblr_theme.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 6 | ``import 'package:frontendats/scribblr_widgets.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 7 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 8 | ``class RegisterPage extends StatefulWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 9 | ``  const RegisterPage({super.key});`` | Mendeklarasikan variabel atau konstanta. |
| 10 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 11 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 12 | ``  State<RegisterPage> createState() => _RegisterPageState();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 13 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 14 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 15 | ``class _RegisterPageState extends State<RegisterPage> {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 16 | ``  final _formKey = GlobalKey<FormState>();`` | Mendeklarasikan variabel atau konstanta. |
| 17 | ``  final usernameController = TextEditingController();`` | Mendeklarasikan variabel atau konstanta. |
| 18 | ``  final emailController = TextEditingController();`` | Mendeklarasikan variabel atau konstanta. |
| 19 | ``  final passwordController = TextEditingController();`` | Mendeklarasikan variabel atau konstanta. |
| 20 | ``  bool isSaving = false;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 21 | ``  bool obscure = true;`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 22 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 23 | ``  static final _emailRx = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 24 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 25 | ``  Future<void> register() async {`` | Mendefinisikan operasi asynchronous. |
| 26 | ``    FocusScope.of(context).unfocus();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 27 | ``    if (!(_formKey.currentState?.validate() ?? false)) return;`` | Mengatur percabangan logika. |
| 28 | ``    final username = usernameController.text.trim();`` | Mendeklarasikan variabel atau konstanta. |
| 29 | ``    final email = emailController.text.trim();`` | Mendeklarasikan variabel atau konstanta. |
| 30 | ``    final password = passwordController.text;`` | Mendeklarasikan variabel atau konstanta. |
| 31 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 32 | ``    setState(() => isSaving = true);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 33 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 34 | ``    try {`` | Menangani atau meneruskan error/exception. |
| 35 | ``      final response = await http`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 36 | ``          .post(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 37 | ``            Uri.parse('$baseUrl/users'),`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 38 | ``            headers: {'Content-Type': 'application/json'},`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 39 | ``            body: jsonEncode({`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 40 | ``              'username': username,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 41 | ``              'email': email,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 42 | ``              'password': password,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 43 | ``            }),`` | Menutup blok, widget, atau pemanggilan method. |
| 44 | ``          )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 45 | ``          .timeout(const Duration(seconds: 10));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 46 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 47 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 48 | ``      setState(() => isSaving = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 49 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 50 | ``      if (response.statusCode == 200 \|\| response.statusCode == 201) {`` | Mengatur percabangan logika. |
| 51 | ``        ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 52 | ``          const SnackBar(content: Text('Berhasil daftar, silakan masuk')),`` | Mendeklarasikan variabel atau konstanta. |
| 53 | ``        );`` | Menutup blok, widget, atau pemanggilan method. |
| 54 | ``        Navigator.pop(context);`` | Menyusun elemen antarmuka Flutter. |
| 55 | ``      } else {`` | Menutup blok, widget, atau pemanggilan method. |
| 56 | ``        String msg = 'Gagal daftar: ${response.statusCode}';`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 57 | ``        try {`` | Menangani atau meneruskan error/exception. |
| 58 | ``          final decodedBody = jsonDecode(response.body);`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 59 | ``          if (decodedBody is Map && decodedBody['message'] != null)`` | Mengatur percabangan logika. |
| 60 | ``            msg = '$msg - ${decodedBody['message']}';`` | Mengakses API, penyimpanan lokal, media, atau serialisasi data. |
| 61 | ``        } catch (_) {`` | Menutup blok, widget, atau pemanggilan method. |
| 62 | ``          if (response.body.isNotEmpty) msg = '$msg ${response.body}';`` | Mengatur percabangan logika. |
| 63 | ``        }`` | Menutup blok, widget, atau pemanggilan method. |
| 64 | ``        ScaffoldMessenger.of(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 65 | ``          context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 66 | ``        ).showSnackBar(SnackBar(content: Text(msg)));`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 67 | ``      }`` | Menutup blok, widget, atau pemanggilan method. |
| 68 | ``    } catch (error) {`` | Menutup blok, widget, atau pemanggilan method. |
| 69 | ``      if (!mounted) return;`` | Mengatur percabangan logika. |
| 70 | ``      setState(() => isSaving = false);`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 71 | ``      ScaffoldMessenger.of(context).showSnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 72 | ``        SnackBar(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 73 | ``          content: Text(friendlyNetworkError(error)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 74 | ``          duration: const Duration(seconds: 6),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 75 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 76 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 77 | ``    }`` | Menutup blok, widget, atau pemanggilan method. |
| 78 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 79 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 80 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 81 | ``  void dispose() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 82 | ``    usernameController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 83 | ``    emailController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 84 | ``    passwordController.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 85 | ``    super.dispose();`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 86 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 87 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 88 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 89 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 90 | ``    return Scaffold(`` | Mengembalikan nilai dari fungsi atau widget. |
| 91 | ``      backgroundColor: ScribblrColors.bg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 92 | ``      appBar: AppBar(`` | Menyusun elemen antarmuka Flutter. |
| 93 | ``        leading: const BackButton(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 94 | ``        backgroundColor: Colors.transparent,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 95 | ``        elevation: 0,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 96 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 97 | ``      extendBodyBehindAppBar: true,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 98 | ``      body: SafeArea(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 99 | ``        top: false,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 100 | ``        child: SingleChildScrollView(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 101 | ``          child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 102 | ``            children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 103 | ``              const AuthHeader(`` | Mendeklarasikan variabel atau konstanta. |
| 104 | ``                title: 'Create your\naccount.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 105 | ``                subtitle: 'Join Writly and start sharing your ideas.',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 106 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 107 | ``              AuthCard(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 108 | ``                child: Form(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 109 | ``                  key: _formKey,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 110 | ``                  child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 111 | ``                    crossAxisAlignment: CrossAxisAlignment.stretch,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 112 | ``                    children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 113 | ``                      const ScribblrLabel(text: 'Username'),`` | Mendeklarasikan variabel atau konstanta. |
| 114 | ``                      TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 115 | ``                        controller: usernameController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 116 | ``                        decoration: const InputDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 117 | ``                          hintText: 'username',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 118 | ``                          prefixIcon: Icon(Icons.person_outline),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 119 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 120 | ``                        validator: (value) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 121 | ``                          if ((value ?? '').trim().length < 4) {`` | Mengatur percabangan logika. |
| 122 | ``                            return 'Username minimal 4 karakter';`` | Mengembalikan nilai dari fungsi atau widget. |
| 123 | ``                          }`` | Menutup blok, widget, atau pemanggilan method. |
| 124 | ``                          return null;`` | Mengembalikan nilai dari fungsi atau widget. |
| 125 | ``                        },`` | Menutup blok, widget, atau pemanggilan method. |
| 126 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 127 | ``                      const SizedBox(height: 16),`` | Mendeklarasikan variabel atau konstanta. |
| 128 | ``                      const ScribblrLabel(text: 'Email'),`` | Mendeklarasikan variabel atau konstanta. |
| 129 | ``                      TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 130 | ``                        controller: emailController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 131 | ``                        keyboardType: TextInputType.emailAddress,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 132 | ``                        decoration: const InputDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 133 | ``                          hintText: 'nama@email.com',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 134 | ``                          prefixIcon: Icon(Icons.email_outlined),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 135 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 136 | ``                        validator: (value) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 137 | ``                          final trimmed = (value ?? '').trim();`` | Mendeklarasikan variabel atau konstanta. |
| 138 | ``                          if (trimmed.isEmpty) return 'Email wajib diisi';`` | Mengatur percabangan logika. |
| 139 | ``                          if (!_emailRx.hasMatch(trimmed)) {`` | Mengatur percabangan logika. |
| 140 | ``                            return 'Format email tidak valid';`` | Mengembalikan nilai dari fungsi atau widget. |
| 141 | ``                          }`` | Menutup blok, widget, atau pemanggilan method. |
| 142 | ``                          return null;`` | Mengembalikan nilai dari fungsi atau widget. |
| 143 | ``                        },`` | Menutup blok, widget, atau pemanggilan method. |
| 144 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 145 | ``                      const SizedBox(height: 16),`` | Mendeklarasikan variabel atau konstanta. |
| 146 | ``                      const ScribblrLabel(text: 'Password'),`` | Mendeklarasikan variabel atau konstanta. |
| 147 | ``                      TextFormField(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 148 | ``                        controller: passwordController,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 149 | ``                        obscureText: obscure,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 150 | ``                        decoration: InputDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 151 | ``                          hintText:`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 152 | ``                              '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 153 | ``                          prefixIcon: const Icon(Icons.lock_outline),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 154 | ``                          suffixIcon: IconButton(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 155 | ``                            onPressed: () => setState(() => obscure = !obscure),`` | Memperbarui state dan menjadwalkan rebuild UI. |
| 156 | ``                            icon: Icon(`` | Menyusun elemen antarmuka Flutter. |
| 157 | ``                              obscure`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 158 | ``                                  ? Icons.visibility_off_outlined`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 159 | ``                                  : Icons.visibility_outlined,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 160 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 161 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 162 | ``                        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 163 | ``                        validator: (value) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 164 | ``                          if ((value ?? '').length < 4) {`` | Mengatur percabangan logika. |
| 165 | ``                            return 'Password minimal 4 karakter';`` | Mengembalikan nilai dari fungsi atau widget. |
| 166 | ``                          }`` | Menutup blok, widget, atau pemanggilan method. |
| 167 | ``                          return null;`` | Mengembalikan nilai dari fungsi atau widget. |
| 168 | ``                        },`` | Menutup blok, widget, atau pemanggilan method. |
| 169 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 170 | ``                      const SizedBox(height: 24),`` | Mendeklarasikan variabel atau konstanta. |
| 171 | ``                      ScribblrPrimaryButton(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 172 | ``                        text: 'Sign Up',`` | Menyusun elemen antarmuka Flutter. |
| 173 | ``                        loading: isSaving,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 174 | ``                        onPressed: isSaving ? null : register,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 175 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 176 | ``                      const SizedBox(height: 16),`` | Mendeklarasikan variabel atau konstanta. |
| 177 | ``                      Row(`` | Menyusun elemen antarmuka Flutter. |
| 178 | ``                        mainAxisAlignment: MainAxisAlignment.center,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 179 | ``                        children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 180 | ``                          const Text(`` | Mendeklarasikan variabel atau konstanta. |
| 181 | ``                            'Already have an account? ',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 182 | ``                            style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 183 | ``                              fontSize: 13,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 184 | ``                              color: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 185 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 186 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 187 | ``                          TextButton(`` | Menyusun elemen antarmuka Flutter. |
| 188 | ``                            style: TextButton.styleFrom(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 189 | ``                              padding: EdgeInsets.zero,`` | Menyusun elemen antarmuka Flutter. |
| 190 | ``                              minimumSize: Size.zero,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 191 | ``                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 192 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 193 | ``                            onPressed: isSaving`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 194 | ``                                ? null`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 195 | ``                                : () => Navigator.pop(context),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 196 | ``                            child: const Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 197 | ``                              'Sign In',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 198 | ``                              style: TextStyle(fontWeight: FontWeight.w700),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 199 | ``                            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 200 | ``                          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 201 | ``                        ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 202 | ``                      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 203 | ``                    ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 204 | ``                  ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 205 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 206 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 207 | ``              const SizedBox(height: 8),`` | Mendeklarasikan variabel atau konstanta. |
| 208 | ``            ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 209 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 210 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 211 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 212 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 213 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 214 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `scribblr_theme.dart`

Path: [`lib/scribblr_theme.dart`](lib/scribblr_theme.dart)
Jumlah baris: **85**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 3 | ``class ScribblrColors {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 4 | ``  static const bg = Color(0xFFFDF8F2);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 5 | ``  static const surface = Color(0xFFFFFFFF);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 6 | ``  static const primary = Color(0xFFA9603D);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 7 | ``  static const primaryDark = Color(0xFF8C4E30);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 8 | ``  static const ink = Color(0xFF2E2220);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 9 | ``  static const muted = Color(0xFF8A7E78);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 10 | ``  static const line = Color(0xFFEADDCF);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 11 | ``  static const chipBg = Color(0xFFF3E8DC);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 12 | ``  static const placeholderBg = Color(0xFFF1E4D6);`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 13 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 14 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 15 | ``ThemeData scribblrTheme() {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 16 | ``  const primary = ScribblrColors.primary;`` | Mendeklarasikan variabel atau konstanta. |
| 17 | ``  return ThemeData(`` | Mengembalikan nilai dari fungsi atau widget. |
| 18 | ``    useMaterial3: true,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 19 | ``    scaffoldBackgroundColor: ScribblrColors.bg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 20 | ``    colorScheme: ColorScheme.fromSeed(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 21 | ``      seedColor: primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 22 | ``      primary: primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 23 | ``      surface: ScribblrColors.surface,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 24 | ``    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 25 | ``    appBarTheme: const AppBarTheme(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 26 | ``      backgroundColor: ScribblrColors.bg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 27 | ``      foregroundColor: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 28 | ``      elevation: 0,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 29 | ``      centerTitle: false,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 30 | ``      titleTextStyle: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 31 | ``        color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 32 | ``        fontSize: 20,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 33 | ``        fontWeight: FontWeight.w700,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 34 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 35 | ``    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 36 | ``    inputDecorationTheme: InputDecorationTheme(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 37 | ``      filled: true,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 38 | ``      fillColor: ScribblrColors.surface,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 39 | ``      labelStyle: const TextStyle(color: ScribblrColors.muted, fontSize: 13),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 40 | ``      hintStyle: const TextStyle(color: ScribblrColors.muted, fontSize: 14),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 41 | ``      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 42 | ``      enabledBorder: OutlineInputBorder(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 43 | ``        borderRadius: BorderRadius.circular(14),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 44 | ``        borderSide: const BorderSide(color: ScribblrColors.line),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 45 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 46 | ``      focusedBorder: OutlineInputBorder(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 47 | ``        borderRadius: BorderRadius.circular(14),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 48 | ``        borderSide: const BorderSide(color: primary, width: 1.4),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 49 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 50 | ``      errorBorder: OutlineInputBorder(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 51 | ``        borderRadius: BorderRadius.circular(14),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 52 | ``        borderSide: const BorderSide(color: Colors.redAccent),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 53 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 54 | ``      focusedErrorBorder: OutlineInputBorder(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 55 | ``        borderRadius: BorderRadius.circular(14),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 56 | ``        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 57 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 58 | ``    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 59 | ``    elevatedButtonTheme: ElevatedButtonThemeData(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 60 | ``      style: ElevatedButton.styleFrom(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 61 | ``        backgroundColor: primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 62 | ``        foregroundColor: Colors.white,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 63 | ``        minimumSize: const Size.fromHeight(52),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 64 | ``        shape: const StadiumBorder(),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 65 | ``        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 66 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 67 | ``    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 68 | ``    textButtonTheme: TextButtonThemeData(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 69 | ``      style: TextButton.styleFrom(foregroundColor: primary),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 70 | ``    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 71 | ``    chipTheme: const ChipThemeData(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 72 | ``      backgroundColor: ScribblrColors.chipBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 73 | ``      selectedColor: primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 74 | ``      labelStyle: TextStyle(fontSize: 13),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 75 | ``      shape: StadiumBorder(side: BorderSide(color: ScribblrColors.line)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 76 | ``    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 77 | ``    bottomNavigationBarTheme: const BottomNavigationBarThemeData(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 78 | ``      backgroundColor: ScribblrColors.surface,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 79 | ``      selectedItemColor: primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 80 | ``      unselectedItemColor: ScribblrColors.muted,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 81 | ``      showUnselectedLabels: true,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 82 | ``      type: BottomNavigationBarType.fixed,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 83 | ``    ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 84 | ``  );`` | Menutup blok, widget, atau pemanggilan method. |
| 85 | ``}`` | Menutup blok, widget, atau pemanggilan method. |

## `scribblr_widgets.dart`

Path: [`lib/scribblr_widgets.dart`](lib/scribblr_widgets.dart)
Jumlah baris: **255**

| Baris | Kode | Penjelasan |
|---:|---|---|
| 1 | ``import 'package:flutter/material.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 2 | ``import 'package:frontendats/posts_refresh.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 3 | ``import 'package:frontendats/scribblr_theme.dart';`` | Mengimpor library atau file Dart yang dibutuhkan. |
| 4 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 5 | ``class ScribblrHeader extends StatelessWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 6 | ``  final String title;`` | Mendeklarasikan variabel atau konstanta. |
| 7 | ``  final String? subtitle;`` | Mendeklarasikan variabel atau konstanta. |
| 8 | ``  const ScribblrHeader({super.key, required this.title, this.subtitle});`` | Mendeklarasikan variabel atau konstanta. |
| 9 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 10 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 11 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 12 | ``    return Column(`` | Mengembalikan nilai dari fungsi atau widget. |
| 13 | ``      crossAxisAlignment: CrossAxisAlignment.start,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 14 | ``      children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 15 | ``        Text(`` | Menyusun elemen antarmuka Flutter. |
| 16 | ``          title,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 17 | ``          style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 18 | ``            fontSize: 26,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 19 | ``            fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 20 | ``            color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 21 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 22 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 23 | ``        if (subtitle != null) ...[`` | Mengatur percabangan logika. |
| 24 | ``          const SizedBox(height: 4),`` | Mendeklarasikan variabel atau konstanta. |
| 25 | ``          Text(`` | Menyusun elemen antarmuka Flutter. |
| 26 | ``            subtitle!,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 27 | ``            style: const TextStyle(fontSize: 13, color: ScribblrColors.muted),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 28 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 29 | ``        ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 30 | ``      ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 31 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 32 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 33 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 34 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 35 | ``class ScribblrLabel extends StatelessWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 36 | ``  final String text;`` | Mendeklarasikan variabel atau konstanta. |
| 37 | ``  const ScribblrLabel({super.key, required this.text});`` | Mendeklarasikan variabel atau konstanta. |
| 38 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 39 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 40 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 41 | ``    return Padding(`` | Mengembalikan nilai dari fungsi atau widget. |
| 42 | ``      padding: const EdgeInsets.only(bottom: 6),`` | Menyusun elemen antarmuka Flutter. |
| 43 | ``      child: Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 44 | ``        text,`` | Menyusun elemen antarmuka Flutter. |
| 45 | ``        style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 46 | ``          fontSize: 13,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 47 | ``          fontWeight: FontWeight.w600,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 48 | ``          color: ScribblrColors.ink,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 49 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 50 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 51 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 52 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 53 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 54 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 55 | ``class ScribblrPrimaryButton extends StatelessWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 56 | ``  final String text;`` | Mendeklarasikan variabel atau konstanta. |
| 57 | ``  final VoidCallback? onPressed;`` | Mendeklarasikan variabel atau konstanta. |
| 58 | ``  final bool loading;`` | Mendeklarasikan variabel atau konstanta. |
| 59 | ``  const ScribblrPrimaryButton({`` | Mendeklarasikan variabel atau konstanta. |
| 60 | ``    super.key,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 61 | ``    required this.text,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 62 | ``    required this.onPressed,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 63 | ``    this.loading = false,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 64 | ``  });`` | Menutup blok, widget, atau pemanggilan method. |
| 65 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 66 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 67 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 68 | ``    return ElevatedButton(`` | Mengembalikan nilai dari fungsi atau widget. |
| 69 | ``      onPressed: loading ? null : onPressed,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 70 | ``      child: loading`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 71 | ``          ? const SizedBox(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 72 | ``              height: 18,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 73 | ``              width: 18,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 74 | ``              child: CircularProgressIndicator(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 75 | ``                strokeWidth: 2,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 76 | ``                color: Colors.white,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 77 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 78 | ``            )`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 79 | ``          : Text(text),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 80 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 81 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 82 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 83 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 84 | ``class ScribblrThumb extends StatelessWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 85 | ``  final dynamic cover;`` | Mendeklarasikan variabel atau konstanta. |
| 86 | ``  final double width;`` | Mendeklarasikan variabel atau konstanta. |
| 87 | ``  final double height;`` | Mendeklarasikan variabel atau konstanta. |
| 88 | ``  const ScribblrThumb({`` | Mendeklarasikan variabel atau konstanta. |
| 89 | ``    super.key,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 90 | ``    required this.cover,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 91 | ``    this.width = 92,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 92 | ``    this.height = 92,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 93 | ``  });`` | Menutup blok, widget, atau pemanggilan method. |
| 94 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 95 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 96 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 97 | ``    final url = resolveCoverUrl(cover);`` | Mendeklarasikan variabel atau konstanta. |
| 98 | ``    return ClipRRect(`` | Mengembalikan nilai dari fungsi atau widget. |
| 99 | ``      borderRadius: BorderRadius.circular(16),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 100 | ``      child: Container(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 101 | ``        width: width,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 102 | ``        height: height,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 103 | ``        color: ScribblrColors.placeholderBg,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 104 | ``        child: url.isEmpty`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 105 | ``            ? const Icon(Icons.article_outlined, color: ScribblrColors.primary)`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 106 | ``            : Image.network(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 107 | ``                url,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 108 | ``                fit: BoxFit.cover,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 109 | ``                errorBuilder: (_, _, _) => const Icon(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 110 | ``                  Icons.article_outlined,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 111 | ``                  color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 112 | ``                ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 113 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 114 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 115 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 116 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 117 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 118 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 119 | ``class ScribblrCard extends StatelessWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 120 | ``  final Widget child;`` | Mendeklarasikan variabel atau konstanta. |
| 121 | ``  final VoidCallback? onTap;`` | Mendeklarasikan variabel atau konstanta. |
| 122 | ``  const ScribblrCard({super.key, required this.child, this.onTap});`` | Mendeklarasikan variabel atau konstanta. |
| 123 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 124 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 125 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 126 | ``    return Card(`` | Mengembalikan nilai dari fungsi atau widget. |
| 127 | ``      color: ScribblrColors.surface,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 128 | ``      elevation: 0,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 129 | ``      shape: RoundedRectangleBorder(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 130 | ``        borderRadius: BorderRadius.circular(18),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 131 | ``        side: const BorderSide(color: ScribblrColors.line),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 132 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 133 | ``      child: InkWell(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 134 | ``        borderRadius: BorderRadius.circular(18),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 135 | ``        onTap: onTap,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 136 | ``        child: Padding(padding: const EdgeInsets.all(12), child: child),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 137 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 138 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 139 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 140 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 141 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 142 | ``class AuthHeader extends StatelessWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 143 | ``  final String title;`` | Mendeklarasikan variabel atau konstanta. |
| 144 | ``  final String subtitle;`` | Mendeklarasikan variabel atau konstanta. |
| 145 | ``  const AuthHeader({super.key, required this.title, required this.subtitle});`` | Mendeklarasikan variabel atau konstanta. |
| 146 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 147 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 148 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 149 | ``    return Container(`` | Mengembalikan nilai dari fungsi atau widget. |
| 150 | ``      width: double.infinity,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 151 | ``      padding: const EdgeInsets.fromLTRB(24, 56, 24, 72),`` | Menyusun elemen antarmuka Flutter. |
| 152 | ``      decoration: const BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 153 | ``        gradient: LinearGradient(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 154 | ``          begin: Alignment.topLeft,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 155 | ``          end: Alignment.bottomRight,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 156 | ``          colors: [ScribblrColors.primary, ScribblrColors.primaryDark],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 157 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 158 | ``        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 159 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 160 | ``      child: Column(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 161 | ``        crossAxisAlignment: CrossAxisAlignment.start,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 162 | ``        children: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 163 | ``          Container(`` | Menyusun elemen antarmuka Flutter. |
| 164 | ``            width: 56,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 165 | ``            height: 56,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 166 | ``            decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 167 | ``              color: Colors.white,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 168 | ``              borderRadius: BorderRadius.circular(18),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 169 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 170 | ``            alignment: Alignment.center,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 171 | ``            child: const Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 172 | ``              'W',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 173 | ``              style: TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 174 | ``                fontSize: 28,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 175 | ``                fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 176 | ``                color: ScribblrColors.primary,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 177 | ``              ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 178 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 179 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 180 | ``          const SizedBox(height: 16),`` | Mendeklarasikan variabel atau konstanta. |
| 181 | ``          Text(`` | Menyusun elemen antarmuka Flutter. |
| 182 | ``            title,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 183 | ``            style: const TextStyle(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 184 | ``              fontSize: 28,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 185 | ``              fontWeight: FontWeight.w800,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 186 | ``              color: Colors.white,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 187 | ``              height: 1.2,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 188 | ``            ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 189 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 190 | ``          const SizedBox(height: 6),`` | Mendeklarasikan variabel atau konstanta. |
| 191 | ``          Text(`` | Menyusun elemen antarmuka Flutter. |
| 192 | ``            subtitle,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 193 | ``            style: const TextStyle(fontSize: 14, color: Colors.white70),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 194 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 195 | ``        ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 196 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 197 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 198 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 199 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 200 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 201 | ``class AuthCard extends StatelessWidget {`` | Mendefinisikan tipe atau abstraksi Dart. |
| 202 | ``  final Widget child;`` | Mendeklarasikan variabel atau konstanta. |
| 203 | ``  const AuthCard({super.key, required this.child});`` | Mendeklarasikan variabel atau konstanta. |
| 204 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 205 | ``  @override`` | Annotation/metadata untuk framework atau analyzer. |
| 206 | ``  Widget build(BuildContext context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 207 | ``    return Container(`` | Mengembalikan nilai dari fungsi atau widget. |
| 208 | ``      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 209 | ``      transform: Matrix4.translationValues(0, -40, 0),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 210 | ``      padding: const EdgeInsets.all(20),`` | Menyusun elemen antarmuka Flutter. |
| 211 | ``      decoration: BoxDecoration(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 212 | ``        color: ScribblrColors.surface,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 213 | ``        borderRadius: BorderRadius.circular(24),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 214 | ``        border: Border.all(color: ScribblrColors.line),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 215 | ``        boxShadow: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 216 | ``          BoxShadow(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 217 | ``            color: ScribblrColors.ink.withValues(alpha: 0.08),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 218 | ``            blurRadius: 24,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 219 | ``            offset: const Offset(0, 12),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 220 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 221 | ``        ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 222 | ``      ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 223 | ``      child: child,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 224 | ``    );`` | Menutup blok, widget, atau pemanggilan method. |
| 225 | ``  }`` | Menutup blok, widget, atau pemanggilan method. |
| 226 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
| 227 | ```` | Baris kosong untuk pemisah dan keterbacaan. |
| 228 | ``Future<bool> confirmDeleteArticle(BuildContext context) async {`` | Mendefinisikan operasi asynchronous. |
| 229 | ``  final ok = await showDialog<bool>(`` | Mendeklarasikan variabel atau konstanta. |
| 230 | ``    context: context,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 231 | ``    builder: (context) {`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 232 | ``      return AlertDialog(`` | Mengembalikan nilai dari fungsi atau widget. |
| 233 | ``        backgroundColor: ScribblrColors.surface,`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 234 | ``        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 235 | ``        title: const Text(`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 236 | ``          'Delete Article',`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 237 | ``          style: TextStyle(fontWeight: FontWeight.w700),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 238 | ``        ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 239 | ``        content: const Text('Are you sure you want to delete this article?'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 240 | ``        actions: [`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 241 | ``          TextButton(`` | Menyusun elemen antarmuka Flutter. |
| 242 | ``            onPressed: () => Navigator.pop(context, false),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 243 | ``            child: const Text('Cancel'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 244 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 245 | ``          ElevatedButton(`` | Menyusun elemen antarmuka Flutter. |
| 246 | ``            style: ElevatedButton.styleFrom(minimumSize: const Size(110, 44)),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 247 | ``            onPressed: () => Navigator.pop(context, true),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 248 | ``            child: const Text('Yes, Delete'),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 249 | ``          ),`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 250 | ``        ],`` | Implementasi detail logika, konfigurasi, atau UI pada konteks sekitarnya. |
| 251 | ``      );`` | Menutup blok, widget, atau pemanggilan method. |
| 252 | ``    },`` | Menutup blok, widget, atau pemanggilan method. |
| 253 | ``  );`` | Menutup blok, widget, atau pemanggilan method. |
| 254 | ``  return ok == true;`` | Mengembalikan nilai dari fungsi atau widget. |
| 255 | ``}`` | Menutup blok, widget, atau pemanggilan method. |
