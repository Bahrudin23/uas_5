import 'dart:math';
import 'package:flutter/material.dart';

class SunAnimation extends StatelessWidget {
  const SunAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 40,
      child: CustomPaint(
        size: const Size(80, 80),
        painter: _SunPainter(),
      ),
    );
  }
}

class _SunPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.orange, Colors.deepOrange],
      ).createShader(Rect.fromCircle(center: center, radius: 40));

    canvas.drawCircle(center, 30, sunPaint);

    final rayPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 3;

    for (int i = 0; i < 12; i++) {
      final angle = i * 3.14 / 6;
      canvas.drawLine(
        center,
        center + Offset(45 * cos(angle), 45 * sin(angle)),
        rayPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
