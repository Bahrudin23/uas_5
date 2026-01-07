import 'package:flutter/material.dart';

class MoonAnimation extends StatelessWidget {
  const MoonAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 40,
      child: CustomPaint(
        size: const Size(70, 70),
        painter: _MoonPainter(),
      ),
    );
  }
}

class _MoonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.shade300;

    canvas.drawCircle(size.center(Offset.zero), 25, paint);

    paint.color = Colors.grey.shade400;
    canvas.drawCircle(const Offset(35, 30), 6, paint);
    canvas.drawCircle(const Offset(25, 40), 4, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}
