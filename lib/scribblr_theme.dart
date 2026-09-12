import 'package:flutter/material.dart';

// Design system "Scribblr" (UI layer saja, tanpa logic).
// Estimasi visual dari referensi: krem hangat + terracotta.
class ScribblrColors {
  static const bg = Color(0xFFFDF8F2);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFFA9603D);
  static const primaryDark = Color(0xFF8C4E30);
  static const ink = Color(0xFF2E2220);
  static const muted = Color(0xFF8A7E78);
  static const line = Color(0xFFEADDCF);
  static const chipBg = Color(0xFFF3E8DC);
  static const placeholderBg = Color(0xFFF1E4D6);
}

ThemeData scribblrTheme() {
  const primary = ScribblrColors.primary;
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: ScribblrColors.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      surface: ScribblrColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ScribblrColors.bg,
      foregroundColor: ScribblrColors.ink,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: ScribblrColors.ink,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ScribblrColors.surface,
      labelStyle: const TextStyle(color: ScribblrColors.muted, fontSize: 13),
      hintStyle: const TextStyle(color: ScribblrColors.muted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ScribblrColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: ScribblrColors.chipBg,
      selectedColor: primary,
      labelStyle: TextStyle(fontSize: 13),
      shape: StadiumBorder(side: BorderSide(color: ScribblrColors.line)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ScribblrColors.surface,
      selectedItemColor: primary,
      unselectedItemColor: ScribblrColors.muted,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
