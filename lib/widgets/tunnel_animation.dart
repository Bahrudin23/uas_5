import 'package:flutter/material.dart';

class TunnelAnimation extends StatelessWidget {
  final double progress;
  final int correctLane;
  final bool explode;

  const TunnelAnimation({
    super.key,
    required this.progress,
    required this.correctLane,
    required this.explode,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 4;
    final y = MediaQuery.of(context).size.height * progress;

    return Positioned(
      top: y,
      left: 0,
      right: 0,
      child: Row(
        children: List.generate(4, (i) {
          return SizedBox(
            width: w,
            height: 80,
            child: CustomPaint(
              painter: _TunnelPainter(
                correct: i == correctLane,
                explode: explode && i != correctLane,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TunnelPainter extends CustomPainter {
  final bool correct;
  final bool explode;

  _TunnelPainter({required this.correct, required this.explode});

  @override
  void paint(Canvas canvas, Size size) {
    final body = Paint()
      ..color = explode
          ? Colors.orange
          : (correct ? Colors.green : Colors.red);

    canvas.drawRect(
      Rect.fromLTWH(10, 10, size.width - 20, size.height - 20),
      body,
    );
  }

  @override
  bool shouldRepaint(_) => true;
}
