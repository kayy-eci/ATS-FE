import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontendats/api.dart';
import 'package:frontendats/editpost.dart';

class DetailPostPage extends StatefulWidget {
  final Map post;
  final String category;
  const DetailPostPage({super.key, required this.post, this.category = ''});

  @override
  State<DetailPostPage> createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  bool isSaving = false;

  Future<void> deletePost() async {
    setState(() => isSaving = true);

    final data = await http.delete(
      Uri.parse('$baseUrl/posts/${widget.post['id']}'),
    );

    setState(() => isSaving = false);

    if (data.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Artikel berhasil dihapus: ${data.statusCode}')),
      );
      Navigator.pop(context, true);
    } else {
      print('Gagal menghapus artikel: ${data.statusCode}');
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
                  builder: (context) => EditPostPage(post: post),
                ),
              ).then((ok) {
                if (ok == true) Navigator.pop(context, true);
              });
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: isSaving ? null : deletePost,
            icon: Icon(Icons.delete),
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
