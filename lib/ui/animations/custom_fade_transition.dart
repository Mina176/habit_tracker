import 'package:flutter/widgets.dart';

class CustomFadeTransition extends StatelessWidget {
  CustomFadeTransition({
    required this.child,
    required Animation<double> animation,
  }) : opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInCubic));
  final Animation<double> opacityAnimation;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: child,
    );
  }
}
