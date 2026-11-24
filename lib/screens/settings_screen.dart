import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../services/progress_manager.dart';

class SettingsScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const SettingsScreen({super.key, required this.themeNotifier});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ProgressManager pm = ProgressManager();
  final TextEditingController secretController = TextEditingController();

  @override
  void dispose() {
    secretController.dispose();
    super.dispose();
  }

  Future<void> _checkSecretCode(String code) async {
    if (code.trim().toLowerCase() == 'admin') {
      await pm.activateSecretCode();
      setState(() {
        secretController.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Секретный код принят! Открыто 7 разделов и все уровни проводок.'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Неверный код.'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isDarkMode = widget.themeNotifier.value == ThemeMode.dark;

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
                widget.themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isDarkMode', value);
              },
            ),
          ),

          const SizedBox(height: 30),

          const Text('Секретный код', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textGrey)),
          const SizedBox(height: 8),
          Card(
            color: isDark ? AppTheme.darkSurface : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: secretController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Введите код',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () => _checkSecretCode(secretController.text),
                  ),
                ),
                onSubmitted: _checkSecretCode,
              ),
            ),
          ),
        ],
      ),
    );
  }
}