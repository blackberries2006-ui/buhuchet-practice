import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const SettingsScreen({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isDarkMode = themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Внешний вид', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textGrey)),
          const SizedBox(height: 8),
          Card(
            color: isDark ? AppTheme.darkSurface : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: SwitchListTile(
              title: const Text('Темная тема', style: TextStyle(fontWeight: FontWeight.w600)),
              secondary: const Icon(Icons.dark_mode),
              value: isDarkMode,
              activeColor: AppTheme.primary,
              onChanged: (bool value) async {
                themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isDarkMode', value);
              },
            ),
          ),
        ],
      ),
    );
  }
}