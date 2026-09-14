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

class EditPostPage extends StatefulWidget {
  final Map post;
  final List<dynamic> categories;
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
  late final titleController = TextEditingController(
    text: strOf(widget.post, 'title'),
  );
  late final contentController = TextEditingController(
    text: strOf(widget.post, 'content'),
  );
  late final excerptController = TextEditingController(
    text: strOf(widget.post, 'excerpt'),
  );
  late final authorController = TextEditingController(
    text: strOf(widget.post, 'author'),
  );
  List<dynamic> categories = [];

  final Set<int> selectedCategories = {};
  String? categoryError;
  late String selectedStatus;
  bool isSaving = false;
  bool isLoadingCats = false;

  XFile? _pickedCover;
  Uint8List? _pickedBytes;

  bool get _isMine =>
      widget.currentUsername.isEmpty ||
      isMine(widget.post, widget.currentUsername);

  @override
  void initState() {
    super.initState();
    categories = widget.categories;

    for (final categoryIdText in postCategoryIds(widget.post)) {
      final id = int.tryParse(categoryIdText);
      if (id != null) selectedCategories.add(id);
    }
    final statusValue = strOf(widget.post, 'status');
    selectedStatus = statusValue.isEmpty ? 'published' : statusValue;

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
    } catch (error) {
      debugPrint('fetchCategories error: $error');
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
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $error')));
    }
  }

  Future<void> updatePost() async {
    FocusScope.of(context).unfocus();
    if (!_isMine) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kamu hanya bisa mengedit artikelmu sendiri'),
        ),
      );
      return;
    }
    final valid = _formKey.currentState?.validate() ?? false;
    if (selectedCategories.isEmpty) {
      setState(() => categoryError = 'Kategori belum dipilih');
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
      final postId = strOf(widget.post, 'id');
      if (postId.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('ID artikel tidak valid')));
        return;
      }

      Map<String, String> buildFields() {
        final catList = selectedCategories.toList();
        final fields = <String, String>{
          'title': titleController.text.trim(),
          'slug': slug,
          'content': contentController.text,
          'category_id': catList.first.toString(),
          'category_ids': jsonEncode(catList),
          'status': selectedStatus,
        };
        if (excerptController.text.isNotEmpty) {
          fields['excerpt'] = excerptController.text;
        }

        if (authorController.text.trim().isNotEmpty) {
          fields['author'] = authorController.text.trim();
        }
        return fields;
      }

      MediaType guessImageType(String filename) {
        final lower = filename.toLowerCase();
        if (lower.endsWith('.png')) return MediaType('image', 'png');
        if (lower.endsWith('.webp')) return MediaType('image', 'webp');
        if (lower.endsWith('.gif')) return MediaType('image', 'gif');
        return MediaType('image', 'jpeg');
      }

      void attachFile(http.MultipartRequest request) {
        final picked = _pickedCover;
        final bytes = _pickedBytes;

        if (picked != null && bytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'cover_image',
              bytes,
              filename: picked.name.isEmpty ? 'cover.jpg' : picked.name,
              contentType: guessImageType(picked.name),
            ),
          );
        }
      }

      Future<http.Response> sendJsonPut() async {
        final catList = selectedCategories.toList();
        return http
            .put(
              Uri.parse('$baseUrl/posts/$postId'),
              headers: authHeaders(),
              body: jsonEncode({
                'title': titleController.text.trim(),
                'slug': slug,
                'content': contentController.text,
                'excerpt': excerptController.text.isEmpty
                    ? null
                    : excerptController.text,
                'category_id': catList.first,
                'category_ids': catList,
                'author': authorController.text.trim().isEmpty
                    ? null
                    : authorController.text.trim(),
                'status': selectedStatus,
              }),
            )
            .timeout(const Duration(seconds: 10));
      }

      Future<http.Response> sendPutMultipart() async {
        final req = http.MultipartRequest(
          'PUT',
          Uri.parse('$baseUrl/posts/$postId'),
        )..headers.addAll(authOnlyHeaders());
        req.fields.addAll(buildFields());
        attachFile(req);
        final streamed = await req.send().timeout(const Duration(seconds: 20));
        return http.Response.fromStream(streamed);
      }

      Future<http.Response> sendPostSpoofedPut() async {
        final req = http.MultipartRequest(
          'POST',
          Uri.parse('$baseUrl/posts/$postId'),
        )..headers.addAll(authOnlyHeaders());
        req.fields['_method'] = 'PUT';
        req.fields.addAll(buildFields());
        attachFile(req);
        final streamed = await req.send().timeout(const Duration(seconds: 20));
        return http.Response.fromStream(streamed);
      }

      final hasNewImage = _pickedCover != null && _pickedBytes != null;
      http.Response response;
      if (!hasNewImage) {
        response = await sendJsonPut();
      } else {
        response = await sendPutMultipart();

        if (response.statusCode == 404 || response.statusCode == 405) {
          debugPrint(
            'PUT multipart ditolak (${response.statusCode}), coba POST + _method=PUT',
          );
          response = await sendPostSpoofedPut();
        }
      }

      if (!mounted) return;
      if (await handleAuthError(context, response)) return;

      if (response.statusCode == 200) {
        PostsRefresh.bump();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Berhasil memperbarui artikel: ${response.statusCode}',
            ),
          ),
        );
        Navigator.pop(context, true);
      } else {
        debugPrint(
          'PUT /posts/$postId gagal: ${response.statusCode} ${response.body}',
        );
        String msg = 'Gagal memperbarui artikel: ${response.statusCode}';
        try {
          final decodedBody = jsonDecode(response.body);
          if (decodedBody is Map) {
            if (decodedBody['message'] != null) {
              msg = '$msg - ${decodedBody['message']}';
            } else if (decodedBody['errors'] != null) {
              msg = '$msg - ${decodedBody['errors']}';
            } else if (decodedBody['error'] != null) {
              msg = '$msg - ${decodedBody['error']}';
            } else {
              msg = '$msg - ${response.body}';
            }
          } else {
            msg = '$msg - ${response.body}';
          }
        } catch (_) {
          if (response.body.isNotEmpty) {
            msg = '$msg - ${response.body}';
          }
        }
        if (msg.length > 500) msg = '${msg.substring(0, 500)}...';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), duration: const Duration(seconds: 6)),
        );
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
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Edit Article'),
      ),
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
              const WritlyLabel(text: 'Cover image (dari galeri)'),
              _coverPreview(),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: (!_isMine || isSaving) ? null : pickCover,
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: Text(
                      _pickedCover == null && _existingCover().isEmpty
                          ? 'Pilih gambar'
                          : 'Ganti gambar',
                    ),
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
                      label: const Text('Batalkan ganti'),
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
                enabled: _isMine,
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
                enabled: _isMine,
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
                enabled: _isMine,
              ),
              const SizedBox(height: 14),
              const WritlyLabel(text: 'Author (terkunci)'),
              TextFormField(
                controller: authorController,
                readOnly: true,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.lock_outline, size: 18),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Select Topics${selectedCategories.isEmpty ? '' : ' (${selectedCategories.length})'}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: WritlyColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Bisa pilih lebih dari 1 topik.',
                style: TextStyle(fontSize: 12, color: WritlyColors.muted),
              ),
              const SizedBox(height: 8),
              if (isLoadingCats)
                const Center(
                  child: CircularProgressIndicator(
                    color: WritlyColors.primary,
                  ),
                )
              else if (categories.isNotEmpty)
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
                      onSelected: !_isMine
                          ? null
                          : (_) {
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
                text: 'Save Changes',
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

  String _existingCover() => resolveCoverUrl(strOf(widget.post, 'cover_image'));

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
    final url = _existingCover();
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
        onTap: !_isMine ? null : () => setState(() => selectedStatus = value),
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
