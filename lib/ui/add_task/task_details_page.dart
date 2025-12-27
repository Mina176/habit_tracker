import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/constants/app_assets.dart';
import 'package:habit_tracker/models/front_or_back_side.dart';
import 'package:habit_tracker/models/task.dart';
import 'package:habit_tracker/models/task_preset.dart';
import 'package:habit_tracker/persistence/hive_data_store.dart';
import 'package:habit_tracker/ui/add_task/select_icon_page.dart';
import 'package:habit_tracker/ui/add_task/task_preset_list_tile.dart';
import 'package:habit_tracker/ui/add_task/task_ring_with_image.dart';
import 'package:habit_tracker/ui/add_task/text_field_header.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';
import 'package:habit_tracker/ui/widgets/add_task_page.dart';
import 'package:habit_tracker/ui/widgets/app_bar_icon_widget.dart';
import 'package:habit_tracker/ui/widgets/edit_task_button.dart';
import 'package:habit_tracker/ui/widgets/primary_widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage(
      {super.key, required this.task, required this.isNew, required this.side});
  final Task task;
  final bool isNew;
  final FrontOrBackSide side;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.of(context).secondary,
        leading: AppBarIconButton(
          iconName:
              isNew ? AppAssets.navigationBack : AppAssets.navigationClose,
          onPressed: () => isNew
              ? Navigator.of(context).pop()
              : Navigator.of(context, rootNavigator: true).pop(),
        ),
        title: Text(
          'Confirm Task',
          style: TextStyle(
            color: AppTheme.of(context).settingsText,
          ),
        ),
      ),
      backgroundColor: AppTheme.of(context).primary,
      body: ConfirmTaskContents(
        task: task,
        isNewTask: isNew,
        frontOrBackSide: side,
      ),
    );
  }
}

class ConfirmTaskContents extends ConsumerStatefulWidget {
  const ConfirmTaskContents({
    super.key,
    required this.task,
    required this.isNewTask,
    required this.frontOrBackSide,
  });
  final Task task;
  final bool isNewTask;
  final FrontOrBackSide frontOrBackSide;

  @override
  ConsumerState<ConfirmTaskContents> createState() =>
      _ConfirmTaskContentsState();
}

class _ConfirmTaskContentsState extends ConsumerState<ConfirmTaskContents> {
  final _textFieldKey = GlobalKey<CustomTextFieldState>();

  late String _iconName = widget.task.iconName;

  Future<void> _saveTask() async {
    final textFieldState = _textFieldKey.currentState;
    if (textFieldState != null) {
      // Create new task with updated name and asset icon
      final task = Task(
        id: widget.task.id,
        name: textFieldState.text,
        iconName: _iconName,
      );
      try {
        final navigator = Navigator.of(context, rootNavigator: true);
        // * Note: here we can use ref.read because ref is a property of [ConsumerState]
        final dataStore = ref.read<HiveDataStore>(dataStoreProvider);
        // * Once the first task is added, we no longer need to show the onboarding screen
        await dataStore.setDidAddFirstTask(true);
        await dataStore.saveTask(task, widget.frontOrBackSide);
        // * Pop back to HomePage, using `rootNavigator: true` to ensure we dismiss the entire navigation stack.
        navigator.pop();
      } catch (e) {
        // TODO: Proper error handling
        debugPrint(e.toString());
        rethrow;
      }
    }
  }

  Future<void> _deleteTask() async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final didConfirm = await showAdaptiveActionSheet<bool?>(
      context: context,
      title: const Text('Are you sure?'),
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: const Text('Delete'),
          onPressed: (context) => Navigator.of(context).pop(true),
        ),
      ],
      cancelAction: CancelAction(
        title: const Text('Cancel'),
      ),
    );
    if (didConfirm == true) {
      try {
        final dataStore = ref.read<HiveDataStore>(dataStoreProvider);
        await dataStore.deleteTask(widget.task, widget.frontOrBackSide);
        // * Pop back to HomePage, using `rootNavigator: true` to ensure we dismiss the entire navigation stack.
        navigator.pop();
      } catch (e) {
        // TODO: Proper error handling
        debugPrint(e.toString());
        rethrow;
      }
    }
  }

  Future<void> _changeIcon() async {
    final appThemeData = AppTheme.of(context);
    final iconName = await showCupertinoModalBottomSheet<String?>(
      context: context,
      builder: (_) => AppTheme(
        data: appThemeData,
        child: SelectIconPage(
          selectedIconName: _iconName,
        ),
      ),
    );
    if (iconName != null) {
      setState(() => _iconName = iconName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // * Make content scrollable if needed
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              ConfirmTaskHeader(
                iconName: _iconName,
                onChangeIcon: _changeIcon,
              ),
              const SizedBox(height: 48),
              const TextFieldHeader('TITLE:'),
              CustomTextField(
                key: _textFieldKey,
                showChevron: false,
                initialValue: widget.task.name,
              ),
              if (!widget.isNewTask) ...[
                Container(height: 48),
                TaskPresetListTile(
                  taskPreset: const TaskPreset(
                      name: 'Delete Task', iconName: AppAssets.delete),
                  showChevron: false,
                  onPressed: (_) => _deleteTask(),
                ),
              ],
            ],
          ),
        ),
        // * Pin PrimaryButton to the bottom
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: PrimaryButton(
            title: widget.isNewTask ? 'SAVE TASK' : 'DONE',
            onPressed: _saveTask,
          ),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }
}

class ConfirmTaskHeader extends StatelessWidget {
  const ConfirmTaskHeader(
      {super.key, required this.iconName, this.onChangeIcon});
  final String iconName;
  final VoidCallback? onChangeIcon;
  @override
  Widget build(BuildContext context) {
    const size = 150.0;
    final padding = (MediaQuery.of(context).size.width - size) / 2;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Stack(
        children: [
          TaskRingWithImage(
            iconName: iconName,
          ),
          Positioned.fill(
            child: FractionallySizedBox(
              widthFactor: EditTaskButton.scaleFactor,
              heightFactor: EditTaskButton.scaleFactor,
              alignment: Alignment.bottomRight,
              child: EditTaskButton(
                onPressed: onChangeIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
