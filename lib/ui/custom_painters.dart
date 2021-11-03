import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurveLinePainter extends CustomPainter {
  final painter = Paint();

  CurveLinePainter(this.deviceWidth) {
    painter.color = Colors.grey;
    painter.strokeWidth = 1;
    painter.style = PaintingStyle.stroke;
  }

  final double deviceWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(
        Rect.fromLTRB(-20, -20, deviceWidth, 30), pi, -pi, false, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Pos {
  final int x, y;

  Pos(this.x, this.y);
}

class TopperPainter extends CustomPainter {
  final ui.Image img;
  final List<Pos> positions;
  final double pizzaSize;
  final double value;
  final int deviceWidth, deviceHeight;
  final Paint painter = Paint();

  @override
  void paint(Canvas canvas, Size size) async {
    final pizzaRadius = pizzaSize / 2;
    final centerX = deviceWidth / 2;
    const centerY = 70 + (350 / 2);
    for (int j = 0; j < positions.length; j++) {
      final double startX =
          (deviceWidth * (positions[j].x - centerX) / pizzaRadius) + centerX;
      final double startY =
          (deviceHeight * (positions[j].y - centerY) / pizzaRadius) + centerY;
      final double x2 = (startX - (value) * (startX - positions[j].x));
      final double y2 = (startY - (value) * (startY - positions[j].y));
      // canvas.drawShadow(Path() .. addRect(Rect.fromLTRB(x2, y2, x2+(1.2-value)*70,y2+(1.2-value)*70)), Colors.grey.shade100.withOpacity(0.2), 5, true);
      // canvas.drawCircle(Offset(x2,y2), 2, painter);
      canvas.drawImageRect(
          img,
          Rect.fromLTRB(0, 0, img.width.toDouble(), img.height.toDouble()),
          Rect.fromLTRB(x2, y2, x2 + (1.2 - value) * img.width,
              y2 + (1.2 - value) * img.height),
          painter);
    }
  }

  TopperPainter({
    required this.pizzaSize,
    required this.deviceWidth,
    required this.deviceHeight,
    required this.img,
    required this.positions,
    required this.value,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
