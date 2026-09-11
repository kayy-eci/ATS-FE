import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontendats/api.dart';
import 'package:frontendats/api_client.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final excerptController = TextEditingController();
  final authorController = TextEditingController();
  List categories = [];
  int? selectedCategory;
  String selectedStatus = 'published';
  bool isSaving = false;

  /// Samakan dengan validasi backend (Zod):
  /// slug hanya lowercase, angka, hyphen, tanpa hyphen ganda/di ujung.
  String makeSlug(String title) {
    var s = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s-]'), '');
    s = s.trim().replaceAll(RegExp(r'\s+'), '-').replaceAll(RegExp(r'-+'), '-');
    s = s.replaceAll(RegExp(r'^-+|-+$'), '');
    return s;
  }

  int? parseId(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  Future<void> getCategories() async {
    try {
      final data = await http
          .get(Uri.parse('$baseUrl/categories'), headers: authHeaders())
          .timeout(const Duration(seconds: 10));
      if (!mounted) return;
      if (await handleAuthError(context, data)) return;

      if (data.statusCode == 200) {
        setState(() {
          categories = jsonDecode(data.body)['data'] ?? [];
          if (categories.isNotEmpty) {
            selectedCategory = parseId(categories[0]['id']);
          }
        });
      } else {
        debugPrint('data gagal di ambil: ${data.statusCode}');
      }
    } catch (e) {
      debugPrint('getCategories error: $e');
    }
  }

  Future<void> addPost() async {
    if (titleController.text.trim().isEmpty || contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan isi artikel wajib diisi')),
      );
      return;
    }
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kategori dulu')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final slug = makeSlug(titleController.text);
      final response = await http
          .post(
            Uri.parse('$baseUrl/posts'),
            headers: authHeaders(),
            body: jsonEncode({
              'title': titleController.text.trim(),
              'slug': slug.isEmpty ? null : slug,
              'content': contentController.text,
              'excerpt': excerptController.text.isEmpty ? null : excerptController.text,
              'cover_image': null,
              'category_id': selectedCategory,
              'author': authorController.text.isEmpty ? null : authorController.text,
              'status': selectedStatus,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;
      setState(() => isSaving = false);
      if (await handleAuthError(context, response)) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil menyimpan artikel: ${response.body}')),
        );
        Navigator.pop(context, true);
      } else {
        String msg = 'Gagal menyimpan artikel: ${response.statusCode}';
        try {
          final b = jsonDecode(response.body);
          if (b is Map && b['message'] != null) msg = '$msg - ${b['message']}';
        } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
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
    getCategories();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    excerptController.dispose();
    authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Artikel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Isi Artikel'),
            ),
            TextField(
              controller: excerptController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Ringkasan'),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Penulis'),
            ),
            const SizedBox(height: 12),
            DropdownButton<int>(
              value: selectedCategory,
              isExpanded: true,
              hint: const Text('Kategori'),
              items: categories.map<DropdownMenuItem<int>>((c) {
                final id = parseId(c['id']);
                return DropdownMenuItem<int>(
                  value: id,
                  child: Text(c['name'].toString()),
                );
              }).toList(),
              onChanged: (v) => setState(() => selectedCategory = v),
            ),
            DropdownButton<String>(
              value: selectedStatus,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'published', child: Text('published')),
                DropdownMenuItem(value: 'draft', child: Text('draft')),
              ],
              onChanged: (v) => setState(() => selectedStatus = v ?? 'published'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSaving ? null : addPost,
              child: isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
