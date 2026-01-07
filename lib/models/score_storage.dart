import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreStorage {
  static const _key = "global_scores";

  static Future<void> saveScore(
      String name,
      int score,
      String difficulty,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    list.add(jsonEncode({
      "name": name,
      "score": score,
      "difficulty": difficulty,
      "time": DateTime.now().toIso8601String(),
    }));

    await prefs.setStringList(_key, list);
  }

  static Future<List<Map<String, dynamic>>> loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    return list
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList()
      ..sort((a, b) => b["score"].compareTo(a["score"]));
  }
}