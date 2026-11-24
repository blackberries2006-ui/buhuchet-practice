import 'package:flutter/material.dart';
import 'widgets/base_task_layout.dart'; 

class Task8ResultsScreen extends StatelessWidget {
  const Task8ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTaskLayout(
      category: 'VIII. Финансовые результаты',
      scoreNumber: '99',
      taskDescription: 'Подводятся итоги месяца. Выручка от текущей деятельности составила 50 000 руб. НДС с выручки — 8 333 руб. Себестоимость — 30 000 руб. Прочие доходы (штрафы от поставщиков) — 2 000 руб. Прочие расходы (уплаченные штрафы) — 500 руб.',
      operations: [
        {'text': '1. Отражена выручка от текущей деятельности', 'dt': '62', 'kt': '90-1', 'amount': '50000'},
        {'text': '2. Начислен НДС с выручки', 'dt': '90-2', 'kt': '68-2', 'amount': '8333'},
        {'text': '3. Списана себестоимость', 'dt': '90-4', 'kt': '43', 'amount': '30000'},
        {'text': '4. Отражены прочие доходы (штрафы)', 'dt': '76-3', 'kt': '91-1', 'amount': '2000'},
        {'text': '5. Отражены прочие расходы (штрафы)', 'dt': '91-4', 'kt': '76-3', 'amount': '500'},
      ],
    );
  }
}