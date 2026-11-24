import 'package:flutter/material.dart';
import 'widgets/base_task_layout.dart';

class Task4GoodsScreen extends StatelessWidget {
  const Task4GoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTaskLayout(
      category: 'IV. Готовая продукция и товары',
      scoreNumber: '90',
      taskDescription: 'Реализованы семена организацией ООО «Флагман» на сумму 250 000 рублей. Ставка НДС 10%. Себестоимость семян составила 120 000 рублей. Управленческие расходы 100 000 рублей. Расходы на реализацию 50 000 рублей. Необходимо определить финансовый результат от реализации семян и отразить все бухгалтерскими записями.',
      operations: [
        {'text': '1. Отражена выручка от реализации семян', 'dt': '62', 'kt': '90-1', 'amount': '250000'},
        {'text': '2. Начислен НДС с выручки (10%)', 'dt': '90-2', 'kt': '68-2', 'amount': '25000'},
        {'text': '3. Списана себестоимость семян', 'dt': '90-4', 'kt': '43', 'amount': '120000'},
        {'text': '4. Списаны управленческие расходы', 'dt': '90-5', 'kt': '26', 'amount': '100000'},
        {'text': '5. Списаны расходы на реализацию', 'dt': '90-6', 'kt': '44', 'amount': '50000'},
      ],
    );
  }
}