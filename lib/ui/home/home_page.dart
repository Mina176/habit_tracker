import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';
import 'package:habit_tracker/ui/widgets/task_completion_ring.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.of(context).primary,
      body: Center(
        child: SizedBox(
          width: 120,
          child: taskCompletionRing(),
        ),
      ),
    );
  }
}
