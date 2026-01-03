import 'package:flutter/material.dart';

class CarWidget extends StatelessWidget {
  const CarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 40,
      color: Colors.blue,
      child: const Center(child: Text('CAR')),
    );
  }
}
