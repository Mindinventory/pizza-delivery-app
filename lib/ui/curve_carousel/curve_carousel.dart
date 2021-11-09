import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pizza_delivery/common/swipe_detector.dart';

class CurvedCarousel extends StatefulWidget {
  const CurvedCarousel(
      {Key? key,
      required this.itemBuilder,
      required this.itemCount,
      this.viewPortSize = 0.15, this.curveScale=8, this.scaleMiddleItem=true, this.middleItemScaleRatio=1.2})
      : super(key: key);
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;
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
  int viewPortIndex = 0;
  int lastViewPortIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final count = 1 ~/ widget.viewPortSize;

    final eachWidth = (MediaQuery.of(context).size.width / count);
    viewPortCount = MediaQuery.of(context).size.width ~/ eachWidth;
    if (viewPortCount % 2 == 0) {
      viewPortCount--;
    }
    currentSelected = (viewPortCount - 1) ~/ 2;
    final itemWidth = MediaQuery.of(context).size.width / viewPortCount;
    return SwipeDetector(
      onSwipe: (bool) {
        if (!bool) {
          if (viewPortIndex + viewPortCount < widget.itemCount) {
            lastViewPortIndex = viewPortIndex;
            viewPortIndex = viewPortIndex + 1;
            setState(() {});
          }
        } else {
          if (viewPortIndex > 0) {
            lastViewPortIndex = viewPortIndex;
            viewPortIndex = viewPortIndex - 1;
            setState(() {});
          }
        }
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        child: TweenAnimationBuilder(
            key: ValueKey(viewPortIndex),
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 400),
            builder: (context, double value, child) {
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  for (int i = viewPortIndex;
                      i < viewPortIndex + viewPortCount;
                      i++)
                    Positioned(
                      left: 0,
                      child: Transform.translate(
                        offset: Offset(
                          getCurveX(i - viewPortIndex, itemWidth, value),
                          getCurveY(i - viewPortIndex, itemWidth, value),
                        ),
                        child: Transform.rotate(
                          angle: getAngle(i - viewPortIndex, itemWidth, value),
                          child: Transform.scale(
                            scale: getItemScale(i - viewPortIndex, value),
                            child: widget.itemBuilder(context, i),
                          ),
                        ),
                      ),
                    ),
                  if(viewPortIndex>0&&viewPortIndex>lastViewPortIndex&&value<0.9)
                    Positioned(
                      left: 0,
                      child: Transform.translate(
                        offset: Offset(
                          getCurveX( -1, itemWidth, value),
                          getCurveY( -1, itemWidth, value),
                        ),
                        child: Transform.rotate(
                          angle: getAngle( -1, itemWidth, value),
                          child: Transform.scale(
                            scale: getItemScale( -1, value),
                            child: widget.itemBuilder(context, viewPortIndex-1),
                          ),
                        ),
                      ),
                    ),
                  if(viewPortIndex<lastViewPortIndex&&value<0.9)
                    Positioned(
                      left: 0,
                      child: Transform.translate(
                        offset: Offset(
                          getCurveX( viewPortCount, itemWidth, value),
                          getCurveY( viewPortCount, itemWidth, value),
                        ),
                        child: Transform.rotate(
                          angle: getAngle( viewPortCount, itemWidth, value),
                          child: Transform.scale(
                            scale: getItemScale( viewPortCount, value),
                            child: widget.itemBuilder(context, viewPortIndex+viewPortCount),
                          ),
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
    if (lastViewPortIndex != -1) {
      return interpolate(
          (i + (lastViewPortIndex < viewPortIndex ? 1 : -1)) * itemWidth,
          i  * itemWidth,
          value);
    }
    return i * itemWidth;
  }

  double getCurveY(int i, double itemWidth, double value) {
    if (lastViewPortIndex != -1) {
      return interpolate(
          getCurvePoint(i + (lastViewPortIndex < viewPortIndex ? 1 : -1)),
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
          getAngleValue(i + (lastViewPortIndex < viewPortIndex ? 1 : -1)),
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
      } else if (i + (lastViewPortIndex < viewPortIndex ? 1 : -1) ==
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
