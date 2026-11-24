import 'package:flutter/material.dart';
import 'widgets/base_task_layout.dart';

class Task5CashScreen extends StatelessWidget {
  const Task5CashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTaskLayout(
      category: 'V. Денежные средства',
      scoreNumber: '50',
      taskDescription: 'С расчетного счета в кассу снято 5 000 руб. на выдачу зарплаты. Из кассы выдана зарплата работникам — 4 000 руб. Оставшиеся деньги возвращены в банк. Подотчетному лицу выдано из кассы 300 руб. на покупку канцтоваров.',
      operations: [
        {'text': '1. Снятие наличных с расчетного счета', 'dt': '50', 'kt': '51', 'amount': '5000'},
        {'text': '2. Выдача зарплаты из кассы', 'dt': '70', 'kt': '50', 'amount': '4000'},
        {'text': '3. Возврат остатка в банк', 'dt': '51', 'kt': '50', 'amount': '1000'},
        {'text': '4. Выдача подотчетному лицу', 'dt': '71', 'kt': '50', 'amount': '300'},
      ],
    );
  }
}