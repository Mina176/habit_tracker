import 'package:flutter/material.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/models/task_preset.dart';
import 'package:habit_tracker/ui/task/task_with_name.dart';
import 'package:habit_tracker/ui/task/task_with_name_loader.dart';

class TasksGrid extends StatelessWidget {
  const TasksGrid({super.key, required this.tasks});
  final List<Task> tasks;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.85,
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskWWithNameLoader(
              task: task,
            );
          }),
    );
  }
}
