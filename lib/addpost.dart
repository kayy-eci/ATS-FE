import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:frontendats/api.dart';
import 'package:frontendats/api_client.dart';
import 'package:frontendats/posts_refresh.dart';
import 'package:frontendats/writly_theme.dart';
import 'package:frontendats/writly_widgets.dart';

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
  late final authorController = TextEditingController(text: widget.username);
  List<dynamic> categories = [];

  final Set<int> selectedCategories = {};
  String? categoryError;
  String selectedStatus = 'published';
  bool isSaving = false;

  XFile? _pickedCover;
  Uint8List? _pickedBytes;

  Future<void> fetchCategories() async {
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
          if (categories.isNotEmpty && selectedCategories.isEmpty) {
            final first = idOf(categories[0]['id']);
            if (first != null) selectedCategories.add(first);
          }
          categoryError = null;
        });
      } else {
        debugPrint('Gagal mengambil data: ${data.statusCode}');
      }
    } catch (error) {
      debugPrint('fetchCategories error: $error');
    }
  }

  Future<void> createCategoryInline() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final created = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: WritlyColors.surface,
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
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Wajib diisi'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(
                    hintText: 'Description (opsional)',
                  ),
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
              style: ElevatedButton.styleFrom(minimumSize: const Size(100, 44)),
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
    final slug = makeCategorySlug(name);
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Topik baru tersimpan')));
        await fetchCategories();

        for (final categoryItem in categories) {
          if (strOf(categoryItem, 'name') == name) {
            final id = idOf((categoryItem as Map)['id']);
            if (id != null) {
              setState(() {
                selectedCategories.add(id);
                categoryError = null;
              });
            }
            break;
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal bikin topik: ${res.statusCode}')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),
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
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $error')));
    }
  }

  void clearPickedCover() {
    setState(() {
      _pickedCover = null;
      _pickedBytes = null;
    });
  }

  MediaType _guessImageType(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.png')) return MediaType('image', 'png');
    if (lower.endsWith('.webp')) return MediaType('image', 'webp');
    if (lower.endsWith('.gif')) return MediaType('image', 'gif');
    return MediaType('image', 'jpeg');
  }

  void _showSaveError(int status, String body) {
    debugPrint('POST /posts gagal: $status $body');
    String msg = 'Gagal menyimpan artikel: $status';
    try {
      final decodedBody = jsonDecode(body);
      if (decodedBody is Map) {
        if (decodedBody['message'] != null) {
          msg = '$msg - ${decodedBody['message']}';
        } else if (decodedBody['errors'] != null) {
          msg = '$msg - ${decodedBody['errors']}';
        } else if (decodedBody['error'] != null) {
          msg = '$msg - ${decodedBody['error']}';
        } else {
          msg = '$msg - $body';
        }
      } else {
        msg = '$msg - $body';
      }
    } catch (_) {
      if (body.isNotEmpty) msg = '$msg - $body';
    }
    if (msg.length > 500) msg = '${msg.substring(0, 500)}...';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 6)),
    );
  }

  Future<void> addPost() async {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState?.validate() ?? false;
    if (selectedCategories.isEmpty) {
      setState(() => categoryError = 'Pilih minimal 1 kategori');
    }
    if (!valid || selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Periksa lagi isian yang ditandai')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      var slug = makeCategorySlug(titleController.text);
      if (slug.isEmpty) {
        slug = 'post-${DateTime.now().millisecondsSinceEpoch}';
      }

      final author = authorController.text.trim().isEmpty
          ? (widget.username.trim().isEmpty ? null : widget.username.trim())
          : authorController.text.trim();
      final hasImage = _pickedCover != null && _pickedBytes != null;
      final excerpt = excerptController.text.isEmpty
          ? null
          : excerptController.text;

      final catList = selectedCategories.toList();
      final primaryCat = catList.first;

      http.Response response;
      if (!hasImage) {
        response = await http
            .post(
              Uri.parse('$baseUrl/posts'),
              headers: authHeaders(),
              body: jsonEncode({
                'title': titleController.text.trim(),
                'slug': slug,
                'content': contentController.text,
                'excerpt': excerpt,
                'category_id': primaryCat,
                'category_ids': catList,
                'author': author,
                'status': selectedStatus,
              }),
            )
            .timeout(const Duration(seconds: 10));
      } else {
        final req = http.MultipartRequest('POST', Uri.parse('$baseUrl/posts'))
          ..headers.addAll(authOnlyHeaders());
        req.fields['title'] = titleController.text.trim();
        req.fields['slug'] = slug;
        req.fields['content'] = contentController.text;
        if (excerpt != null) req.fields['excerpt'] = excerpt;
        req.fields['category_id'] = primaryCat.toString();
        req.fields['category_ids'] = jsonEncode(catList);
        if (author != null && author.isNotEmpty) {
          req.fields['author'] = author;
        }
        req.fields['status'] = selectedStatus;

        final picked = _pickedCover!;
        req.files.add(
          http.MultipartFile.fromBytes(
            'cover_image',
            _pickedBytes!,
            filename: picked.name.isEmpty ? 'cover.jpg' : picked.name,
            contentType: _guessImageType(picked.name),
          ),
        );

        final streamed = await req.send().timeout(const Duration(seconds: 20));
        response = await http.Response.fromStream(streamed);
      }

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
          _formKey.currentState?.reset();
          titleController.clear();
          contentController.clear();
          excerptController.clear();
          clearPickedCover();
          widget.onSaved?.call();
        } else {
          Navigator.pop(context, true);
        }
      } else {
        _showSaveError(response.statusCode, response.body);
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
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
                  color: WritlyColors.chipBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  selectedStatus == 'draft' ? 'Draft' : 'Publish',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: WritlyColors.primary,
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
              const WritlyLabel(text: 'Cover image (opsional, dari galeri)'),
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
              if (_pickedCover != null)
                Text(
                  _pickedCover!.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: WritlyColors.muted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 14),
              const WritlyLabel(text: 'Title'),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Article title'),
                validator: (value) {
                  if ((value ?? '').trim().length < 3) {
                    return 'Judul minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              const WritlyLabel(text: 'Article'),
              TextFormField(
                controller: contentController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Tell your story...',
                ),
                validator: (value) {
                  if ((value ?? '').trim().length < 10) {
                    return 'Isi artikel minimal 10 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              const WritlyLabel(text: 'Excerpt'),
              TextFormField(
                controller: excerptController,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'Short summary...'),
              ),
              const SizedBox(height: 14),
              const WritlyLabel(text: 'Author (akun kamu, terkunci)'),
              TextFormField(
                controller: authorController,
                readOnly: authorLocked,
                decoration: InputDecoration(
                  hintText: 'Your name',
                  suffixIcon: authorLocked
                      ? const Icon(Icons.lock_outline, size: 18)
                      : null,
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty &&
                      widget.username.trim().isEmpty) {
                    return 'Author wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    'Select Topics${selectedCategories.isEmpty ? '' : ' (${selectedCategories.length})'}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: WritlyColors.ink,
                    ),
                  ),
                  const Spacer(),
                  if (selectedCategories.isNotEmpty)
                    TextButton(
                      onPressed: isSaving
                          ? null
                          : () => setState(() {
                              selectedCategories.clear();
                              categoryError = null;
                            }),
                      child: const Text('Clear'),
                    ),
                  TextButton.icon(
                    onPressed: isSaving ? null : createCategoryInline,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('New'),
                  ),
                ],
              ),
              const Row(
                children: [
                  Icon(
                    Icons.touch_app_outlined,
                    size: 14,
                    color: WritlyColors.muted,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Bisa pilih lebih dari 1 topik.',
                    style: TextStyle(fontSize: 12, color: WritlyColors.muted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (categories.isEmpty)
                const Text(
                  'Belum ada topik. Bikin baru lewat tombol New.',
                  style: TextStyle(color: WritlyColors.muted, fontSize: 13),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map<Widget>((categoryItem) {
                    final id = idOf((categoryItem as Map)['id']);
                    final selected =
                        id != null && selectedCategories.contains(id);
                    return FilterChip(
                      label: Text(strOf(categoryItem, 'name')),
                      avatar: CircleAvatar(
                        radius: 11,
                        backgroundColor: selected
                            ? Colors.white24
                            : WritlyColors.chipBg,
                        backgroundImage: const AssetImage('assets/logokpi.png'),
                        onBackgroundImageError: (_, _) {},
                        child: const SizedBox.shrink(),
                      ),
                      selected: selected,
                      onSelected: (_) {
                        if (id == null) return;
                        setState(() {
                          if (selected) {
                            selectedCategories.remove(id);
                          } else {
                            selectedCategories.add(id);
                          }
                          categoryError = null;
                        });
                      },
                      selectedColor: WritlyColors.primary,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : WritlyColors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: const StadiumBorder(
                        side: BorderSide(color: WritlyColors.line),
                      ),
                    );
                  }).toList(),
                ),
              if (categoryError != null) ...[
                const SizedBox(height: 6),
                Text(
                  categoryError!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ],
              const SizedBox(height: 18),
              const WritlyLabel(text: 'Status'),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: WritlyColors.chipBg,
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
              WritlyPrimaryButton(
                text: selectedStatus == 'draft' ? 'Save Draft' : 'Publish',
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
    return _coverPlaceholder();
  }

  Widget _coverPlaceholder() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: WritlyColors.placeholderBg,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 40,
        color: WritlyColors.primary,
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
            color: active ? WritlyColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: active ? WritlyColors.primary : WritlyColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}
