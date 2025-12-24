import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/persistence/hive_data_store.dart';
import 'package:habit_tracker/ui/home/tasks_grid_page.dart';
import 'package:habit_tracker/ui/sliding_panel/sliding_panel_animator.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';
import 'package:habit_tracker/ui/theming/app_theme_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_flip_builder/page_flip_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageFlipKey = GlobalKey<PageFlipBuilderState>();
  final _frontSlidingPanelLeftAnimatorKey =
      GlobalKey<SlidingPanelAnimatorState>();
  final _frontSlidingPanelRightAnimatorKey =
      GlobalKey<SlidingPanelAnimatorState>();
  final _backSlidingPanelLeftAnimatorKey =
      GlobalKey<SlidingPanelAnimatorState>();
  final _backSlidingPanelRightAnimatorKey =
      GlobalKey<SlidingPanelAnimatorState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      final dataStore = ref.watch(dataStoreProvider);
      return PageFlipBuilder(
        key: _pageFlipKey,
        frontBuilder: (_) => ValueListenableBuilder(
          valueListenable: dataStore.frontTasksListenable(),
          builder: (context, Box<Task> box, child) => TasksGridPage(
            themeSettings: ref.watch(frontThemeManagerProvider),
            key: ValueKey(1),
            leftAnimatorKey: _frontSlidingPanelLeftAnimatorKey,
            rightAnimatorKey: _frontSlidingPanelRightAnimatorKey,
            tasks: box.values.toList(),
            onFlip: () => _pageFlipKey.currentState?.flip(),
            onColorIndexSelected: (colorIndex) => ref
                .watch(frontThemeManagerProvider.notifier)
                .updateColorIndex(colorIndex),
            onVariantIndexSelected: (variantIndex) => ref
                .watch(frontThemeManagerProvider.notifier)
                .updateVariantIndex(variantIndex),
          ),
        ),
        backBuilder: (_) => ValueListenableBuilder(
          valueListenable: dataStore.backTasksListenable(),
          builder: (context, Box<Task> box, child) => TasksGridPage(
            themeSettings: ref.watch(backThemeManagerProvider),
            key: ValueKey(2),
            leftAnimatorKey: _backSlidingPanelLeftAnimatorKey,
            rightAnimatorKey: _backSlidingPanelRightAnimatorKey,
            tasks: box.values.toList(),
            onFlip: () => _pageFlipKey.currentState?.flip(),
            onColorIndexSelected: (colorIndex) => ref
                .watch(backThemeManagerProvider.notifier)
                .updateColorIndex(colorIndex),
            onVariantIndexSelected: (variantIndex) => ref
                .watch(backThemeManagerProvider.notifier)
                .updateVariantIndex(variantIndex),
          ),
        ),
      );
    });
  }
}
