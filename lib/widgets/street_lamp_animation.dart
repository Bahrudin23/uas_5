import 'package:flutter/material.dart';
import '../models/time_mode.dart';

class StreetLampAnimation extends StatelessWidget {
  final TimeMode mode;
  const StreetLampAnimation({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 220,
      left: 40,
      child: CustomPaint(
        size: const Size(40, 120),
        painter: _LampPainter(mode),
      ),
    );
  }
}

class _LampPainter extends CustomPainter {
  final TimeMode mode;
  _LampPainter(this.mode);

  @override
  void paint(Canvas canvas, Size size) {
    final polePaint = Paint()..color = Colors.grey;
    canvas.drawRect(
      Rect.fromLTWH(18, 20, 4, size.height),
      polePaint,
    );

    final lightPaint = Paint()
      ..color = mode == TimeMode.night
          ? Colors.yellow.withOpacity(0.8)
          : Colors.transparent;

    canvas.drawCircle(const Offset(20, 10), 10, lightPaint);
  }

  @override
  bool shouldRepaint(_) => true;
}
