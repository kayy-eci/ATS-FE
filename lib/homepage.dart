import 'package:flutter/material.dart';
import 'package:frontendats/addpost.dart';
import 'package:frontendats/editpost.dart';
import 'package:frontendats/detailpost.dart';
import 'package:frontendats/login.dart';
import 'package:frontendats/api.dart';
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

    final postRes = await http.get(Uri.parse('$baseUrl/posts'));
    final catRes = await http.get(Uri.parse('$baseUrl/categories'));

    setState(() => isLoading = false);

    if (postRes.statusCode == 200) {
      final body = jsonDecode(postRes.body);
      setState(() {
        posts = body['data'] ?? [];
      });
    } else {
      print('data gagal di ambil');
    }

    if (catRes.statusCode == 200) {
      final body = jsonDecode(catRes.body);
      setState(() {
        categories = body['data'] ?? [];
      });
    }
  }

  Future<void> deletePost(int id) async {
    final data = await http.delete(
      Uri.parse('$baseUrl/posts/$id'),
    );

    if (data.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Artikel berhasil dihapus: ${data.statusCode}')),
      );

      setState(() {
        posts.removeWhere((post) => post['id'] == id);
      });
    } else {
      print('Gagal menghapus artikel: ${data.statusCode}');
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
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              deletePost(itemPost['id']);
                            },
                            icon: Icon(Icons.delete),
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
            MaterialPageRoute(builder: (context) => AddPostPage()),
          ).then((_) => getPosts());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
