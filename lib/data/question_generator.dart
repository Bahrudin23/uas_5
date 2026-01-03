import 'dart:math';
import 'question.dart';

class QuestionGenerator {
  static Question generate(String level) {
    final rnd = Random();
    int a = rnd.nextInt(20) + 1;
    int b = rnd.nextInt(10) + 1;
    String op;

    if (level == 'easy') {
      op = rnd.nextBool() ? '+' : '-';
    } else if (level == 'medium') {
      op = rnd.nextBool() ? '*' : '/';
      if (op == '/') {
        a = b * (rnd.nextInt(10) + 1);
      }
    } else {
      op = ['+','-','*','/'][rnd.nextInt(4)];
      if (op == '/') {
        a = b * (rnd.nextInt(10) + 1);
      }
    }

    int correct;
    switch (op) {
      case '+': correct = a + b; break;
      case '-': correct = a - b; break;
      case '*': correct = a * b; break;
      default: correct = a ~/ b;
    }

    final set = <int>{correct};
    while (set.length < 4) {
      set.add(correct + rnd.nextInt(10) - 5);
    }

    return Question('$a $op $b', correct, set.toList()..shuffle());
  }
}
