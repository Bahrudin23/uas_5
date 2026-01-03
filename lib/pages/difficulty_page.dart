import 'package:flutter/material.dart';
import 'game_page.dart';

class DifficultyPage extends StatelessWidget {
  const DifficultyPage({super.key});

  void start(BuildContext context, String level) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GamePage(level: level),
      ),
    );
  }

  Widget levelCard(
      BuildContext context,
      String title,
      String desc,
      String level,
      ) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 20)),
        subtitle: Text(desc),
        trailing: const Icon(Icons.play_arrow),
        onTap: () => start(context, level),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Level')),
      body: Column(
        children: [
          levelCard(context, 'Mudah', 'Tambah dan kurang. Waktu 15 detik', 'easy'),
          levelCard(context, 'Sedang', 'Kali dan bagi. Waktu 15 detik', 'medium'),
          levelCard(context, 'Susah', 'Campuran. Waktu 10 detik', 'hard'),
        ],
      ),
    );
  }
}
