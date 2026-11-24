import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/progress_manager.dart';
import '../data/sections_data.dart';
import '../data/accounts_data.dart';
import '../models/account.dart';
import 'lesson_screen.dart';
import 'entries_screen.dart';
import 'section_quiz_screen.dart';

class LevelStep {
  final String id;
  final int sectionIndex;
  final String title;
  final String sectionName;
  final bool isSubAccount;
  final IconData icon;
  final Color color;

  LevelStep({
    required this.id,
    required this.sectionIndex,
    required this.title,
    required this.sectionName,
    required this.isSubAccount,
    required this.icon,
    required this.color,
  });
}

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  final progressManager = ProgressManager();

  List<LevelStep> generateSteps() {
    List<LevelStep> steps = [];
    for (int i = 0; i < sectionsInfo.length; i++) {
      final info = sectionsInfo[i];
      
      steps.add(LevelStep(
        id: 'sec_${i}_main',
        sectionIndex: i,
        title: info.title,
        sectionName: info.title,
        isSubAccount: false,
        icon: info.icon,
        color: info.color,
      ));

      List<Account> accs = globalAccounts.where((a) => a.section == info.title).toList();
      int subsCount = 0;
      for (var a in accs) {
        subsCount += a.subAccounts.length;
      }

      if (subsCount >= 4) {
        steps.add(LevelStep(
          id: 'sec_${i}_sub',
          sectionIndex: i,
          title: 'Субсчета: ${info.title}',
          sectionName: info.title,
          isSubAccount: true,
          icon: Icons.account_tree_rounded,
          color: Colors.pinkAccent,
        ));
      }
    }
    return steps;
  }

  void _showSectionDialog(LevelStep step) {
    HapticFeedback.lightImpact();

    String title = step.isSubAccount ? 'Субсчета раздела' : 'Раздел';
    String desc = step.isSubAccount 
        ? 'Проверь свои знания по субсчетам этого раздела. Здесь собраны все детальные счета.'
        : 'Изучим счета из этого раздела. Тебя ждут 4 уровня: сопоставление, выбор названия, выбор номера и ручной ввод.';
    
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF7B61FF),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step.sectionName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    desc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        if (step.isSubAccount) {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (_) => LessonScreen(
                                stepId: step.id,
                                sectionName: step.sectionName,
                                isSubAccountTest: true,
                              )
                            )
                          ).then((_) => setState(() {}));
                        } else {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (_) => SectionQuizScreen(
                                sectionName: step.sectionName,
                                sectionIndex: step.sectionIndex,
                              )
                            )
                          ).then((_) => setState(() {}));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF7B61FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                      child: const Text('Приступить', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF7B61FF),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: [BoxShadow(color: step.color.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)],
                ),
                child: Icon(step.icon, size: 40, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : AppTheme.ink;
    final steps = generateSteps();
    
    int completedMain = 0;
    for (var step in steps) {
      if (!step.isSubAccount && progressManager.isCompleted(step.id)) completedMain++;
    }
    int totalMain = sectionsInfo.length;

    bool isEntriesUnlocked = completedMain >= 5;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkCanvas : AppTheme.lightCanvas,
      appBar: AppBar(
        title: Text(
          'Тренировка', 
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, bottom: 60, left: 20, right: 20),
        child: Column(
          children: [
            // Блок проводок
            if (isEntriesUnlocked)
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EntriesScreen())),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.purpleAccent.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
                    ]
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                        child: const Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Тренировка проводок', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            SizedBox(height: 4),
                            Text('Дт / Кт на время', style: TextStyle(fontSize: 14, color: Colors.white70)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: Colors.white),
                    ],
                  ),
                ),
              )
            else
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.lock_rounded, color: Colors.grey, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Тренировка проводок', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor.withOpacity(0.5))),
                          const SizedBox(height: 4),
                          const Text('Откроется после 5 разделов', style: TextStyle(fontSize: 14, color: AppTheme.textGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Блок прогресса
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Прогресс разделов', style: TextStyle(fontSize: 14, color: AppTheme.textGrey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        '$completedMain из $totalMain',
                        style: TextStyle(fontSize: 18, color: isDark ? Colors.white : AppTheme.ink, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppTheme.textGrey),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final step = steps[index];
                final isCompleted = progressManager.isCompleted(step.id);
                
                bool isUnlocked = false;
                if (step.sectionIndex == 0 && !step.isSubAccount) {
                  isUnlocked = true; 
                } else if (step.isSubAccount) {
                  isUnlocked = progressManager.isCompleted('sec_${step.sectionIndex}_main');
                } else {
                  isUnlocked = progressManager.isCompleted('sec_${step.sectionIndex - 1}_main');
                }

                final isCurrent = isUnlocked && !isCompleted;

                double horizontalOffset = 0;
                if (index % 2 != 0) {
                  horizontalOffset = 40.0;
                } else {
                  horizontalOffset = -40.0;
                }
                if (index == 0) horizontalOffset = 0;

                return Transform.translate(
                  offset: Offset(horizontalOffset, 0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: isUnlocked ? () => _showSectionDialog(step) : null,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: isCurrent 
                                  ? LinearGradient(
                                      colors: [step.color, step.color.withOpacity(0.7)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                                color: !isCurrent 
                                  ? (isDark ? const Color(0xFF1E1A3C) : Colors.white) 
                                  : null,
                                boxShadow: [
                                  if (isCurrent)
                                    BoxShadow(
                                      color: step.color.withOpacity(0.5),
                                      blurRadius: 25,
                                      spreadRadius: 2,
                                    )
                                ],
                                border: Border.all(
                                  color: isCompleted 
                                    ? Colors.transparent 
                                    : (isCurrent ? Colors.transparent : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200)),
                                  width: 2,
                                )
                              ),
                              child: Center(
                                child: Icon(
                                  step.icon,
                                  size: 40,
                                  color: isCompleted 
                                    ? step.color 
                                    : (isCurrent ? Colors.white : AppTheme.textGrey),
                                ),
                              ),
                            ),
                            
                            if (isCompleted)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppTheme.success,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check, color: Colors.white, size: 16),
                              ),
                              
                            if (!isUnlocked)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppTheme.darkSurface : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade300),
                                  ),
                                  child: const Icon(Icons.lock, color: AppTheme.textGrey, size: 16),
                                ),
                              )
                          ],
                        ),
                      ),

                      // ПЛАШКА С ПОДПИСЬЮ В ЦВЕТ РАЗДЕЛА
                      Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isCurrent ? step.color.withOpacity(0.1) : Colors.transparent, // Легкая заливка для текущего
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: isCompleted 
                                ? AppTheme.textGrey.withOpacity(0.5) // Для пройденных — серая рамка
                                : (isUnlocked ? step.color : AppTheme.textGrey.withOpacity(0.3)), // Для закрытых — бледная
                            width: 2,
                          ),
                        ),
                        child: Text(
                          step.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                            color: isCompleted 
                                ? AppTheme.textGrey // Пройденные — серый текст
                                : (isUnlocked ? step.color : AppTheme.textGrey.withOpacity(0.3)), // Текущие и закрытые
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}