import 'package:flutter/widgets.dart';
import 'package:habit_tracker/models/front_or_back_side.dart';
import 'package:habit_tracker/models/task.dart';

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage(
      {super.key, required this.task, required this.isNew, required this.side});
  final Task task;
  final bool isNew;
  final FrontOrBackSide side;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
