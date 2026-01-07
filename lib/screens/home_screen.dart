import 'dart:math';
import 'package:flutter/material.dart';
import 'difficulty_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ControlMode { sentuh, tombol, gyro }
enum Difficulty { mudah, normal, sulit }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String playerName = "";
  ControlMode controlMode = ControlMode.sentuh;

  final Map<Difficulty, List<Map<String, int>>> dummyLeaderboard = {
    Difficulty.mudah: List.generate(
      10,
          (i) => {"Player${i + 1}": 300 - (i * 10)},
    ),
    Difficulty.normal: List.generate(
      10,
          (i) => {"Player${i + 1}": 250 - (i * 10)},
    ),
    Difficulty.sulit: List.generate(
      10,
          (i) => {"Player${i + 1}": 200 - (i * 10)},
    ),
  };

  @override
  void initState() {
    super.initState();
    loadPlayer();
    loadControl();
  }

  Future<void> loadPlayer() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      playerName = prefs.getString("player_name") ??
          "Player${Random().nextInt(999)}";
    });
    prefs.setString("player_name", playerName);
  }

  Future<void> loadControl() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt("control_mode") ?? 0;
    setState(() {
      controlMode = ControlMode.values[value];
    });
  }

  Future<void> saveControl(ControlMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("control_mode", mode.index);
    setState(() => controlMode = mode);
  }

  void editName() {
    final controller = TextEditingController(text: playerName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nama Pemain"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setString("player_name", controller.text);
              setState(() => playerName = controller.text);
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void showControlSetting() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Kontrol Game"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ControlMode.values.map((mode) {
            return RadioListTile(
              title: Text(mode.name),
              value: mode,
              groupValue: controlMode,
              onChanged: (v) => saveControl(v!),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          )
        ],
      ),
    );
  }

  void showLeaderboard() {
    showDialog(
      context: context,
      builder: (_) => DefaultTabController(
        length: 3,
        child: AlertDialog(
          title: const Text("Papan Skor Terbaik"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: "Mudah"),
                    Tab(text: "Normal"),
                    Tab(text: "Sulit"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      leaderboardList(Difficulty.mudah),
                      leaderboardList(Difficulty.normal),
                      leaderboardList(Difficulty.sulit),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            )
          ],
        ),
      ),
    );
  }

  Widget leaderboardList(Difficulty diff) {
    final data = dummyLeaderboard[diff]!;
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_, i) {
        final entry = data[i].entries.first;
        return ListTile(
          leading: Text("${i + 1}"),
          title: Text(entry.key),
          trailing: Text(entry.value.toString()),
        );
      },
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
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DifficultyScreen(),
                  ),
                );
              },
              child: const Text("Mulai"),
            ),
          ),

          Positioned(
            left: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: editName,
              child: Text(
                playerName,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),

          Positioned(
            left: 16,
            top: 16,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: showControlSetting,
            ),
          ),

          Positioned(
            right: 16,
            top: 16,
            child: IconButton(
              icon: const Icon(Icons.emoji_events, color: Colors.white),
              onPressed: showLeaderboard,
            ),
          ),
        ],
      ),
    );
  }
}