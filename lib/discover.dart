import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontendats/api.dart';
import 'package:frontendats/api_client.dart';
import 'package:frontendats/detailpost.dart';
import 'package:frontendats/posts_refresh.dart';
import 'package:frontendats/scribblr_theme.dart';
import 'package:frontendats/scribblr_widgets.dart';

// Discover: browse kategori (GET /categories) + list artikel per kategori.
// Filter artikel per kategori + search by title dilakukan client-side
// dari GET /posts. Tanpa endpoint/logic baru.
class DiscoverPage extends StatefulWidget {
  final String username;
  const DiscoverPage({super.key, this.username = ''});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  List posts = [];
  List categories = [];
  bool isLoading = false;
  String? selectedCategoryId;
  final searchController = TextEditingController();
  String query = '';
  int _seenVersion = -1;

  String categoryName(dynamic id) => catNameOf(categories, id);

  Future<void> getData() async {
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

  void _onRefreshBus() {
    if (PostsRefresh.notifier.value != _seenVersion) {
      _seenVersion = PostsRefresh.notifier.value;
      getData();
    }
  }

  @override
  void initState() {
    super.initState();
    _seenVersion = PostsRefresh.notifier.value;
    PostsRefresh.notifier.addListener(_onRefreshBus);
    getData();
  }

  @override
  void dispose() {
    PostsRefresh.notifier.removeListener(_onRefreshBus);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = query.trim().toLowerCase();
    final filtered = posts.where((p) {
      if (p is! Map) return false;
      if (selectedCategoryId != null &&
          (p['category_id']?.toString() ?? '') != selectedCategoryId) {
        return false;
      }
      if (q.isNotEmpty &&
          !strOf(p, 'title').toLowerCase().contains(q)) {
        return false;
      }
      return true;
    }).toList();

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
                onRefresh: getData,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  children: [
                    const ScribblrHeader(
                      title: 'Discover',
                      subtitle: 'Browse topics and articles.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      onChanged: (v) => setState(() => query = v),
                      decoration: InputDecoration(
                        hintText: 'Search by title...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: query.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  setState(() => query = '');
                                },
                                icon: const Icon(Icons.close),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Explore by Topics',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: ScribblrColors.ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (categories.isEmpty)
                      const Text(
                        'Belum ada kategori.',
                        style: TextStyle(color: ScribblrColors.muted),
                      )
                    else
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: const Text('All'),
                              selected: selectedCategoryId == null,
                              onSelected: (_) =>
                                  setState(() => selectedCategoryId = null),
                            ),
                            const SizedBox(width: 8),
                            ...categories.map((c) {
                              final id = (c as Map)['id']?.toString();
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(strOf(c, 'name')),
                                  selected: selectedCategoryId == id,
                                  // Tap chip aktif = kembali ke All.
                                  onSelected: (selected) => setState(() {
                                    if (!selected ||
                                        selectedCategoryId == id) {
                                      selectedCategoryId = null;
                                    } else {
                                      selectedCategoryId = id;
                                    }
                                  }),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text(
                      selectedCategoryId == null
                          ? 'All Articles (${filtered.length})'
                          : '${categoryName(selectedCategoryId)} (${filtered.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: ScribblrColors.ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            q.isNotEmpty
                                ? 'Tidak ketemu artikel berjudul "$query".'
                                : 'Tidak ada artikel di kategori ini.',
                            style:
                                const TextStyle(color: ScribblrColors.muted),
                          ),
                        ),
                      )
                    else
                      ...filtered.map(
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
                                if (ok == true) getData();
                              });
                            },
                            child: Row(
                              children: [
                                ScribblrThumb(cover: (p as Map)['cover_image']),
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
                                      const SizedBox(height: 4),
                                      Text(
                                        strOf(p, 'author'),
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
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
