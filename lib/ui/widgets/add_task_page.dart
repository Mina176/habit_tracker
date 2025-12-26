import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/constants/app_assets.dart';
import 'package:habit_tracker/constants/app_colors.dart';
import 'package:habit_tracker/constants/text_styles.dart';
import 'package:habit_tracker/models/app_theme_settings.dart';
import 'package:habit_tracker/models/front_or_back_side.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/models/task_preset.dart';
import 'package:habit_tracker/persistence/hive_data_store.dart';
import 'package:habit_tracker/ui/add_task/add_task_navigator.dart';
import 'package:habit_tracker/ui/add_task/task_preset_list_tile.dart';
import 'package:habit_tracker/ui/add_task/text_field_header.dart';
import 'package:habit_tracker/ui/task/task_completion_ring.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';
import 'package:habit_tracker/ui/widgets/app_bar_icon_widget.dart';
import 'package:habit_tracker/ui/widgets/centered_svg_icon.dart';
import 'package:habit_tracker/ui/widgets/chevron_icon.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.of(context).secondary,
        leading: AppBarIconButton(
          iconName: AppAssets.navigationClose,
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        title: Text(
          'Add Task',
          style: TextStyles.heading.copyWith(
            color: AppTheme.of(context).settingsText,
          ),
        ),
      ),
      backgroundColor: AppTheme.of(context).primary,
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: AddTaskContents(),
      ),
    );
  }
}

class AddTaskContents extends StatelessWidget {
  const AddTaskContents({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 32,
              ),
              TextFieldHeader(
                'CREATE YOUR OWN:',
              ),
              SizedBox(height: 8),
              CustomTextField(
                hintText: 'Enter task title...',
                onSubmit: (value) {
                  Navigator.of(context).pushNamed(
                    AddTaskRoutes.confirmTask,
                    arguments: TaskPreset(
                      iconName: value.substring(0, 1).toUpperCase(),
                      name: value,
                    ),
                  );
                },
              ),
              SizedBox(
                height: 32,
              ),
              TextFieldHeader('CHOOSE A PRESET:'),
              SizedBox(height: 8),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return TaskPresetListTile(
                taskPreset: TaskPreset.allPresets[index],
                onPressed: (taskPreset) => Navigator.of(context).pushNamed(
                  AddTaskRoutes.confirmTask,
                  arguments: taskPreset,
                ),
              );
            },
            childCount: TaskPreset.allPresets.length,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          ),
        )
      ],
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.initialValue = '',
    this.hintText = '',
    this.showChevron = true,
    this.onSubmit,
  });
  final String initialValue;
  final String hintText;
  final bool showChevron;
  final ValueChanged<String>? onSubmit;

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _controller;

  String get text => _controller.value.text;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  void _clearText() {
    _controller.clear();
    // * This empty call to setState forces a rebuild which will hide the chevron.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.of(context).secondary,
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              // * This empty call to setState forces a rebuild which may show/hide the chevron.
              onChanged: (value) => setState(() {}),
              onSubmitted: (value) => widget.onSubmit?.call(value),
              controller: _controller,
              cursorColor: AppTheme.of(context).settingsText,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              style: TextStyles.content.copyWith(
                color: AppTheme.of(context).settingsText,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyles.content.copyWith(
                    color: AppTheme.of(context).settingsText.withOpacity(0.4)),
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                suffixIcon: text.isNotEmpty
                    ? IconButton(
                        onPressed: _clearText,
                        icon: Icon(
                          Icons.cancel,
                          color: AppTheme.of(context).settingsText,
                        ),
                      )
                    : null,
                // * https://stackoverflow.com/questions/56315495/how-to-remove-underline-below-textfield
                border: InputBorder.none,
              ),
            ),
          ),
          if (text.isNotEmpty && widget.showChevron)
            Container(
              padding: const EdgeInsets.only(left: 4, right: 4),
              color: AppTheme.of(context).settingsListIconBackground,
              child: IconButton(
                onPressed: () => widget.onSubmit?.call(text),
                icon: const ChevronIcon(
                  color: AppColors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.taskPreset,
    required this.iconBackground,
  });
  final TaskPreset taskPreset;
  final Color iconBackground;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFDDDDDD),
      height: 64,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(32),
              ),
              child: CenteredSvgIcon(
                iconName: taskPreset.iconName,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16),
            Text(
              taskPreset.name,
              style: TextStyles.caption,
            ),
            Spacer(),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: AppAssets.iconSize,
                ))
          ],
        ),
      ),
    );
  }
}
