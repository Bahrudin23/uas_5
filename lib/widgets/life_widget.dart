import 'package:flutter/material.dart';

class LifeWidget extends StatelessWidget {
  final int life;
  const LifeWidget({super.key, required this.life});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(life, (_) {
        return const Icon(Icons.favorite, color: Colors.red);
      }),
    );
  }
}
