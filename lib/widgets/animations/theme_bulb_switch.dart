import 'package:flutter/material.dart';

class ThemeBulbSwitch extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  const ThemeBulbSwitch({
    super.key,
    required this.isDarkMode,
    required this.onChanged,
  });

  @override
  State<ThemeBulbSwitch> createState() => _ThemeBulbSwitchState();
}

class _ThemeBulbSwitchState extends State<ThemeBulbSwitch> {
  double _dragOffset = 0;
  bool _isDragging = false;
  final double _threshold = 40.0;

  @override
  Widget build(BuildContext context) {
    bool isDark = widget.isDarkMode;
    Color bulbColor = isDark ? Colors.amber : Colors.grey.shade400;
    Color glowColor = isDark ? Colors.amber.withOpacity(0.4) : Colors.transparent;
    Color cordColor = isDark ? Colors.white54 : Colors.grey.shade600;
    Color textColor = isDark ? Colors.white70 : Colors.grey.shade700;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Провод, уходящий вверх за экран (как с потолка)
        Container(
          width: 4,
          height: 120, // Длина провода до потолка
          decoration: BoxDecoration(
            color: cordColor,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, cordColor], // Плавное исчезновение вверху
            ),
          ),
        ),
        
        // 2. Сама лампа (увеличенная)
        GestureDetector(
          onVerticalDragStart: (_) => setState(() => _isDragging = true),
          onVerticalDragUpdate: (details) {
            setState(() {
              _dragOffset += details.delta.dy;
              if (_dragOffset < 0) _dragOffset = 0;
              if (_dragOffset > 60) _dragOffset = 60;
            });
          },
          onVerticalDragEnd: (_) {
            setState(() => _isDragging = false);
            if (_dragOffset > _threshold) {
              widget.onChanged(!isDark);
            }
            setState(() => _dragOffset = 0);
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.amber.withOpacity(0.15) : Colors.transparent,
                  boxShadow: isDark ? [
                    BoxShadow(color: glowColor, blurRadius: 60, spreadRadius: 20)
                  ] : [],
                ),
                child: Icon(Icons.lightbulb_rounded, size: 140, color: bulbColor), // Огромная лампа
              ),
              
              // 3. Шнурок, который тянем
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: _isDragging ? Curves.linear : Curves.elasticOut,
                height: 100 + _dragOffset,
                width: 40,
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 4, color: cordColor, height: 100 + _dragOffset - 24),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: cordColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // 4. Подсказка
        const SizedBox(height: 16),
        Text(
          isDark ? 'Потяните вниз, чтобы включить светлую тему' : 'Потяните вниз, чтобы включить темную тему',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: textColor, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}