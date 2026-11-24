import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../services/progress_manager.dart';

class BaseTaskLayout extends StatefulWidget {
  final String category;
  final String scoreNumber;
  final String taskDescription;
  final List<Map<String, String>> operations;

  const BaseTaskLayout({
    super.key,
    required this.category,
    required this.scoreNumber,
    required this.taskDescription,
    required this.operations,
  });

  @override
  State<BaseTaskLayout> createState() => _BaseTaskLayoutState();
}

class _BaseTaskLayoutState extends State<BaseTaskLayout> {
  final pm = ProgressManager();
  late List<Map<String, TextEditingController>> _rowControllers;

  final autoDtController = TextEditingController(text: '-');
  final autoKtController = TextEditingController(text: '-');
  final autoAmountController = TextEditingController(text: '0');

  List<Map<String, String>> dtOps = [];
  List<Map<String, String>> ktOps = [];
  double totalDt = 0;
  double totalKt = 0;
  double skDt = 0;
  double skKt = 0;

  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _rowControllers = List.generate(
      widget.operations.length,
      (_) => {
        'dt': TextEditingController(),
        'kt': TextEditingController(),
        'amount': TextEditingController(),
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => calculateTurnovers());
  }

  @override
  void dispose() {
    for (var map in _rowControllers) {
      map['dt']?.dispose();
      map['kt']?.dispose();
      map['amount']?.dispose();
    }
    autoDtController.dispose();
    autoKtController.dispose();
    autoAmountController.dispose();
    super.dispose();
  }

  void calculateTurnovers() {
    dtOps.clear();
    ktOps.clear();
    totalDt = 0;
    totalKt = 0;

    String prefix = widget.scoreNumber;
    String resultSubaccount = prefix == '90' ? '90-11' : '91-9';

    for (int i = 0; i < _rowControllers.length; i++) {
      String dt = _rowControllers[i]['dt']!.text.trim();
      String kt = _rowControllers[i]['kt']!.text.trim();
      String amountStr = _rowControllers[i]['amount']!.text.trim().replaceAll(',', '.');
      double amount = double.tryParse(amountStr) ?? 0;

      if (dt.contains(resultSubaccount) || kt.contains(resultSubaccount)) continue;

      if (dt.startsWith(prefix)) {
        totalDt += amount;
        dtOps.add({'num': '${i + 1})', 'amount': amount.toStringAsFixed(2)});
      }
      if (kt.startsWith(prefix)) {
        totalKt += amount;
        ktOps.add({'num': '${i + 1})', 'amount': amount.toStringAsFixed(2)});
      }
    }

    skDt = totalDt - totalKt;
    skKt = totalKt - totalDt;

    if (skDt < 0) skDt = 0;
    if (skKt < 0) skKt = 0;

    setState(() {
      if (skDt > 0) {
        autoDtController.text = '99';
        autoKtController.text = resultSubaccount;
        autoAmountController.text = skDt.toStringAsFixed(2);
      } else if (skKt > 0) {
        autoDtController.text = resultSubaccount;
        autoKtController.text = '99';
        autoAmountController.text = skKt.toStringAsFixed(2);
      } else {
        autoDtController.text = '-';
        autoKtController.text = '-';
        autoAmountController.text = '0';
      }
    });
  }

  void fillExample() {
    for (int i = 0; i < widget.operations.length; i++) {
      _rowControllers[i]['dt']!.text = widget.operations[i]['dt']!;
      _rowControllers[i]['kt']!.text = widget.operations[i]['kt']!;
      _rowControllers[i]['amount']!.text = widget.operations[i]['amount']!;
    }
    calculateTurnovers();
    setState(() { isChecked = false; });
  }

  Future<void> checkTask() async {
    calculateTurnovers();
    setState(() {
      isChecked = true;
    });

    bool allCorrect = true;
    for (int i = 0; i < widget.operations.length; i++) {
      String userDt = _rowControllers[i]['dt']!.text.trim().replaceAll(' ', '');
      String userKt = _rowControllers[i]['kt']!.text.trim().replaceAll(' ', '');
      String userAmount = _rowControllers[i]['amount']!.text.trim().replaceAll(',', '.').replaceAll(' ', '');
      
      if (userDt != widget.operations[i]['dt']! || userKt != widget.operations[i]['kt']! || userAmount != widget.operations[i]['amount']!) {
        allCorrect = false;
        break;
      }
    }

    if (allCorrect) {
      await pm.completeEntryLevel(widget.category, 4);
      
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.darkSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('🎉 Превосходно!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: const Text(
            'Ты успешно справился с практической задачей!\n\nФинансовый результат рассчитан верно, а проводки составлены идеально.',
            style: TextStyle(fontSize: 16, color: AppTheme.textGrey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Отлично', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Есть ошибки! Посмотри на красные ячейки.'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  Widget _buildCell({
    required TextEditingController controller,
    required String correctValue,
    required bool isDark,
    bool isAmount = false,
    bool readOnly = false,
  }) {
    String userVal = controller.text.trim().replaceAll(' ', '').replaceAll(',', '.');
    bool isCorrect = userVal == correctValue;
    
    Color bgColor = isDark ? AppTheme.darkSurface : Colors.white;
    Color borderColor = isDark ? Colors.white24 : Colors.black26;
    Color textColor = isDark ? Colors.white : AppTheme.ink;

    if (readOnly) {
      bgColor = Colors.transparent;
      borderColor = Colors.transparent;
      textColor = isDark ? Colors.white : AppTheme.ink;
    } else if (isChecked) {
      bgColor = isCorrect ? AppTheme.success.withOpacity(0.1) : AppTheme.error.withOpacity(0.1);
      borderColor = isCorrect ? AppTheme.success : AppTheme.error;
      textColor = isCorrect ? AppTheme.success : AppTheme.error;
    }

    return TextField(
      controller: controller,
      readOnly: readOnly,
      onChanged: (_) {
        if (!isChecked) calculateTurnovers();
      },
      keyboardType: isAmount ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: textColor,
        fontWeight: isChecked && !readOnly ? FontWeight.bold : (readOnly ? FontWeight.w600 : null),
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: readOnly ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        fillColor: bgColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(readOnly ? 0 : 8), 
          borderSide: BorderSide(color: borderColor)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(readOnly ? 0 : 8), 
          borderSide: BorderSide(color: borderColor)
        ),
        hintText: isChecked && !isCorrect && !readOnly ? correctValue : '',
        hintStyle: TextStyle(color: AppTheme.error.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.normal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.ink;
    final cardColor = isDark ? AppTheme.darkSurface : Colors.white;
    final dividerColor = isDark ? Colors.white54 : Colors.black54;

    String resultText = '';
    if (skKt > 0) resultText = 'Прибыль: ${skKt.toStringAsFixed(2)}';
    if (skDt > 0) resultText = 'Убыток: ${skDt.toStringAsFixed(2)}';

    int maxOps = dtOps.length > ktOps.length ? dtOps.length : ktOps.length;
    List<Widget> opRows = [];
    for (int i = 0; i < maxOps; i++) {
      opRows.add(
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: i < dtOps.length 
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dtOps[i]['num']!, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                            Text(dtOps[i]['amount']!, style: TextStyle(color: textColor)),
                          ],
                        )
                      : const SizedBox(),
                ),
              ),
              VerticalDivider(color: dividerColor, thickness: 1, width: 1),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: i < ktOps.length 
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(ktOps[i]['num']!, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                            Text(ktOps[i]['amount']!, style: TextStyle(color: textColor)),
                          ],
                        )
                      : const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkCanvas : AppTheme.lightCanvas,
      appBar: AppBar(
        title: const Text('Практическая задача'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          TextButton.icon(
            onPressed: fillExample,
            icon: const Icon(Icons.auto_fix_high, color: AppTheme.primary),
            label: const Text('Пример', style: TextStyle(color: AppTheme.primary)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.assignment, color: AppTheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Раздел: ${widget.category}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.taskDescription,
                    style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('Журнал хозяйственных операций', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        const Expanded(flex: 4, child: Text('Операция', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                        const Expanded(flex: 1, child: Text('Дт', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                        const Expanded(flex: 1, child: Text('Кт', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                        const Expanded(flex: 2, child: Text('Сумма', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                      ],
                    ),
                  ),
                  ...List.generate(widget.operations.length, (index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: isDark ? Colors.white12 : Colors.black12)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(widget.operations[index]['text']!, style: TextStyle(fontSize: 13, color: textColor)),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: _buildCell(controller: _rowControllers[index]['dt']!, correctValue: widget.operations[index]['dt']!, isDark: isDark),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: _buildCell(controller: _rowControllers[index]['kt']!, correctValue: widget.operations[index]['kt']!, isDark: isDark),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: _buildCell(controller: _rowControllers[index]['amount']!, correctValue: widget.operations[index]['amount']!, isDark: isDark, isAmount: true),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.05),
                      border: Border(top: BorderSide(color: isDark ? Colors.white12 : Colors.black12)),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${widget.operations.length + 1}. Финансовый результат (авто)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                                Text('(на основе самолётика)', style: TextStyle(fontSize: 10, color: AppTheme.textGrey)),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: _buildCell(controller: autoDtController, correctValue: autoDtController.text, isDark: isDark, readOnly: true),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: _buildCell(controller: autoKtController, correctValue: autoKtController.text, isDark: isDark, readOnly: true),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: _buildCell(controller: autoAmountController, correctValue: autoAmountController.text, isDark: isDark, isAmount: true, readOnly: true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Text('Расчет по счету ${widget.scoreNumber}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white12 : Colors.black26),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Center(
                      child: Text(widget.scoreNumber, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: textColor)),
                    ),
                  ),
                  
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(child: Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Дебет', style: TextStyle(fontWeight: FontWeight.bold, color: textColor))))),
                        VerticalDivider(color: dividerColor, thickness: 1, width: 1),
                        Expanded(child: Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Кредит', style: TextStyle(fontWeight: FontWeight.bold, color: textColor))))),
                      ],
                    ),
                  ),

                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: Row(children: [
                              const Text('Сн = ', style: TextStyle(fontWeight: FontWeight.bold)),
                              const Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                          ),
                        ),
                        VerticalDivider(color: dividerColor, thickness: 1, width: 1),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: Row(children: [
                              const Text('Сн = ', style: TextStyle(fontWeight: FontWeight.bold)),
                              const Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(color: dividerColor, thickness: 1.5, height: 1),

                  ...opRows,

                  Divider(color: dividerColor, thickness: 1.5, height: 1),

                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('До =', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                                Text(totalDt.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                              ],
                            ),
                          ),
                        ),
                        VerticalDivider(color: dividerColor, thickness: 1, width: 1),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Ко =', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                                Text(totalKt.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(color: dividerColor, thickness: 1.5, height: 1),

                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            child: Row(
                              children: [
                                if (skDt > 0) ...[
                                  const Text('Ск = ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(skDt.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.error)),
                                ]
                              ],
                            ),
                          ),
                        ),
                        VerticalDivider(color: dividerColor, thickness: 1, width: 1),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            child: Row(
                              children: [
                                if (skKt > 0) ...[
                                  const Text('Ск = ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(skKt.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.success)),
                                ]
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            
            ElevatedButton(
              onPressed: checkTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Проверить задачу', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}