import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'flashcards_screen.dart';
import 'reference_screen.dart';
import 'levels_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const HomeScreen({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? AppTheme.darkCanvas : AppTheme.lightCanvas;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('План счетов РБ'), 
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(themeNotifier: themeNotifier)))
          )
        ]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primary,
                  child: Icon(Icons.person, size: 35, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Привет, Артём! 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Продолжим учить?', style: TextStyle(fontSize: 15, color: AppTheme.textGrey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // БАННЕР PREMIUM (как на скрине)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, Color(0xFF9F8BFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Оформить Premium', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 4),
                      Text('Мнемотехника и без рекламы', style: TextStyle(fontSize: 14, color: Colors.white70)),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onPressed: () {},
                    child: const Text('Апгрейд'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            const Text('Обучение', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            _buildMenuCard(context, title: 'Путь обучения', subtitle: 'Поэтапное прохождение', icon: Icons.map_rounded, color: AppTheme.success, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LevelsScreen()))),
            const SizedBox(height: 16),
            _buildMenuCard(context, title: 'Карточки', subtitle: 'Быстрое повторение', icon: Icons.style_rounded, color: AppTheme.primary, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardsScreen()))),
            const SizedBox(height: 16),
            _buildMenuCard(context, title: 'Справочник', subtitle: 'Все счета с типами', icon: Icons.menu_book_rounded, color: AppTheme.warning, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferenceScreen()))),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : Colors.white, 
          borderRadius: BorderRadius.circular(24), 
          border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05), 
              blurRadius: 15, 
              offset: const Offset(0, 5)
            )
          ]
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14), 
              decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle), 
              child: Icon(icon, color: color, size: 28)
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 14, color: AppTheme.textGrey)),
            ])),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.textGrey),
          ],
        ),
      ),
    );
  }
}
