import 'package:flutter/material.dart';
import '../models/time_mode.dart';

class SkyAnimation extends StatelessWidget {
  final TimeMode mode;
  const SkyAnimation({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _SkyPainter(mode),
      ),
    );
  }
}

class _SkyPainter extends CustomPainter {
  final TimeMode mode;
  _SkyPainter(this.mode);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: mode == TimeMode.day
            ? [const Color(0xFF87CEEB), const Color(0xFFBFEFFF)]
            : [const Color(0xFF0B132B), const Color(0xFF1C2541)],
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}
