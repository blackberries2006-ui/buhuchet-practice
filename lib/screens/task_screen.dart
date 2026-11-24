import 'package:flutter/material.dart';
import 'tasks/task_1_assets.dart';
import 'tasks/task_2_inventory.dart';
import 'tasks/task_3_costs.dart';
import 'tasks/task_4_goods.dart';
import 'tasks/task_5_cash.dart';
import 'tasks/task_6_settlements.dart';
import 'tasks/task_7_capital.dart';
import 'tasks/task_8_results.dart';

class TaskScreen extends StatelessWidget {
  final String category;
  const TaskScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    if (category.startsWith('I.')) {
      return const Task1AssetsScreen();
    } else if (category.startsWith('II.')) {
      return const Task2InventoryScreen();
    } else if (category.startsWith('III.')) {
      return const Task3CostsScreen();
    } else if (category.startsWith('IV.')) {
      return const Task4GoodsScreen();
    } else if (category.startsWith('V.')) {
      return const Task5CashScreen();
    } else if (category.startsWith('VI.')) {
      return const Task6SettlementsScreen();
    } else if (category.startsWith('VII.')) {
      return const Task7CapitalScreen();
    } else if (category.startsWith('VIII.')) {
      return const Task8ResultsScreen();
    }
    
    return const Task1AssetsScreen();
  }
}