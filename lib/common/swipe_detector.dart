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
  final double threshold;
  final void Function(bool) onSwipe;
  double? startX;
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
    if (startX != null) {
      if ((startX! - event.globalPosition.dx).abs() > threshold) {
        leftToRightSwipe = startX! < event.globalPosition.dx;
      }
    }
    startX = event.globalPosition.dx;
  }

  void dragEnd(event) {
    if (leftToRightSwipe != null) {
      onSwipe(leftToRightSwipe!);
      print('SWIPE $leftToRightSwipe');
    }
    startX=null;
  }

  void onMove(event) {}
}
