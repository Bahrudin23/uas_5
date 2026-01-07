import 'package:flutter/material.dart';

class CloudAnimation extends StatelessWidget {
  final String question;
  final double progress;

  const CloudAnimation({
    super.key,
    required this.question,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: MediaQuery.of(context).size.width / 2 - 80,
      child: Column(
        children: [
          CustomPaint(
            size: const Size(160, 80),
            painter: _CloudPainter(),
          ),
          const SizedBox(height: 6),
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                question,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 5
                    ..color = Colors.black,
                ),
              ),
              Text(
                question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.6), 25, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 35, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.6), 25, paint);

    canvas.drawRect(
      Rect.fromLTWH(20, size.height * 0.6, size.width - 40, 30),
      paint,
    );
  }

  @override
  bool shouldRepaint(_) => true;
}
