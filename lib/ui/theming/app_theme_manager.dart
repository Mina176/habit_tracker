import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/models/app_theme_settings.dart';
import 'package:habit_tracker/models/front_or_back_side.dart';
import 'package:habit_tracker/persistence/hive_data_store.dart';

class AppThemeManager extends StateNotifier<AppThemeSettings> {
  AppThemeManager({
    required AppThemeSettings themeSettings,
    required this.dataStore,
    required this.side,
  }) : super(themeSettings);

  final HiveDataStore dataStore;
  final FrontOrBackSide side;

  Future<void> updateColorIndex(int colorIndex) async {
    state = state.copyWith(colorIndex: colorIndex);
    await dataStore.setAppThemeSettings(settings: state, side: side);
  }

  Future<void> updateVariantIndex(int variantIndex) async {
    state = state.copyWith(variantIndex: variantIndex);
    await dataStore.setAppThemeSettings(settings: state, side: side);
  }
}

final frontThemeManagerProvider =
    StateNotifierProvider<AppThemeManager, AppThemeSettings>((ref) {
  throw UnimplementedError();
});
final backThemeManagerProvider =
    StateNotifierProvider<AppThemeManager, AppThemeSettings>((ref) {
  throw UnimplementedError();
});
