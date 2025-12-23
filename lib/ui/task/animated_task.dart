import 'package:flutter/material.dart';
import 'package:habit_tracker/constants/app_assets.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';
import 'package:habit_tracker/ui/widgets/centered_svg_icon.dart';
import 'package:habit_tracker/ui/task/task_completion_ring.dart';

class AnimatedTask extends StatefulWidget {
  const AnimatedTask(
      {super.key,
      required this.iconName,
      required this.completed,
      this.onCompleted});
  final String iconName;
  final bool completed;
  final ValueChanged<bool>? onCompleted;

  @override
  State<AnimatedTask> createState() => _AnimatedTaskState();
}

class _AnimatedTaskState extends State<AnimatedTask>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _curveAnimation;
  bool _showCheckIcon = false;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );

    _animationController.addStatusListener(_checkStatusUpdates);

    _curveAnimation = _animationController.drive(
      CurveTween(
        curve: Curves.easeInOut,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_checkStatusUpdates);
    _animationController.dispose();
    super.dispose();
  }

  void _checkStatusUpdates(AnimationStatus status) {
    if (status == AnimationStatus.completed) widget.onCompleted?.call(true);
    if (mounted) {
      setState(() => _showCheckIcon = true);
    }
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showCheckIcon = false);
      }
    });
  }

  void handleTapDown(TapDownDetails details) {
    if (!widget.completed &&
        _animationController.status != AnimationStatus.completed) {
      _animationController.forward();
    } else if (!_showCheckIcon) {
      widget.onCompleted?.call(false);
      _animationController.reset();
    }
  }

  void handleTapUp() {
    if (_animationController.status != AnimationStatus.completed) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: handleTapDown,
      onTapUp: (_) => handleTapUp(),
      onTapCancel: handleTapUp,
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
