import 'package:flutter/material.dart';
import 'game_screen.dart';

enum Difficulty { mudah, normal, sulit }

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  void showConfirm(BuildContext context, Difficulty diff) {
    String title = "";
    String desc = "";

    if (diff == Difficulty.mudah) {
      title = "Mudah";
      desc =
      "Waktu berpikir 15 detik\nSoal penjumlahan dan pengurangan";
    } else if (diff == Difficulty.normal) {
      title = "Normal";
      desc =
      "Waktu berpikir 15 detik\nSoal perkalian dan pembagian";
    } else {
      title = "Sulit";
      desc =
      "Waktu berpikir 10 detik\nSoal penjumlahan, pengurangan, perkalian, dan pembagian";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Expanded(child: Text("Apakah kamu yakin")),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(desc),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => GameScreen(difficulty: diff),
                ),
              );
            },
            child: const Text("Mulai"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/images/background.jpg",
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      showConfirm(context, Difficulty.mudah),
                  child: const Text("Mudah"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () =>
                      showConfirm(context, Difficulty.normal),
                  child: const Text("Normal"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () =>
                      showConfirm(context, Difficulty.sulit),
                  child: const Text("Sulit"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
