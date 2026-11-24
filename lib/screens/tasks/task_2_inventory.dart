import 'package:flutter/material.dart';
import 'widgets/base_task_layout.dart';

class Task2InventoryScreen extends StatelessWidget {
  const Task2InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTaskLayout(
      category: 'II. Производственные запасы',
      scoreNumber: '10',
      taskDescription: 'На склад организации поступили материалы от поставщика на сумму 5 000 руб. (в т.ч. НДС 20% — 1 000 руб.). Оплата поставщику произведена с расчетного счета. Из поступивших материалов на производство было списано сырье на сумму 3 000 руб. Оставшиеся материалы частично испорчены (выявлена недостача при инвентаризации) на сумму 200 руб.',
      operations: [
        {'text': '1. Поступили материалы от поставщика', 'dt': '10', 'kt': '60', 'amount': '4000'},
        {'text': '2. Отражен входной НДС', 'dt': '18', 'kt': '60', 'amount': '1000'},
        {'text': '3. Оплата поставщику с расчетного счета', 'dt': '60', 'kt': '51', 'amount': '5000'},
        {'text': '4. Списание материалов в основное производство', 'dt': '20', 'kt': '10', 'amount': '3000'},
        {'text': '5. Выявлена недостача материалов', 'dt': '94', 'kt': '10', 'amount': '200'},
      ],
    );
  }
}