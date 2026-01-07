import 'package:flutter/material.dart';

class RoadAnimation extends StatelessWidget {
  const RoadAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width, 220),
        painter: _RoadPainter(),
      ),
    );
  }
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()..color = Colors.grey.shade800;
    canvas.drawRect(Offset.zero & size, roadPaint);

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3;

    final laneWidth = size.width / 4;
    for (int i = 1; i < 4; i++) {
      canvas.drawLine(
        Offset(laneWidth * i, 0),
        Offset(laneWidth * i, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
