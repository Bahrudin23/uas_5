import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
//aktifkan untuk gyro
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
//

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
import 'home_screen.dart' show ControlMode;


class GameScreen extends StatefulWidget {
  final Difficulty difficulty;
  final ControlMode controlMode;
  final String playerName;

  const GameScreen({
    super.key,
    required this.difficulty,
    required this.controlMode,
    required this.playerName,
  });


  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  int score = 0;
  int life = 3;

  int get tunnelTimeLeft {
    final totalSeconds =
    widget.difficulty == Difficulty.sulit ? 3 : 5;

    final progress = tunnelController.value;
    final left = (totalSeconds * (1 - progress)).ceil();

    return left < 0 ? 0 : left;
  }

  void startGyro() {
    gyroSub?.cancel();

    gyroSub = accelerometerEvents.listen((event) {
      if (isGameOver) return;

      if (event.x > 2 && selectedLane > 0) {
        setState(() => selectedLane--);
      } else if (event.x < -2 && selectedLane < laneCount - 1) {
        setState(() => selectedLane++);
      }
    });
  }

  final int laneCount = 4;
  int selectedLane = 1;
  int correctLane = 0;

  List<int> answers = [];
  String question = "";

  late AnimationController tunnelController;
  late AnimationController shakeController;

  //aktifkan untuk gyro
  StreamSubscription<AccelerometerEvent>? gyroSub;
  //
  bool explodeTunnel = false;
  bool isGameOver = false;
  bool audioStarted = false;
  bool dialogShown = false;

  final bgm = AudioPlayer();
  final sfx = AudioPlayer();

  Future<void> startBgm() async {
    if (audioStarted) return;
    audioStarted = true;
    await bgm.setReleaseMode(ReleaseMode.loop);
    await bgm.play(AssetSource("audio/music_bg.mp3"));
  }

  @override
  void initState() {
    super.initState();

    startBgm();

    tunnelController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: widget.difficulty == Difficulty.sulit ? 3 : 5,
      ),
    );

    shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: -10,
      upperBound: 10,
    );

    tunnelController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (!mounted || isGameOver) return;
          checkAnswer();
        });
      }
    });

    if (widget.controlMode == ControlMode.gyro) {
      startGyro();
    }

    generateQuestion();
    startRound();
  }

  void startRound() {
    if (isGameOver) return;

    explodeTunnel = false;
    shakeController.stop();
    shakeController.reset();

    tunnelController.stop();
    tunnelController.reset();

    tunnelController.forward();
  }

  void generateQuestion() {
    final rnd = Random();
    int a = rnd.nextInt(10) + 1;
    int b = rnd.nextInt(10) + 1;

    int result;

    if (widget.difficulty == Difficulty.mudah) {
      final ops = ["+", "-"];
      final op = ops[rnd.nextInt(2)];

      if (op == "+") {
        result = a + b;
        question = "$a + $b";
      } else {
        result = a - b;
        question = "$a - $b";
      }
    } else if (widget.difficulty == Difficulty.normal) {
      final ops = ["×", "÷"];
      final op = ops[rnd.nextInt(2)];

      if (op == "÷") {
        result = a;
        question = "${a * b} ÷ $b";
      } else {
        result = a * b;
        question = "$a × $b";
      }
    } else {
      final ops = ["+", "-", "×", "÷"];
      final op = ops[rnd.nextInt(4)];

      if (op == "+") {
        result = a + b;
        question = "$a + $b";
      } else if (op == "-") {
        result = a - b;
        question = "$a - $b";
      } else if (op == "×") {
        result = a * b;
        question = "$a × $b";
      } else {
        result = a;
        question = "${a * b} ÷ $b";
      }
    }

    correctLane = rnd.nextInt(laneCount);

    answers = List.generate(laneCount, (i) {
      if (i == correctLane) return result;
      return result + rnd.nextInt(9) + 1;
    });
  }

  void checkAnswer() async {
    if (isGameOver) return;

    if (selectedLane == correctLane) {
      setState(() {
        score += 20;
      });
      await sfx.play(AssetSource("audio/benar.mp3"));
    } else {
      setState(() {
        life--;
        explodeTunnel = true;
      });

      shakeController.forward(from: 0);
      await sfx.play(AssetSource("audio/menabrak.mp3"));

      if (life <= 0) {
        isGameOver = true;

        tunnelController.stop(canceled: true);
        shakeController.stop(canceled: true);
        gyroSub?.cancel();

        await sfx.play(AssetSource("audio/meledak.mp3"));
        try {
          await ScoreStorage.saveScore(
            widget.playerName,
            score,
            widget.difficulty.name,
          );
        } catch (e) {
          debugPrint('Save score failed: $e');
        }

        if (!dialogShown) {
          dialogShown = true;

          Future.microtask(() {
            if (!mounted) return;
            showGameOver();
          });
        }
        return;
      }
    }

    if (isGameOver) return;

    setState(() {
      generateQuestion();
    });
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
                  builder: (_) => GameScreen(
                    difficulty: widget.difficulty,
                    controlMode: widget.controlMode,
                    playerName: widget.playerName,
                  ),
                ),
              );
            },
            child: const Text("Mulai Lagi"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => DifficultyScreen(
                    controlMode: widget.controlMode,
                    playerName: widget.playerName,
                  ),
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
    gyroSub?.cancel();
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
      body: Stack(
        children: [
          IgnorePointer(
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
                    return Stack(
                      children: [
                        TunnelAnimation(
                          progress: tunnelController.value,
                          answers: answers,
                          explode: explodeTunnel,
                        ),
                        Positioned(
                          top: 200,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  '$tunnelTimeLeft',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 5
                                      ..color = Colors.black,
                                  ),
                                ),
                                Text(
                                  '$tunnelTimeLeft',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

          if (widget.controlMode == ControlMode.sentuh)
            Listener(
              behavior: HitTestBehavior.opaque,
              onPointerMove: (event) {
                if (event.delta.dx > 8 && selectedLane < laneCount - 1) {
                  setState(() => selectedLane++);
                } else if (event.delta.dx < -8 && selectedLane > 0) {
                  setState(() => selectedLane--);
                }
              },
            ),

          if (widget.controlMode == ControlMode.tombol)
            Positioned(
              bottom: 200,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left, size: 48),
                    color: Colors.white,
                    onPressed: () {
                      if (selectedLane > 0) {
                        setState(() => selectedLane--);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right, size: 48),
                    color: Colors.white,
                    onPressed: () {
                      if (selectedLane < laneCount - 1) {
                        setState(() => selectedLane++);
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
