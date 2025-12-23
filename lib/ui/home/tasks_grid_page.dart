import 'package:flutter/material.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/ui/home/home_page_bottom_options.dart';
import 'package:habit_tracker/ui/home/tasks_grid.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';

class TasksGridPage extends StatelessWidget {
  const TasksGridPage({
    super.key,
    required this.tasks,
    required this.onFlip,
  });
  final List<Task> tasks;
  final VoidCallback? onFlip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.of(context).primary,
      body: TasksGridContents(
        tasks: tasks,
        onFlip: onFlip,
      ),
    );
  }
}

class TasksGridContents extends StatelessWidget {
  const TasksGridContents({
    super.key,
    required this.tasks,
    required this.onFlip,
  });
  final List<Task> tasks;
  final VoidCallback? onFlip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TasksGrid(
            tasks: tasks,
          ),
        ),
        HomePageBottomOptions(onFlip: onFlip),
      ],
    );
  }
}
