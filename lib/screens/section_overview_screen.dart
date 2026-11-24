import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/accounts_data.dart';
import '../services/progress_manager.dart';
import '../data/sections_data.dart';
import 'lesson_screen.dart';

class SectionOverviewScreen extends StatelessWidget {
  final int sectionIndex;
  final String sectionName;

  const SectionOverviewScreen({
    super.key,
    required this.sectionIndex,
    required this.sectionName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.ink;
    final cardColor = isDark ? AppTheme.darkSurface : Colors.white;

    final info = sectionsInfo[sectionIndex];
    final accounts = globalAccounts.where((a) => a.section == sectionName).toList();
    final pm = ProgressManager();
    final isCompleted = pm.isCompleted('sec_${sectionIndex}_main');

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkCanvas : AppTheme.lightCanvas,
      appBar: AppBar(
        title: Text(sectionName, style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: info.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: info.color.withOpacity(0.3), width: 2),
              ),
              child: Column(
                children: [
                  Icon(info.icon, size: 64, color: info.color),
                  const SizedBox(height: 16),
                  Text(
                    sectionName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Счетов в разделе: ${accounts.length}',
                    style: const TextStyle(fontSize: 14, color: AppTheme.textGrey),
                  ),
                  if (isCompleted) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('✓ Раздел пройден', style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text('Счета раздела', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 12),
            ...accounts.map((acc) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: info.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      acc.num,
                      style: TextStyle(fontWeight: FontWeight.bold, color: info.color, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(acc.name, style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 15)),
                        if (acc.subAccounts.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Субсчетов: ${acc.subAccounts.length}',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textGrey),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: info.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      acc.type,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: info.color),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonScreen(
                      stepId: 'sec_${sectionIndex}_main',
                      sectionName: sectionName,
                      isSubAccountTest: false,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: info.color,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(
                isCompleted ? 'Повторить раздел' : 'Начать тренировку',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
