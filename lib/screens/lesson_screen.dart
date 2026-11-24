import 'package:flutter/material.dart';
import 'dart:math';
import '../data/accounts_data.dart';
import '../models/account.dart';
import '../theme/app_theme.dart';
import '../services/progress_manager.dart';

class LessonScreen extends StatefulWidget {
  final String? stepId;
  final String? sectionName;
  final bool isSubAccountTest;
  final bool isFavoritesMode;

  const LessonScreen({
    super.key,
    this.stepId,
    this.sectionName,
    this.isSubAccountTest = false,
    this.isFavoritesMode = false,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late List<Account> levelAccounts;
  late List<Account> questions;
  late List<List<String>> allOptions;

  int currentQuestionIndex = 0;
  int correctCount = 0;
  int incorrectCount = 0;
  bool isAnswered = false;
  String? selectedAnswer;

  final progressManager = ProgressManager();

  @override
  void initState() {
    super.initState();

    final rnd = Random(DateTime.now().microsecondsSinceEpoch);

    if (widget.isFavoritesMode) {
      final favNums = progressManager.getFavorites();
      levelAccounts = globalAccounts.where((a) => favNums.contains(a.num)).toList();
    } else if (widget.isSubAccountTest) {
      List<Account> sectionAccs = globalAccounts.where((a) => a.section == widget.sectionName).toList();
      levelAccounts = [];
      for (var acc in sectionAccs) {
        for (var sub in acc.subAccounts) {
          levelAccounts.add(Account(num: sub.num, name: sub.name, type: 'Субсчет', section: widget.sectionName ?? ''));
        }
      }
    } else {
      levelAccounts = globalAccounts.where((a) => a.section == widget.sectionName).toList();
    }

    levelAccounts.shuffle(rnd);

    questions = List.from(levelAccounts);
    if (questions.length > 10) {
      questions = questions.take(10).toList();
    } else if (questions.length < 10 && questions.isNotEmpty) {
      while (questions.length < 10) {
        questions.add(levelAccounts[rnd.nextInt(levelAccounts.length)]);
      }
    }
    questions.shuffle(rnd);

    allOptions = [];
    List<SubAccount> allSubsGlobal = globalAccounts.expand((a) => a.subAccounts).toList();

    for (var question in questions) {
      List<String> opts = [question.name];
      while (opts.length < 4) {
        String randomName;
        if (widget.isSubAccountTest) {
          randomName = allSubsGlobal[rnd.nextInt(allSubsGlobal.length)].name;
        } else {
          randomName = globalAccounts[rnd.nextInt(globalAccounts.length)].name;
        }
        if (!opts.contains(randomName)) {
          opts.add(randomName);
        }
      }
      opts.shuffle(rnd);
      allOptions.add(opts);
    }
  }

  void checkAnswer(String answer, String correctAnswer) {
    if (isAnswered) return;
    setState(() {
      isAnswered = true;
      selectedAnswer = answer;
      if (answer == correctAnswer) {
        correctCount++;
      } else {
        incorrectCount++;
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          isAnswered = false;
          selectedAnswer = null;
        });
      } else {
        finishLesson();
      }
    });
  }

  void finishLesson() {
    double score = (correctCount / questions.length) * 100;
    bool isPassed = score >= 90.0;

    if (isPassed && widget.stepId != null) {
      progressManager.completeStep(widget.stepId!);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(isPassed ? '🎉 Отлично!' : '😕 Попробуй еще раз',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Твой результат: $correctCount из ${questions.length} (${score.toStringAsFixed(1)}%).\n\n'
          '${isPassed ? "Ты успешно прошел этот шаг!" : "Для прохождения нужно набрать 90% (минимум 9 из 10)."}',
          style: const TextStyle(fontSize: 16, color: AppTheme.textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('ОК',
                style: TextStyle(color: AppTheme.primary, fontSize: 16, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? AppTheme.darkCanvas : AppTheme.lightCanvas;
    Color textColor = isDark ? Colors.white : AppTheme.ink;
    Color cardColor = isDark ? AppTheme.darkSurface : Colors.white;

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(title: const Text('Избранное'), backgroundColor: bgColor),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Ты ещё не добавил ни одного счёта в избранное.\n\nНажми на звёздочку на экране любого вопроса, чтобы добавить счёт сюда и повторять только его.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
        ),
      );
    }

    final currentAccount = questions[currentQuestionIndex];
    final options = allOptions[currentQuestionIndex];

    String titleText = widget.isFavoritesMode ? 'Избранное' : (widget.sectionName ?? '');
    if (widget.isSubAccountTest) titleText += ' (Субсчета)';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(titleText, style: TextStyle(color: textColor)),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        // actions: [...] <-- УДАЛЕНО
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: currentQuestionIndex / questions.length,
            backgroundColor: isDark ? Colors.white12 : Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('✓ Верно: $correctCount',
                      style: const TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('✗ Ошибки: $incorrectCount',
                      style: const TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text('Вопрос ${currentQuestionIndex + 1} из ${questions.length}',
                style: const TextStyle(fontSize: 15, color: AppTheme.textGrey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Как называется счет ${currentAccount.num}?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: textColor, letterSpacing: -0.5)),
            const SizedBox(height: 40),
            ...options.map((option) {
              bool isSelected = option == selectedAnswer;
              Color btnBgColor = cardColor;
              Color btnTxtColor = textColor;
              if (isAnswered) {
                if (isSelected) {
                  if (option == currentAccount.name) {
                    btnBgColor = AppTheme.success;
                    btnTxtColor = Colors.white;
                  } else {
                    btnBgColor = AppTheme.error;
                    btnTxtColor = Colors.white;
                  }
                } else {
                  btnBgColor = cardColor.withOpacity(0.3);
                  btnTxtColor = textColor.withOpacity(0.2);
                }
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GestureDetector(
                  onTap: isAnswered ? null : () => checkAnswer(option, currentAccount.name),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    decoration: BoxDecoration(
                      color: btnBgColor,
                      borderRadius: BorderRadius.circular(30),
                      border: isDark ? Border.all(color: Colors.white.withOpacity(0.05), width: 1) : null,
                    ),
                    child: Center(
                      child: Text(option,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: btnTxtColor)),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}