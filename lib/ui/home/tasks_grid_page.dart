import 'package:flutter/material.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/ui/home/tasks_grid.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';

class TasksGridPage extends StatelessWidget {
  const TasksGridPage({
    super.key,
    required this.tasks,
  });
  final List<Task> tasks;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.of(context).primary,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: TasksGridContents(
          tasks: tasks,
        ),
      ),
    );
  }
}

class TasksGridContents extends StatelessWidget {
  const TasksGridContents({
    super.key,
    required this.tasks,
  });
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return TasksGrid();
  }
}
