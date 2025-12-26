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
        fontFamily: 'Helvetica Neue',
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.only(left: 16),
        ),
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      initialRoute: 'home',
      routes: {
        'home': (context) => const HomePage(),
        'test': (context) => const Test(),
      },
    );
  }
}

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
