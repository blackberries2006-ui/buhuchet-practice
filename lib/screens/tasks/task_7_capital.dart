import 'package:flutter/material.dart';
import 'widgets/base_task_layout.dart';

class Task7CapitalScreen extends StatelessWidget {
  const Task7CapitalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTaskLayout(
      category: 'VII. Собственный капитал',
      scoreNumber: '80',
      taskDescription: 'После регистрации ООО учредители внесли на расчетный счет вклады в уставный капитал на сумму 20 000 руб. Из полученной чистой прибыли 5 000 руб. было принято решение отчислить 1 000 руб. в резервный капитал.',
      operations: [
        {'text': '1. Отражена задолженность учредителей', 'dt': '75-1', 'kt': '80', 'amount': '20000'},
        {'text': '2. Внесение вкладов учредителями на р/с', 'dt': '51', 'kt': '75-1', 'amount': '20000'},
        {'text': '3. Отчисления в резервный капитал', 'dt': '84', 'kt': '82', 'amount': '1000'},
      ],
    );
  }
}