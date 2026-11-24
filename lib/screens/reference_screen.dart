import 'package:flutter/material.dart';
import '../data/accounts_data.dart';
import '../widgets/account_list_tile.dart';
import '../theme/app_theme.dart';

// --- БАЗОВЫЕ ОПРЕДЕЛЕНИЯ (Прямо внутри экрана) ---
final List<Map<String, dynamic>> theoryBasics = [
  {
    'title': 'Активный счет (А)',
    'icon': 'active', 
    'color': 0xFF32D74B, // Зеленый
    'description': 'Счет для учета наличия и движения активов (имущества) организации (отражаются в активе баланса).',
    'details': [
      'Сальдо: только дебетовое (или 0).',
      'Записи: увеличение — по дебету, уменьшение — по кредиту.',
      'Формула: Ск = Сн + Од - Ок.'
    ]
  },
  {
    'title': 'Пассивный счет (П)',
    'icon': 'passive',
    'color': 0xFFFF453A, // Красный
    'description': 'Счет для учета источников формирования имущества — собственного капитала и обязательств (отражаются в пассиве баланса).',
    'details': [
      'Сальдо: только кредитовое (или 0).',
      'Записи: увеличение — по кредиту, уменьшение — по дебету.',
      'Формула: Ск = Сн + Ок - Од.'
    ]
  },
  {
    'title': 'Активно-пассивный счет (АП)',
    'icon': 'both',
    'color': 0xFFFF9F0A, // Оранжевый
    'description': 'Счет, сочетающий признаки активного и пассивного (используется для учета расчетов и финансовых результатов).',
    'details': [
      'Сальдо: может быть дебетовым, кредитовым или двусторонним (развернутым) одновременно.',
      'В балансе: дебетовое сальдо идет в актив, кредитовое — в пассив.'
    ]
  },
];

class ReferenceScreen extends StatelessWidget {
  const ReferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : AppTheme.ink;
    Color cardColor = isDark ? AppTheme.darkSurface : Colors.white;

    return Scaffold(
      appBar: AppBar(title: const Text('Справочник счетов')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Блок теории
          Text(
            'Базовые определения',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 12),
          
          ...theoryBasics.map((item) {
            Color itemColor = Color(item['color']);
            IconData iconData;
            switch (item['icon']) {
              case 'active': iconData = Icons.add_circle_outline; break;
              case 'passive': iconData = Icons.remove_circle_outline; break;
              default: iconData = Icons.swap_horiz;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: itemColor.withOpacity(0.3), width: 1.5),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  iconColor: itemColor,
                  collapsedIconColor: itemColor,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: itemColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(iconData, color: itemColor, size: 24),
                  ),
                  title: Text(
                    item['title'],
                    style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 16),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item['description'],
                        style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...item['details'].map<Widget>((detail) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.circle, size: 6, color: itemColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              detail,
                              style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 24),
          Text(
            'Все счета',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 12),

          // Список счетов
          ...globalAccounts.map((account) {
            return AccountListTile(account: account);
          }).toList(),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}