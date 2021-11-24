import 'package:flutter/material.dart';
import 'package:pizza_delivery/extensions/context_extension.dart';

extension ExtNum on num {
  double toSize(BuildContext context) {
    return context.getWithSize(this);
  }
}