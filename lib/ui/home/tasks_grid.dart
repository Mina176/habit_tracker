import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/constants/app_colors.dart';
import 'package:habit_tracker/models/front_or_back_side.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/ui/add_task/add_task_navigator.dart';
import 'package:habit_tracker/ui/add_task/task_details_page.dart';
import 'package:habit_tracker/ui/animations/custom_fade_transition.dart';
import 'package:habit_tracker/ui/animations/staggerd_scale_transition.dart';
import 'package:habit_tracker/ui/task/add_task_item.dart';
import 'package:habit_tracker/ui/task/task_with_name_loader.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';
import 'package:habit_tracker/ui/widgets/edit_task_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TasksGrid extends StatefulWidget {
  const TasksGrid(
      {super.key, required this.tasks, required this.onAddOrEditTask});
  final List<Task> tasks;
  final VoidCallback? onAddOrEditTask;

  @override
  TasksGridState createState() => TasksGridState();
}

class TasksGridState extends State<TasksGrid>
    with SingleTickerProviderStateMixin {
  late final animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 300));
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

  Future<void> _addTask(WidgetRef ref) async {
    widget.onAddOrEditTask?.call();
    await Future.delayed(Duration(milliseconds: 200));
    final appTheme = AppTheme.of(context);
    final frontOrBackSide = ref.read<FrontOrBackSide>(frontOrBackSideProvider);
    await showCupertinoModalBottomSheet<void>(
      context: context,
      barrierColor: AppColors.black50,
      builder: (_) => AppTheme(
        data: appTheme,
        child: AddTaskNavigator(
          frontOrBackSide: frontOrBackSide,
        ),
      ),
    );
  }

  Future<void> _editTask(WidgetRef ref, Task task) async {
    widget.onAddOrEditTask?.call();
    await Future.delayed(Duration(milliseconds: 200));
    final appTheme = AppTheme.of(context);
    final frontOrBackSide = ref.read<FrontOrBackSide>(frontOrBackSideProvider);
    await showCupertinoSheet<void>(
      context: context,
      builder: (_) => AppTheme(
        data: appTheme,
        child: TaskDetailsPage(
          task: task,
          isNew: false,
          side: frontOrBackSide,
        ),
      ),
    );
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
              return Consumer(
                  builder: (context, ref, _) => AddTaskItem(
                        onCompleted: () => _addTask(ref),
                      ));
            }
            final task = widget.tasks[index];
            return TaskWithNameLoader(
              task: task,
              isEditing: _isEditing,
              editTaskButtonBuilder: (_) => StaggerdScaleTransition(
                animation: animationController,
                index: index,
                child: Consumer(
                  builder: (context, ref, __) => EditTaskButton(
                    onPressed: () => _editTask(
                      ref,
                      task,
                    ),
                  ),
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
