import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/persistence/hive_data_store.dart';
import 'package:habit_tracker/ui/home/tasks_grid_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

class homePage extends ConsumerWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataStore = ref.watch(dataStoreProvider);
    return ValueListenableBuilder(
      valueListenable: dataStore.tasksListenable(),
      builder: (context, Box<Task> box, child) => TasksGridPage(
        tasks: box.values.toList(),
      ),
    );
  }
}
