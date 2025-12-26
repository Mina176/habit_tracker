import 'package:flutter/material.dart';
import 'package:habit_tracker/models/front_or_back_side.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/models/task_preset.dart';
import 'package:habit_tracker/ui/add_task/task_details_page.dart';
import 'package:habit_tracker/ui/widgets/add_task_page.dart';

class AddTaskRoutes {
  static const root = '/';
  static const confirmTask = 'confirmTask';
}

class AddTaskNavigator extends StatelessWidget {
  const AddTaskNavigator({super.key, required this.frontOrBackSide});
  final FrontOrBackSide frontOrBackSide;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: AddTaskRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) {
          switch (routeSettings.name) {
            case AddTaskRoutes.root:
              return AddTaskPage();
            case AddTaskRoutes.confirmTask:
              final taskPreset = routeSettings.arguments as TaskPreset;
              final task = Task.create(
                name: taskPreset.name,
                iconName: taskPreset.iconName,
              );
              return TaskDetailsPage(
                task: task,
                isNew: true,
                side: frontOrBackSide,
              );
            default:
              throw UnimplementedError();
          }
        });
      },
    );
  }
}
