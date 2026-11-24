import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'levels_screen.dart';
import 'flashcards_screen.dart';
import 'reference_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const MainScreen({super.key, required this.themeNotifier});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Начинаем со Словаря (индекс 0)
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // ВАЖНО: Порядок экранов должен совпадать с порядком иконок внизу!
    final List<Widget> _screens = [
      const ReferenceScreen(),   // 0. Словарь
      const FlashcardsScreen(),  // 1. Уроки (теперь тут карточки)
      const LevelsScreen(),      // 2. Тренировка (теперь тут тесты)
      ProfileScreen(themeNotifier: widget.themeNotifier), // 3. Профиль
    ];

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkCanvas : AppTheme.lightCanvas,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
            border: isDark ? Border.all(color: Colors.white.withOpacity(0.05)) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.menu_book_rounded, 'Словарь', isDark),
              _buildNavItem(1, Icons.school_rounded, 'Уроки', isDark),
              _buildNavItem(2, Icons.style_rounded, 'Тренировка', isDark),
              _buildNavItem(3, Icons.person_rounded, 'Профиль', isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isDark) {
    bool isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primary.withOpacity(0.15) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : AppTheme.textGrey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primary : AppTheme.textGrey,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
