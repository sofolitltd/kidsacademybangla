import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  final AudioPlayer audioPlayer;
  late final FlutterTts _tts;

  SpeechService({AudioPlayer? audioPlayer})
    : audioPlayer = audioPlayer ?? AudioPlayer() {
    _tts = FlutterTts();
  }

  FlutterTts get tts => _tts;

  Future<void> initTts() async {
    try {
      await _tts.setLanguage('ar');
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);
    } catch (e) {
      debugPrint('TTS init error: $e');
    }
  }

  Future<void> speak(String text) async {
    try {
      await audioPlayer.stop();
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  /// Plays the item's recorded voice (`sound`) if it has one.
  /// Returns false when there is no recording, so callers can fall back to TTS.
  Future<bool> playItemSound(String itemId, Map<String, dynamic> item) async {
    final sound = item['sound'];
    if (sound is! String || sound.isEmpty) return false;
    try {
      await _tts.stop();
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource('sounds/$itemId/$sound'));
      return true;
    } catch (e) {
      debugPrint('Item sound error: $e');
      return false;
    }
  }

  /// Recorded voice when available, otherwise spoken name + meaning (TTS).
  Future<void> speakItemWithRecording(
    String itemId,
    Map<String, dynamic> item,
  ) async {
    if (await playItemSound(itemId, item)) return;
    await speakItemWithMeaning(item);
  }

  /// Math lessons are spoken in Bangla only.
  Future<void> speakMath(String itemId, Map<String, dynamic> item) async {
    final String pron = item['pron'] ?? '';
    final String name = item['item'] ?? '';

    // Shapes: English name, then "মানে <Bangla name>", then the meaning.
    if (itemId == 'math_shapes') {
      try {
        await audioPlayer.stop();
        await _tts.stop();
        if (pron.isNotEmpty) {
          await _tts.setLanguage('en-US');
          await _tts.speak(pron);
        }
        await _tts.setLanguage('bn');
        if (name.isNotEmpty) await _tts.speak('মানে $name');
        final meaning = item['meaning'] ?? '';
        if (meaning.isNotEmpty) await _tts.speak(meaning);
        await _tts.setLanguage('ar');
      } catch (e) {
        debugPrint('TTS speak shape error: $e');
      }
      return;
    }

    String text;
    switch (itemId) {
      case 'math_addition':
        final answer = item['answer'] ?? '';
        text = answer.isEmpty ? pron : '$pron, সমান $answer';
        break;
      default: // counting, time
        text = pron.isNotEmpty ? pron : name;
    }
    if (text.isEmpty) return;
    await speakBangla(text);
    try {
      await _tts.setLanguage('ar');
    } catch (_) {}
  }

  Future<void> speakBangla(String text) async {
    try {
      await audioPlayer.stop();
      await _tts.stop();
      await _tts.setLanguage('bn');
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS speak bangla error: $e');
    }
  }

  Future<void> speakEnglish(String text) async {
    try {
      await audioPlayer.stop();
      await _tts.stop();
      await _tts.setLanguage('en-US');
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS speak english error: $e');
    }
  }

  Future<void> speakArabicWithMeaning(Map<String, dynamic> item) async {
    try {
      await audioPlayer.stop();
      await _tts.stop();

      final arabicItem = item['item'] ?? '';
      final banglaPron = item['pron'] ?? '';

      if (arabicItem.isNotEmpty) {
        await _tts.setLanguage('ar');
        await _tts.speak(arabicItem);
      }

      if (banglaPron.isNotEmpty) {
        await _tts.setLanguage('bn');
        await _tts.speak('মানে $banglaPron');
      }
    } catch (e) {
      debugPrint('TTS speak arabic with meaning error: $e');
    }
  }

  Future<void> speakAllahName(Map<String, dynamic> item) async {
    try {
      await audioPlayer.stop();
      await _tts.stop();

      final arabicName = item['item'] ?? '';
      final banglaPron = item['meaning'] ?? '';

      if (arabicName.isNotEmpty) {
        await _tts.setLanguage('ar');
        await _tts.speak(arabicName);
      }

      if (banglaPron.isNotEmpty) {
        await _tts.setLanguage('bn');
        await _tts.speak(banglaPron);
      }

      await _tts.setLanguage('ar');
    } catch (e) {
      debugPrint('TTS speak allah name error: $e');
    }
  }

  Future<void> speakArabicItem(Map<String, dynamic> item) async {
    try {
      await audioPlayer.stop();
      await _tts.stop();

      final arabicItem = item['item'] ?? '';
      if (arabicItem.isNotEmpty) {
        await _tts.setLanguage('ar');
        await _tts.speak(arabicItem);
      }
    } catch (e) {
      debugPrint('TTS speak arabic item error: $e');
    }
  }

  Future<void> speakRhyme(Map<String, dynamic> item) async {
    try {
      await audioPlayer.stop();
      await _tts.stop();

      final text = item['text'] ?? '';
      if (text.isNotEmpty) {
        await _tts.setLanguage('bn');
        await _tts.setSpeechRate(0.42);
        await _tts.setPitch(1.15);

        final lines = (text as String)
            .split('\n')
            .where((String l) => l.trim().isNotEmpty)
            .toList();
        for (int i = 0; i < lines.length; i++) {
          await _tts.speak(lines[i].trim());
          if (i < lines.length - 1) {
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        await _tts.setSpeechRate(0.5);
        await _tts.setPitch(1.0);
      }
    } catch (e) {
      debugPrint('TTS speak rhyme error: $e');
    }
  }

  Future<void> speakEnglishRhyme(Map<String, dynamic> item) async {
    try {
      await audioPlayer.stop();
      await _tts.stop();

      final text = item['text'] ?? '';
      if (text.isNotEmpty) {
        await _tts.setLanguage('en-US');
        await _tts.setSpeechRate(0.42);
        await _tts.setPitch(1.15);

        final lines = (text as String)
            .split('\n')
            .where((String l) => l.trim().isNotEmpty)
            .toList();
        for (int i = 0; i < lines.length; i++) {
          await _tts.speak(lines[i].trim());
          if (i < lines.length - 1) {
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        await _tts.setSpeechRate(0.5);
        await _tts.setPitch(1.0);
      }
    } catch (e) {
      debugPrint('TTS speak english rhyme error: $e');
    }
  }

  Future<void> speakItemWithMeaning(Map<String, dynamic> item) async {
    try {
      await audioPlayer.stop();
      await _tts.stop();

      final englishItem = item['item'] ?? '';
      final banglaPron = item['pron'] ?? '';

      // Flags (items with a countryCode): say only the Bangla country name.
      if (item['countryCode'] != null) {
        if (banglaPron.isNotEmpty) {
          await _tts.setLanguage('bn');
          await _tts.speak(banglaPron);
        }
        return;
      }

      if (englishItem.isNotEmpty) {
        await _tts.setLanguage('en-US');
        await _tts.speak(englishItem);
      }

      if (banglaPron.isNotEmpty) {
        await _tts.setLanguage('bn');
        await _tts.speak('মানে $banglaPron');
      }

      await _tts.setLanguage('ar');
    } catch (e) {
      debugPrint('TTS speak item with meaning error: $e');
    }
  }

  Future<void> speakSolarSystem(Map<String, dynamic> item) async {
    try {
      await audioPlayer.stop();
      await _tts.stop();

      final englishName = item['pron'] ?? '';
      final banglaName = item['item'] ?? '';

      if (englishName.isNotEmpty) {
        await _tts.setLanguage('en-US');
        await _tts.speak(englishName);
      }

      if (banglaName.isNotEmpty) {
        await _tts.setLanguage('bn');
        await _tts.speak('মানে $banglaName');
      }

      final meaning = item['meaning'] ?? '';
      if (meaning.isNotEmpty) {
        await _tts.setLanguage('bn');
        await _tts.speak(meaning);
      }

      await _tts.setLanguage('ar');
    } catch (e) {
      debugPrint('TTS speak solar system error: $e');
    }
  }

  Future<void> speakIslamicContent(Map<String, dynamic> item) async {
    try {
      await audioPlayer.stop();
      await _tts.stop();

      final String title = item['item'] ?? '';
      final String arabic = item['arabic'] ?? '';
      final String text = item['text'] ?? '';
      final String meaning = item['meaning'] ?? '';
      final bool hasMeaning = meaning.isNotEmpty;

      if (title.isNotEmpty) {
        await _tts.setLanguage('bn');
        await _tts.speak(title);
      }

      if (arabic.isNotEmpty) {
        await _tts.setLanguage('ar');
        await _tts.speak(arabic);
      } else if (text.isNotEmpty) {
        await _tts.setLanguage(hasMeaning ? 'ar' : 'bn');
        await _tts.speak(text);
      }

      if (meaning.isNotEmpty) {
        await _tts.setLanguage('bn');
        await _tts.speak('মানে $meaning');
      }
    } catch (e) {
      debugPrint('TTS speak islamic content error: $e');
    }
  }

  void disposeTts() {
    _tts.stop();
    _tts.awaitSpeakCompletion(false);
  }
}
