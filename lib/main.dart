import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MathDriveApp());
}

class MathDriveApp extends StatelessWidget {
  const MathDriveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const HomePage(),
    );
  }
}
