import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/home/tasks_grid_page.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.of(context).primary,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: TasksGridPage(),
      ),
    );
  }
}
