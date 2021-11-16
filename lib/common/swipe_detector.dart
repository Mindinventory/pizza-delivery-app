import 'package:flutter/material.dart';
import 'dart:math' as math;

class SwipeDetector extends StatelessWidget {
  SwipeDetector(
      {Key? key,
        required this.child,
        required this.onSwipe,
        this.threshold = 10.0})
      : super(key: key);
  final Widget child;
  // minimum finger displacement to count as a swipe
  final double threshold;
  final void Function(bool) onSwipe;
  double? _offsetX;
  bool? leftToRightSwipe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: dragStart,
      onVerticalDragStart: dragStart,

      onHorizontalDragDown:dragStart,
      onVerticalDragDown: dragStart,

      onHorizontalDragEnd: dragEnd,
      onVerticalDragEnd: dragEnd,
      child: child,
    );
  }

  void dragStart(event) {
    if (_offsetX != null) {
      if ((_offsetX! - event.globalPosition.dx).abs() > threshold) {
        leftToRightSwipe = _offsetX! < event.globalPosition.dx;
      }
    }
    _offsetX = event.globalPosition.dx;
  }

  void dragEnd(event) {
    if (leftToRightSwipe != null) {
      onSwipe(leftToRightSwipe!);
    }
    _offsetX=null;
  }

}
