import 'package:flutter/material.dart';
import 'package:frontendats/detailpost.dart';
import 'package:frontendats/api.dart';
import 'package:frontendats/api_client.dart';
import 'package:frontendats/posts_refresh.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontendats/scribblr_theme.dart';
import 'package:frontendats/scribblr_widgets.dart';

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
  int _seenVersion = -1;

  String categoryName(dynamic id) => catNameOf(categories, id);

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
        try {
          final body = jsonDecode(postRes.body);
          final list = (body is Map ? body['data'] : null) ?? [];
          setState(() {
            posts = list is List ? list : [];
          });
        } catch (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Respon server tidak valid')),
            );
          }
        }
      } else {
        debugPrint('data gagal di ambil: ${postRes.statusCode} ${postRes.body}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal ambil artikel: ${postRes.statusCode}')),
          );
        }
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

  void openDetail(Map post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPostPage(
          post: post,
          category: categoryName(post['category_id']),
          categories: categories,
          currentUsername: widget.username,
        ),
      ),
    ).then((ok) {
      if (ok == true) getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final published = posts
        .where((p) => p is Map && (strOf(p, 'status').isEmpty || strOf(p, 'status') == 'published'))
        .toList();
    final featured = published.isNotEmpty ? published.first as Map : null;
    final recent = published.length > 1
        ? published.sublist(1, published.length > 6 ? 6 : published.length)
        : <dynamic>[];

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
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Writly',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: ScribblrColors.ink,
                                ),
                              ),
                              Text(
                                widget.username.isEmpty
                                    ? 'Welcome back!'
                                    : 'Welcome back, ${widget.username}!',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: ScribblrColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: ScribblrColors.chipBg,
                          child: Text(
                            widget.username.isEmpty
                                ? 'S'
                                : widget.username[0].toUpperCase(),
                            style: const TextStyle(
                              color: ScribblrColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (featured != null) ...[
                      GestureDetector(
                        onTap: () => openDetail(
                          Map<String, dynamic>.from(featured),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: ScribblrColors.primary,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryName(featured['category_id']).isEmpty
                                    ? 'Featured'
                                    : categoryName(
                                        featured['category_id'],
                                      ).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white70,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                strOf(featured, 'title'),
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.3,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _metaLine(featured),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                    ],
                    const Text(
                      'Recent Articles',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: ScribblrColors.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (published.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Text(
                            'Belum ada artikel.',
                            style: TextStyle(color: ScribblrColors.muted),
                          ),
                        ),
                      )
                    else if (recent.isEmpty && featured != null)
                      _articleTile(featured)
                    else
                      ...recent.map((p) => _articleTile(p)),
                    const SizedBox(height: 12),
                    const Text(
                      'Your Articles',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: ScribblrColors.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...posts
                        .where(
                          (p) => p is Map && isMine(p, widget.username),
                        )
                        .take(3)
                        .map((p) => _articleTile(p)),
                  ],
                ),
              ),
      ),
    );
  }

  String _metaLine(Map post) {
    final author = strOf(post, 'author');
    final cat = categoryName(post['category_id']);
    final parts = <String>[
      if (cat.isNotEmpty) cat,
      if (author.isNotEmpty) author,
    ];
    return parts.join('  \u2022  ');
  }

  Widget _articleTile(Map post) {
    final cat = categoryName(post['category_id']);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ScribblrCard(
        onTap: () => openDetail(Map<String, dynamic>.from(post)),
        child: Row(
          children: [
            ScribblrThumb(cover: post['cover_image']),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cat.isNotEmpty)
                    Text(
                      cat.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: ScribblrColors.primary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    strOf(post, 'title'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ScribblrColors.ink,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _metaLine(post),
                    style: const TextStyle(
                      fontSize: 11,
                      color: ScribblrColors.muted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: ScribblrColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}
