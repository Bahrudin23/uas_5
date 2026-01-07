import 'package:flutter/material.dart';

class CarAnimation extends StatelessWidget {
  final int lane;
  final int life;
  final Animation<double> shake;

  const CarAnimation({
    super.key,
    required this.lane,
    required this.life,
    required this.shake,
  });

  @override
  Widget build(BuildContext context) {
    final laneWidth = MediaQuery.of(context).size.width / 4;

    return Positioned(
      bottom: 40,
      left: laneWidth * lane + laneWidth / 2 - 30,
      child: AnimatedBuilder(
        animation: shake,
        builder: (_, __) {
          return Transform.translate(
            offset: Offset(shake.value, 0),
            child: CustomPaint(
              size: const Size(60, 100),
              painter: _CarPainter(life),
            ),
          );
        },
      ),
    );
  }
}

class _CarPainter extends CustomPainter {
  final int life;
  _CarPainter(this.life);

  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()
      ..color = life == 3
          ? Colors.red
          : life == 2
          ? Colors.orange
          : Colors.grey;

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(10, 20, 40, 60),
      const Radius.circular(10),
    );

    canvas.drawRRect(body, bodyPaint);

    final wheelPaint = Paint()..color = Colors.black;
    canvas.drawCircle(const Offset(18, 90), 6, wheelPaint);
    canvas.drawCircle(const Offset(42, 90), 6, wheelPaint);
  }

  @override
  bool shouldRepaint(_) => true;
}
