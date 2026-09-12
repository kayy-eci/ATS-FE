import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:frontendats/api.dart';
import 'package:frontendats/api_client.dart';
import 'package:frontendats/posts_refresh.dart';
import 'package:frontendats/scribblr_theme.dart';
import 'package:frontendats/scribblr_widgets.dart';

class EditPostPage extends StatefulWidget {
  final Map post;
  final List categories;
  final String currentUsername;
  const EditPostPage({
    super.key,
    required this.post,
    this.categories = const [],
    this.currentUsername = '',
  });

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final _formKey = GlobalKey<FormState>();
  late final titleController = TextEditingController(text: strOf(widget.post, 'title'));
  late final contentController = TextEditingController(text: strOf(widget.post, 'content'));
  late final excerptController = TextEditingController(text: strOf(widget.post, 'excerpt'));
  late final authorController = TextEditingController(text: strOf(widget.post, 'author'));
  late final coverController =
      TextEditingController(text: strOf(widget.post, 'cover_image'));
  List categories = [];
  int? selectedCategory;
  String? categoryError;
  late String selectedStatus;
  bool isSaving = false;
  bool isUploading = false;
  bool isLoadingCats = false;

  XFile? _pickedCover;
  Uint8List? _pickedBytes;

  bool get _isMine =>
      widget.currentUsername.isEmpty ||
      isMine(widget.post, widget.currentUsername);

  String makeSlug(String title) {
    var s = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s-]'), '');
    s = s.trim().replaceAll(RegExp(r'\s+'), '-').replaceAll(RegExp(r'-+'), '-');
    s = s.replaceAll(RegExp(r'^-+|-+$'), '');
    return s;
  }

  @override
  void initState() {
    super.initState();
    categories = widget.categories;
    selectedCategory = idOf(widget.post['category_id']);
    final st = strOf(widget.post, 'status');
    selectedStatus = st.isEmpty ? 'published' : st;
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
        final body = jsonDecode(res.body);
        final list = (body is Map ? body['data'] : null) ?? [];
        setState(() {
          categories = list is List ? list : [];
        });
      }
    } catch (e) {
      debugPrint('fetchCategories error: $e');
    } finally {
      if (mounted) setState(() => isLoadingCats = false);
    }
  }

  Future<void> pickCover() async {
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _pickedCover = file;
        _pickedBytes = bytes;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih gambar: $e')),
      );
    }
  }

  /// Upload cover ke backend (POST /api/upload, field `image`).
  /// Null kalau gagal — pemanggil fallback ke URL teks.
  Future<String?> uploadCover() async {
    final picked = _pickedCover;
    final bytes = _pickedBytes;
    if (picked == null || bytes == null) return null;
    try {
      final req = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload'),
      )..headers.addAll(authHeaders());
      req.files.add(
        http.MultipartFile.fromBytes('image', bytes, filename: picked.name),
      );
      final streamed =
          await req.send().timeout(const Duration(seconds: 20));
      final res = await http.Response.fromStream(streamed);
      if (res.statusCode == 200 || res.statusCode == 201) {
        try {
          final body = jsonDecode(res.body);
          String url = '';
          if (body is Map) {
            url = (body['url'] ?? body['path'] ?? '').toString();
            if (url.isEmpty && body['data'] is Map) {
              final d = body['data'] as Map;
              url = (d['url'] ?? d['path'] ?? '').toString();
            }
          }
          if (url.isEmpty) return null;
          if (url.startsWith('http')) return url;
          final origin =
              Uri.parse(baseUrl).replace(path: '').toString().replaceAll(RegExp(r'/+$'), '');
          return url.startsWith('/') ? '$origin$url' : '$origin/$url';
        } catch (_) {
          return null;
        }
      }
      return null;
    } catch (e) {
      debugPrint('uploadCover error: $e');
      return null;
    }
  }

  Future<void> updatePost() async {
    FocusScope.of(context).unfocus();
    if (!_isMine) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamu hanya bisa mengedit artikelmu sendiri')),
      );
      return;
    }
    final valid = _formKey.currentState?.validate() ?? false;
    if (selectedCategory == null) {
      setState(() => categoryError = 'Kategori belum dipilih');
    }
    if (!valid || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Periksa lagi isian yang ditandai')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      String? uploadedUrl;
      if (_pickedCover != null) {
        setState(() => isUploading = true);
        uploadedUrl = await uploadCover();
        if (!mounted) return;
        setState(() => isUploading = false);
      }

      var slug = makeSlug(titleController.text);
      if (slug.isEmpty) {
        slug = 'post-${DateTime.now().millisecondsSinceEpoch}';
      }
      final urlCover = coverController.text.trim();
      final cover = uploadedUrl ?? (urlCover.isEmpty ? null : urlCover);
      final postId = strOf(widget.post, 'id');
      if (postId.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID artikel tidak valid')),
        );
        return;
      }
      final response = await http
          .put(
            Uri.parse('$baseUrl/posts/$postId'),
            headers: authHeaders(),
            body: jsonEncode({
              'title': titleController.text.trim(),
              'slug': slug,
              'content': contentController.text,
              'excerpt': excerptController.text.isEmpty ? null : excerptController.text,
              'cover_image': cover,
              'category_id': selectedCategory,
              // Author tidak diubah saat edit agar kepemilikan konsisten.
              'author': authorController.text.isEmpty ? null : authorController.text.trim(),
              'status': selectedStatus,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;
      if (await handleAuthError(context, response)) return;

      if (response.statusCode == 200) {
        PostsRefresh.bump();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa terhubung ke server: $e')),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    excerptController.dispose();
    authorController.dispose();
    coverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Edit Article')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              if (!_isMine)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDECEA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Artikel ini milik penulis lain. Kamu tidak bisa mengubahnya.',
                    style: TextStyle(color: Colors.redAccent, fontSize: 13),
                  ),
                ),
              _coverPreview(),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: (!_isMine || isSaving) ? null : pickCover,
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: const Text('Ganti gambar'),
                  ),
                  if (_pickedCover != null)
                    TextButton.icon(
                      onPressed: isSaving
                          ? null
                          : () => setState(() {
                                _pickedCover = null;
                                _pickedBytes = null;
                              }),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Hapus'),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              const ScribblrLabel(text: 'Cover image URL (opsional)'),
              TextFormField(
                controller: coverController,
                keyboardType: TextInputType.url,
                enabled: _isMine,
                decoration: const InputDecoration(hintText: 'https://...'),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return null;
                  final uri = Uri.tryParse(t);
                  if (uri == null ||
                      !(uri.isScheme('http') || uri.isScheme('https'))) {
                    return 'URL tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              const ScribblrLabel(text: 'Title'),
              TextFormField(
                controller: titleController,
                enabled: _isMine,
                validator: (v) {
                  if ((v ?? '').trim().length < 3) {
                    return 'Judul minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              const ScribblrLabel(text: 'Article'),
              TextFormField(
                controller: contentController,
                maxLines: 6,
                enabled: _isMine,
                validator: (v) {
                  if ((v ?? '').trim().length < 10) {
                    return 'Isi artikel minimal 10 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              const ScribblrLabel(text: 'Excerpt'),
              TextFormField(
                controller: excerptController,
                maxLines: 2,
                enabled: _isMine,
              ),
              const SizedBox(height: 14),
              const ScribblrLabel(text: 'Author (terkunci)'),
              TextFormField(
                controller: authorController,
                readOnly: true,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.lock_outline, size: 18),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Select Topics',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: ScribblrColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              if (isLoadingCats)
                const Center(
                  child: CircularProgressIndicator(
                    color: ScribblrColors.primary,
                  ),
                )
              else if (categories.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map<Widget>((c) {
                    final id = idOf((c as Map)['id']);
                    final selected = selectedCategory == id;
                    return FilterChip(
                      label: Text(strOf(c, 'name')),
                      selected: selected,
                      onSelected: !_isMine
                          ? null
                          : (_) => setState(() {
                                selectedCategory = id;
                                categoryError = null;
                              }),
                      selectedColor: ScribblrColors.primary,
                      labelStyle: TextStyle(
                        color: selected
                            ? Colors.white
                            : ScribblrColors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: const StadiumBorder(
                        side: BorderSide(color: ScribblrColors.line),
                      ),
                    );
                  }).toList(),
                ),
              if (categoryError != null) ...[
                const SizedBox(height: 6),
                Text(
                  categoryError!,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              const ScribblrLabel(text: 'Status'),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ScribblrColors.chipBg,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _statusButton('published', 'Publish'),
                    _statusButton('draft', 'Draft'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ScribblrPrimaryButton(
                text: isUploading ? 'Uploading image...' : 'Save Changes',
                loading: isSaving,
                onPressed: (!_isMine || isSaving) ? null : updatePost,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coverPreview() {
    if (_pickedBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.memory(
          _pickedBytes!,
          height: 180,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _coverPlaceholder(),
        ),
      );
    }
    final url = coverController.text.trim();
    if (url.isEmpty) return _coverPlaceholder();
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        url,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _coverPlaceholder(),
      ),
    );
  }

  Widget _coverPlaceholder() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: ScribblrColors.placeholderBg,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 40,
        color: ScribblrColors.primary,
      ),
    );
  }

  Widget _statusButton(String value, String label) {
    final active = selectedStatus == value;
    return Expanded(
      child: GestureDetector(
        onTap: !_isMine ? null : () => setState(() => selectedStatus = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? ScribblrColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: active ? ScribblrColors.primary : ScribblrColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}
