import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontendats/api.dart';
import 'package:frontendats/api_client.dart';
import 'package:frontendats/edit_profile.dart';
import 'package:frontendats/posts_refresh.dart';
import 'package:frontendats/scribblr_theme.dart';
import 'package:frontendats/scribblr_widgets.dart';

// Profile read-only: nama, email, jumlah artikel milik user.
// Jumlah artikel dihitung client-side dari GET /posts (filter author).
// Tanpa followers/following (di luar scope). Logout pakai logic yang ada.
class ProfilePage extends StatefulWidget {
  final String username;
  final String email;
  const ProfilePage({super.key, this.username = '', this.email = ''});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int articleCount = 0;
  bool isLoading = false;

  Future<void> getCount() async {
    setState(() => isLoading = true);
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/posts'), headers: authHeaders())
          .timeout(const Duration(seconds: 10));
      if (!mounted) return;
      setState(() => isLoading = false);
      if (await handleAuthError(context, res)) return;
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body)['data'] ?? [];
        setState(() {
          articleCount = data
              .where((p) => p is Map && isMine(p, widget.username))
              .length;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: ScribblrColors.primary,
          onRefresh: getCount,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              const ScribblrHeader(title: 'Profile'),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: ScribblrColors.chipBg,
                      child: Text(
                        widget.username.isEmpty
                            ? 'S'
                            : widget.username[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: ScribblrColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.username.isEmpty ? '-' : widget.username,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: ScribblrColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.email.isEmpty ? '-' : widget.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: ScribblrColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ScribblrCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.article_outlined,
                      color: ScribblrColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isLoading ? '...' : '$articleCount',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: ScribblrColors.ink,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Articles',
                      style: TextStyle(
                        fontSize: 13,
                        color: ScribblrColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ScribblrCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.edit_outlined,
                        color: ScribblrColors.primary,
                      ),
                      title: const Text('Edit Profile'),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: ScribblrColors.muted,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              username: widget.username,
                              email: widget.email,
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                      color: ScribblrColors.line,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                      ),
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onTap: () => forceLogout(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
