import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontendats/api.dart';
import 'package:frontendats/api_client.dart';
import 'package:frontendats/detailpost.dart';
import 'package:frontendats/editpost.dart';
import 'package:frontendats/posts_refresh.dart';
import 'package:frontendats/scribblr_theme.dart';
import 'package:frontendats/scribblr_widgets.dart';

// My Article: list artikel milik user (filter client-side author == username,
// case-insensitive, karena backend tidak punya owner/user_id).
// Tab Draft & Published memakai field status yang memang ada di model.
// Aksi Edit -> form edit, Delete -> konfirmasi + DELETE /posts/:id.
class MyArticlesPage extends StatefulWidget {
  final String username;
  const MyArticlesPage({super.key, this.username = ''});

  @override
  State<MyArticlesPage> createState() => _MyArticlesPageState();
}

class _MyArticlesPageState extends State<MyArticlesPage> {
  List posts = [];
  List categories = [];
  bool isLoading = false;
  String tab = 'published';
  int _seenVersion = -1;

  String categoryName(dynamic id) => catNameOf(categories, id);

  Future<void> getPosts() async {
    setState(() => isLoading = true);
    try {
      final postRes = await http
          .get(Uri.parse('$baseUrl/posts'), headers: authHeaders())
          .timeout(const Duration(seconds: 10));
      final catRes = await http
          .get(Uri.parse('$baseUrl/categories'), headers: authHeaders())
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;
      setState(() => isLoading = false);
      if (isUnauthorized(postRes) || isUnauthorized(catRes)) {
        await handleAuthError(
          context,
          postRes.statusCode == 401 || postRes.statusCode == 403
              ? postRes
              : catRes,
        );
        return;
      }
      if (postRes.statusCode == 200) {
        try {
          final body = jsonDecode(postRes.body);
          final list = (body is Map ? body['data'] : null) ?? [];
          setState(() {
            posts = list is List ? list : [];
          });
        } catch (_) {}
      }
      if (catRes.statusCode == 200) {
        try {
          final body = jsonDecode(catRes.body);
          final list = (body is Map ? body['data'] : null) ?? [];
          setState(() {
            categories = list is List ? list : [];
          });
        } catch (_) {}
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa terhubung ke server: $e')),
      );
    }
  }

  Future<void> deletePost(dynamic rawId) async {
    final id = rawId?.toString() ?? '';
    if (id.isEmpty) return;
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
          posts.removeWhere((post) => post is Map && post['id']?.toString() == id);
        });
        PostsRefresh.bump();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: ${data.statusCode}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa terhubung ke server: $e')),
      );
    }
  }

  void _onRefreshBus() {
    if (PostsRefresh.notifier.value != _seenVersion) {
      _seenVersion = PostsRefresh.notifier.value;
      getPosts();
    }
  }

  @override
  void initState() {
    super.initState();
    _seenVersion = PostsRefresh.notifier.value;
    PostsRefresh.notifier.addListener(_onRefreshBus);
    getPosts();
  }

  @override
  void dispose() {
    PostsRefresh.notifier.removeListener(_onRefreshBus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myPosts = posts
        .where((p) => p is Map && isMine(p, widget.username))
        .toList();
    final mine = myPosts
        .where((p) {
          final st = strOf(p, 'status');
          return (st.isEmpty ? 'published' : st) == tab;
        })
        .toList();
    final draftCount = myPosts
        .where((p) => strOf(p, 'status') == 'draft')
        .length;
    final pubCount = myPosts
        .where((p) {
          final st = strOf(p, 'status');
          return st.isEmpty || st == 'published';
        })
        .length;

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: ScribblrColors.primary,
                ),
              )
            : RefreshIndicator(
                color: ScribblrColors.primary,
                onRefresh: getPosts,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  children: [
                    ScribblrHeader(
                      title: 'My Articles',
                      subtitle:
                          '$pubCount Published  \u2022  $draftCount Drafts',
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: ScribblrColors.chipBg,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          _tabButton('published', 'Published'),
                          _tabButton('draft', 'Draft'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (mine.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Text(
                            'Belum ada artikel di tab ini.',
                            style: TextStyle(color: ScribblrColors.muted),
                          ),
                        ),
                      )
                    else
                      ...mine.map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ScribblrCard(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPostPage(
                                    post: p,
                                    category: categoryName(
                                      p['category_id'],
                                    ),
                                    categories: categories,
                                    currentUsername: widget.username,
                                  ),
                                ),
                              ).then((ok) {
                                if (ok == true) getPosts();
                              });
                            },
                            child: Row(
                              children: [
                                ScribblrThumb(cover: p['cover_image']),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        strOf(p, 'title'),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: ScribblrColors.ink,
                                          height: 1.35,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditPostPage(
                                                    post: p,
                                                    categories: categories,
                                                    currentUsername:
                                                        widget.username,
                                                  ),
                                                ),
                                              ).then((ok) {
                                                if (ok == true) getPosts();
                                              });
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  Icons.edit_outlined,
                                                  size: 15,
                                                  color:
                                                      ScribblrColors.primary,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: ScribblrColors
                                                        .primary,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          InkWell(
                                            onTap: () async {
                                              final ok =
                                                  await confirmDeleteArticle(
                                                context,
                                              );
                                              if (!ok) return;
                                              deletePost(p['id']);
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  Icons.delete_outline,
                                                  size: 15,
                                                  color: Colors.redAccent,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.redAccent,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _tabButton(String value, String label) {
    final active = tab == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tab = value),
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
