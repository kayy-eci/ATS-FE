import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontendats/api.dart';
import 'package:frontendats/api_client.dart';
import 'package:frontendats/detailpost.dart';
import 'package:frontendats/posts_refresh.dart';
import 'package:frontendats/writly_theme.dart';
import 'package:frontendats/writly_widgets.dart';

class DiscoverPage extends StatefulWidget {
  final String username;
  const DiscoverPage({super.key, this.username = ''});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  List<dynamic> posts = [];
  List<dynamic> categories = [];
  bool isLoading = false;

  final Set<String> selectedIds = {};
  final searchController = TextEditingController();
  String query = '';
  int _seenVersion = -1;
  bool _catSaving = false;

  String categoryName(dynamic id) => catNameOf(categories, id);

  int categoryUsage(String id) {
    var usageCount = 0;
    for (final postItem in posts) {
      if (postItem is Map && postCategoryIds(postItem).contains(id))
        usageCount++;
    }
    return usageCount;
  }

  Future<void> fetchDiscoverData() async {
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

            final alive = categories
                .whereType<Map>()
                .map((categoryItem) => categoryItem['id']?.toString() ?? '')
                .toSet();
            selectedIds.retainWhere(alive.contains);
          });
        } catch (_) {}
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),
      );
    }
  }

  Future<void> openManageCategory(Map cat) async {
    final id = cat['id']?.toString() ?? '';
    if (id.isEmpty) return;
    final name = strOf(cat, 'name');
    final used = categoryUsage(id);

    await showModalBottomSheet(
      context: context,
      backgroundColor: WritlyColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: WritlyColors.line,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        'assets/logokpi.png',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 44,
                          height: 44,
                          color: WritlyColors.chipBg,
                          child: const Icon(
                            Icons.label_outline,
                            color: WritlyColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name.isEmpty ? 'Tanpa nama' : name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: WritlyColors.ink,
                            ),
                          ),
                          Text(
                            used == 0
                                ? 'Belum dipakai artikel'
                                : 'Dipakai $used artikel',
                            style: const TextStyle(
                              fontSize: 12,
                              color: WritlyColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          openEditCategory(cat);
                        },
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          confirmDeleteCategory(cat, used);
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.redAccent,
                        ),
                        label: const Text(
                          'Hapus',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> openEditCategory(Map cat) async {
    final id = cat['id']?.toString() ?? '';
    if (id.isEmpty) return;
    final nameController = TextEditingController(text: strOf(cat, 'name'));
    final descController = TextEditingController(
      text: strOf(cat, 'description'),
    );
    final formKey = GlobalKey<FormState>();

    final save = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: WritlyColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Edit Topic',
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
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(100, 44)),
              onPressed: () {
                if (formKey.currentState?.validate() != true) return;
                Navigator.pop(ctx, true);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (save != true || !mounted) return;

    final name = nameController.text.trim();
    var slug = makeCategorySlug(name);
    if (slug.isEmpty) slug = 'topic-$id';
    setState(() => _catSaving = true);
    try {
      final res = await http
          .put(
            Uri.parse('$baseUrl/categories/$id'),
            headers: authHeaders(),
            body: jsonEncode({
              'name': name,
              'slug': slug,
              'description': descController.text.trim().isEmpty
                  ? null
                  : descController.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 10));
      if (!mounted) return;
      if (await handleAuthError(context, res)) return;
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Topik diperbarui')));
        PostsRefresh.bump();
        await fetchDiscoverData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update topik: ${res.statusCode}')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),
      );
    } finally {
      if (mounted) setState(() => _catSaving = false);
    }
  }

  Future<void> confirmDeleteCategory(Map cat, int used) async {
    final id = cat['id']?.toString() ?? '';
    if (id.isEmpty) return;
    final name = strOf(cat, 'name');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: WritlyColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Topic',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Text(
            used == 0
                ? 'Hapus topik "$name"? Tindakan ini tidak bisa dibatalkan.'
                : 'Topik "$name" dipakai $used artikel. '
                      'Artikel tersebut akan kehilangan kategori ini. '
                      'Tetap hapus?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(110, 44),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Yes, Delete'),
            ),
          ],
        );
      },
    );
    if (ok != true || !mounted) return;
    setState(() => _catSaving = true);
    try {
      final res = await http
          .delete(Uri.parse('$baseUrl/categories/$id'), headers: authHeaders())
          .timeout(const Duration(seconds: 10));
      if (!mounted) return;
      if (await handleAuthError(context, res)) return;
      if (res.statusCode == 200 || res.statusCode == 204) {
        setState(() => selectedIds.remove(id));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Topik dihapus')));
        PostsRefresh.bump();
        await fetchDiscoverData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal hapus topik: ${res.statusCode}')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa terhubung ke server: $error')),
      );
    } finally {
      if (mounted) setState(() => _catSaving = false);
    }
  }

  void _onRefreshBus() {
    if (PostsRefresh.notifier.value != _seenVersion) {
      _seenVersion = PostsRefresh.notifier.value;
      fetchDiscoverData();
    }
  }

  @override
  void initState() {
    super.initState();
    _seenVersion = PostsRefresh.notifier.value;
    PostsRefresh.notifier.addListener(_onRefreshBus);
    fetchDiscoverData();
  }

  @override
  void dispose() {
    PostsRefresh.notifier.removeListener(_onRefreshBus);
    searchController.dispose();
    super.dispose();
  }

  Widget _catAvatar(bool selected) {
    return CircleAvatar(
      radius: 11,
      backgroundColor: selected ? Colors.white24 : WritlyColors.chipBg,
      backgroundImage: const AssetImage('assets/logokpi.png'),
      onBackgroundImageError: (_, _) {},
      child: const SizedBox.shrink(),
    );
  }

  Widget _topicChip(Map categoryItem) {
    final id = categoryItem['id']?.toString() ?? '';
    final selected = selectedIds.contains(id);

    return GestureDetector(
      onLongPress: () => openManageCategory(categoryItem),
      child: FilterChip(
        label: Text(strOf(categoryItem, 'name')),
        avatar: _catAvatar(selected),
        selected: selected,
        onSelected: (_) => setState(() {
          if (selected) {
            selectedIds.remove(id);
          } else {
            selectedIds.add(id);
          }
        }),
        selectedColor: WritlyColors.primary,
        labelStyle: TextStyle(
          color: selected ? Colors.white : WritlyColors.ink,
          fontWeight: FontWeight.w600,
        ),
        shape: const StadiumBorder(
          side: BorderSide(color: WritlyColors.line),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = query.trim().toLowerCase();
    final filtered = posts.where((postItem) {
      if (postItem is! Map) return false;

      if (selectedIds.isNotEmpty) {
        final ids = postCategoryIds(postItem);
        if (ids.intersection(selectedIds).isEmpty) return false;
      }
      if (normalizedQuery.isNotEmpty &&
          !strOf(postItem, 'title').toLowerCase().contains(normalizedQuery)) {
        return false;
      }
      return true;
    }).toList();

    final selectionLabel = selectedIds.isEmpty
        ? 'All Articles (${filtered.length})'
        : selectedIds.length == 1
        ? '${categoryName(selectedIds.first)} (${filtered.length})'
        : '${selectedIds.length} topik (${filtered.length})';

    return Scaffold(
      body: SafeArea(
        child: isLoading || _catSaving
            ? const Center(
                child: CircularProgressIndicator(color: WritlyColors.primary),
              )
            : RefreshIndicator(
                color: WritlyColors.primary,
                onRefresh: fetchDiscoverData,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  children: [
                    const WritlyHeader(
                      title: 'Discover',
                      subtitle: 'Browse topics and articles.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      onChanged: (value) => setState(() => query = value),
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
                    Row(
                      children: [
                        const Text(
                          'Explore by Topics',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: WritlyColors.ink,
                          ),
                        ),
                        const Spacer(),
                        if (selectedIds.isNotEmpty)
                          TextButton(
                            onPressed: () =>
                                setState(() => selectedIds.clear()),
                            child: Text('Clear (${selectedIds.length})'),
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
                          'Tap untuk filter banyak, tahan lama untuk kelola.',
                          style: TextStyle(
                            fontSize: 12,
                            color: WritlyColors.muted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (categories.isEmpty)
                      const Text(
                        'Belum ada kategori.',
                        style: TextStyle(color: WritlyColors.muted),
                      )
                    else
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: const Text('All'),
                              selected: selectedIds.isEmpty,
                              onSelected: (_) =>
                                  setState(() => selectedIds.clear()),
                            ),
                            const SizedBox(width: 8),
                            ...categories.map((categoryItem) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _topicChip(categoryItem as Map),
                              );
                            }),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text(
                      selectionLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: WritlyColors.ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            normalizedQuery.isNotEmpty
                                ? 'Tidak ketemu artikel berjudul "$query".'
                                : 'Tidak ada artikel di kategori ini.',
                            style: const TextStyle(color: WritlyColors.muted),
                          ),
                        ),
                      )
                    else
                      ...filtered.map(
                        (postItem) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: WritlyCard(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPostPage(
                                    post: postItem,
                                    category: categoryName(
                                      primaryCategoryId(postItem),
                                    ),
                                    categories: categories,
                                    currentUsername: widget.username,
                                  ),
                                ),
                              ).then((ok) {
                                if (ok == true) fetchDiscoverData();
                              });
                            },
                            child: Row(
                              children: [
                                WritlyThumb(
                                  cover: (postItem as Map)['cover_image'],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        categoryLabelOf(
                                          categories,
                                          postItem,
                                        ).toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: WritlyColors.primary,
                                          letterSpacing: 0.8,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        strOf(postItem, 'title'),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: WritlyColors.ink,
                                          height: 1.35,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        strOf(postItem, 'author'),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: WritlyColors.muted,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: WritlyColors.muted,
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
