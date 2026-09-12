import 'package:flutter/material.dart';
import 'package:frontendats/scribblr_theme.dart';

// Kumpulan widget presentasional gaya Scribblr.
// Tidak ada API call / logic bisnis di sini, hanya tampilan.

class ScribblrHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const ScribblrHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: ScribblrColors.ink,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: const TextStyle(fontSize: 13, color: ScribblrColors.muted),
          ),
        ],
      ],
    );
  }
}

class ScribblrLabel extends StatelessWidget {
  final String text;
  const ScribblrLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: ScribblrColors.ink,
        ),
      ),
    );
  }
}

class ScribblrPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  const ScribblrPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(text),
    );
  }
}

/// Thumbnail artikel: tampilkan cover URL kalau ada,
/// kalau kosong/null tampilkan placeholder warna krem (tanpa asumsi asset lain).
class ScribblrThumb extends StatelessWidget {
  final dynamic cover;
  final double width;
  final double height;
  const ScribblrThumb({
    super.key,
    required this.cover,
    this.width = 92,
    this.height = 92,
  });

  @override
  Widget build(BuildContext context) {
    final url = cover?.toString() ?? '';
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        height: height,
        color: ScribblrColors.placeholderBg,
        child: url.isEmpty
            ? const Icon(Icons.article_outlined, color: ScribblrColors.primary)
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.article_outlined,
                  color: ScribblrColors.primary,
                ),
              ),
      ),
    );
  }
}

class ScribblrCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const ScribblrCard({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ScribblrColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: ScribblrColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(12), child: child),
      ),
    );
  }
}

/// Header auth full-width: gradasi primary, logo, judul, subjudul.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 72),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ScribblrColors.primary, ScribblrColors.primaryDark],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: const Text(
              'W',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: ScribblrColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

/// Card form auth yang overlap ke header.
class AuthCard extends StatelessWidget {
  final Widget child;
  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      transform: Matrix4.translationValues(0, -40, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ScribblrColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ScribblrColors.line),
        boxShadow: [
          BoxShadow(
            color: ScribblrColors.ink.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Dialog konfirmasi hapus gaya Scribblr (UI saja).
Future<bool> confirmDeleteArticle(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: ScribblrColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Delete Article',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text('Are you sure you want to delete this article?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(110, 44),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Delete'),
          ),
        ],
      );
    },
  );
  return ok == true;
}
