// tunnel_animation.dart
import 'package:flutter/material.dart';

class TunnelAnimation extends StatelessWidget {
  final double progress;
  final List<int> answers;
  final bool explode;

  const TunnelAnimation({
    super.key,
    required this.progress,
    required this.answers,
    required this.explode,
  });

  double laneX(int index, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final laneWidth = width / answers.length;
    return laneWidth * index + laneWidth / 2 - 12;
  }

  @override
  Widget build(BuildContext context) {
    final tunnelY = 160 + progress * 220;

    return Stack(
      children: [
        for (int i = 0; i < answers.length; i++)
          Positioned(
            top: tunnelY,
            left: laneX(i, context),
            child: Column(
              children: [
                Text(
                  answers[i].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 70,
                  height: 40,
                  decoration: BoxDecoration(
                    color: explode ? Colors.red : Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
