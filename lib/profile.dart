import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontendats/api.dart';
import 'package:frontendats/api_client.dart';
import 'package:frontendats/edit_profile.dart';
import 'package:frontendats/posts_refresh.dart';
import 'package:frontendats/writly_theme.dart';
import 'package:frontendats/writly_widgets.dart';

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

  Future<void> fetchArticleCount() async {
    setState(() => isLoading = true);
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/posts'), headers: authHeaders())
          .timeout(const Duration(seconds: 10));
      if (!mounted) return;
      setState(() => isLoading = false);
      if (await handleAuthError(context, res)) return;
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body)['data'] ?? [];
        setState(() {
          articleCount = data
              .where(
                (postItem) =>
                    postItem is Map && isMine(postItem, widget.username),
              )
              .length;
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchArticleCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: WritlyColors.primary,
          onRefresh: fetchArticleCount,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              const WritlyHeader(title: 'Profile'),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: WritlyColors.chipBg,
                      child: Text(
                        widget.username.isEmpty
                            ? 'S'
                            : widget.username[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: WritlyColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.username.isEmpty ? '-' : widget.username,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: WritlyColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.email.isEmpty ? '-' : widget.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: WritlyColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              WritlyCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.article_outlined,
                      color: WritlyColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isLoading ? '...' : '$articleCount',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: WritlyColors.ink,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Articles',
                      style: TextStyle(
                        fontSize: 13,
                        color: WritlyColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              WritlyCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.edit_outlined,
                        color: WritlyColors.primary,
                      ),
                      title: const Text('Edits Profile'),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: WritlyColors.muted,
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
                    const Divider(height: 1, color: WritlyColors.line),
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
