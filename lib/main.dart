import 'package:flutter/material.dart';
import 'package:frontendats/api.dart';
import 'package:frontendats/login.dart';
import 'package:frontendats/scribblr_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiConfig.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Writly',
      theme: scribblrTheme(),

      home: const LoginPage(),
    );
  }
}
