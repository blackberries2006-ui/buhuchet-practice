import 'package:flutter/material.dart';
import 'widgets/base_task_layout.dart';

class Task6SettlementsScreen extends StatelessWidget {
  const Task6SettlementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTaskLayout(
      category: 'VI. Расчеты',
      scoreNumber: '68',
      taskDescription: 'С расчетного счета перечислен налог на прибыль в бюджет — 1 500 руб. Удержан подоходный налог из зарплаты сотрудника — 800 руб. Работник вернул в кассу неиспользованный аванс на командировку — 200 руб. Получен краткосрочный кредит банка на расчетный счет — 10 000 руб.',
      operations: [
        {'text': '1. Перечислен налог на прибыль', 'dt': '68-3', 'kt': '51', 'amount': '1500'},
        {'text': '2. Удержан подоходный налог', 'dt': '70', 'kt': '68-4', 'amount': '800'},
        {'text': '3. Возврат неиспользованного аванса', 'dt': '50', 'kt': '71', 'amount': '200'},
        {'text': '4. Получен краткосрочный кредит', 'dt': '51', 'kt': '66', 'amount': '10000'},
      ],
    );
  }
}