import 'package:audioplayers/audioplayers.dart';

class AudioEngine {
  static final AudioPlayer _bgm = AudioPlayer();
  static final AudioPlayer _sfx = AudioPlayer();

  static bool _bgmStarted = false;

  static Future<void> startBgm() async {
    if (_bgmStarted) return;
    _bgmStarted = true;

    await _bgm.setReleaseMode(ReleaseMode.loop);
    await _bgm.setVolume(0.5);
    await _bgm.play(
      AssetSource("audio/music_bg.mp3"),
    );
  }

  static Future<void> stopBgm() async {
    _bgmStarted = false;
    await _bgm.stop();
  }

  static Future<void> playCorrect() async {
    await _sfx.stop();
    await _sfx.play(
      AssetSource("audio/benar.mp3"),
    );
  }

  static Future<void> playCrash() async {
    await _sfx.stop();
    await _sfx.play(
      AssetSource("audio/menabrak.mp3"),
    );
  }

  static Future<void> playExplosion() async {
    await _sfx.stop();
    await _sfx.play(
      AssetSource("audio/meledak.mp3"),
    );
  }

  static Future<void> playClick() async {
    await _sfx.stop();
    await _sfx.play(
      AssetSource("audio/clik.mp3"),
    );
  }

  static Future<void> dispose() async {
    await _bgm.dispose();
    await _sfx.dispose();
  }
}
