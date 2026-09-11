import 'package:flutter/material.dart';
import 'package:frontendats/addpost.dart';
import 'package:frontendats/editpost.dart';
import 'package:frontendats/detailpost.dart';
import 'package:frontendats/api.dart';
import 'package:frontendats/api_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, this.username = ''});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List posts = [];
  List categories = [];
  bool isLoading = false;

  String categoryName(dynamic id) {
    for (final c in categories) {
      if (c['id'].toString() == id.toString()) {
        return c['name'].toString();
      }
    }
    return '';
  }

  Future<void> getPosts() async {
    setState(() => isLoading = true);

    try {
      // Backend protected: wajib Bearer token.
      final postRes = await http
          .get(Uri.parse('$baseUrl/posts'), headers: authHeaders())
          .timeout(const Duration(seconds: 10));
      final catRes = await http
          .get(Uri.parse('$baseUrl/categories'), headers: authHeaders())
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;
      setState(() => isLoading = false);

      if (isUnauthorized(postRes) || isUnauthorized(catRes)) {
        await handleAuthError(context, postRes.statusCode == 401 || postRes.statusCode == 403 ? postRes : catRes);
        return;
      }

      if (postRes.statusCode == 200) {
        final body = jsonDecode(postRes.body);
        setState(() {
          posts = body['data'] ?? [];
        });
      } else {
        debugPrint('data gagal di ambil: ${postRes.statusCode} ${postRes.body}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal ambil artikel: ${postRes.statusCode}')),
          );
        }
      }

      if (catRes.statusCode == 200) {
        final body = jsonDecode(catRes.body);
        setState(() {
          categories = body['data'] ?? [];
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa terhubung ke server')),
      );
    }
  }

  Future<void> deletePost(int id) async {
    try {
      final data = await http
          .delete(Uri.parse('$baseUrl/posts/$id'), headers: authHeaders())
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;
      if (await handleAuthError(context, data)) return;

      if (data.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Artikel berhasil dihapus: ${data.statusCode}')),
        );

        setState(() {
          posts.removeWhere((post) => post['id'] == id);
        });
      } else {
        debugPrint('Gagal menghapus artikel: ${data.statusCode} ${data.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: ${data.statusCode}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa terhubung ke server')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username.isEmpty ? 'Blog' : 'Blog - ${widget.username}'),
        actions: [
          IconButton(
            onPressed: () => forceLogout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: getPosts,
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final itemPost = posts[index];
                  final cat = categoryName(itemPost['category_id']);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPostPage(
                            post: itemPost,
                            category: cat,
                            categories: categories,
                          ),
                        ),
                      ).then((_) => getPosts());
                    },
                    child: ListTile(
                      title: Text(itemPost['title']?.toString() ?? ''),
                      subtitle: Text(
                        cat.isEmpty
                            ? (itemPost['excerpt']?.toString() ?? '')
                            : '$cat - ${itemPost['excerpt']?.toString() ?? ''}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPostPage(
                                    post: itemPost,
                                    categories: categories,
                                  ),
                                ),
                              ).then((_) => getPosts());
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              final rawId = itemPost['id'];
                              final id = int.tryParse(rawId.toString());
                              if (id != null) deletePost(id);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostPage()),
          ).then((_) => getPosts());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
