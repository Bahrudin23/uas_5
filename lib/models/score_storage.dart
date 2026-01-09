import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreStorage {
  static final _db = FirebaseFirestore.instance;

  static Future<void> saveScore(
      String name,
      int score,
      String difficulty,
      ) async {
    final ref = _db.collection('leaderboard').doc(name);
    final snap = await ref.get();

    if (!snap.exists) {
      await ref.set({
        'name': name,
        difficulty: score,
      });
      return;
    }

    final data = snap.data()!;
    final oldScore = data[difficulty];

    if (oldScore == null || score > oldScore) {
      await ref.update({
        difficulty: score,
      });
    }
  }

  static Stream<QuerySnapshot> loadScores(String difficulty) {
    return _db
        .collection('leaderboard')
        .where(difficulty, isGreaterThan: 0)
        .orderBy(difficulty, descending: true)
        .limit(10)
        .snapshots();
  }
}
