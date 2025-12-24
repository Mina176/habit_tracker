import 'package:flutter/material.dart';
import 'package:habit_tracker/constants/app_assets.dart';
import 'package:habit_tracker/ui/animations/animation_controller_state.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';
import 'package:habit_tracker/ui/widgets/centered_svg_icon.dart';
import 'package:habit_tracker/ui/task/task_completion_ring.dart';

class AnimatedTask extends StatefulWidget {
  const AnimatedTask(
      {super.key,
      required this.iconName,
      required this.completed,
      this.onCompleted,
      required this.isEditing,
      required this.hasCompletedState});
  final String iconName;
  final bool completed;
  final ValueChanged<bool>? onCompleted;
  final bool isEditing;
  final bool hasCompletedState;

  @override
  _AnimatedTaskState createState() =>
      _AnimatedTaskState(Duration(milliseconds: 300));
}

class _AnimatedTaskState extends AnimationState<AnimatedTask> {
  _AnimatedTaskState(Duration duration) : super(duration);

  late final Animation<double> _curveAnimation;
  bool _showCheckIcon = false;
  @override
  void initState() {
    animationController.addStatusListener(_checkStatusUpdates);

    _curveAnimation = animationController.drive(
      CurveTween(
        curve: Curves.easeInOut,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_checkStatusUpdates);
    super.dispose();
  }

  void _checkStatusUpdates(AnimationStatus status) {
    if (status == AnimationStatus.completed) widget.onCompleted?.call(true);
    if (widget.hasCompletedState) {
      if (mounted) {
        setState(() => _showCheckIcon = true);
      }
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _showCheckIcon = false);
        }
      });
    } else {
      animationController.value = 0.0;
    }
  }

  void handleTapDown(TapDownDetails details) {
    if (!widget.completed &&
        !widget.isEditing &&
        animationController.status != AnimationStatus.completed) {
      animationController.forward();
    } else if (!_showCheckIcon) {
      widget.onCompleted?.call(false);
      animationController.reset();
    }
  }

  void handleTapCancel() {
    if (!widget.isEditing &&
        animationController.status != AnimationStatus.completed) {
      animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: handleTapDown,
      onTapUp: (_) => handleTapCancel(),
      onTapCancel: handleTapCancel,
      child: AnimatedBuilder(
          animation: _curveAnimation,
          builder: (BuildContext context, Widget? child) {
            final themeData = AppTheme.of(context);
            final progress = widget.completed ? 1.0 : _curveAnimation.value;
            final hasCompleted = progress == 1;
            final iconColor =
                hasCompleted ? themeData.accentNegative : themeData.taskIcon;
            return Stack(
              children: [
                TaskCompletionRing(
                  progress: progress,
                ),
                Positioned.fill(
                  child: CenteredSvgIcon(
                    iconName: hasCompleted && _showCheckIcon
                        ? AppAssets.check
                        : widget.iconName,
                    color: iconColor,
                  ),
                ),
              ],
            );
          }),
    );
  }
}
