import 'package:flutter/material.dart';
import 'package:frontendats/addpost.dart';
import 'package:frontendats/discover.dart';
import 'package:frontendats/homepage.dart';
import 'package:frontendats/my_articles.dart';
import 'package:frontendats/posts_refresh.dart';
import 'package:frontendats/profile.dart';
import 'package:frontendats/scribblr_theme.dart';

// Shell bottom navigation 5 tab setelah login:
// Home - Discover - Create (tengah) - My Article - Profile.
// Pages dibuat sekali di initState agar state IndexedStack tidak reset
// saat pindah tab. Mutasi data (create/update/delete) lewat PostsRefresh.
class MainShell extends StatefulWidget {
  final String username;
  final String email;
  const MainShell({super.key, this.username = '', this.email = ''});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(username: widget.username),
      DiscoverPage(username: widget.username),
      AddPostPage(
        username: widget.username,
        onSaved: () {
          // Habis publish dari tab Create: pindah ke My Article
          // dan paksa semua list refresh (poin 1+8).
          setState(() => index = 3);
          PostsRefresh.bump();
        },
      ),
      MyArticlesPage(username: widget.username),
      ProfilePage(username: widget.username, email: widget.email),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: ScribblrColors.surface,
          border: Border(top: BorderSide(color: ScribblrColors.line)),
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (v) => setState(() => index = v),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Discover'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), activeIcon: Icon(Icons.add_circle), label: 'Create'),
            BottomNavigationBarItem(icon: Icon(Icons.article_outlined), activeIcon: Icon(Icons.article), label: 'My Article'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
