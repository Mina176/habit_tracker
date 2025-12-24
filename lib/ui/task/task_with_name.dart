import 'package:flutter/material.dart';
import 'package:habit_tracker/constants/text_styles.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/ui/task/animated_task.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';
import 'package:habit_tracker/ui/widgets/edit_task_button.dart';

class TaskWithName extends StatelessWidget {
  const TaskWithName(
      {super.key,
      required this.task,
      this.completed = false,
      this.onCompleted,
      this.isEditing = false,
      this.hasCompletedState = true,
      this.editTaskButtonBuilder});
  final Task task;
  final bool completed;
  final bool isEditing;
  final bool hasCompletedState;
  final ValueChanged<bool>? onCompleted;
  final WidgetBuilder? editTaskButtonBuilder;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Stack(
            children: [
              AnimatedTask(
                iconName: task.iconName,
                completed: completed,
                isEditing: isEditing,
                hasCompletedState: hasCompletedState,
                onCompleted: onCompleted,
              ),
              if (editTaskButtonBuilder != null)
                Positioned.fill(
                  child: FractionallySizedBox(
                    widthFactor: EditTaskButton.scaleFactor,
                    heightFactor: EditTaskButton.scaleFactor,
                    alignment: Alignment.bottomRight,
                    child: editTaskButtonBuilder!(context),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 4),
        Text(
          task.name.toUpperCase(),
          style:
              TextStyles.taskName.copyWith(color: AppTheme.of(context).accent),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
