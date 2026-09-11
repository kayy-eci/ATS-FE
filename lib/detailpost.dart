import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontendats/api.dart';
import 'package:frontendats/api_client.dart';
import 'package:frontendats/editpost.dart';

class DetailPostPage extends StatefulWidget {
  final Map post;
  final String category;
  final List categories;
  const DetailPostPage({super.key, required this.post, this.category = '', this.categories = const []});

  @override
  State<DetailPostPage> createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  bool isSaving = false;

  Future<void> deletePost() async {
    setState(() => isSaving = true);

    try {
      final data = await http
          .delete(
            Uri.parse('$baseUrl/posts/${widget.post['id']}'),
            headers: authHeaders(),
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;
      setState(() => isSaving = false);
      if (await handleAuthError(context, data)) return;

      if (data.statusCode == 200) {
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
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa terhubung ke server')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Artikel'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Teruskan categories agar dropdown edit tidak kosong.
                  builder: (context) => EditPostPage(
                    post: post,
                    categories: widget.categories,
                  ),
                ),
              ).then((ok) {
                if (ok == true && mounted) Navigator.pop(context, true);
              });
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: isSaving ? null : deletePost,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              post['title']?.toString() ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.category.isEmpty ? '' : '${widget.category} - '}${post['author']?.toString() ?? ''}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(post['content']?.toString() ?? ''),
          ],
        ),
      ),
    );
  }
}
