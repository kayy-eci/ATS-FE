import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontendats/api.dart';

class EditPostPage extends StatefulWidget {
  final Map post;
  final List categories;
  const EditPostPage({super.key, required this.post, this.categories = const []});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late final titleController = TextEditingController(text: widget.post['title']?.toString() ?? '');
  late final contentController = TextEditingController(text: widget.post['content']?.toString() ?? '');
  late final excerptController = TextEditingController(text: widget.post['excerpt']?.toString() ?? '');
  late final authorController = TextEditingController(text: widget.post['author']?.toString() ?? '');
  int? selectedCategory;
  late String selectedStatus;
  bool isSaving = false;

  String makeSlug(String title) {
    return title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '-');
  }

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.post['category_id'];
    selectedStatus = widget.post['status']?.toString() ?? 'published';
  }

  Future<void> updatePost() async {
    setState(() => isSaving = true);

    final response = await http.put(
      Uri.parse('$baseUrl/posts/${widget.post['id']}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': titleController.text,
        'slug': makeSlug(titleController.text),
        'content': contentController.text,
        'excerpt': excerptController.text.isEmpty ? null : excerptController.text,
        'cover_image': widget.post['cover_image'],
        'category_id': selectedCategory,
        'author': authorController.text.isEmpty ? null : authorController.text,
        'status': selectedStatus,
      }),
    );

    setState(() => isSaving = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berhasil memperbarui artikel: ${response.statusCode}')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui artikel: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Artikel')),
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
            if (widget.categories.isNotEmpty)
              DropdownButton<int>(
                value: selectedCategory,
                isExpanded: true,
                items: widget.categories.map<DropdownMenuItem<int>>((c) {
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
              onPressed: isSaving ? null : updatePost,
              child: isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Perbarui'),
            ),
          ],
        ),
      ),
    );
  }
}
