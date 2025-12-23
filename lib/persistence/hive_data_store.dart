import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/models/task_state.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDataStore {
  static const tasksBoxName = 'tasks';
  static const tasksStateBoxName = 'taskState';
  static String taskStateKey(String key) => 'taskState_$key';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TaskStateAdapter());
    await Hive.openBox<Task>(tasksBoxName);
    await Hive.openBox<TaskState>(tasksStateBoxName);
  }

  ValueListenable<Box<Task>> tasksListenable() {
    return Hive.box<Task>(tasksBoxName).listenable();
  }

  ValueListenable<Box<TaskState>> tasksStateListenable({required Task task}) {
    final box = Hive.box<TaskState>(tasksStateBoxName);
    final key = taskStateKey(task.id);
    return box.listenable(keys: [key]);
  }

  Future<void> setTaskState({
    required Task taskId,
    required bool completed,
  }) async {
    final box = Hive.box<TaskState>(tasksStateBoxName);
    final taskState = TaskState(taskId: taskId, completed: completed);
    await box.put(taskStateKey(taskId), taskState);
  }
}

final dataStoreProvider = Provider<HiveDataStore>((ref) {
  throw UnimplementedError();
});
