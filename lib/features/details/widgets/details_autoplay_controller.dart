import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../../core/services/speech_service.dart';
import 'package:kidsacademybangla/core/config/app_urls.dart';

enum AutoplayState { stopped, playing, paused }

class DetailsAutoplayController {
  final SpeechService speech;
  final String itemId;
  final List<Map<String, dynamic>> items;
  final ScrollController scrollController;
  final void Function(int) onIndexChanged;
  final void Function(bool) onLoadingChanged;
  final void Function(AutoplayState) onStateChanged;

  AutoplayState state = AutoplayState.stopped;
  int currentIndex = -1;

  /// Bumped whenever playback restarts/stops so stale waits never advance.
  int _playToken = 0;

  DetailsAutoplayController({
    required this.speech,
    required this.itemId,
    required this.items,
    required this.scrollController,
    required this.onIndexChanged,
    required this.onLoadingChanged,
    required this.onStateChanged,
  });

  void dispose() => _playToken++;

  int _calculateSilentDelay(Map<String, dynamic> item) {
    String combinedText = "";
    item.forEach((key, value) {
      if (value is String && key != 'sound' && key != 'image' && key != 'hex') {
        combinedText += " $value";
      }
    });
    int wordCount = combinedText.trim().split(RegExp(r'\s+')).length;
    int delay = 2000 + (wordCount * 350);
    return delay.clamp(2000, 8000);
  }

  void handlePlayPause() async {
    if (state == AutoplayState.playing) {
      if (itemId == 'allah_names') {
        await speech.tts.stop();
      } else {
        await speech.audioPlayer.pause();
      }
      state = AutoplayState.paused;
      onStateChanged(state);
    } else if (state == AutoplayState.paused) {
      state = AutoplayState.playing;
      onStateChanged(state);
      _playSequentially(currentIndex);
    } else {
      int startIndex = currentIndex;
      if (startIndex == -1 || startIndex >= items.length - 1) {
        startIndex = 0;
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      _startAutoplayFrom(startIndex);
    }
  }

  void handleStop() {
    _playToken++;
    speech.audioPlayer.stop();
    speech.tts.stop();
    state = AutoplayState.stopped;
    onStateChanged(state);
    onLoadingChanged(false);
  }

  void _startAutoplayFrom(int index) {
    if (index >= items.length) {
      handleStop();
      return;
    }
    state = AutoplayState.playing;
    onStateChanged(state);
    _playSequentially(index);
  }

  void playSequentially(int index) => _playSequentially(index);

  void _playSequentially(int index) async {
    if (index >= items.length) {
      handleStop();
      return;
    }

    _scrollToIndex(index);
    final item = items[index];

    if (itemId == 'kalima' ||
        itemId == 'namaj' ||
        itemId == 'wudu' ||
        itemId == 'pillars' ||
        itemId == 'daily_dua' ||
        itemId == 'roja' ||
        itemId == 'haj' ||
        itemId == 'jakat') {
      currentIndex = index;
      onIndexChanged(index);
      Future.delayed(const Duration(milliseconds: 300), () async {
        if (state == AutoplayState.playing) {
          await speech.speakIslamicContent(item);
          _playNextInSequence();
        }
      });
      return;
    }

    if (itemId == 'allah_names') {
      currentIndex = index;
      onIndexChanged(index);
      Future.delayed(const Duration(milliseconds: 300), () async {
        if (state == AutoplayState.playing) {
          await speech.speakAllahName(item);
          _playNextInSequence();
        }
      });
      return;
    }

    if (itemId == 'bangla_rhymes') {
      currentIndex = index;
      onIndexChanged(index);
      Future.delayed(const Duration(milliseconds: 300), () async {
        if (state == AutoplayState.playing) {
          await speech.speakRhyme(item);
          _playNextInSequence();
        }
      });
      return;
    }

    if (itemId == 'english_rhymes') {
      currentIndex = index;
      onIndexChanged(index);
      Future.delayed(const Duration(milliseconds: 300), () async {
        if (state == AutoplayState.playing) {
          await speech.speakEnglishRhyme(item);
          _playNextInSequence();
        }
      });
      return;
    }

    if (itemId == 'arabic_alphabets' || itemId == 'arabic_numbers') {
      currentIndex = index;
      onIndexChanged(index);
      Future.delayed(const Duration(milliseconds: 300), () async {
        if (state == AutoplayState.playing) {
          await speech.speakArabicItem(item);
          _playNextInSequence();
        }
      });
      return;
    }

    final hasRecording =
        item['sound'] is String && (item['sound'] as String).isNotEmpty;

    if (!hasRecording &&
        (itemId == 'animals' ||
            itemId == 'fruits' ||
            itemId == 'birds' ||
            itemId == 'flowers' ||
            itemId == 'fish' ||
            itemId == 'electronics' ||
            itemId == 'vehicles' ||
            itemId == 'body_parts' ||
            itemId == 'vegetables' ||
            itemId == 'dress' ||
            itemId == 'learning_tools' ||
            itemId == 'flags' ||
            itemId == 'english_weeks' ||
            itemId == 'english_months' ||
            itemId == 'english_seasons')) {
      currentIndex = index;
      onIndexChanged(index);
      Future.delayed(const Duration(milliseconds: 300), () async {
        if (state == AutoplayState.playing) {
          await speech.speakItemWithMeaning(item);
          _playNextInSequence();
        }
      });
      return;
    }

    if (itemId == 'bangla_weeks' ||
        itemId == 'bangla_months' ||
        itemId == 'bangla_seasons') {
      currentIndex = index;
      onIndexChanged(index);
      Future.delayed(const Duration(milliseconds: 300), () async {
        if (state == AutoplayState.playing) {
          await speech.speakBangla(item['item'] ?? '');
          _playNextInSequence();
        }
      });
      return;
    }

    if (itemId == 'arabic_weeks' ||
        itemId == 'arabic_months' ||
        itemId == 'arabic_seasons') {
      currentIndex = index;
      onIndexChanged(index);
      Future.delayed(const Duration(milliseconds: 300), () async {
        if (state == AutoplayState.playing) {
          await speech.speakArabicWithMeaning(item);
          _playNextInSequence();
        }
      });
      return;
    }

    if (itemId == 'math_counting' ||
        itemId == 'math_shapes' ||
        itemId == 'math_addition' ||
        itemId == 'math_time') {
      currentIndex = index;
      onIndexChanged(index);
      Future.delayed(const Duration(milliseconds: 300), () async {
        if (state == AutoplayState.playing) {
          await speech.speakMath(itemId, item);
          _playNextInSequence();
        }
      });
      return;
    }

    if (itemId == 'solar_system') {
      currentIndex = index;
      onIndexChanged(index);
      Future.delayed(const Duration(milliseconds: 300), () async {
        if (state == AutoplayState.playing) {
          await speech.speakSolarSystem(item);
          _playNextInSequence();
        }
      });
      return;
    }

    dynamic soundSource;
    if (itemId == 'small_suras') {
      soundSource = AppUrls.surahAudio(item['id']);
    } else {
      soundSource = item['sound'] ?? '';
    }

    if (soundSource == null || (soundSource is String && soundSource.isEmpty)) {
      currentIndex = index;
      onIndexChanged(index);
      int delay = _calculateSilentDelay(items[index]);
      Future.delayed(Duration(milliseconds: delay), () {
        if (state == AutoplayState.playing && currentIndex == index) {
          _playNextInSequence();
        }
      });
      return;
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (state == AutoplayState.playing) {
        _playSound(soundSource, index);
      }
    });
  }

  Future<void> playSound(dynamic soundSource, int index) =>
      _playSound(soundSource, index);

  Future<void> _playSound(dynamic soundSource, int index) async {
    currentIndex = index;
    onIndexChanged(index);
    final token = ++_playToken;

    if (soundSource == null || (soundSource is String && soundSource.isEmpty)) {
      final text = items[index]['item'] ?? '';
      if (text.isNotEmpty) await speech.speak(text);
      if (token == _playToken) _playNextInSequence();
      return;
    }

    try {
      await speech.audioPlayer.stop();

      // Subscribe before playing: very short clips can finish immediately.
      final completed = speech.audioPlayer.onPlayerComplete.first.then(
        (_) => true,
      );

      if (soundSource is String && soundSource.startsWith('http')) {
        onLoadingChanged(true);
        final File file = await DefaultCacheManager().getSingleFile(
          soundSource,
        );
        if (token != _playToken) {
          onLoadingChanged(false);
          return;
        }
        await speech.audioPlayer.play(DeviceFileSource(file.path));
        onLoadingChanged(false);
      } else {
        await speech.audioPlayer.play(
          AssetSource('sounds/$itemId/$soundSource'),
        );
      }

      // Wait for the clip to end; fall back to its length (+ margin) in case
      // the completion event is missed on some platforms.
      final duration = await speech.audioPlayer.getDuration();
      final limit =
          (duration ?? const Duration(seconds: 8)) + const Duration(seconds: 2);
      await completed.timeout(limit, onTimeout: () => false);
    } catch (e) {
      debugPrint("Error playing sound: $e");
      onLoadingChanged(false);
      if (token == _playToken && state == AutoplayState.playing) {
        await Future.delayed(
          Duration(milliseconds: _calculateSilentDelay(items[index])),
        );
      }
    }

    // Stopped, paused, restarted or moved on meanwhile: do nothing.
    if (token != _playToken || state != AutoplayState.playing) return;
    await Future.delayed(const Duration(milliseconds: 600));
    if (token == _playToken && state == AutoplayState.playing) {
      _playNextInSequence();
    }
  }

  void _scrollToIndex(int index) {
    if (index < 0 || index >= items.length) return;
    currentIndex = index;
    onIndexChanged(index);
  }

  void _playNextInSequence() {
    if (state != AutoplayState.playing) return;
    int nextIndex = currentIndex + 1;
    if (nextIndex < items.length) {
      _playSequentially(nextIndex);
    } else {
      handleStop();
    }
  }
}
