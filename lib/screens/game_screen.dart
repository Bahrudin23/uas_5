import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../models/time_mode.dart';
import '../models/score_storage.dart';

import '../widgets/sky_animation.dart';
import '../widgets/sun_animation.dart';
import '../widgets/moon_animation.dart';
import '../widgets/road_animation.dart';
import '../widgets/ground_animation.dart';
import '../widgets/tree_animation.dart';
import '../widgets/cloud_animation.dart';
import '../widgets/car_animation.dart';
import '../widgets/life_animation.dart';
import '../widgets/street_lamp_animation.dart';
import '../widgets/tunnel_animation.dart';

import 'difficulty_screen.dart';
import 'home_screen.dart' hide Difficulty;

class GameScreen extends StatefulWidget {
  final Difficulty difficulty;
  const GameScreen({super.key, required this.difficulty});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {

  int score = 0;
  int life = 3;

  final int laneCount = 4;
  int selectedLane = 1;
  int correctLane = 0;

  late int maxTime;
  String question = "";

  late AnimationController tunnelController;
  late AnimationController shakeController;

  bool explodeTunnel = false;
  bool isGameOver = false;
  bool audioStarted = false;

  final bgm = AudioPlayer();
  final sfx = AudioPlayer();

  @override
  void initState() {
    super.initState();

    maxTime = widget.difficulty == Difficulty.sulit ? 10 : 15;

    tunnelController = AnimationController(
      vsync: this,
      duration: Duration(seconds: maxTime),
    );

    shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: -10,
      upperBound: 10,
    );

    tunnelController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkAnswer();
      }
    });

    generateQuestion();
    startRound();
  }

  Future<void> startAudioIfNeeded() async {
    if (audioStarted) return;
    audioStarted = true;

    await bgm.setReleaseMode(ReleaseMode.loop);
    await bgm.play(AssetSource("audio/music_bg.mp3"));
  }

  void startRound() {
    if (isGameOver) return;
    explodeTunnel = false;
    tunnelController.forward(from: 0);
  }

  void generateQuestion() {
    final rnd = Random();
    int a = rnd.nextInt(10) + 1;
    int b = rnd.nextInt(10) + 1;

    if (widget.difficulty == Difficulty.mudah) {
      question = "$a + $b";
    } else if (widget.difficulty == Difficulty.normal) {
      question = "$a × $b";
    } else {
      final ops = ["+", "-", "×"];
      final op = ops[rnd.nextInt(3)];
      question = "$a $op $b";
    }

    correctLane = rnd.nextInt(laneCount);
  }

  void checkAnswer() async {
    if (isGameOver) return;

    if (selectedLane == correctLane) {
      score += 20;
      await sfx.play(AssetSource("audio/benar.mp3"));
    } else {
      life--;
      explodeTunnel = true;
      shakeController.forward(from: 0);
      await sfx.play(AssetSource("audio/menabrak.mp3"));

      if (life <= 0) {
        isGameOver = true;
        tunnelController.stop();
        shakeController.stop();

        await sfx.play(AssetSource("audio/meledak.mp3"));
        await ScoreStorage.saveScore(
          "Player",
          score,
          widget.difficulty.name,
        );

        if (!mounted) return;
        showGameOver();
        return;
      }
    }

    generateQuestion();
    startRound();
  }

  void showGameOver() {
    bgm.stop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("GAME OVER"),
        content: Text("Skor kamu $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      GameScreen(difficulty: widget.difficulty),
                ),
              );
            },
            child: const Text("Mulai Kembali"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const DifficultyScreen(),
                ),
              );
            },
            child: const Text("Kembali"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                ),
                    (_) => false,
              );
            },
            child: const Text("Home"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tunnelController.dispose();
    shakeController.dispose();
    bgm.dispose();
    sfx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = getTimeMode();

    return Scaffold(
      body: GestureDetector(
        onTap: startAudioIfNeeded,
        onHorizontalDragUpdate: (d) {
          if (d.delta.dx > 8 && selectedLane < laneCount - 1) {
            setState(() => selectedLane++);
          } else if (d.delta.dx < -8 && selectedLane > 0) {
            setState(() => selectedLane--);
          }
        },
        child: Stack(
          children: [
            SkyAnimation(mode: mode),
            if (mode == TimeMode.day) const SunAnimation(),
            if (mode == TimeMode.night) const MoonAnimation(),

            const RoadAnimation(),
            const GroundAnimation(),
            StreetLampAnimation(mode: mode),

            TreeAnimation(left: 20),
            TreeAnimation(left: 300),

            AnimatedBuilder(
              animation: tunnelController,
              builder: (_, __) {
                return TunnelAnimation(
                  progress: tunnelController.value,
                  correctLane: correctLane,
                  explode: explodeTunnel,
                );
              },
            ),

            CloudAnimation(
              question: question,
              progress: 1 - tunnelController.value,
            ),

            CarAnimation(
              lane: selectedLane,
              life: life,
              shake: shakeController,
            ),

            LifeAnimation(life: life),

            Positioned(
              left: 16,
              top: 16,
              child: Text(
                "Skor $score",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
