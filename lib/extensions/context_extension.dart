import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pizza_delivery/core/utils/dimensions.dart';

extension Util on BuildContext {
  MediaQueryData get info => MediaQuery.of(this);
}

extension Dimension on BuildContext {
  double get height => info.size.height;

  double get width => info.size.width;

  double percentHeight(double percent) => height * percent;

  double percentWidth(double percent) => width * percent;

  double keyboardPadding(double bottomOffset) {
    if (Platform.isAndroid) {
      return info.viewInsets.bottom;
    } else {
      return (info.viewInsets.bottom - bottomOffset) > 0
          ? (info.viewInsets.bottom - bottomOffset)
          : 0;
    }
  }

  double get keyboardHeight => keyboardPadding(0);

  bool get isKeyboardVisible => info.viewInsets.bottom != 0.0;

  double get topPadding => info.padding.top;

  double get bottomPadding => info.padding.bottom;

  double get safeAreaPadding => topPadding + bottomPadding;

  double getWithSize(num sizeConstant) {
    return sizeConstant != 0.0 ? ((width * (sizeConstant)) / Dimens.DESIGN_WIDTH) : 0.0;
  }
}
