import 'package:flutter/material.dart';

class GroundAnimation extends StatelessWidget {
  const GroundAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 200,
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width, 40),
        painter: _GroundPainter(),
      ),
    );
  }
}

class _GroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grass = Paint()..color = Colors.green;
    final soil = Paint()..color = Colors.brown;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, 15),
      grass,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 15, size.width, 25),
      soil,
    );
  }

  @override
  bool shouldRepaint(_) => true;
}
