import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:frontendats/addpost.dart';
import 'package:frontendats/discover.dart';
import 'package:frontendats/homepage.dart';
import 'package:frontendats/my_articles.dart';
import 'package:frontendats/posts_refresh.dart';
import 'package:frontendats/profile.dart';
import 'package:frontendats/scribblr_theme.dart';

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
          setState(() => index = 3);
          PostsRefresh.bump();
        },
      ),
      MyArticlesPage(username: widget.username),
      ProfilePage(username: widget.username, email: widget.email),
    ];
  }

  void _onTap(int tappedIndex) => setState(() => index = tappedIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomBar(
        layout: const BottomBarLayout.adaptive(
          maxWidth: 440,
          offset: 16,
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
        motion: const BottomBarMotion.cupertino(
          preset: BottomBarCupertinoMotion.snappy,
        ),
        scrollBehavior: const BottomBarScrollBehavior(
          hideOnScroll: true,
          showOnScrollEnd: true,
          showAtStart: true,
        ),
        theme: BottomBarThemeData(
          barDecoration: BoxDecoration(
            color: ScribblrColors.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: ScribblrColors.line),
            boxShadow: [
              BoxShadow(
                color: ScribblrColors.ink.withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
        ),

        showIcon: false,
        body: BottomBarBodyPadding(
          child: IndexedStack(index: index, children: pages),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            children: [
              _navItem(0, Icons.home_outlined, Icons.home, 'Home'),
              _navItem(1, Icons.explore_outlined, Icons.explore, 'Discover'),
              _createItem(),
              _navItem(3, Icons.article_outlined, Icons.article, 'My Article'),
              _navItem(4, Icons.person_outline, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    int tabIndex,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final selected = index == tabIndex;
    final color = selected ? ScribblrColors.primary : ScribblrColors.muted;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _onTap(tabIndex),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(selected ? activeIcon : icon, color: color, size: 24),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createItem() {
    final selected = index == 2;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _onTap(2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: ScribblrColors.primary,
                  shape: BoxShape.circle,
                  border: selected
                      ? Border.all(
                          color: ScribblrColors.primaryDark,
                          width: 2.5,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: ScribblrColors.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 2),
              Text(
                'Create',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? ScribblrColors.primary
                      : ScribblrColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
