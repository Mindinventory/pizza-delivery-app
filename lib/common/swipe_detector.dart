import 'package:flutter/material.dart';


class SwipeDetector extends StatelessWidget {
  SwipeDetector({Key? key, required this.child,required this.onSwipe}) : super(key: key);
  final Widget child;
  final void Function(bool) onSwipe;
  double? startX;
  bool? leftToRightSwipe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (event){
        if(startX!=null){
          leftToRightSwipe=startX!<event.globalPosition.dx;
        }
        startX=event.globalPosition.dx;
        },
      onHorizontalDragUpdate: (event){
        if(startX!=null){
          leftToRightSwipe=startX!<event.globalPosition.dx;
        }
        startX=event.globalPosition.dx;
      },
      onHorizontalDragDown: (event){
      if(startX!=null){
        leftToRightSwipe=startX!<event.globalPosition.dx;
      }
      startX=event.globalPosition.dx;
    },
      onHorizontalDragEnd: (event){
        onSwipe(leftToRightSwipe!);
      }
      ,
      child: child,
    );
  }
  void onMove(event){

  }
}
