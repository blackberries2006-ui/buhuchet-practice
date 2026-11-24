import 'package:shared_preferences/shared_preferences.dart';
import '../data/sections_data.dart';
import '../data/accounts_data.dart';

class ProgressManager {
  static final ProgressManager _instance = ProgressManager._internal();
  factory ProgressManager() => _instance;
  ProgressManager._internal();

  List<String> completedSteps = [];
  List<String> favorites = [];
  Map<String, Map<String, int>> sectionStats = {};
  Map<String, Map<String, dynamic>> cardProgress = {};

  int completedSmartDays = 0;
  String lastLessonDate = '';
  int streakDays = 0;
  String lastActiveDate = '';

  // --- ПРОВОДКИ: ПРОЙДЕННЫЕ УРОВНИ ---
  // Ключ вида "entries|раздел|уровень"
  Set<String> _completedEntryLevels = {};

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    completedSteps = prefs.getStringList('completedSteps') ?? [];
    favorites = prefs.getStringList('favorites') ?? [];

    completedSmartDays = prefs.getInt('completedSmartDays') ?? 0;
    lastLessonDate = prefs.getString('lastLessonDate') ?? '';

    streakDays = prefs.getInt('streakDays') ?? 0;
    lastActiveDate = prefs.getString('lastActiveDate') ?? '';

    _completedEntryLevels = (prefs.getStringList('completedEntryLevels') ?? []).toSet();

    _checkStreakOnStartup();

    final statsStr = prefs.getStringList('sectionStats') ?? [];
    sectionStats = {};
    for (var s in statsStr) {
      final parts = s.split('|');
      if (parts.length == 3) {
        sectionStats[parts[0]] = {
          'known': int.tryParse(parts[1]) ?? 0,
          'unknown': int.tryParse(parts[2]) ?? 0
        };
      }
    }

    final cardsStr = prefs.getStringList('cardProgress') ?? [];
    cardProgress = {};
    for (var s in cardsStr) {
      final parts = s.split('|');
      if (parts.length == 3) {
        cardProgress[parts[0]] = {
          'score': int.tryParse(parts[1]) ?? 0,
          'nextReview': parts[2],
        };
      }
    }
  }

  void _checkStreakOnStartup() {
    if (lastActiveDate.isEmpty) return;
    final lastDate = DateTime.parse(lastActiveDate);
    final diff = DateTime.now().difference(lastDate).inDays;
    if (diff > 1) {
      streakDays = 0;
      _saveStreak();
    }
  }

  Future<void> _saveStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streakDays', streakDays);
    await prefs.setString('lastActiveDate', lastActiveDate);
  }

  bool isCompleted(String stepId) => completedSteps.contains(stepId);

  Future<void> completeStep(String stepId) async {
    if (!completedSteps.contains(stepId)) {
      completedSteps.add(stepId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completedSteps', completedSteps);
    }
  }

  bool isTodayLessonDone() {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return lastLessonDate == today;
  }

  Future<void> completeSmartDay() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    if (lastLessonDate == today) return;

    completedSmartDays++;
    lastLessonDate = today;

    if (lastActiveDate.isEmpty) {
      streakDays = 1;
    } else {
      final last = DateTime.parse(lastActiveDate);
      final diff = DateTime.now().difference(last).inDays;
      if (diff == 1) {
        streakDays++;
      } else if (diff > 1) {
        streakDays = 1;
      }
    }
    lastActiveDate = today;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('completedSmartDays', completedSmartDays);
    await prefs.setString('lastLessonDate', lastLessonDate);
    await _saveStreak();
  }

  Future<void> resetProgress() async {
    completedSteps.clear();
    cardProgress.clear();
    sectionStats.clear();
    _completedEntryLevels.clear();
    completedSmartDays = 0;
    lastLessonDate = '';
    streakDays = 0;
    lastActiveDate = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('completedSteps');
    await prefs.remove('cardProgress');
    await prefs.remove('sectionStats');
    await prefs.remove('completedEntryLevels');
    await prefs.remove('completedSmartDays');
    await prefs.remove('lastLessonDate');
    await prefs.remove('streakDays');
    await prefs.remove('lastActiveDate');
  }

  bool isFavorite(String accountNum) => favorites.contains(accountNum);

  Future<void> toggleFavorite(String accountNum) async {
    if (favorites.contains(accountNum)) {
      favorites.remove(accountNum);
    } else {
      favorites.add(accountNum);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', favorites);
  }

  List<String> getFavorites() => List.unmodifiable(favorites);

  Future<void> saveSectionResult(String sectionName, int known, int unknown) async {
    if (sectionName == 'Все разделы (Повторить всё)' || sectionName == 'Избранное') return;
    final current = sectionStats[sectionName] ?? {'known': 0, 'unknown': 0};
    sectionStats[sectionName] = {
      'known': current['known']! + known,
      'unknown': current['unknown']! + unknown,
    };
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('sectionStats',
      sectionStats.entries.map((e) => '${e.key}|${e.value['known']}|${e.value['unknown']}').toList());
  }

  Map<String, int> getSectionStats(String sectionName) {
    return sectionStats[sectionName] ?? {'known': 0, 'unknown': 0};
  }

  Future<void> updateCardProgress(String accountNum, bool isCorrect) async {
    final today = DateTime.now();
    final current = cardProgress[accountNum];
    int score = current?['score'] ?? 0;

    int daysToAdd = 1;

    if (isCorrect) {
      score++;
      if (score == 1) daysToAdd = 1;
      else if (score == 2) daysToAdd = 3;
      else if (score == 3) daysToAdd = 7;
      else if (score >= 4) daysToAdd = 14;
    } else {
      score = 0;
      daysToAdd = 1;
    }

    final nextDate = today.add(Duration(days: daysToAdd));
    final nextReviewStr = nextDate.toIso8601String().split('T')[0];

    cardProgress[accountNum] = {
      'score': score,
      'nextReview': nextReviewStr,
    };
    await _saveCards();
  }

  Future<void> _saveCards() async {
    final prefs = await SharedPreferences.getInstance();
    final list = cardProgress.entries.map((e) => '${e.key}|${e.value['score']}|${e.value['nextReview']}').toList();
    await prefs.setStringList('cardProgress', list);
  }

  int getCardScore(String accountNum) {
    return cardProgress[accountNum]?['score'] ?? 0;
  }

  Map<String, Map<String, int>> getDetailedSectionStats() {
    Map<String, Map<String, int>> stats = {};

    for (var section in sectionsInfo) {
      final accounts = globalAccounts.where((a) => a.section == section.title).toList();
      int mastered = 0;
      int learning = 0;
      int unlearned = 0;

      for (var acc in accounts) {
        final data = cardProgress[acc.num];
        if (data == null) {
          unlearned++;
        } else {
          int score = data['score'] ?? 0;
          if (score >= 4) {
            mastered++;
          } else if (score > 0) {
            learning++;
          } else {
            unlearned++;
          }
        }
      }

      stats[section.title] = {
        'total': accounts.length,
        'mastered': mastered,
        'learning': learning,
        'unlearned': unlearned,
      };
    }
    return stats;
  }

  Map<String, int> getTodayStats(List<String> allAccountNums) {
    int todayDeckSize = getSmartDeck().length;
    return {
      'totalToday': todayDeckSize,
    };
  }

  int getCurrentSectionIndex() {
    return completedSmartDays % sectionsInfo.length;
  }

  List<String> getSmartDeck() {
    final currentSectionIdx = getCurrentSectionIndex();
    if (currentSectionIdx >= sectionsInfo.length) return [];

    final currentSectionName = sectionsInfo[currentSectionIdx].title;

    List<String> newSectionAccounts = globalAccounts
        .where((a) => a.section == currentSectionName)
        .map((a) => a.num)
        .toList();

    List<String> repeatAccounts = [];
    if (currentSectionIdx > 0) {
      final prevSectionName = sectionsInfo[currentSectionIdx - 1].title;
      List<String> prevAccounts = globalAccounts
          .where((a) => a.section == prevSectionName)
          .map((a) => a.num)
          .toList();

      prevAccounts.shuffle();
      int takeCount = (prevAccounts.length / 2).round();
      repeatAccounts = prevAccounts.take(takeCount).toList();
    }

    List<String> finalDeck = [...newSectionAccounts, ...repeatAccounts];
    finalDeck.shuffle();

    return finalDeck;
  }

  // ============================================================
  // --- ПРОВОДКИ: УРОВНИ (НОВЫЙ БЛОК) ---
  // ============================================================

  String _entryKey(String category, int level) => 'entries|$category|$level';

  bool isEntryLevelCompleted(String category, int level) {
    return _completedEntryLevels.contains(_entryKey(category, level));
  }

  Future<void> completeEntryLevel(String category, int level) async {
    final key = _entryKey(category, level);
    if (_completedEntryLevels.add(key)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completedEntryLevels', _completedEntryLevels.toList());
    }
  }

  bool isEntryLevelUnlocked(String category, int level) {
    if (level == 1) return true;
    return isEntryLevelCompleted(category, level - 1);
  }

  // --- СЕКРЕТНЫЙ КОД ---
  Future<void> activateSecretCode() async {
    for (int i = 0; i < 7; i++) {
      if (!completedSteps.contains('sec_${i}_main')) {
        completedSteps.add('sec_${i}_main');
      }
      if (!completedSteps.contains('sec_${i}_sub')) {
        completedSteps.add('sec_${i}_sub');
      }
      
      String sectionName = sectionsInfo[i].title; 
      for (int level = 1; level <= 4; level++) {
        String key = _entryKey(sectionName, level);
        _completedEntryLevels.add(key);
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('completedSteps', completedSteps);
    await prefs.setStringList('completedEntryLevels', _completedEntryLevels.toList());
  }
}