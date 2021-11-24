import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pizza_delivery/common/swipe_detector.dart';

class CurvedCarousel extends StatefulWidget {
  const CurvedCarousel(
      {Key? key,
      required this.itemBuilder,
      required this.itemCount,
      this.viewPortSize = 0.20,
      this.curveScale = 8,
      this.scaleMiddleItem = true,
      this.middleItemScaleRatio = 1.2,
      this.disableInfiniteScrolling = false})
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
  late int _selectedItemIndex;
  late int _visibleItemsCount;
  bool? _forward;
  int _viewPortIndex = 0;
  int _lastViewPortIndex = -1;
  late double _itemWidth;
  late int _itemsCount;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _itemsCount = 1 ~/ widget.viewPortSize;
    _itemWidth = (MediaQuery.of(context).size.width / _itemsCount);
    _visibleItemsCount = MediaQuery.of(context).size.width ~/ _itemWidth;
    if (_visibleItemsCount % 2 == 0) {
      if (_itemWidth * (_visibleItemsCount + 0.5) <=
          MediaQuery.of(context).size.width) {
        _visibleItemsCount++;
      } else {
        _visibleItemsCount--;
      }
    }
    _selectedItemIndex = (_visibleItemsCount - 1) ~/ 2;
  }

  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
      threshold: 10,
      onSwipe: (value) {
        if (!value) {
          // if user swipes right to left side
          if (_viewPortIndex + _visibleItemsCount < widget.itemCount ||
              !widget.disableInfiniteScrolling) {
            moveRight();
          }
        } else {
          // if user swipes left to right side
          if (_viewPortIndex > 0 || !widget.disableInfiniteScrolling) {
            moveLeft();
          }
        }
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        child: TweenAnimationBuilder(
          key: ValueKey(_viewPortIndex),
          curve: Curves.easeInOut,
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          builder: (context, double value, child) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // All visible items in viewport
                for (int i = 0; i < _visibleItemsCount; i++)
                  AnimatedItem(
                    offset: Offset(
                      getCurveX(i, _itemWidth, value),
                      getCurveY(i, _itemWidth, value),
                    ),
                    angle: getAngle(i, _itemWidth, value),
                    scale: getItemScale(i, value),
                    child: widget.itemBuilder(
                      context,
                      (i + _viewPortIndex) % widget.itemCount,
                    ),
                  ),
                if (_forward != null && _forward! && value < 0.9)
                  AnimatedItem(
                    offset: Offset(
                      getCurveX(-1, _itemWidth, value),
                      getCurveY(-1, _itemWidth, value),
                    ),
                    angle: getAngle(-1, _itemWidth, value),
                    scale: getItemScale(-1, value),
                    child: widget.itemBuilder(
                      context,
                      (_viewPortIndex - 1) % widget.itemCount,
                    ),
                  ),
                if (_forward != null && !_forward! && value < 0.9)
                  AnimatedItem(
                    offset: Offset(
                      getCurveX(_visibleItemsCount, _itemWidth, value),
                      getCurveY(_visibleItemsCount, _itemWidth, value),
                    ),
                    angle: getAngle(_visibleItemsCount, _itemWidth, value),
                    scale: getItemScale(_visibleItemsCount, value),
                    child: widget.itemBuilder(
                      context,
                      (_viewPortIndex + _visibleItemsCount) % widget.itemCount,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  double interpolate(double prev, double current, double progress) {
    //progress will be between 0 and 1 !!
    return (prev + (progress * (current - prev)));
  }

  double getCurvePoint(int i) {
    if (_selectedItemIndex == i) {
      return 0;
    }
    return -((i - _selectedItemIndex).abs() *
            (i - _selectedItemIndex).abs() *
            widget.curveScale)
        .toDouble();
  }

  double getCurveX(int i, double itemWidth, double value) {
    if (_forward != null) {
      return interpolate(
          -(_selectedItemIndex - i - (_forward! ? 1 : -1)) * itemWidth,
          -(_selectedItemIndex - i) * itemWidth,
          value);
    }
    return -(_selectedItemIndex - i) * itemWidth;
  }

  double getCurveY(int i, double itemWidth, double value) {
    if (_forward != null) {
      return interpolate(
        getCurvePoint(i + (_forward! ? 1 : -1)),
        getCurvePoint(i),
        value,
      );
    }
    return getCurvePoint(i);
  }

  double getAngleValue(int i) {
    if (_selectedItemIndex == i) {
      return 0;
    }
    return -((i - _selectedItemIndex) * pi / (widget.curveScale + 5))
        .toDouble();
  }

  double getAngle(int i, double itemWidth, double value) {
    if (_lastViewPortIndex != -1) {
      return interpolate(
        getAngleValue(i + (_forward! ? 1 : -1)),
        getAngleValue(i),
        value,
      );
    }
    return getAngleValue(i);
  }

  double getItemScale(int i, double value) {
    if (!widget.scaleMiddleItem) {
      return 1;
    }
    if (_lastViewPortIndex != -1) {
      if (_selectedItemIndex == i) {
        return interpolate(1, widget.middleItemScaleRatio, value);
      } else if (i + (_forward! ? 1 : -1) == _selectedItemIndex) {
        return interpolate(widget.middleItemScaleRatio, 1, value);
      }
    }
    if (_selectedItemIndex == i) {
      return widget.middleItemScaleRatio;
    } else {
      return 1;
    }
  }

  void moveRight() {
    _lastViewPortIndex = _viewPortIndex;
    _viewPortIndex = (_viewPortIndex + 1) % widget.itemCount;
    setState(() {});
    _forward = true;
  }

  void moveLeft() {
    _lastViewPortIndex = _viewPortIndex;
    _viewPortIndex = _viewPortIndex - 1;
    if (_viewPortIndex < 0) {
      _viewPortIndex = widget.itemCount - 1;
    }
    setState(() {});
    _forward = false;
  }
}

class AnimatedItem extends StatelessWidget {
  final Offset offset;
  final double angle;
  final double scale;
  final Widget child;

  const AnimatedItem(
      {Key? key,
      required this.offset,
      required this.angle,
      required this.scale,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: angle,
        child: Transform.scale(
          scale: scale,
          child: child,
        ),
      ),
    );
  }
}
