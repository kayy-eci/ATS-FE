import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontendats/api.dart';

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

  String makeSlug(String title) {
    return title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '-');
  }

  Future<void> getCategories() async {
    final data = await http.get(Uri.parse('$baseUrl/categories'));

    if (data.statusCode == 200) {
      setState(() {
        categories = jsonDecode(data.body)['data'] ?? [];
        if (categories.isNotEmpty) {
          selectedCategory = categories[0]['id'];
        }
      });
    } else {
      print('data gagal di ambil');
    }
  }

  Future<void> addPost() async {
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih kategori dulu')),
      );
      return;
    }

    setState(() => isSaving = true);

    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': titleController.text,
        'slug': makeSlug(titleController.text),
        'content': contentController.text,
        'excerpt': excerptController.text.isEmpty ? null : excerptController.text,
        'cover_image': null,
        'category_id': selectedCategory,
        'author': authorController.text.isEmpty ? null : authorController.text,
        'status': selectedStatus,
      }),
    );

    setState(() => isSaving = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berhasil menyimpan artikel: ${response.body}')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan artikel: ${response.statusCode}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
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
                return DropdownMenuItem<int>(
                  value: c['id'],
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
