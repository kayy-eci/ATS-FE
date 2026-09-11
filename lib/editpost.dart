import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontendats/api.dart';
import 'package:frontendats/api_client.dart';

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
  List categories = [];
  int? selectedCategory;
  late String selectedStatus;
  bool isSaving = false;
  bool isLoadingCats = false;

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

  @override
  void initState() {
    super.initState();
    categories = widget.categories;
    selectedCategory = parseId(widget.post['category_id']);
    selectedStatus = widget.post['status']?.toString() ?? 'published';
    // DetailPost kadang tidak membawa categories -> fetch sendiri.
    if (categories.isEmpty) fetchCategories();
  }

  Future<void> fetchCategories() async {
    setState(() => isLoadingCats = true);
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/categories'), headers: authHeaders())
          .timeout(const Duration(seconds: 10));
      if (!mounted) return;
      if (await handleAuthError(context, res)) return;
      if (res.statusCode == 200) {
        setState(() {
          categories = jsonDecode(res.body)['data'] ?? [];
        });
      }
    } catch (e) {
      debugPrint('fetchCategories error: $e');
    } finally {
      if (mounted) setState(() => isLoadingCats = false);
    }
  }

  Future<void> updatePost() async {
    if (titleController.text.trim().isEmpty || contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan isi artikel wajib diisi')),
      );
      return;
    }
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori belum dipilih')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final slug = makeSlug(titleController.text);
      final response = await http
          .put(
            Uri.parse('$baseUrl/posts/${widget.post['id']}'),
            headers: authHeaders(),
            body: jsonEncode({
              'title': titleController.text.trim(),
              'slug': slug.isEmpty ? null : slug,
              'content': contentController.text,
              'excerpt': excerptController.text.isEmpty ? null : excerptController.text,
              'cover_image': widget.post['cover_image'],
              'category_id': selectedCategory,
              'author': authorController.text.isEmpty ? null : authorController.text,
              'status': selectedStatus,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;
      setState(() => isSaving = false);
      if (await handleAuthError(context, response)) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil memperbarui artikel: ${response.statusCode}')),
        );
        Navigator.pop(context, true);
      } else {
        String msg = 'Gagal memperbarui artikel: ${response.statusCode}';
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
            if (isLoadingCats)
              const Center(child: CircularProgressIndicator())
            else if (categories.isNotEmpty)
              DropdownButton<int>(
                value: selectedCategory,
                isExpanded: true,
                items: categories.map<DropdownMenuItem<int>>((c) {
                  return DropdownMenuItem<int>(
                    value: parseId(c['id']),
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
