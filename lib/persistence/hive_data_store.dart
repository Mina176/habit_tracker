import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/models/app_theme_settings.dart';
import 'package:habit_tracker/models/front_or_back_side.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/models/task_state.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDataStore {
  static const frontTasksBoxName = 'frontTasks';
  static const backTasksBoxName = 'backTasks';
  static const tasksStateBoxName = 'tasksState';
  static const frontAppThemeBoxName = 'frontAppTheme';
  static const backAppThemeBoxName = 'backAppTheme';
  static const flagsBoxName = 'flags';
  static const didAddFirstTaskKey = 'didAddFirstTask';

  static String taskStateKey(String key) => 'taskState_$key';

  Future<void> init() async {
    await Hive.initFlutter();
    // register adapters
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TaskStateAdapter());
    Hive.registerAdapter<AppThemeSettings>(AppThemeSettingsAdapter());
    // open boxes
    // task lists
    await Hive.openBox<Task>(frontTasksBoxName);
    await Hive.openBox<Task>(backTasksBoxName);
    await Hive.openBox<bool>(flagsBoxName);
    // task state
    await Hive.openBox<TaskState>(tasksStateBoxName);
    // theming
    await Hive.openBox<AppThemeSettings>(frontAppThemeBoxName);
    await Hive.openBox<AppThemeSettings>(backAppThemeBoxName);
  }

  ValueListenable<Box<Task>> frontTasksListenable() {
    return Hive.box<Task>(frontTasksBoxName).listenable();
  }

  ValueListenable<Box<Task>> backTasksListenable() {
    return Hive.box<Task>(backTasksBoxName).listenable();
  }

  addTask(Task task, FrontOrBackSide side) async {
    final frontBox = Hive.box<Task>(frontTasksBoxName);
    final backBox = Hive.box<Task>(backTasksBoxName);

    await side == FrontOrBackSide.front
        ? frontBox.add(task)
        : backBox.add(task);
  }

  deleteTask(Task task, FrontOrBackSide side) async {
    final frontBox = Hive.box<Task>(frontTasksBoxName);
    final backBox = Hive.box<Task>(backTasksBoxName);

    await side == FrontOrBackSide.front
        ? frontBox.delete(task)
        : backBox.delete(task);
  }

  Future<void> setDidAddFirstTask(bool value) async {
    final box = Hive.box<bool>(flagsBoxName);
    await box.put(didAddFirstTaskKey, value);
  }

  ValueListenable<Box<bool>> didAddFirstTaskListenable() {
    return Hive.box<bool>(flagsBoxName)
        .listenable(keys: <String>[didAddFirstTaskKey]);
  }

  bool didAddFirstTask(Box<bool> box) {
    final value = box.get(didAddFirstTaskKey);
    return value ?? false;
  }

  ValueListenable<Box<TaskState>> tasksStateListenable({required Task task}) {
    final box = Hive.box<TaskState>(tasksStateBoxName);
    final key = taskStateKey(task.id);
    return box.listenable(keys: [key]);
  }

  Future<void> setAppThemeSettings(
      {required AppThemeSettings settings,
      required FrontOrBackSide side}) async {
    final themeKey = side == FrontOrBackSide.front
        ? frontAppThemeBoxName
        : backAppThemeBoxName;
    final box = Hive.box<AppThemeSettings>(themeKey);
    await box.put(themeKey, settings);
  }

  Future<AppThemeSettings> appThemeSettings(
      {required FrontOrBackSide side}) async {
    final themeKey = side == FrontOrBackSide.front
        ? frontAppThemeBoxName
        : backAppThemeBoxName;
    final box = Hive.box<AppThemeSettings>(themeKey);
    final settings = box.get(themeKey);
    return settings ?? AppThemeSettings.defaults(side);
  }

  Future<void> setTaskState({
    required Task task,
    required bool completed,
  }) async {
    final box = Hive.box<TaskState>(tasksStateBoxName);
    final taskState = TaskState(taskId: task.id, completed: completed);
    await box.put(taskStateKey(task.id), taskState);
  }

  TaskState taskState(Box<TaskState> box, {required Task task}) {
    final key = taskStateKey(task.id);
    return box.get(key) ?? TaskState(taskId: task.id, completed: false);
  }
}

final dataStoreProvider = Provider<HiveDataStore>((ref) {
  throw UnimplementedError();
});
