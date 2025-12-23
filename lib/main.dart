import 'package:flutter/material.dart';
import 'package:habit_tracker/constants/app_assets.dart';
import 'package:habit_tracker/constants/app_colors.dart';
import 'package:habit_tracker/persistence/hive_data_store.dart';
import 'package:habit_tracker/ui/home/home_page.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppAssets.preloadSVGs();
  final dataStore = HiveDataStore();
  await dataStore.init();
  runApp(const MainApp());
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
