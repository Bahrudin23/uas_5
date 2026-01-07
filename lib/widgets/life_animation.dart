import 'package:flutter/material.dart';

class LifeAnimation extends StatelessWidget {
  final int life;
  const LifeAnimation({super.key, required this.life});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: Row(
        children: List.generate(3, (i) {
          return Padding(
            padding: const EdgeInsets.all(4),
            child: CustomPaint(
              size: const Size(20, 20),
              painter: _HeartPainter(active: i < life),
            ),
          );
        }),
      ),
    );
  }
}

class _HeartPainter extends CustomPainter {
  final bool active;
  _HeartPainter({required this.active});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = active ? Colors.red : Colors.grey;

    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.cubicTo(size.width * 1.2, size.height * 0.6, size.width * 0.8, 0,
        size.width / 2, size.height * 0.4);
    path.cubicTo(size.width * 0.2, 0, -size.width * 0.2,
        size.height * 0.6, size.width / 2, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}
