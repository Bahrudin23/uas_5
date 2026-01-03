import 'package:flutter/material.dart';

class TunnelWidget extends StatelessWidget {
  final int value;
  final VoidCallback onTap;

  const TunnelWidget({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value.toString()),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60,
            height: 120,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
