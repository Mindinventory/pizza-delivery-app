import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pizza_delivery/common/swipe_detector.dart';

class CurvedCarousel extends StatefulWidget {
  const CurvedCarousel(
      {Key? key,
      required this.itemBuilder,
      required this.itemCount,
      this.viewPortSize = 0.20, this.curveScale=8, this.scaleMiddleItem=true, this.middleItemScaleRatio=1.2, this.disableInfiniteScrolling=false})
      : super(key: key);
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;
  final bool disableInfiniteScrolling;
  final bool scaleMiddleItem;
  final double viewPortSize;
  final double curveScale;
  final double middleItemScaleRatio;

  @override
  _CurvedCarouselState createState() => _CurvedCarouselState();
}

class _CurvedCarouselState extends State<CurvedCarousel>
    with SingleTickerProviderStateMixin {
  late int currentSelected;
  late AnimationController controller;
  late int viewPortCount;
  bool? forward;
  int viewPortIndex = 0;
  int lastViewPortIndex = -1;
  late double eachWidth;
  late int count;
  @override
  void initState() {
    super.initState();
  }
@override
  void didChangeDependencies() {
    super.didChangeDependencies();
     count= 1 ~/ widget.viewPortSize;
    eachWidth = (MediaQuery.of(context).size.width / count);
    viewPortCount = MediaQuery.of(context).size.width ~/ eachWidth;
    if (viewPortCount % 2 == 0) {
     if(eachWidth*(viewPortCount+0.5)<= MediaQuery.of(context).size.width)
       {
         viewPortCount++;
       }
     else{
       viewPortCount--;
     }
    }
    currentSelected = (viewPortCount - 1) ~/ 2;
  }
  @override
  Widget build(BuildContext context) {

    return SwipeDetector(
      threshold: 10,
      onSwipe: (bool) {
        if (!bool) {
          if (viewPortIndex + viewPortCount < widget.itemCount||!widget.disableInfiniteScrolling) {
            lastViewPortIndex = viewPortIndex;
            viewPortIndex = (viewPortIndex + 1)%widget.itemCount;
            setState(() {});
            forward=true;
          }
            //
            // else{
          //   lastViewPortIndex = viewPortIndex;
          //   viewPortIndex = viewPortIndex + 1;
          //   setState(() {});
          // }
        } else {
          if (viewPortIndex > 0||!widget.disableInfiniteScrolling) {
            lastViewPortIndex = viewPortIndex;
            viewPortIndex = viewPortIndex - 1;
            if(viewPortIndex<0){
              viewPortIndex=widget.itemCount-1;
            }
            setState(() {});
            forward=false;
          }
        }
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        child: TweenAnimationBuilder(
            key: ValueKey(viewPortIndex),
            curve: Curves.easeInOut,
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 300),
            builder: (context, double value, child) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  for (int i=0;
                      i < viewPortCount;
                      i++)
                    Transform.translate(
                      offset: Offset(
                        getCurveX(i, eachWidth, value),
                        getCurveY(i, eachWidth, value),
                      ),
                      child: Transform.rotate(
                        angle: getAngle(i, eachWidth, value),
                        child: Transform.scale(
                          scale: getItemScale(i , value),
                          child: widget.itemBuilder(context, (i+viewPortIndex)%widget.itemCount),
                        ),
                      ),
                    ),
                  if(forward!=null&&forward!&&value<0.9)
                    Transform.translate(
                      offset: Offset(
                        getCurveX( -1, eachWidth, value),
                        getCurveY( -1, eachWidth, value),
                      ),
                      child: Transform.rotate(
                        angle: getAngle( -1, eachWidth, value),
                        child: Transform.scale(
                          scale: getItemScale( -1, value),
                          child: widget.itemBuilder(context, (viewPortIndex-1)%widget.itemCount),
                        ),
                      ),
                    ),
                  if(forward!=null&&!forward!&&value<0.9)
                    Transform.translate(
                      offset: Offset(
                        getCurveX( viewPortCount, eachWidth, value),
                        getCurveY( viewPortCount, eachWidth, value),
                      ),
                      child: Transform.rotate(
                        angle: getAngle( viewPortCount, eachWidth, value),
                        child: Transform.scale(
                          scale: getItemScale( viewPortCount, value),
                          child: widget.itemBuilder(context, (viewPortIndex+viewPortCount)%widget.itemCount),
                        ),
                      ),
                    ),
                ],
              );
            }),
      ),
    );
  }

  double interpolate(double prev, double current, double progress) {
    //progress will be between 0 and 1 !!
    return (prev + (progress * (current - prev)));
  }

  double getCurvePoint(int i) {
    if (currentSelected == i) {
      return 0;
    }
    // if(i<viewPortCount/2.0){
    return -((i - currentSelected).abs() * (i - currentSelected).abs() * widget.curveScale)
        .toDouble();
    // }
  }

  double getCurveX(int i, double itemWidth, double value) {
    if (forward != null) {
      return interpolate(
          - (currentSelected- i - (forward! ? 1 : -1)) * itemWidth,
          -(currentSelected-i)  * itemWidth,
          value);
    }
    return  -(currentSelected-i)  * itemWidth;
  }

  double getCurveY(int i, double itemWidth, double value) {
    if (forward != null) {
      return interpolate(
          getCurvePoint(i + (forward!? 1 : -1)),
          getCurvePoint(i),
          value);
    }
    return getCurvePoint(i);
  }

  double getAngleValue(int i) {
    if (currentSelected == i) {
      return 0;
    }
    // if(i<viewPortCount/2.0){
    return -((i - currentSelected) * pi / (widget.curveScale+5)).toDouble();
  }

  double getAngle(int i, double itemWidth, double value) {
    if (lastViewPortIndex != -1) {
      return interpolate(
          getAngleValue(i + (forward! ? 1 : -1)),
          getAngleValue(i),
          value);
    }
    return getAngleValue(i);
  }

  double getItemScale(int i, double value) {
    if(!widget.scaleMiddleItem) {
      return 1;
    }
    if (lastViewPortIndex != -1) {
      if (currentSelected == i) {
        return interpolate(1, widget.middleItemScaleRatio, value);
      } else if (i + (forward! ? 1 : -1) ==
          currentSelected) {
        return interpolate(widget.middleItemScaleRatio, 1, value);
      }
    }
    if (currentSelected == i) {
      return widget.middleItemScaleRatio;
    } else {
      return 1;
    }
  }
}
