import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/animations/animation_controller_state.dart';
import 'package:habit_tracker/ui/sliding_panel/sliding_panel.dart';

class SlidingPanelAnimator extends StatefulWidget {
  const SlidingPanelAnimator(
      {super.key, required this.child, required this.direction});
  final Widget child;
  final SlideDirection direction;

  @override
  SlidingPanelAnimatorState createState() =>
      SlidingPanelAnimatorState(Duration(milliseconds: 300));
}

class SlidingPanelAnimatorState
    extends AnimationControllerState<SlidingPanelAnimator> {
  SlidingPanelAnimatorState(Duration duration) : super(duration);

  late final _curveAnimation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInCubic));

  void slideIn() {
    animationController.forward();
  }

  void slideOut() {
    animationController.reverse();
  }

  double _getOffSetX(double screenWidth, double animationValue) {
    final startOffset = widget.direction == SlideDirection.rightToLeft
        ? screenWidth - SlidingPanel.leftPanelFixedWidth
        : -SlidingPanel.leftPanelFixedWidth;
    return startOffset * (1.0 - animationValue);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curveAnimation,
      child: SlidingPanel(
        child: widget.child,
        direction: widget.direction,
      ),
      builder: (context, child) {
        final animationValue = _curveAnimation.value;
        // if not on—screen return empty container
        if (animationValue == 0) {
          return Container();
        }
        // else return the SlidingPanel
        final screenWidth = MediaQuery.of(context).size.width;
        final offsetX = _getOffSetX(screenWidth, animationValue);
        return Transform.translate(
          offset: Offset(offsetX, 0),
          child: child,
        );
      },
    );
  }
}
