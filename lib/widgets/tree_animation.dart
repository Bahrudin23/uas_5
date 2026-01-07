import 'package:flutter/material.dart';

class TreeAnimation extends StatelessWidget {
  final double left;
  const TreeAnimation({super.key, required this.left});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 220,
      left: left,
      child: CustomPaint(
        size: const Size(60, 100),
        painter: _TreePainter(),
      ),
    );
  }
}

class _TreePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final trunkPaint = Paint()..color = Colors.brown;
    canvas.drawRect(
      Rect.fromLTWH(25, 40, 10, 60),
      trunkPaint,
    );

    final leafPaint = Paint()..color = Colors.green;
    canvas.drawCircle(const Offset(30, 30), 25, leafPaint);
    canvas.drawCircle(const Offset(18, 35), 20, leafPaint);
    canvas.drawCircle(const Offset(42, 35), 20, leafPaint);
  }

  @override
  bool shouldRepaint(_) => true;
}
