import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MobilMathematicsApp());
}

class MobilMathematicsApp extends StatelessWidget {
  const MobilMathematicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
