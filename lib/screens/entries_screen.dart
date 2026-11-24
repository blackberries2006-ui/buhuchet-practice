import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../theme/app_theme.dart';
import '../services/progress_manager.dart';
import 'task_screen.dart';

class Entry {
  final String dt;
  final String kt;
  final String description;
  final String category;
  final String recommendation;

  Entry({
    required this.dt,
    required this.kt,
    required this.description,
    required this.category,
    required this.recommendation,
  });
}

// --- БАЗА ПРОВОДОК ПО РАЗДЕЛАМ ---
final List<Entry> allEntries = [
  // I. Долгосрочные активы
  Entry(dt: '08', kt: '60', description: 'Приобретение основного средства у поставщика', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 02, 08'),
  Entry(dt: '01', kt: '08', description: 'Ввод основного средства в эксплуатацию', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 02, 08'),
  Entry(dt: '08-4', kt: '60', description: 'Приобретение НМА у поставщика', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 02, 04, 08'),
  Entry(dt: '04', kt: '08-4', description: 'Ввод НМА в эксплуатацию', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 02, 04, 08'),
  Entry(dt: '08', kt: '76', description: 'Приняты услуги посредника по покупке ОС', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 02, 08, 76'),
  Entry(dt: '08', kt: '07', description: 'Оборудование передано в монтаж', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 07, 08'),
  Entry(dt: '20', kt: '02', description: 'Начисление амортизации основных средств', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 02, 20'),
  Entry(dt: '91-4', kt: '01', description: 'Списание остаточной стоимости выбывшего ОС', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 02, 91'),
  Entry(dt: '04', kt: '08', description: 'Создан веб-сайт (принят к учету как НМА)', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 04, 08'),

  // II. Производственные запасы
  Entry(dt: '10', kt: '60', description: 'Поступление материалов от поставщика', category: 'II. Производственные запасы', recommendation: 'счета 10, 18, 60'),
  Entry(dt: '20', kt: '10', description: 'Списание материалов в основное производство', category: 'II. Производственные запасы', recommendation: 'счета 10, 20'),
  Entry(dt: '10', kt: '71', description: 'Оприходованы материалы, приобретенные подотчетником', category: 'II. Производственные запасы', recommendation: 'счета 10, 71'),
  Entry(dt: '94', kt: '10', description: 'Выявлена недостача материалов на складе', category: 'II. Производственные запасы', recommendation: 'счета 10, 94'),
  Entry(dt: '10', kt: '76-3', description: 'Признание претензии к поставщику за недостачу', category: 'II. Производственные запасы', recommendation: 'счета 10, 76'),
  Entry(dt: '10', kt: '60', description: 'Приобретение топлива по электронным картам', category: 'II. Производственные запасы', recommendation: 'счета 10, 60'),
  Entry(dt: '18', kt: '60', description: 'Отражен входной НДС по приобретенным материалам', category: 'II. Производственные запасы', recommendation: 'счета 10, 18, 60'),

  // III. Затраты на производство
  Entry(dt: '20', kt: '70', description: 'Начислена зарплата работникам основного производства', category: 'III. Затраты на производство', recommendation: 'счета 20, 26, 70'),
  Entry(dt: '20', kt: '69', description: 'Начислены страховые взносы в ФСЗН', category: 'III. Затраты на производство', recommendation: 'счета 20, 69'),
  Entry(dt: '20', kt: '76-2', description: 'Начислены взносы в Белгосстрах', category: 'III. Затраты на производство', recommendation: 'счета 20, 76'),
  Entry(dt: '43', kt: '20', description: 'Выпуск готовой продукции из производства', category: 'III. Затраты на производство', recommendation: 'счета 20, 43'),
  Entry(dt: '20', kt: '26', description: 'Списаны общехозяйственные расходы', category: 'III. Затраты на производство', recommendation: 'счета 20, 26'),
  Entry(dt: '20', kt: '96', description: 'Формирование резерва предстоящих платежей', category: 'III. Затраты на производство', recommendation: 'счета 20, 96'),

  // IV. Готовая продукция и товары
  Entry(dt: '62', kt: '90-1', description: 'Отражена выручка от реализации покупателю', category: 'IV. Готовая продукция и товары', recommendation: 'счета 43, 62, 90'),
  Entry(dt: '90-4', kt: '43', description: 'Списана себестоимость реализованной продукции', category: 'IV. Готовая продукция и товары', recommendation: 'счета 43, 90'),
  Entry(dt: '90-2', kt: '68-2', description: 'Начислен НДС с выручки от реализации', category: 'IV. Готовая продукция и товары', recommendation: 'счета 68, 90'),
  Entry(dt: '90-5', kt: '26', description: 'Списаны управленческие расходы на реализацию', category: 'IV. Готовая продукция и товары', recommendation: 'счета 26, 90'),
  Entry(dt: '51', kt: '62', description: 'Зачислен аванс от покупателя на расчетный счет', category: 'IV. Готовая продукция и товары', recommendation: 'счета 51, 62'),
  Entry(dt: '76-5', kt: '68-2', description: 'Начислен НДС с полученного аванса', category: 'IV. Готовая продукция и товары', recommendation: 'счета 68, 76'),

  // V. Денежные средства
  Entry(dt: '50', kt: '51', description: 'Снятие наличных с расчетного счета в кассу', category: 'V. Денежные средства', recommendation: 'счета 50, 51'),
  Entry(dt: '51', kt: '50', description: 'Внесение наличных из кассы на расчетный счет', category: 'V. Денежные средства', recommendation: 'счета 50, 51'),
  Entry(dt: '71', kt: '50', description: 'Выдача подотчетному лицу из кассы', category: 'V. Денежные средства', recommendation: 'счета 50, 71'),
  Entry(dt: '50', kt: '71', description: 'Возврат неиспользованного аванса в кассу', category: 'V. Денежные средства', recommendation: 'счета 50, 71'),
  Entry(dt: '60', kt: '51', description: 'Оплата поставщику с расчетного счета', category: 'V. Денежные средства', recommendation: 'счета 51, 60'),
  Entry(dt: '51', kt: '62', description: 'Поступление оплаты от покупателя на р/с', category: 'V. Денежные средства', recommendation: 'счета 51, 62'),
  Entry(dt: '91-4', kt: '51', description: 'Оплата банковских услуг за РКО', category: 'V. Денежные средства', recommendation: 'счета 51, 91'),

  // VI. Расчеты
  Entry(dt: '70', kt: '68-4', description: 'Удержан подоходный налог из заработной платы', category: 'VI. Расчеты', recommendation: 'счета 68, 70'),
  Entry(dt: '70', kt: '50', description: 'Выплата заработной платы из кассы', category: 'VI. Расчеты', recommendation: 'счета 50, 70'),
  Entry(dt: '70', kt: '51', description: 'Выплата заработной платы с р/с', category: 'VI. Расчеты', recommendation: 'счета 51, 70'),
  Entry(dt: '68-4', kt: '51', description: 'Перечислен подоходный налог в бюджет', category: 'VI. Расчеты', recommendation: 'счета 51, 68'),
  Entry(dt: '68-3', kt: '51', description: 'Уплата налога на прибыль в бюджет', category: 'VI. Расчеты', recommendation: 'счета 51, 68'),
  Entry(dt: '51', kt: '66', description: 'Получен краткосрочный кредит на р/с', category: 'VI. Расчеты', recommendation: 'счета 51, 66'),
  Entry(dt: '60', kt: '66-1', description: 'Переоформление долга поставщику в краткосрочный кредит', category: 'VI. Расчеты', recommendation: 'счета 60, 66'),

  // VII. Собственный капитал
  Entry(dt: '75-1', kt: '80', description: 'Формирование уставного капитала после регистрации', category: 'VII. Собственный капитал', recommendation: 'счета 75, 80'),
  Entry(dt: '75-2', kt: '68-4', description: 'Удержание подоходного налога с дивидендов', category: 'VII. Собственный капитал', recommendation: 'счета 68, 75'),
  Entry(dt: '84', kt: '82', description: 'Отчисления в резервный капитал из чистой прибыли', category: 'VII. Собственный капитал', recommendation: 'счета 82, 84'),
  Entry(dt: '86', kt: '98', description: 'Получение целевого финансирования', category: 'VII. Собственный капитал', recommendation: 'счета 86, 98'),

  // VIII. Финансовые результаты
  Entry(dt: '99', kt: '68-3', description: 'Начисление налога на прибыль', category: 'VIII. Финансовые результаты', recommendation: 'счета 68, 99'),
  Entry(dt: '99', kt: '84', description: 'Списание чистой прибыли на нераспределенную', category: 'VIII. Финансовые результаты', recommendation: 'счета 84, 99'),
  Entry(dt: '84', kt: '99', description: 'Списание убытка за счет нераспределенной прибыли', category: 'VIII. Финансовые результаты', recommendation: 'счета 84, 99'),
  Entry(dt: '99', kt: '91-1', description: 'Списание сальдо прочих доходов и расходов (прибыль)', category: 'VIII. Финансовые результаты', recommendation: 'счета 91, 99'),
  Entry(dt: '76-3', kt: '51', description: 'Уплата штрафа по претензии контрагента', category: 'VIII. Финансовые результаты', recommendation: 'счета 51, 76'),
  Entry(dt: '91-2', kt: '68-2', description: 'Начислен НДС от прочих доходов', category: 'VIII. Финансовые результаты', recommendation: 'счета 68, 91'),
];

final List<String> categories = [
  'I. Долгосрочные активы',
  'II. Производственные запасы',
  'III. Затраты на производство',
  'IV. Готовая продукция и товары',
  'V. Денежные средства',
  'VI. Расчеты',
  'VII. Собственный капитал',
  'VIII. Финансовые результаты',
];

class EntriesScreen extends StatefulWidget {
  const EntriesScreen({super.key});

  @override
  State<EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  final pm = ProgressManager();

  String selectedCategory = 'I. Долгосрочные активы';
  int difficulty = 1;
  List<Entry> questions = [];
  int currentIndex = 0;
  int correct = 0;
  int wrong = 0;
  bool isAnswered = false;
  String? selected;
  Timer? timer;
  int secondsLeft = 30;
  bool gameStarted = false;

  List<String> currentOptions = [];

  final TextEditingController dtController = TextEditingController();
  final TextEditingController ktController = TextEditingController();

  int get questionCount => 5;
  int get timePerQuestion => difficulty == 1 ? 0 : (difficulty == 2 ? 30 : 60);

  void startGame(int level) {
    if (!pm.isEntryLevelUnlocked(selectedCategory, level)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сначала пройди предыдущий уровень!')),
      );
      return;
    }

    difficulty = level;
    final rnd = Random(DateTime.now().microsecondsSinceEpoch);
    final pool = allEntries.where((e) => e.category == selectedCategory).toList();

    if (pool.isEmpty) return;

    pool.shuffle(rnd);
    questions = pool.take(min(questionCount, pool.length)).toList();
    currentIndex = 0;
    correct = 0;
    wrong = 0;
    isAnswered = false;
    selected = null;
    dtController.clear();
    ktController.clear();
    gameStarted = true;
    _prepareOptions();
    _startTimer();
    setState(() {});
  }

  void _prepareOptions() {
    if (difficulty == 3) {
      currentOptions = [];
      return;
    }
    final q = questions[currentIndex];
    final rnd = Random(DateTime.now().microsecondsSinceEpoch + currentIndex * 1000);
    final pool = allEntries.where((e) => e.description != q.description).toList();
    pool.shuffle(rnd);

    List<String> opts = [];
    if (difficulty == 1) {
      opts = [q.description, pool.first.description];
    } else {
      opts = [
        'Дт ${q.dt} — Кт ${q.kt}',
        ...pool.take(3).map((e) => 'Дт ${e.dt} — Кт ${e.kt}')
      ];
    }
    opts.shuffle(rnd);
    currentOptions = opts;
  }

  void _startTimer() {
    timer?.cancel();
    if (timePerQuestion == 0) return;
    secondsLeft = timePerQuestion;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft <= 1) {
        t.cancel();
        if (!isAnswered) _timeUp();
      } else {
        setState(() => secondsLeft--);
      }
    });
  }

  void _timeUp() {
    setState(() {
      isAnswered = true;
      selected = null;
      wrong++;
    });
    _nextAfterDelay();
  }

  void answer(String option) {
    if (isAnswered) return;
    timer?.cancel();
    final q = questions[currentIndex];

    final correctStr = difficulty == 2 ? 'Дт ${q.dt} — Кт ${q.kt}' : q.description;
    final isCorrect = option == correctStr;

    setState(() {
      isAnswered = true;
      selected = option;
      if (isCorrect) correct++; else wrong++;
    });
    _nextAfterDelay();
  }

  void checkManual() {
    if (isAnswered) return;
    timer?.cancel();
    final q = questions[currentIndex];
    
    // Умная очистка ввода от пробелов
    final userDt = dtController.text.trim().replaceAll(' ', '');
    final userKt = ktController.text.trim().replaceAll(' ', '');
    
    // Умная проверка: отрезаем субсчет (все, что после дефиса)
    final cleanQdt = q.dt.split('-').first;
    final cleanQkt = q.kt.split('-').first;
    final cleanUserDt = userDt.split('-').first;
    final cleanUserKt = userKt.split('-').first;

    // Засчитываем, если совпало полностью ИЛИ если совпал главный счет
    final isCorrect = (userDt == q.dt && userKt == q.kt) || 
                      (cleanUserDt == cleanQdt && cleanUserKt == cleanQkt);

    setState(() {
      isAnswered = true;
      if (isCorrect) correct++; else wrong++;
    });
    _nextAfterDelay();
  }

  void _nextAfterDelay() {
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      if (currentIndex < questions.length - 1) {
        setState(() {
          currentIndex++;
          isAnswered = false;
          selected = null;
          dtController.clear();
          ktController.clear();
        });
        _prepareOptions();
        _startTimer();
      } else {
        _finish();
      }
    });
  }

  Future<void> _finish() async {
    timer?.cancel();
    final score = (correct / questions.length) * 100;
    final passed = score >= 80;

    if (passed) {
      await pm.completeEntryLevel(selectedCategory, difficulty);
      if (mounted) setState(() {});
    }

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(passed ? '🎉 Отлично!' : '😕 Попробуй ещё', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Правильно: $correct из ${questions.length}\n(${score.toStringAsFixed(0)}%)',
          style: const TextStyle(fontSize: 16, color: AppTheme.textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => gameStarted = false);
            },
            child: const Text('ОК', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    dtController.dispose();
    ktController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.ink;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkCanvas : AppTheme.lightCanvas,
      appBar: AppBar(
        title: const Text('Тренировка проводок'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: !gameStarted ? _buildStartScreen(isDark, textColor) : _buildGame(isDark, textColor),
    );
  }

  Widget _buildStartScreen(bool isDark, Color textColor) {
    String rec = 'счета из раздела';
    final firstEntry = allEntries.where((e) => e.category == selectedCategory).firstOrNull;
    if (firstEntry != null) rec = firstEntry.recommendation;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Выбери раздел', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor), textAlign: TextAlign.center),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: categories.map((cat) {
              final isSelected = selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: AppTheme.primary.withOpacity(0.3),
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.primary : textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (val) {
                  setState(() {
                    selectedCategory = cat;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: AppTheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Перед началом рекомендуем повторить: $rec',
                    style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          Text('Выбери уровень', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor), textAlign: TextAlign.center),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLevelCircle(1, 'Лёгкий', Colors.green, Icons.sentiment_satisfied_alt_rounded, isDark, textColor),
              _buildLevelCircle(2, 'Средний', Colors.orange, Icons.sentiment_neutral_rounded, isDark, textColor),
              _buildLevelCircle(3, 'Сложный', Colors.redAccent, Icons.keyboard_rounded, isDark, textColor),
              _buildLevelCircle(4, 'Задача', Colors.purpleAccent, Icons.assignment_turned_in_rounded, isDark, textColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCircle(int level, String title, Color color, IconData icon, bool isDark, Color textColor) {
    bool isUnlocked = pm.isEntryLevelUnlocked(selectedCategory, level);
    bool isCompleted = pm.isEntryLevelCompleted(selectedCategory, level);

    Color currentColor = isUnlocked ? color : Colors.grey;
    IconData currentIcon = isUnlocked ? icon : Icons.lock;

    return GestureDetector(
      onTap: () {
        if (level == 4) {
          if (isUnlocked) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TaskScreen(category: selectedCategory)),
            ).then((_) => setState(() {}));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Сначала пройди предыдущий уровень!')),
            );
          }
        } else {
          startGame(level);
        }
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: currentColor.withOpacity(isUnlocked ? 0.15 : 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(color: currentColor.withOpacity(isUnlocked ? 1.0 : 0.3), width: 2),
                ),
                child: Icon(currentIcon, color: isUnlocked ? currentColor : Colors.grey, size: 32),
              ),
              if (isCompleted)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppTheme.success, shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Colors.white, size: 14),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isUnlocked ? textColor : Colors.grey,
              fontSize: 14
            )
          ),
          Text(
            level == 1 ? '2 варианта' : (level == 2 ? '4 варианта' : (level == 3 ? 'Ввод' : 'Самолётик')),
            style: const TextStyle(color: AppTheme.textGrey, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildGame(bool isDark, Color textColor) {
    if (questions.isEmpty) return const Center(child: Text('Нет проводок'));

    final q = questions[currentIndex];
    final showTimer = timePerQuestion > 0;
    final correctStr = difficulty == 2 ? 'Дт ${q.dt} — Кт ${q.kt}' : q.description;
    
    // ИСПРАВЛЕНО: Правильная проверка для ручного ввода (уровень 3)
    bool isCorrectAnswer = false;
    if (difficulty == 3) {
      final userDt = dtController.text.trim().replaceAll(' ', '');
      final userKt = ktController.text.trim().replaceAll(' ', '');
      final cleanQdt = q.dt.split('-').first;
      final cleanQkt = q.kt.split('-').first;
      final cleanUserDt = userDt.split('-').first;
      final cleanUserKt = userKt.split('-').first;
      
      isCorrectAnswer = (userDt == q.dt && userKt == q.kt) || 
                        (cleanUserDt == cleanQdt && cleanUserKt == cleanQkt);
    } else {
      isCorrectAnswer = selected == correctStr;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${currentIndex + 1} / ${questions.length}', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              if (showTimer)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: secondsLeft <= 5 ? Colors.red.withOpacity(0.2) : AppTheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('⏱ $secondsLeft с', style: TextStyle(
                    color: secondsLeft <= 5 ? Colors.red : AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  )),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                if (difficulty == 1) ...[
                  Text('Дт ${q.dt}  —  Кт ${q.kt}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: textColor)),
                  const SizedBox(height: 8),
                  const Text('Что это за операция?', style: TextStyle(color: AppTheme.textGrey, fontSize: 14)),
                ] else if (difficulty == 2) ...[
                  const Text('Выбери правильные счета', style: TextStyle(color: AppTheme.textGrey, fontSize: 14)),
                  const SizedBox(height: 16),
                  Text(q.description, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textColor)),
                ] else ...[
                  const Text('Введи номера счетов для этой операции', style: TextStyle(color: AppTheme.textGrey, fontSize: 14)),
                  const SizedBox(height: 16),
                  Text(q.description, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textColor)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (difficulty < 3) ...[
            ...currentOptions.map((opt) {
              final isSelected = opt == selected;
              Color bg = isDark ? AppTheme.darkSurface : Colors.white;
              Color txt = textColor;
              if (isAnswered) {
                if (opt == correctStr) { bg = AppTheme.success; txt = Colors.white; }
                else if (isSelected) { bg = AppTheme.error; txt = Colors.white; }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: isAnswered ? null : () => answer(opt),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black12),
                    ),
                    child: Text(opt, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: txt)),
                  ),
                ),
              );
            })
          ],

          if (difficulty == 3) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dtController,
                    enabled: !isAnswered,
                    decoration: InputDecoration(
                      labelText: 'Дебет',
                      hintText: 'например 50',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: isDark ? AppTheme.darkSurface : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: ktController,
                    enabled: !isAnswered,
                    decoration: InputDecoration(
                      labelText: 'Кредит',
                      hintText: 'например 51',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: isDark ? AppTheme.darkSurface : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isAnswered ? null : checkManual,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Проверить', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            if (isAnswered) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // ТЕПЕРЬ ЦВЕТ РАБОТАЕТ ПРАВИЛЬНО
                  color: isCorrectAnswer ? AppTheme.success.withOpacity(0.15) : AppTheme.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      isCorrectAnswer ? 'Верно!' : 'Правильный ответ:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: isCorrectAnswer ? AppTheme.success : AppTheme.error),
                    ),
                    const SizedBox(height: 8),
                    Text('Дт ${q.dt}  —  Кт ${q.kt}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textColor)),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}