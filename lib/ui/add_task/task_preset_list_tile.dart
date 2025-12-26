import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habit_tracker/constants/app_colors.dart';
import 'package:habit_tracker/constants/text_styles.dart';
import 'package:habit_tracker/models/task_preset.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';
import 'package:habit_tracker/ui/widgets/selectable_tile.dart';

class TaskPresetListTile extends StatelessWidget {
  const TaskPresetListTile({
    super.key,
    required this.taskPreset,
    this.showChevron = true,
    this.onPressed,
  });
  final TaskPreset taskPreset;
  final bool showChevron;
  final ValueChanged<TaskPreset>? onPressed;

  @override
  Widget build(BuildContext context) {
    return SelectableTile(
      onPressed: () => onPressed?.call(taskPreset),
      builder: (context, isSelected) => Container(
        color: isSelected
            ? AppTheme.of(context).secondary.withOpacity(0.5)
            : AppTheme.of(context).secondary,
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.of(context).settingsListIconBackground,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              taskPreset.iconName,
              colorFilter:
                  const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
          ),
          title: Text(
            taskPreset.name,
            style: TextStyles.content.copyWith(
              color: AppTheme.of(context).settingsText,
            ),
          ),
          trailing: showChevron
              ? Icon(Icons.arrow_forward_ios_rounded,
                  color: AppTheme.of(context).accent)
              : null,
        ),
      ),
    );
  }
}
