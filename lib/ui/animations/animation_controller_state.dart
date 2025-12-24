import 'package:flutter/material.dart';

abstract class AnimationState<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  AnimationState(this.animationDuration);
  final Duration animationDuration;
  late final animationController =
      AnimationController(vsync: this, duration: animationDuration);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
