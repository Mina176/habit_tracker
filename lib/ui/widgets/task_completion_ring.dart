import 'dart:math';

import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';

class TaskCompletionRing extends StatelessWidget {
  const TaskCompletionRing({super.key, required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: progress < 1
          ? CustomPaint(
              painter: RingPainter(
                progress: progress,
                taskNotCompletedColor: AppTheme.of(context).taskRing,
                taskCompletedColor: AppTheme.of(context).accent,
              ),
            )
          : CompletedTask(),
    );
  }
}

class CompletedTask extends StatelessWidget {
  const CompletedTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.of(context).accent,
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  RingPainter({
    super.repaint,
    required this.progress,
    required this.taskNotCompletedColor,
    required this.taskCompletedColor,
  });
  final double progress;
  final Color taskNotCompletedColor;
  final Color taskCompletedColor;
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width / 15.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..color = taskNotCompletedColor
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, backgroundPaint);

    final foregroundPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..color = taskCompletedColor
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      progress * pi * 2,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
