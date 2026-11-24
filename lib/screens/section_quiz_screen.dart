import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../theme/app_theme.dart';
import '../services/progress_manager.dart';
import '../models/account.dart';
import '../data/accounts_data.dart';

class SectionQuizScreen extends StatefulWidget {
  final String sectionName;
  final int sectionIndex;

  const SectionQuizScreen({
    super.key,
    required this.sectionName,
    required this.sectionIndex,
  });

  @override
  State<SectionQuizScreen> createState() => _SectionQuizScreenState();
}

class _SectionQuizScreenState extends State<SectionQuizScreen> {
  final pm = ProgressManager();
  late List<Account> accounts;
  
  bool isPlaying = false;
  int level = 1; 
  
  @override
  void initState() {
    super.initState();
    accounts = globalAccounts.where((a) => a.section == widget.sectionName).toList();
    if (accounts.isEmpty) {
      accounts = [Account(num: '00', name: 'Нет данных', type: 'З', section: widget.sectionName)];
    }
  }

  void _startLevel(int lvl) {
    HapticFeedback.lightImpact();
    
    String title = '';
    String desc = '';
    IconData icon;
    Color color;

    if (lvl == 1) {
      title = 'Сопоставление';
      desc = 'Вам нужно соединить название счета слева с его номером справа. Нажмите на карточку слева, затем на карточку справа.';
      icon = Icons.compare_arrows;
      color = Colors.blue;
    } else if (lvl == 2) {
      title = 'Название по номеру';
      desc = 'Вам будет показан номер счета. Выберите его правильное название из четырех вариантов.';
      icon = Icons.text_fields;
      color = Colors.orange;
    } else if (lvl == 3) {
      title = 'Номер по названию';
      desc = 'Вам будет показано название счета. Выберите его правильный номер из четырех вариантов.';
      icon = Icons.numbers;
      color = Colors.purple;
    } else {
      title = 'Ввод номера';
      desc = 'Вам будет показано название счета. Введите его правильный номер с помощью клавиатуры.';
      icon = Icons.keyboard;
      color = Colors.green;
    }

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
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    desc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() {
                          level = lvl;
                          isPlaying = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF7B61FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                      child: const Text('Начать', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)],
                ),
                child: Icon(icon, size: 40, color: Colors.white),
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
    Color cardColor = isDark ? const Color(0xFF2C2C2E) : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkCanvas : AppTheme.lightCanvas,
      appBar: AppBar(
        title: Text(isPlaying ? 'Уровень $level' : widget.sectionName, style: TextStyle(color: textColor, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (isPlaying) {
              setState(() => isPlaying = false);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: isPlaying 
          ? LevelPlayWidget(
              sectionName: widget.sectionName,
              sectionIndex: widget.sectionIndex, // <-- ПЕРЕДАЕМ ИНДЕКС
              level: level,
              accounts: accounts,
              onFinish: () {
                setState(() => isPlaying = false);
              },
            )
          : _buildLevelSelection(isDark, textColor, cardColor),
    );
  }

  Widget _buildLevelSelection(bool isDark, Color textColor, Color cardColor) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Выбери уровень', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 20),
        _buildLevelCard(1, 'Сопоставление', 'Соедини название с номером', Icons.compare_arrows, Colors.blue, isDark, textColor, cardColor),
        _buildLevelCard(2, 'Название по номеру', 'Выбери правильное название', Icons.text_fields, Colors.orange, isDark, textColor, cardColor),
        _buildLevelCard(3, 'Номер по названию', 'Выбери правильный номер', Icons.numbers, Colors.purple, isDark, textColor, cardColor),
        _buildLevelCard(4, 'Ввод номера', 'Напиши номер счета вручную', Icons.keyboard, Colors.green, isDark, textColor, cardColor),
      ],
    );
  }

  Widget _buildLevelCard(int lvl, String title, String subtitle, IconData icon, Color color, bool isDark, Color textColor, Color cardColor) {
    bool isUnlocked = lvl == 1 || pm.isEntryLevelCompleted(widget.sectionName, lvl - 1);
    bool isCompleted = pm.isEntryLevelCompleted(widget.sectionName, lvl);

    return GestureDetector(
      onTap: isUnlocked ? () => _startLevel(lvl) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isUnlocked ? cardColor : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isUnlocked ? color.withOpacity(0.3) : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: isUnlocked ? color.withOpacity(0.15) : Colors.grey.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(isUnlocked ? icon : Icons.lock, color: isUnlocked ? color : Colors.grey, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isUnlocked ? textColor : Colors.grey)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 14, color: isUnlocked ? AppTheme.textGrey : Colors.grey.withOpacity(0.5))),
                ],
              ),
            ),
            if (isCompleted)
              const Icon(Icons.check_circle, color: AppTheme.success, size: 28)
            else if (!isUnlocked)
              const Icon(Icons.lock, color: Colors.grey, size: 24),
          ],
        ),
      ),
    );
  }
}

class LevelPlayWidget extends StatefulWidget {
  final String sectionName;
  final int sectionIndex; // <-- НОВОЕ ПОЛЕ
  final int level;
  final List<Account> accounts;
  final VoidCallback onFinish;

  const LevelPlayWidget({
    super.key,
    required this.sectionName,
    required this.sectionIndex, // <-- ДОБАВЛЕНО
    required this.level,
    required this.accounts,
    required this.onFinish,
  });

  @override
  State<LevelPlayWidget> createState() => _LevelPlayWidgetState();
}

class _LevelPlayWidgetState extends State<LevelPlayWidget> {
  final pm = ProgressManager();
  int currentIndex = 0;
  int wrongCount = 0;
  bool isAnswered = false;
  String? selectedAnswer;
  final TextEditingController inputController = TextEditingController();

  Account? selectedLeft;
  Set<String> matchedNums = {};
  List<Account> leftItems = [];
  List<Account> rightItems = [];
  
  String? errorLeftNum;
  String? errorRightNum;

  List<String> currentOptions = [];
  String currentQuestion = '';
  String currentCorrectAnswer = '';

  @override
  void initState() {
    super.initState();
    List<Account> shuffled = List.from(widget.accounts)..shuffle(Random());
    if (widget.level == 1) {
      leftItems = List.from(shuffled);
      rightItems = List.from(shuffled)..shuffle(Random());
    } else {
      widget.accounts.clear();
      widget.accounts.addAll(shuffled);
      _prepareQuestion();
    }
  }

  void _prepareQuestion() {
    final currentAcc = widget.accounts[currentIndex];
    
    if (widget.level == 2) {
      currentQuestion = 'Как называется счет ${currentAcc.num}?';
      currentCorrectAnswer = currentAcc.name;
      currentOptions = [currentAcc.name, ...widget.accounts.where((a) => a.num != currentAcc.num).take(3).map((a) => a.name)]..shuffle();
    } else if (widget.level == 3) {
      currentQuestion = 'Какой номер у счета «${currentAcc.name}»?';
      currentCorrectAnswer = currentAcc.num;
      currentOptions = [currentAcc.num, ...widget.accounts.where((a) => a.num != currentAcc.num).take(3).map((a) => a.num)]..shuffle();
    } else if (widget.level == 4) {
      currentQuestion = 'Введите номер счета «${currentAcc.name}»';
      currentCorrectAnswer = currentAcc.num;
      currentOptions = [];
    }
  }

  void _finish() {
    bool passed = wrongCount <= 1;
    if (passed) {
      pm.completeEntryLevel(widget.sectionName, widget.level);
      
      // НОВОЕ: Если пройден 4-й уровень, отмечаем ВЕСЬ РАЗДЕЛ как пройденный
      if (widget.level == 4) {
        pm.completeStep('sec_${widget.sectionIndex}_main');
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(passed ? '🎉 Уровень пройден!' : '😕 Попробуй ещё', style: const TextStyle(color: Colors.white)),
        content: Text('Ошибок: $wrongCount', style: const TextStyle(color: AppTheme.textGrey)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (passed) {
                // НОВОЕ: Если это 4-й уровень, возвращаемся на экран выбора разделов
                if (widget.level == 4) {
                  Navigator.pop(context); 
                } else {
                  widget.onFinish();
                }
              } else {
                setState(() {
                  currentIndex = 0;
                  wrongCount = 0;
                  matchedNums.clear();
                  selectedAnswer = null;
                  isAnswered = false;
                  inputController.clear();
                  selectedLeft = null;
                  _prepareQuestion();
                });
              }
            },
            child: Text(passed ? 'Продолжить' : 'Повторить', style: const TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
    );
  }

  void _onLeftTap(Account acc) {
    if (matchedNums.contains(acc.num)) return;
    setState(() {
      selectedLeft = acc;
      errorLeftNum = null;
      errorRightNum = null;
    });
  }

  void _onRightTap(Account acc) {
    if (selectedLeft == null || matchedNums.contains(acc.num)) return;

    if (selectedLeft!.num == acc.num) {
      setState(() {
        matchedNums.add(acc.num);
        selectedLeft = null;
      });
      if (matchedNums.length == leftItems.length) {
        _finish();
      }
    } else {
      setState(() {
        wrongCount++;
        errorLeftNum = selectedLeft!.num;
        errorRightNum = acc.num;
        selectedLeft = null;
      });
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            errorLeftNum = null;
            errorRightNum = null;
          });
        }
      });
    }
  }

  void _checkAnswer() {
    if (isAnswered) return;
    setState(() {
      isAnswered = true;
      if (selectedAnswer != currentCorrectAnswer && inputController.text.trim() != currentCorrectAnswer) {
        wrongCount++;
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (currentIndex < widget.accounts.length - 1) {
        setState(() {
          currentIndex++;
          isAnswered = false;
          selectedAnswer = null;
          inputController.clear();
          _prepareQuestion();
        });
      } else {
        _finish();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : AppTheme.ink;
    Color cardColor = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    Color borderColor = isDark ? Colors.white24 : Colors.black12;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: widget.level == 1 
          ? _buildLevel1(isDark, textColor, cardColor, borderColor) 
          : _buildLevel2_4(isDark, textColor, cardColor, borderColor),
    );
  }

  Widget _buildLevel1(bool isDark, Color textColor, Color cardColor, Color defaultBorder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Нажмите на пары', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        children: leftItems.map((acc) {
                          bool isMatched = matchedNums.contains(acc.num);
                          bool isSelected = selectedLeft?.num == acc.num;
                          bool isError = errorLeftNum == acc.num;
                          Color bgColor = cardColor;
                          Color border = defaultBorder;
                          Color txt = textColor;
                          if (isMatched) { bgColor = Colors.grey.withOpacity(0.1); txt = Colors.grey; }
                          else if (isError) { bgColor = AppTheme.error.withOpacity(0.1); border = AppTheme.error; txt = AppTheme.error; }
                          else if (isSelected) { bgColor = AppTheme.primary.withOpacity(0.1); border = AppTheme.primary; txt = AppTheme.primary; }

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () => _onLeftTap(acc),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: bgColor, 
                                    borderRadius: BorderRadius.circular(16), 
                                    border: Border.all(color: border, width: 2)
                                  ),
                                  child: Text(
                                    acc.name, 
                                    textAlign: TextAlign.center, 
                                    style: TextStyle(color: txt, fontSize: 14, fontWeight: FontWeight.w600)
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: rightItems.map((acc) {
                          bool isMatched = matchedNums.contains(acc.num);
                          bool isError = errorRightNum == acc.num;
                          Color bgColor = cardColor;
                          Color border = defaultBorder;
                          Color txt = textColor;
                          if (isMatched) { bgColor = AppTheme.success.withOpacity(0.1); border = AppTheme.success; txt = AppTheme.success; }
                          else if (isError) { bgColor = AppTheme.error.withOpacity(0.1); border = AppTheme.error; txt = AppTheme.error; }

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () => _onRightTap(acc),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: bgColor, 
                                    borderRadius: BorderRadius.circular(16), 
                                    border: Border.all(color: border, width: 2)
                                  ),
                                  child: Text(
                                    acc.num, 
                                    style: TextStyle(color: txt, fontSize: 20, fontWeight: FontWeight.bold)
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevel2_4(bool isDark, Color textColor, Color cardColor, Color defaultBorder) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Text(currentQuestion, textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 40),
          
          if (widget.level == 2 || widget.level == 3) ...[
            ...currentOptions.map((opt) {
              bool isSelected = selectedAnswer == opt;
              Color bgColor = cardColor;
              Color border = defaultBorder;
              Color txt = textColor;
              
              if (isAnswered) {
                if (opt == currentCorrectAnswer) { bgColor = AppTheme.success.withOpacity(0.1); border = AppTheme.success; txt = AppTheme.success; }
                else if (isSelected) { bgColor = AppTheme.error.withOpacity(0.1); border = AppTheme.error; txt = AppTheme.error; }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: isAnswered ? null : () {
                    setState(() => selectedAnswer = opt);
                    _checkAnswer();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: border, width: 2)),
                    child: Center(child: Text(opt, style: TextStyle(fontSize: 18, color: txt, fontWeight: FontWeight.w600))),
                  ),
                ),
              );
            })
          ] else if (widget.level == 4) ...[
            TextField(
              controller: inputController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
              decoration: InputDecoration(
                hintText: 'Номер счета',
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: defaultBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: defaultBorder)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.primary, width: 2)),
              ),
              enabled: !isAnswered,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isAnswered ? null : _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Проверить', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            if (isAnswered) ...[
              const SizedBox(height: 20),
              Text('Правильный ответ: $currentCorrectAnswer', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.success, fontSize: 18, fontWeight: FontWeight.bold)),
            ]
          ]
        ],
      ),
    );
  }
}