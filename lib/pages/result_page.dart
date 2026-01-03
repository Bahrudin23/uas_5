import 'package:flutter/material.dart';
import 'game_page.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final String level;

  const ResultPage({
    super.key,
    required this.score,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Over',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $score',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GamePage(level: level),
                  ),
                );
              },
              child: const Text('Mulai Ulang'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
              child: const Text('Beranda'),
            ),
          ],
        ),
      ),
    );
  }
}
