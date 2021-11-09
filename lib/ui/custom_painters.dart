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
  double velocity;

  Pos(this.x, this.y, this.velocity);
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
    final centerX = (deviceWidth - 20) / 2;
    const centerY = 70 + (350 / 2);
    final valueSquare = value * value;
    for (int j = 0; j < positions.length; j++) {
      final double value = valueSquare * positions[j].velocity < 1
          ? valueSquare * positions[j].velocity
          : 1;
      final double startX =
          (deviceWidth * 1.2 * (positions[j].x - centerX) / pizzaRadius) +
              centerX;
      final double startY =
          (deviceHeight * 1.2 * (positions[j].y - centerY) / pizzaRadius) +
              centerY;
      if (value < 1) {
        painter.imageFilter = ui.ImageFilter.blur(
            sigmaX: (1 - value) * 5, sigmaY: (1 - value) * 5);
      }

      final double x2 = interpolate(startX ,positions[j].x,value);
      final double y2 = interpolate(startY ,positions[j].y,value);
      // canvas.drawShadow(Path() .. addRect(Rect.fromLTRB(x2, y2, x2+(1.2-value)*70,y2+(1.2-value)*70)), Colors.grey.shade100.withOpacity(0.2), 5, true);
      // canvas.drawCircle(Offset(x2,y2), 2, painter);
      // canvas.rotate(j*pi/3);
      canvas.drawImageRect(
          img,
          Rect.fromLTRB(0, 0, img.width.toDouble(), img.height.toDouble()),
          Rect.fromLTRB(x2, y2, x2 + (1.2 - value) * img.width,
              y2 + (1.2 - value) * img.height),
          painter);
      // canvas.translate(x2, y2);
      // canvas.rotate(j*pi/6);
      // canvas.translate(-x2, y2);
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

  double interpolate(num a, num b,double progress){
    return (a - (3*progress*progress-progress-1) * (a - b));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Rect rotateRect(Rect rect, double radian) {
    final x2 = rect.left;
    final y2 = rect.top;
    rect.translate(-x2, -y2);
    // 𝑥cos𝜃−𝑦sin𝜃 ,𝑥sin𝜃+𝑦cos𝜃)
    return Rect.fromPoints(rotatePoint(rect.left, rect.top, radian),
        rotatePoint(rect.right, rect.bottom, radian))
      ..translate(x2, y2);
  }

  Offset rotatePoint(double x, double y, double radian) {
    return Offset(
        x * cos(radian) - y * sin(radian), x * sin(radian) + y * cos(radian));
  }
}
