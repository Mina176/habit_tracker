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
    tasks: [
      Task.create(name: 'Cycle to Work', iconName: AppAssets.bike),
      Task.create(name: 'Wash Your Hands', iconName: AppAssets.washHands),
      Task.create(name: 'Wear a Mask', iconName: AppAssets.mask),
      Task.create(name: 'Brush Your Teeth', iconName: AppAssets.toothbrush),
      Task.create(name: 'Floss Your Teeth', iconName: AppAssets.dentalFloss),
      Task.create(name: 'Drink Water', iconName: AppAssets.water),
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
      theme: ThemeData(fontFamily: 'HelveticaNeue'),
      home: AppTheme(
        data: AppThemeData.defaultWithSwatch(AppColors.red),
        child: homePage(),
      ),
    );
  }
}
