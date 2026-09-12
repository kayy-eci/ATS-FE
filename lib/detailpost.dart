import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontendats/api.dart';
import 'package:frontendats/api_client.dart';
import 'package:frontendats/editpost.dart';
import 'package:frontendats/posts_refresh.dart';
import 'package:frontendats/scribblr_theme.dart';
import 'package:frontendats/scribblr_widgets.dart';

class DetailPostPage extends StatefulWidget {
  final Map post;
  final String category;
  final List categories;
  final String currentUsername;
  const DetailPostPage({
    super.key,
    required this.post,
    this.category = '',
    this.categories = const [],
    this.currentUsername = '',
  });

  @override
  State<DetailPostPage> createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  bool isSaving = false;

  bool get _isMine =>
      widget.currentUsername.isEmpty ||
      isMine(widget.post, widget.currentUsername);

  Future<void> deletePost() async {
    if (!_isMine) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamu hanya bisa menghapus artikelmu sendiri')),
      );
      return;
    }
    final postId = strOf(widget.post, 'id');
    if (postId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID artikel tidak valid')),
      );
      return;
    }
    setState(() => isSaving = true);

    try {
      final data = await http
          .delete(
            Uri.parse('$baseUrl/posts/$postId'),
            headers: authHeaders(),
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;
      if (await handleAuthError(context, data)) return;

      if (data.statusCode == 200) {
        PostsRefresh.bump();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Artikel berhasil dihapus: ${data.statusCode}')),
        );
        Navigator.pop(context, true);
      } else {
        debugPrint('Gagal menghapus artikel: ${data.statusCode} ${data.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: ${data.statusCode}')),
        );
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

  Future<void> askDelete() async {
    final ok = await confirmDeleteArticle(context);
    if (ok && mounted) deletePost();
  }

  void openEdit() {
    if (!_isMine) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamu hanya bisa mengedit artikelmu sendiri')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        // Teruskan categories agar dropdown edit tidak kosong.
        builder: (context) => EditPostPage(
          post: widget.post,
          categories: widget.categories,
          currentUsername: widget.currentUsername,
        ),
      ),
    ).then((ok) {
      if (ok == true && mounted) Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final cover = strOf(post, 'cover_image');
    final author = strOf(post, 'author');
    final date = strOf(post, 'created_at');
    final title = strOf(post, 'title');
    final excerpt = strOf(post, 'excerpt');
    final content = strOf(post, 'content');

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Article'),
        actions: [
          if (_isMine) ...[
            IconButton(
              onPressed: openEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: isSaving ? null : askDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          if (widget.category.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ScribblrColors.chipBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.category,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: ScribblrColors.primary,
                ),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            title.isEmpty ? '(Tanpa judul)' : title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.3,
              color: ScribblrColors.ink,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: ScribblrColors.chipBg,
                child: Icon(
                  Icons.person,
                  size: 16,
                  color: ScribblrColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  [if (author.isNotEmpty) author, if (date.isNotEmpty) date]
                      .join('  \u2022  '),
                  style: const TextStyle(
                    fontSize: 12,
                    color: ScribblrColors.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 200,
              color: ScribblrColors.placeholderBg,
              child: cover.isEmpty
                  ? const Icon(
                      Icons.image_outlined,
                      size: 44,
                      color: ScribblrColors.primary,
                    )
                  : Image.network(
                      cover,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.image_outlined,
                        size: 44,
                        color: ScribblrColors.primary,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          if (excerpt.isNotEmpty) ...[
            Text(
              excerpt,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: ScribblrColors.muted,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            content.isEmpty ? 'Tidak ada isi.' : content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.7,
              color: ScribblrColors.ink,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
