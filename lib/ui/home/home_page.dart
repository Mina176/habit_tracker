import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/persistence/hive_data_store.dart';
import 'package:habit_tracker/ui/home/tasks_grid_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_flip_builder/page_flip_builder.dart';

class homePage extends ConsumerWidget {
  final _pageFlipKey = GlobalKey<PageFlipBuilderState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataStore = ref.watch(dataStoreProvider);
    return PageFlipBuilder(
      key: _pageFlipKey,
      frontBuilder: (_) => ValueListenableBuilder(
        valueListenable: dataStore.frontTasksListenable(),
        builder: (context, Box<Task> box, child) => TasksGridPage(
          tasks: box.values.toList(),
          onFlip: () => _pageFlipKey.currentState?.flip(),
        ),
      ),
      backBuilder: (_) => ValueListenableBuilder(
        valueListenable: dataStore.backTasksListenable(),
        builder: (context, Box<Task> box, child) => TasksGridPage(
          tasks: box.values.toList(),
          onFlip: () => _pageFlipKey.currentState?.flip(),
        ),
      ),
    );
  }
}
