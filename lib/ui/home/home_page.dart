import 'package:flutter/material.dart';
import 'package:habit_tracker/constants/app_assets.dart';
import 'package:habit_tracker/models/task_preset.dart';
import 'package:habit_tracker/ui/task/task_with_name.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.of(context).primary,
      body: Center(
        child: SizedBox(
          width: 240,
          child: TaskWithName(
            task: TaskPreset(name: 'Walk The Dog', iconName: AppAssets.dog),
          ),
        ),
      ),
    );
  }
}
