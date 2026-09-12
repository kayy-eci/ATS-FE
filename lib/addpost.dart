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

class AddPostPage extends StatefulWidget {
  final String username;
  final VoidCallback? onSaved;
  const AddPostPage({super.key, this.username = '', this.onSaved});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final excerptController = TextEditingController();
  late final authorController =
      TextEditingController(text: widget.username);
  final coverController = TextEditingController();
  List categories = [];
  int? selectedCategory;
  String? categoryError;
  String selectedStatus = 'published';
  bool isSaving = false;
  bool isUploading = false;

  XFile? _pickedCover;
  Uint8List? _pickedBytes;

  /// Samakan dengan validasi backend (Zod):
  /// slug hanya lowercase, angka, hyphen, tanpa hyphen ganda/di ujung.
  String makeSlug(String title) {
    var s = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s-]'), '');
    s = s.trim().replaceAll(RegExp(r'\s+'), '-').replaceAll(RegExp(r'-+'), '-');
    s = s.replaceAll(RegExp(r'^-+|-+$'), '');
    return s;
  }

  Future<void> getCategories() async {
    try {
      final data = await http
          .get(Uri.parse('$baseUrl/categories'), headers: authHeaders())
          .timeout(const Duration(seconds: 10));
      if (!mounted) return;
      if (await handleAuthError(context, data)) return;

      if (data.statusCode == 200) {
        final body = jsonDecode(data.body);
        final list = (body is Map ? body['data'] : null) ?? [];
        setState(() {
          categories = list is List ? list : [];
          if (categories.isNotEmpty && selectedCategory == null) {
            selectedCategory = idOf(categories[0]['id']);
          }
          categoryError = null;
        });
      } else {
        debugPrint('data gagal di ambil: ${data.statusCode}');
      }
    } catch (e) {
      debugPrint('getCategories error: $e');
    }
  }

  // Bikin kategori baru inline (POST /categories yang sudah ada di backend),
  // lalu otomatis kepilih (checklist). Field sesuai skema backend.
  Future<void> createCategoryInline() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final created = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ScribblrColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'New Topic',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Topic name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descController,
                  decoration:
                      const InputDecoration(hintText: 'Description (opsional)'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 44),
              ),
              onPressed: () {
                if (formKey.currentState?.validate() != true) return;
                Navigator.pop(context, true);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (created != true || !mounted) return;
    final name = nameController.text.trim();
    final slug = makeSlug(name);
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/categories'),
            headers: authHeaders(),
            body: jsonEncode({
              'name': name,
              'slug': slug.isEmpty ? name.toLowerCase() : slug,
              'description': descController.text.isEmpty
                  ? null
                  : descController.text,
            }),
          )
          .timeout(const Duration(seconds: 10));
      if (!mounted) return;
      if (await handleAuthError(context, res)) return;
      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Topik baru tersimpan')),
        );
        await getCategories();
        // Otomatis checklist topik yang baru dibuat.
        for (final c in categories) {
          if (strOf(c, 'name') == name) {
            setState(() {
              selectedCategory = idOf((c as Map)['id']);
              categoryError = null;
            });
            break;
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal bikin topik: ${res.statusCode}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa terhubung ke server: $e')),
      );
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

  void clearPickedCover() {
    setState(() {
      _pickedCover = null;
      _pickedBytes = null;
    });
  }

  /// Upload cover ke backend (POST /api/upload, field `image`).
  /// Return URL absolut, atau null kalau gagal / endpoint belum ada.
  /// Pemanggil wajib fallback ke URL teks / null agar publish tetap jalan.
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
      debugPrint('upload cover gagal: ${res.statusCode} ${res.body}');
      return null;
    } catch (e) {
      debugPrint('uploadCover error: $e');
      return null;
    }
  }

  Future<void> addPost() async {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState?.validate() ?? false;
    if (selectedCategory == null) {
      setState(() => categoryError = 'Pilih kategori dulu');
    }
    if (!valid || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Periksa lagi isian yang ditandai')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      // Upload dulu kalau user memilih gambar dari galeri.
      String? uploadedUrl;
      if (_pickedCover != null) {
        setState(() => isUploading = true);
        uploadedUrl = await uploadCover();
        if (!mounted) return;
        setState(() => isUploading = false);
        if (uploadedUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Upload gambar gagal (endpoint belum tersedia?), pakai URL teks kalau ada',
              ),
            ),
          );
        }
      }

      var slug = makeSlug(titleController.text);
      if (slug.isEmpty) {
        // Fallback agar tidak pernah mengirim slug null/kosong.
        slug = 'post-${DateTime.now().millisecondsSinceEpoch}';
      }
      final urlCover = coverController.text.trim();
      // Prioritas: hasil upload > URL teks > null.
      final cover = uploadedUrl ?? (urlCover.isEmpty ? null : urlCover);
      // Author dikunci ke akun login agar artikel terdeteksi di My Article.
      final author = authorController.text.trim().isEmpty
          ? (widget.username.trim().isEmpty ? null : widget.username.trim())
          : authorController.text.trim();
      final response = await http
          .post(
            Uri.parse('$baseUrl/posts'),
            headers: authHeaders(),
            body: jsonEncode({
              'title': titleController.text.trim(),
              'slug': slug,
              'content': contentController.text,
              'excerpt': excerptController.text.isEmpty ? null : excerptController.text,
              'cover_image': cover,
              'category_id': selectedCategory,
              'author': author,
              'status': selectedStatus,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;
      if (await handleAuthError(context, response)) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        PostsRefresh.bump();
        final inShell = widget.onSaved != null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              selectedStatus == 'draft'
                  ? 'Draft tersimpan, cek tab Draft di My Article'
                  : 'Artikel terbit, cek tab Published di My Article',
            ),
          ),
        );
        if (inShell) {
          // Di dalam bottom-nav tidak ada route untuk di-pop:
          // reset form lalu pindah ke tab My Article.
          _formKey.currentState?.reset();
          titleController.clear();
          contentController.clear();
          excerptController.clear();
          coverController.clear();
          clearPickedCover();
          widget.onSaved?.call();
        } else {
          Navigator.pop(context, true);
        }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa terhubung ke server: $e')),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  void didUpdateWidget(AddPostPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (authorController.text.isEmpty && widget.username.isNotEmpty) {
      authorController.text = widget.username;
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
    final authorLocked = widget.username.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.onSaved == null,
        title: const Text('Create'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ScribblrColors.chipBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  selectedStatus == 'draft' ? 'Draft' : 'Publish',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: ScribblrColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              _coverPreview(),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: isSaving ? null : pickCover,
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: Text(
                      _pickedCover == null ? 'Pilih gambar' : 'Ganti gambar',
                    ),
                  ),
                  if (_pickedCover != null)
                    TextButton.icon(
                      onPressed: isSaving ? null : clearPickedCover,
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
                decoration: const InputDecoration(
                  hintText: 'https://... (dipakai kalau tidak pilih gambar)',
                ),
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
                decoration: const InputDecoration(
                  hintText: 'Article title',
                ),
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
                decoration: const InputDecoration(
                  hintText: 'Tell your story...',
                ),
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
                decoration: const InputDecoration(
                  hintText: 'Short summary...',
                ),
              ),
              const SizedBox(height: 14),
              const ScribblrLabel(text: 'Author (akun kamu, terkunci)'),
              TextFormField(
                controller: authorController,
                readOnly: authorLocked,
                decoration: InputDecoration(
                  hintText: 'Your name',
                  suffixIcon: authorLocked
                      ? const Icon(Icons.lock_outline, size: 18)
                      : null,
                ),
                validator: (v) {
                  if ((v ?? '').trim().isEmpty &&
                      widget.username.trim().isEmpty) {
                    return 'Author wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Text(
                    'Select Topics',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: ScribblrColors.ink,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: isSaving ? null : createCategoryInline,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('New'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (categories.isEmpty)
                const Text(
                  'Belum ada topik. Bikin baru lewat tombol New.',
                  style: TextStyle(color: ScribblrColors.muted, fontSize: 13),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map<Widget>((c) {
                    final id = idOf((c as Map)['id']);
                    final selected = selectedCategory == id;
                    return FilterChip(
                      label: Text(strOf(c, 'name')),
                      selected: selected,
                      onSelected: (_) => setState(() {
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
                text: isUploading
                    ? 'Uploading image...'
                    : (selectedStatus == 'draft' ? 'Save Draft' : 'Publish'),
                loading: isSaving,
                onPressed: isSaving ? null : addPost,
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
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: coverController,
      builder: (context, value, _) {
        final url = value.text.trim();
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
      },
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
        onTap: isSaving ? null : () => setState(() => selectedStatus = value),
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
