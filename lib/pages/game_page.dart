import 'package:flutter/material.dart';
import 'dart:async';
import '../data/question_generator.dart';
import '../data/question.dart';
import '../core/constants.dart';
import '../widgets/life_widget.dart';
import 'result_page.dart';

class GamePage extends StatefulWidget {
  final String level;
  const GamePage({super.key, required this.level});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int score = 0;
  int life = maxLife;
  late Question q;

  int currentLane = 1;
  int correctLane = 0;
  final int laneCount = 4;

  double obstacleY = -200;
  double roadOffset = 0;

  Timer? frameTimer;
  Timer? countdownTimer;
  int timeLeft = 15;

  @override
  void initState() {
    super.initState();
    startRound();
  }

  int getTimeByLevel() {
    if (widget.level == 'hard') {
      return 10;
    }
    return 15; // easy & medium
  }

  void startRound() {
    q = QuestionGenerator.generate(widget.level);
    correctLane = q.options.indexOf(q.correct);

    obstacleY = -200;
    timeLeft = getTimeByLevel();

    frameTimer?.cancel();
    countdownTimer?.cancel();

    startAnimation();
    startCountdown();

    setState(() {});
  }

  void startAnimation() {
    frameTimer = Timer.periodic(
      const Duration(milliseconds: 16),
          (_) {
        setState(() {
          roadOffset += 6;
          obstacleY += widget.level == 'hard' ? 6 : 4;
        });

        if (obstacleY > MediaQuery.of(context).size.height - 120) {
          checkCollision();
        }
      },
    );
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
          (t) {
        setState(() => timeLeft--);

        if (timeLeft == 0) {
          t.cancel();
          checkCollision();
        }
      },
    );
  }

  void checkCollision() {
    frameTimer?.cancel();
    countdownTimer?.cancel();

    if (currentLane == correctLane) {
      score += scorePerCorrect;
      startRound();
    } else {
      life--;
      if (life == 0) {
        endGame();
      } else {
        startRound();
      }
    }
  }

  void endGame() {
    frameTimer?.cancel();
    countdownTimer?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(
          score: score,
          level: widget.level,
        ),
      ),
    );
  }

  void moveLeft() {
    if (currentLane > 0) {
      setState(() => currentLane--);
    }
  }

  void moveRight() {
    if (currentLane < laneCount - 1) {
      setState(() => currentLane++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final laneWidth = size.width / laneCount;
    final roadHeight = size.height;

    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (d) {
          if (d.delta.dx > 5) moveRight();
          if (d.delta.dx < -5) moveLeft();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: roadOffset % roadHeight,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/road.png',
                height: roadHeight,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: (roadOffset % roadHeight) - roadHeight,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/road.png',
                height: roadHeight,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: 30,
              left: 20,
              child: Text('Score: $score'),
            ),
            Positioned(
              top: 30,
              right: 20,
              child: LifeWidget(life: life),
            ),

            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: LinearProgressIndicator(
                value: timeLeft / getTimeByLevel(),
              ),
            ),

            Positioned(
              top: 90,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  q.text,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Positioned(
              top: 140,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(laneCount, (i) {
                  return Text(
                    q.options[i].toString(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ),
            ),

            Positioned(
              top: obstacleY,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(laneCount, (i) {
                  return Container(
                    width: laneWidth * 0.5,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
            ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 60),
              curve: Curves.easeOut,
              bottom: 30,
              left: currentLane * laneWidth + laneWidth * 0.25,
              child: Image.asset(
                'assets/images/car.jpg',
                width: laneWidth * 0.5,
              ),
            ),

            Positioned(
              bottom: 20,
              left: 20,
              child: FloatingActionButton(
                heroTag: 'left_btn',
                onPressed: moveLeft,
                child: const Icon(Icons.arrow_left),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                heroTag: 'right_btn',
                onPressed: moveRight,
                child: const Icon(Icons.arrow_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}