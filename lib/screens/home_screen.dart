import 'dart:math';
import 'package:flutter/material.dart';
import 'difficulty_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/score_storage.dart';


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

  @override
  void initState() {
    super.initState();
    loadPlayer();
    loadControl();
  }

  Future<void> loadPlayer() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString("player_name");

    if (savedName == null ||
        savedName.trim().isEmpty ||
        savedName.toLowerCase() == "player") {
      savedName = "Player${Random().nextInt(900) + 100}";
      await prefs.setString("player_name", savedName);
    }

    setState(() {
      playerName = savedName!;
    });
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
              final name = controller.text.trim();
              if (name.isEmpty || name.toLowerCase() == "player") return;

              final prefs = await SharedPreferences.getInstance();
              await prefs.setString("player_name", name);
              setState(() => playerName = name);
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void showControlSetting() {
    ControlMode tempMode = controlMode;

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
              groupValue: tempMode,
              onChanged: (v) {
                tempMode = v!;
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              saveControl(tempMode);
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
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
    final field = diff.name;

    return StreamBuilder(
      stream: ScoreStorage.loadScores(field),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("Belum ada skor"));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final score = data[field];

            return ListTile(
              leading: Text("${i + 1}"),
              title: Text(data['name']),
              trailing: Text(score.toString()),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                      builder: (_) => DifficultyScreen(
                        controlMode: controlMode,
                        playerName: playerName,
                      ),
                    ),
                  );
                },
                child: const Text("Mulai"),
              ),
            ),

            Positioned(
              left: 24,
              bottom: 24,
              child: GestureDetector(
                onTap: editName,
                child: Text(
                  playerName,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

            Positioned(
              left: 24,
              top: 24,
              child: IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: showControlSetting,
              ),
            ),

            Positioned(
              right: 24,
              top: 24,
              child: IconButton(
                icon: const Icon(Icons.emoji_events, color: Colors.white),
                onPressed: showLeaderboard,
              ),
            ),
          ],
        ),
      ),
    );
  }
}