import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/models/app_theme_settings.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/ui/home/home_page_bottom_options.dart';
import 'package:habit_tracker/ui/home/tasks_grid.dart';
import 'package:habit_tracker/ui/sliding_panel/sliding_panel.dart';
import 'package:habit_tracker/ui/sliding_panel/sliding_panel_animator.dart';
import 'package:habit_tracker/ui/sliding_panel/theme_selection_close.dart';
import 'package:habit_tracker/ui/sliding_panel/theme_selection_list.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';

class TasksGridPage extends StatelessWidget {
  const TasksGridPage({
    super.key,
    required this.tasks,
    required this.onFlip,
    required this.leftAnimatorKey,
    required this.rightAnimatorKey,
    required this.themeSettings,
    this.onColorIndexSelected,
    this.onVariantIndexSelected,
  });
  final List<Task> tasks;
  final VoidCallback? onFlip;
  final GlobalKey<SlidingPanelAnimatorState> leftAnimatorKey;
  final GlobalKey<SlidingPanelAnimatorState> rightAnimatorKey;
  final AppThemeSettings themeSettings;
  final ValueChanged<int>? onColorIndexSelected;
  final ValueChanged<int>? onVariantIndexSelected;

  void _animateTheme(ThemeData themeData) {
    
  }

  void _enterEditMode() {
    leftAnimatorKey.currentState?.slidIn();
    rightAnimatorKey.currentState?.slidIn();
  }

  void _exitEditMode() {
    leftAnimatorKey.currentState?.slidOut();
    rightAnimatorKey.currentState?.slidOut();
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme(
      data: themeSettings.themeData,
      child: Builder(
        builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppTheme.of(context).overlayStyle,
          child: Scaffold(
            backgroundColor: AppTheme.of(context).primary,
            body: Stack(
              children: [
                TasksGridContents(
                    tasks: tasks,
                    onFlip: onFlip,
                    onEnterEditMode: _enterEditMode),
                Positioned(
                  bottom: 6,
                  left: 0,
                  width: SlidingPanel.leftPanelFixedWidth,
                  child: SlidingPanelAnimator(
                    key: leftAnimatorKey,
                    direction: SlideDirection.leftToRight,
                    child: ThemeSelectionClose(
                      onClose: _exitEditMode,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 0,
                  width: MediaQuery.of(context).size.width -
                      SlidingPanel.leftPanelFixedWidth,
                  child: SlidingPanelAnimator(
                    key: rightAnimatorKey,
                    direction: SlideDirection.rightToLeft,
                    child: ThemeSelectionList(
                      currentThemeSettings: themeSettings,
                      availableWidth: MediaQuery.of(context).size.width -
                          SlidingPanel.leftPanelFixedWidth -
                          SlidingPanel.paddingWidth,
                      onColorIndexSelected: onColorIndexSelected,
                      onVariantIndexSelected: onVariantIndexSelected,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TasksGridContents extends StatelessWidget {
  const TasksGridContents({
    super.key,
    required this.tasks,
    required this.onFlip,
    required this.onEnterEditMode,
  });
  final List<Task> tasks;
  final VoidCallback? onFlip;
  final VoidCallback? onEnterEditMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TasksGrid(
            tasks: tasks,
          ),
        ),
        HomePageBottomOptions(onFlip: onFlip, onEnterEditMode: onEnterEditMode),
      ],
    );
  }
}
