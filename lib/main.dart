import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/constants/app_assets.dart';
import 'package:habit_tracker/constants/app_colors.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/models/task_preset.dart';
import 'package:habit_tracker/persistence/hive_data_store.dart';
import 'package:habit_tracker/ui/home/home_page.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppAssets.preloadSVGs();
  final dataStore = HiveDataStore();
  await dataStore.init();
  await dataStore.createDemoTasks(
    frontTasks: [
      Task.create(name: 'Decrease Screen Time', iconName: AppAssets.phone),
      Task.create(name: 'Do a Workout', iconName: AppAssets.dumbell),
      Task.create(name: 'Do Karate', iconName: AppAssets.karate),
      Task.create(name: 'Go Running', iconName: AppAssets.run),
      Task.create(name: 'Go Swimming', iconName: AppAssets.swimmer),
      Task.create(name: 'Do Some Stretches', iconName: AppAssets.stretching),
    ],
    backTasks: [
      Task.create(name: 'Brush Your Teeth', iconName: AppAssets.toothbrush),
      Task.create(name: 'Floss Your Teeth', iconName: AppAssets.dentalFloss),
      Task.create(name: 'Drink Water', iconName: AppAssets.water),
      Task.create(name: 'Practice Instrument', iconName: AppAssets.guitar),
      Task.create(name: 'Read for 10 Minutes', iconName: AppAssets.book),
      Task.create(name: 'Don\'t Smoke', iconName: AppAssets.smoking),
    ],
    force: false,
  );

  runApp(ProviderScope(
      overrides: [dataStoreProvider.overrideWithValue(dataStore)],
      child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'HelveticaNeue',
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: AppTheme(
        data: AppThemeData.defaultWithSwatch(AppColors.red),
        child: homePage(),
      ),
    );
  }
}
