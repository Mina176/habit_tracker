import 'dart:math';

import 'package:flutter/material.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/ui/animations/animation_controller_state.dart';
import 'package:habit_tracker/ui/animations/custom_fade_transition.dart';
import 'package:habit_tracker/ui/animations/custom_scale_transition.dart';
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

  void enterEditMode() {
    animationController.forward();
  }

  void exitEditMode() {
    animationController.reverse();
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
                  onCompleted: () => print('object'),
                ),
              );
            }
            final task = widget.tasks[index];
            return TaskWithNameLoader(
              task: task,
              isEditing: false,
              editTaskButtonBuilder: (_) => CustomScaleTransition(
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
