import 'package:flutter/material.dart';
import 'package:frontendats/login.dart';
import 'package:frontendats/scribblr_theme.dart';

// Splash murni UI: tampilkan logo lalu ke Login.
// Sesuai kesepakatan: tanpa auto-login/token-check (AuthSession in-memory).
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScribblrColors.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logokpi.png', width: 120, height: 120),
            const SizedBox(height: 16),
            const Text(
              'Writly',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: ScribblrColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Write. Share. Inspire.',
              style: TextStyle(fontSize: 13, color: ScribblrColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
