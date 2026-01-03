import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('PLAYER_NAME', name);
  }

  static Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('PLAYER_NAME') ?? '';
  }

  static Future<void> saveHigh(String level, int score) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('HIGH_$level', score);
  }

  static Future<int> getHigh(String level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('HIGH_$level') ?? 0;
  }
}
