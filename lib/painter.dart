import 'package:flutter/material.dart';

class DrawPainter extends CustomPainter {
  List<Offset> points;

  DrawPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in points) {
      paint.color = const Color.fromRGBO(244, 67, 54, 1);
      canvas.drawCircle(p, 50, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
