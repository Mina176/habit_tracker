import 'dart:math';

import 'package:flutter/material.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/ui/animations/animation_controller_state.dart';
import 'package:habit_tracker/ui/animations/custom_fade_transition.dart';
import 'package:habit_tracker/ui/animations/staggerd_scale_transition.dart';
import 'package:habit_tracker/ui/task/add_task_item.dart';
import 'package:habit_tracker/ui/task/task_with_name_loader.dart';
import 'package:habit_tracker/ui/widgets/edit_task_button.dart';

class TasksGrid extends StatefulWidget {
  const TasksGrid({super.key, required this.tasks, this.onEditTask});
  final List<Task> tasks;
  final VoidCallback? onEditTask;

  @override
  TasksGridState createState() => TasksGridState(Duration(milliseconds: 300));
}

class TasksGridState extends AnimationState<TasksGrid> {
  TasksGridState(Duration duration) : super(duration);
  bool _isEditing = false;
  void enterEditMode() {
    animationController.forward();
    setState(() {
      _isEditing = true;
    });
  }

  void exitEditMode() {
    animationController.reverse();
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisSpacing = constraints.maxWidth * 0.05;
        final taskWidth = (constraints.maxWidth - crossAxisSpacing) / 2.0;
        const aspectRatio = 0.82;
        final taskHeight = taskWidth / aspectRatio;
        // Use max(x, 0.1) to prevent layout error when keyword is visible in modal page
        final mainAxisSpacing =
            max((constraints.maxHeight - taskHeight * 3) / 2.0, 0.1);
        final tasksLength = min(6, widget.tasks.length + 1);
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            if (index == widget.tasks.length) {
              return CustomFadeTransition(
                animation: animationController,
                child: AddTaskItem(
                  onCompleted: _isEditing ? () => print('object') : null,
                ),
              );
            }
            final task = widget.tasks[index];
            return TaskWithNameLoader(
              task: task,
              isEditing: _isEditing,
              editTaskButtonBuilder: (_) => StaggerdScaleTransition(
                animation: animationController,
                index: index,
                child: EditTaskButton(
                  onPressed: () => debugPrint('Edit Item'),
                ),
              ),
            );
          },
          itemCount: tasksLength,
        );
      },
    );
  }
}
