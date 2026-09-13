import 'package:flutter/foundation.dart';
import 'package:frontendats/api.dart';

class PostsRefresh {
  PostsRefresh._();
  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);

  static void bump() => notifier.value++;
}

String strOf(dynamic source, String key) {
  if (source is! Map) return '';
  final value = source[key];
  if (value == null) return '';
  return value.toString();
}

int? idOf(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

String catNameOf(List cats, dynamic id) {
  if (id == null) return '';
  final needle = id.toString();
  for (final categoryItem in cats) {
    if (categoryItem is Map && categoryItem['id']?.toString() == needle) {
      return categoryItem['name']?.toString() ?? '';
    }
  }
  return '';
}

Set<String> postCategoryIds(Map post) {
  final out = <String>{};
  void add(dynamic value) {
    if (value == null) return;
    final idText = value.toString().trim();
    if (idText.isNotEmpty && idText != 'null') out.add(idText);
  }

  add(post['category_id']);
  final ids = post['category_ids'];
  if (ids is List) {
    for (final value in ids) {
      if (value is Map) {
        add(value['id']);
      } else {
        add(value);
      }
    }
  }
  final cats = post['categories'];
  if (cats is List) {
    for (final value in cats) {
      if (value is Map) {
        add(value['id'] ?? value['category_id']);
      } else {
        add(value);
      }
    }
  }
  return out;
}

String primaryCategoryId(Map post) {
  final ids = postCategoryIds(post);
  return ids.isEmpty ? '' : ids.first;
}

String categoryLabelOf(List cats, Map post) {
  final ids = postCategoryIds(post).toList();
  if (ids.isEmpty) return '';
  final first = catNameOf(cats, ids.first);
  if (ids.length <= 1) return first;
  if (first.isEmpty) return '+${ids.length} topik';
  return '$first +${ids.length - 1} lainnya';
}

String makeCategorySlug(String name) {
  var slugBuffer = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s-]'), '');
  slugBuffer = slugBuffer
      .trim()
      .replaceAll(RegExp(r'\s+'), '-')
      .replaceAll(RegExp(r'-+'), '-');
  slugBuffer = slugBuffer.replaceAll(RegExp(r'^-+|-+$'), '');
  return slugBuffer;
}

bool isMine(Map post, String username) {
  final author = strOf(post, 'author').trim().toLowerCase();
  final me = username.trim().toLowerCase();
  if (author.isEmpty || me.isEmpty) return false;
  return author == me;
}

String resolveCoverUrl(dynamic raw) {
  final url = (raw?.toString() ?? '').trim();
  if (url.isEmpty) return '';
  if (url.startsWith('http')) return url;
  final origin = Uri.parse(
    baseUrl,
  ).replace(path: '').toString().replaceAll(RegExp(r'/+$'), '');
  if (url.startsWith('/')) return '$origin$url';
  return '$origin/$url';
}
