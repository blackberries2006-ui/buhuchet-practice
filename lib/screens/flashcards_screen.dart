import 'package:flutter/material.dart';
import 'dart:math';
import '../data/accounts_data.dart';
import '../models/account.dart';
import '../theme/app_theme.dart';
import '../data/sections_data.dart';
import '../services/progress_manager.dart';

class FlashcardsScreen extends StatefulWidget {
  final bool isFavoritesMode;
  final bool isSmartMode;
  const FlashcardsScreen({super.key, this.isFavoritesMode = false, this.isSmartMode = false});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  final pm = ProgressManager();

  @override
  Widget build(BuildContext context) {
    if (widget.isSmartMode) {
      return const FlashcardDeckScreen(
        sectionName: 'Умный режим',
        isFavoritesMode: false,
        isSmartMode: true,
      );
    }

    final sections = [
      'Все разделы (Повторить всё)',
      ...sectionsInfo.map((e) => e.title).toList(),
    ];

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : AppTheme.ink;
    int favCount = pm.getFavorites().length;

    // Получаем статистику для всех разделов
    final detailedStats = pm.getDetailedSectionStats();

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkCanvas : AppTheme.lightCanvas,
      appBar: AppBar(
        title: Text('Карточки', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (favCount > 0)
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FlashcardDeckScreen(
                      sectionName: 'Избранное',
                      isFavoritesMode: true,
                    ),
                  ),
                );
                setState(() {});
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade700, Colors.orange.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orangeAccent.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.bookmark_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Повторить избранное', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('$favCount счетов добавлено', style: const TextStyle(fontSize: 14, color: Colors.white70)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Colors.white),
                  ],
                ),
              ),
            ),
          
          ...sections.asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value;
            final isAll = index == 0;
            
            final info = isAll ? null : sectionsInfo[index - 1];
            final iconData = isAll ? Icons.all_inclusive_rounded : info!.icon;
            final iconColor = isAll ? AppTheme.primary : info!.color;

            // Статистика для конкретного раздела (только для 8 основных)
            final stat = isAll ? null : detailedStats[section];
            final total = stat?['total'] ?? 0;
            final mastered = stat?['mastered'] ?? 0;
            final learning = stat?['learning'] ?? 0;
            final unlearned = stat?['unlearned'] ?? 0;
            final progress = total > 0 ? mastered / total : 0.0;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: isDark
                    ? Border.all(color: Colors.white.withOpacity(0.05))
                    : Border.all(color: Colors.black.withOpacity(0.05)),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FlashcardDeckScreen(
                          sectionName: section,
                          isFavoritesMode: false,
                        ),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: iconColor.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(iconData, color: iconColor, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                section,
                                style: TextStyle(fontWeight: FontWeight.w700, color: textColor, fontSize: 16),
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: AppTheme.textGrey),
                          ],
                        ),
                        // Блок статистики (только для 8 основных разделов)
                        if (!isAll) ...[
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Освоено: $mastered', style: const TextStyle(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w600)),
                              Text('В процессе: $learning', style: const TextStyle(fontSize: 11, color: AppTheme.warning, fontWeight: FontWeight.w600)),
                              Text('Осталось: $unlearned', style: const TextStyle(fontSize: 11, color: AppTheme.textGrey, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Кастомный прогресс-бар (как на скриншоте)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white12 : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: progress,
                                  child: Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [iconColor, iconColor.withOpacity(0.7)],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class FlashcardDeckScreen extends StatefulWidget {
  final String sectionName;
  final bool isFavoritesMode;
  final bool isSmartMode;

  const FlashcardDeckScreen({
    super.key, 
    required this.sectionName,
    this.isFavoritesMode = false,
    this.isSmartMode = false,
  });

  @override
  State<FlashcardDeckScreen> createState() => _FlashcardDeckScreenState();
}

class _FlashcardDeckScreenState extends State<FlashcardDeckScreen> {
  final pm = ProgressManager();
  late List<Account> deck;
  int currentIndex = 0;
  bool isRevealed = false;

  Map<String, bool> _firstAnswers = {};

  double _dragX = 0;
  double _dragY = 0;
  double _rotation = 0;

  @override
  void initState() {
    super.initState();
    _loadDeck();
  }

  void _loadDeck() {
    List<Account> baseDeck = [];

    if (widget.isFavoritesMode) {
      final favNums = pm.getFavorites();
      baseDeck = globalAccounts.where((a) => favNums.contains(a.num)).toList()..shuffle(Random());
    } else if (widget.isSmartMode) {
      final smartNums = pm.getSmartDeck();
      baseDeck = globalAccounts.where((a) => smartNums.contains(a.num)).toList()..shuffle(Random());
    } else if (widget.sectionName.contains('Все разделы')) {
      baseDeck = List.from(globalAccounts)..shuffle(Random());
    } else {
      baseDeck = globalAccounts.where((a) => a.section == widget.sectionName).toList()..shuffle(Random());
    }

    deck = baseDeck;
    _firstAnswers.clear();
  }

  void resetCard() {
    setState(() {
      _dragX = 0;
      _dragY = 0;
      _rotation = 0;
      isRevealed = false;
    });
  }

  void nextCard(bool known) {
    final currentAccount = deck[currentIndex];
    
    if (!_firstAnswers.containsKey(currentAccount.num)) {
      _firstAnswers[currentAccount.num] = known;
    }

    if (known) {
      pm.updateCardProgress(currentAccount.num, true);
      setState(() {
        currentIndex++;
        resetCard();
      });
    } else {
      pm.updateCardProgress(currentAccount.num, false);
      setState(() {
        deck.add(currentAccount); 
        currentIndex++; 
        resetCard();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? Colors.white : AppTheme.ink;

    Color knewColor = isDark ? Colors.white : AppTheme.success;
    Color didntKnowColor = isDark ? Colors.white : AppTheme.error;

    if (currentIndex >= deck.length) {
      int finalKnown = 0;
      int finalUnknown = 0;
      _firstAnswers.forEach((num, wasKnown) {
        if (wasKnown) finalKnown++;
        else finalUnknown++;
      });

      final totalUnique = _firstAnswers.length;
      final percent = totalUnique > 0 ? (finalKnown / totalUnique * 100).round() : 0;
      
      // ВАЖНО: Если это умный режим и пройдено 70% и больше — ЗАВЕРШАЕМ ДЕНЬ
      if (widget.isSmartMode && percent >= 70) {
         pm.completeSmartDay();
      }

      String title = widget.isFavoritesMode ? 'Избранное' : (widget.isSmartMode ? 'Умный режим' : widget.sectionName);

      return Scaffold(
        backgroundColor: isDark ? AppTheme.darkCanvas : AppTheme.lightCanvas,
        appBar: AppBar(
          title: Text(title), 
          backgroundColor: Colors.transparent, 
          elevation: 0, 
          iconTheme: IconThemeData(color: textColor)
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  deck.isEmpty ? Icons.bookmark_border_rounded : Icons.celebration_rounded, 
                  size: 80, 
                  color: AppTheme.primary
                ),
                const SizedBox(height: 16),
                Text(
                  deck.isEmpty ? 'В избранном пока пусто' : 'Колода пройдена!', 
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)
                ),
                const SizedBox(height: 32),
                
                if (totalUnique > 0) ...[
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statItem('Знал', finalKnown, AppTheme.success, isDark),
                            Container(width: 1, height: 50, color: AppTheme.textGrey.withOpacity(0.3)),
                            _statItem('Не знал', finalUnknown, AppTheme.error, isDark),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Успешность: $percent%',
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold,
                            color: percent >= 70 ? AppTheme.success : (percent >= 40 ? Colors.orange : AppTheme.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                if (deck.isNotEmpty) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        setState(() {
                          _loadDeck(); 
                          currentIndex = 0;
                          resetCard();
                        });
                      },
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                      label: const Text('Повторить', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Вернуться назад', style: TextStyle(color: AppTheme.textGrey, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentAccount = deck[currentIndex];
    final isFav = pm.isFavorite(currentAccount.num);
    final cardScore = pm.getCardScore(currentAccount.num);

    double greenOpacity = _dragX > 0 ? (_dragX / 100).clamp(0.0, 1.0) : 0.0;
    double redOpacity = _dragX < 0 ? (-_dragX / 100).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkCanvas : AppTheme.lightCanvas,
      appBar: AppBar(
        title: Text('${currentIndex + 1} / ${deck.length}', style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (currentIndex) / deck.length,
            backgroundColor: isDark ? Colors.white12 : Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _dragX += details.delta.dx;
                    _dragY += details.delta.dy;
                    _rotation = _dragX / 1000;
                  });
                },
                onPanEnd: (details) {
                  if (_dragX > 100) {
                    setState(() => _dragX = 500);
                    Future.delayed(const Duration(milliseconds: 200), () => nextCard(true));
                  } else if (_dragX < -100) {
                    setState(() => _dragX = -500);
                    Future.delayed(const Duration(milliseconds: 200), () => nextCard(false));
                  } else {
                    setState(() {
                      _dragX = 0;
                      _dragY = 0;
                      _rotation = 0;
                    });
                  }
                },
                onTap: () {
                  setState(() => isRevealed = !isRevealed);
                },
                child: Stack(
                  children: [
                    Transform.translate(
                      offset: Offset(_dragX, _dragY),
                      child: Transform.rotate(
                        angle: _rotation,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7B61FF), Color(0xFF9F8BFF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Иконка закладки
                                  GestureDetector(
                                    onTap: () async {
                                      await pm.toggleFavorite(currentAccount.num);
                                      setState(() {});
                                      if (widget.isFavoritesMode && !pm.isFavorite(currentAccount.num)) {
                                         _loadDeck(); 
                                         if (deck.isEmpty) currentIndex = 0;
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                                      child: Icon(
                                        isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, 
                                        color: isFav ? Colors.amber : Colors.white, 
                                        size: 24
                                      ),
                                    ),
                                  ),
                                  // Счетчик прогресса
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          '$cardScore/4',
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              
                              Text(
                                isRevealed ? currentAccount.name : currentAccount.num,
                                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1, letterSpacing: -1),
                              ),
                              const SizedBox(height: 16),
                              
                              Text(
                                isRevealed ? 'Тип счета: ${currentAccount.type}' : 'Нажми, чтобы увидеть название',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.8)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_dragX > 0)
                      Positioned(
                        top: 60,
                        left: 40,
                        child: Opacity(
                          opacity: greenOpacity,
                          child: Transform.rotate(
                            angle: -0.2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: knewColor, width: 4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'ЗНАЛ',
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: knewColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (_dragX < 0)
                      Positioned(
                        top: 60,
                        right: 40,
                        child: Opacity(
                          opacity: redOpacity,
                          child: Transform.rotate(
                            angle: 0.2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: didntKnowColor, width: 4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'НЕ ЗНАЛ',
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: didntKnowColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            if (isRevealed)
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 64,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.error,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        ),
                        onPressed: () {
                          setState(() => _dragX = -500);
                          Future.delayed(const Duration(milliseconds: 200), () => nextCard(false));
                        },
                        child: const Text('Не знал', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 64,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.success,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        ),
                        onPressed: () {
                          setState(() => _dragX = 500);
                          Future.delayed(const Duration(milliseconds: 200), () => nextCard(true));
                        },
                        child: const Text('Знал', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                height: 64,
                alignment: Alignment.center,
                child: Text(
                  'Свайпни влево или вправо',
                  style: TextStyle(fontSize: 16, color: AppTheme.textGrey, fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, int count, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : AppTheme.textGrey),
        ),
      ],
    );
  }
}