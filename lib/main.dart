import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/constants/app_assets.dart';
import 'package:habit_tracker/models/front_or_back_side.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/persistence/hive_data_store.dart';
import 'package:habit_tracker/ui/home/home_page.dart';
import 'package:habit_tracker/ui/theming/app_theme_manager.dart';

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
  final frontThemeSettings =
      await dataStore.appThemeSettings(side: FrontOrBackSide.front);
  final backThemeSettings =
      await dataStore.appThemeSettings(side: FrontOrBackSide.back);

  runApp(ProviderScope(overrides: [
    dataStoreProvider.overrideWithValue(dataStore),
    frontThemeManagerProvider.overrideWith(
      (ref) => AppThemeManager(
        themeSettings: frontThemeSettings,
        side: FrontOrBackSide.front,
        dataStore: dataStore,
      ),
    ),
    backThemeManagerProvider.overrideWith(
      (ref) => AppThemeManager(
        themeSettings: backThemeSettings,
        side: FrontOrBackSide.back,
        dataStore: dataStore,
      ),
    ),
  ], child: MainApp()));
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
      home: HomePage(),
    );
  }
}
