import 'package:flutter/foundation.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDataStore {
  static const tasksBoxName = 'tasks';
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    await Hive.openBox<Task>(tasksBoxName);
  }

  ValueListenable<Box<Task>> tasksListenable() {
    return Hive.box<Task>(tasksBoxName).listenable();
  }
}
