import 'package:flutter/material.dart';

class AppTheme {
  // Цвета из скриншота
  static const Color primary = Color(0xFF7B61FF); // Фиолетовый
  static const Color primaryLight = Color(0xFF9F8BFF);
  static const Color darkCanvas = Color(0xFF09090B); // Глубокий черный
  static const Color darkSurface = Color(0xFF1C1C1E); // Темно-серый для кнопок
  
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF8E8E93);
  
  static const Color success = Color(0xFF32D74B);
  static const Color error = Color(0xFFFF453A);
  static const Color warning = Color(0xFFFF9F0A);

  // Светлая тема (минималистичная)
  static const Color lightCanvas = Color(0xFFF2F2F7);
  static const Color lightSurface = Colors.white;
  static const Color ink = Color(0xFF1C1C1E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightCanvas,
      colorScheme: ColorScheme.fromSeed(seedColor: primary, primary: primary, surface: lightSurface),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightCanvas, 
        foregroundColor: ink, 
        elevation: 0, 
        centerTitle: true,
        titleTextStyle: TextStyle(color: ink, fontSize: 20, fontWeight: FontWeight.w800),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary, foregroundColor: Colors.white, elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
      ),
    );
  }

  // Темная тема (в стиле премиум-приложения)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkCanvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary, primary: primary, surface: darkSurface, brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkCanvas, 
        foregroundColor: textLight, 
        elevation: 0, 
        centerTitle: true,
        titleTextStyle: TextStyle(color: textLight, fontSize: 20, fontWeight: FontWeight.w800),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary, foregroundColor: Colors.white, elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
      ),
    );
  }
}
