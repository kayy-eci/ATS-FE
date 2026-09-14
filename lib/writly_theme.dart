import 'package:flutter/material.dart';

class WritlyColors {
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

ThemeData writlyTheme() {
  const primary = WritlyColors.primary;
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: WritlyColors.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      surface: WritlyColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: WritlyColors.bg,
      foregroundColor: WritlyColors.ink,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: WritlyColors.ink,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: WritlyColors.surface,
      labelStyle: const TextStyle(color: WritlyColors.muted, fontSize: 13),
      hintStyle: const TextStyle(color: WritlyColors.muted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: WritlyColors.line),
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
      backgroundColor: WritlyColors.chipBg,
      selectedColor: primary,
      labelStyle: TextStyle(fontSize: 13),
      shape: StadiumBorder(side: BorderSide(color: WritlyColors.line)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: WritlyColors.surface,
      selectedItemColor: primary,
      unselectedItemColor: WritlyColors.muted,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
