import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/constants/app_assets.dart';
import 'package:habit_tracker/constants/text_styles.dart';
import 'package:habit_tracker/models/app_theme_settings.dart';
import 'package:habit_tracker/models/front_or_back_side.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/models/task_preset.dart';
import 'package:habit_tracker/persistence/hive_data_store.dart';
import 'package:habit_tracker/ui/task/task_completion_ring.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';
import 'package:habit_tracker/ui/widgets/centered_svg_icon.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      appBar: AppBar(
        backgroundColor: Color(0xFFDDDDDD),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.close,
          ),
        ),
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  CustomTextField(
                    label: 'CREATE YOUR OWN:',
                    buttonsColor: AppTheme.of(context).accentNegative,
                    textColor: Colors.black,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text('      OR CHOOSE A PRESET:'),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return CustomListTile(
                    taskPreset: TaskPreset.allPresets[index],
                    iconBackground:
                        AppTheme.of(context).settingsListIconBackground,
                  );
                },
                childCount: TaskPreset.allPresets.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.textColor,
    required this.buttonsColor,
    required this.label,
  });
  final Color textColor;
  final Color buttonsColor;
  final String label;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void clearText() {
    _textController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('      ${widget.label}'),
        SizedBox(
          height: 8,
        ),
        TextField(
          controller: _textController,
          cursorColor: widget.textColor,
          style: TextStyle(
            color: widget.textColor,
          ),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: widget.textColor),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    clearText();
                  },
                  icon: Icon(
                    Icons.close,
                    size: AppAssets.iconSize,
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  color: widget.buttonsColor,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: AppAssets.iconSize,
                    ),
                  ),
                )
              ],
            ),
            filled: true,
            fillColor: Color(0xFFDDDDDD),
            hintText: 'Enter Task Title...',
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            ),
          ),
        ),
      ],
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
