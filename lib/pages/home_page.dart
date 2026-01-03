import 'package:flutter/material.dart';
import 'dart:math';
import '../data/local_storage.dart';
import 'difficulty_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = '';

  @override
  void initState() {
    super.initState();
    loadName();
  }

  void loadName() async {
    final saved = await LocalStorage.getName();
    if (saved.isEmpty) {
      name = ['Rider', 'Nova', 'Neo', 'Alpha'][Random().nextInt(4)];
      await LocalStorage.saveName(name);
    } else {
      name = saved;
    }
    setState(() {});
  }

  void editName() {
    final controller = TextEditingController(text: name);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nama Player'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                name = controller.text;
              });
              LocalStorage.saveName(name);
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
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
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DifficultyPage(),
                  ),
                );
              },
              child: const Text('START'),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: editName,
              child: Text('Player: $name'),
            ),
          ),
        ],
      ),
    );
  }
}