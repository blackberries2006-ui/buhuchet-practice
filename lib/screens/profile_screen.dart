import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'settings_screen.dart';
import '../services/progress_manager.dart';
import '../data/sections_data.dart';
import '../data/accounts_data.dart';
import 'flashcards_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const ProfileScreen({super.key, required this.themeNotifier});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Имя';
  bool _isFemale = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _userName = prefs.getString('userName') ?? 'Имя';
        _isFemale = prefs.getBool('isFemale') ?? false;
      });
    }
  }

  Future<void> _saveUserData(String name, bool isFemale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setBool('isFemale', isFemale);
    setState(() {
      _userName = name;
      _isFemale = isFemale;
    });
  }

  void _showEditProfileDialog() {
    String tempName = _userName;
    bool tempIsFemale = _isFemale;
    TextEditingController controller = TextEditingController(text: _userName);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            bool isDark = Theme.of(context).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? AppTheme.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Text('Редактировать профиль', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Ваше имя',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onChanged: (val) => tempName = val,
                    controller: controller,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChoiceChip(
                        label: const Text('Мужской'),
                        selected: !tempIsFemale,
                        onSelected: (val) => setDialogState(() => tempIsFemale = false),
                      ),
                      ChoiceChip(
                        label: const Text('Женский'),
                        selected: tempIsFemale,
                        selectedColor: Colors.pinkAccent.withOpacity(0.3),
                        onSelected: (val) => setDialogState(() => tempIsFemale = true),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена', style: TextStyle(color: AppTheme.textGrey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveUserData(tempName, tempIsFemale);
                    Navigator.pop(context);
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? AppTheme.darkCanvas : AppTheme.lightCanvas;
    Color textColor = isDark ? Colors.white : AppTheme.ink;
    Color cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white; 
    
    Color avatarColor = _isFemale ? Colors.pinkAccent : AppTheme.primary;

    final progressManager = ProgressManager();
    
    final allNums = globalAccounts.map((a) => a.num).toList();
    final cardStats = progressManager.getTodayStats(allNums);
    bool isDoneToday = progressManager.isTodayLessonDone();

    int currentIdx = progressManager.getCurrentSectionIndex();
    String currentSectionTitle = currentIdx < sectionsInfo.length 
        ? sectionsInfo[currentIdx].title 
        : "Все разделы пройдены";

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Профиль', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: textColor), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(themeNotifier: widget.themeNotifier)))
          ),
        ]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            GestureDetector(
              onTap: _showEditProfileDialog,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: avatarColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isFemale ? Icons.face_3_rounded : Icons.person_rounded, 
                  size: 55, 
                  color: avatarColor
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_userName, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: textColor)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _showEditProfileDialog,
                  child: const Icon(Icons.edit_rounded, size: 20, color: AppTheme.textGrey),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text('${progressManager.streakDays}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Будущий бухгалтер', style: TextStyle(fontSize: 16, color: AppTheme.textGrey, fontWeight: FontWeight.w500)),
            
            const SizedBox(height: 32),
            
            // БЛОК ДОМАШНЕГО ЗАДАНИЯ
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(32),
                border: isDark ? Border.all(color: Colors.white.withOpacity(0.05)) : Border.all(color: Colors.black.withOpacity(0.05)),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                ]
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -12),
                        child: Transform.rotate(
                          angle: -0.06,
                          child: Container(
                            width: 130,
                            height: 90,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -6),
                        child: Transform.rotate(
                          angle: 0.06,
                          child: Container(
                            width: 130,
                            height: 90,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF3A3A3C) : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 130,
                        height: 90,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF48484A) : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(isDoneToday ? '✓' : '${cardStats['totalToday']}', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: textColor)),
                            Text(isDoneToday ? 'Выполнено' : 'Карточки на сегодня', style: TextStyle(fontSize: 10, color: AppTheme.textGrey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    isDoneToday ? 'Приходите завтра!' : 'Текущий раздел: $currentSectionTitle',
                    style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.7), fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: isDoneToday ? null : () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (_) => const FlashcardsScreen(isSmartMode: true)
                          )
                        ).then((_) {
                          setState(() {});
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDoneToday ? Colors.grey.shade600 : const Color(0xFF7B61FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                      icon: Icon(
                        isDoneToday ? Icons.check_circle : Icons.style_rounded, 
                        color: Colors.white
                      ),
                      label: Text(
                        isDoneToday ? 'На сегодня всё' : 'Учить', 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- БЛОК ПРОГРЕСС ПО РАЗДЕЛАМ ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Прогресс по разделам',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
              ),
            ),
            const SizedBox(height: 16),
            ...sectionsInfo.asMap().entries.map((entry) {
              int index = entry.key;
              SectionInfo section = entry.value;
              
              bool mainDone = progressManager.isCompleted('sec_${index}_main');
              bool subDone = progressManager.isCompleted('sec_${index}_sub');
              bool entriesDone = progressManager.isEntryLevelCompleted(section.title, 1);
              bool taskDone = progressManager.isEntryLevelCompleted(section.title, 4);

              return _buildSectionProgressWidget(
                section, mainDone, subDone, entriesDone, taskDone, isDark, textColor, cardColor
              );
            }).toList(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ОБЪЕДИНЕННЫЙ ВИДЖЕТ (Счета + Субсчета + Проводки + Задачи)
  Widget _buildSectionProgressWidget(SectionInfo section, bool mainDone, bool subDone, bool entriesDone, bool taskDone, bool isDark, Color textColor, Color cardColor) {
    bool isOffBalance = section.title == 'Забалансовые счета';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.05)) : Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: section.color.withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(section.icon, color: section.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(section.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor))),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildStatusChip('Счета', mainDone),
              if (!isOffBalance) ...[
                _buildStatusChip('Субсчета', subDone),
                _buildStatusChip('Проводки', entriesDone),
                _buildStatusChip('Задача', taskDone),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, bool isDone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDone ? AppTheme.success.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isDone ? AppTheme.success.withOpacity(0.5) : Colors.transparent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isDone ? Icons.check : Icons.close, size: 12, color: isDone ? AppTheme.success : Colors.grey),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDone ? AppTheme.success : Colors.grey)),
        ],
      ),
    );
  }
}