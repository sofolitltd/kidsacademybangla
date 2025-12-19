import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../core/data/app_data.dart';
import './widgets/detail_card.dart';

class DetailsScreen extends StatefulWidget {
  final String? itemId;
  final String? title;
  final Color color;

  const DetailsScreen({
    super.key,
    this.itemId,
    this.title,
    this.color = Colors.blueGrey,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

enum AutoplayState { stopped, playing, paused }

class _DetailsScreenState extends State<DetailsScreen> {
  late List<Map<String, dynamic>> _items;
  late AudioPlayer _audioPlayer;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateSubscription;

  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _cardKeys;
  AutoplayState _autoplayState = AutoplayState.stopped;
  int _currentlyPlayingIndex = -1;
  bool _isAudioLoading = false;

  @override
  void initState() {
    super.initState();
    _items = AppData.getItems(widget.itemId ?? '');
    _audioPlayer = AudioPlayer();
    _cardKeys = List.generate(_items.length, (_) => GlobalKey());

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (_autoplayState == AutoplayState.playing) {
        _playNextInSequence();
      }
    });

    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((
      state,
    ) {
      if (state == PlayerState.playing ||
          state == PlayerState.paused ||
          state == PlayerState.completed) {
        if (mounted && _isAudioLoading) {
          setState(() => _isAudioLoading = false);
        }
      }
    });
  }

  @override
  void dispose() {
    _playerCompleteSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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

  Future<void> _playSound(dynamic soundSource, int index) async {
    if (mounted) setState(() => _currentlyPlayingIndex = index);
    if (soundSource == null || (soundSource is String && soundSource.isEmpty))
      return;

    try {
      if (_audioPlayer.state != PlayerState.paused) {
        await _audioPlayer.stop();
      }

      if (soundSource is String && soundSource.startsWith('http')) {
        if (mounted) setState(() => _isAudioLoading = true);
        await _audioPlayer.play(UrlSource(soundSource));
      } else {
        await _audioPlayer.play(
          AssetSource('sounds/${widget.itemId}/$soundSource'),
        );
      }
    } catch (e) {
      debugPrint("Error playing sound: $e");
      if (mounted) setState(() => _isAudioLoading = false);
      if (_autoplayState == AutoplayState.playing) {
        int delay = _calculateSilentDelay(_items[index]);
        Future.delayed(Duration(milliseconds: delay), () {
          if (_autoplayState == AutoplayState.playing &&
              _currentlyPlayingIndex == index) {
            _playNextInSequence();
          }
        });
      }
    }
  }

  void _handleItemTap(int index) {
    if (_autoplayState != AutoplayState.stopped) {
      _audioPlayer.stop();
      if (mounted) setState(() => _autoplayState = AutoplayState.stopped);
    }
    _scrollToIndex(index);

    final item = _items[index];
    dynamic soundSource;
    if (widget.itemId == 'small_suras') {
      soundSource =
          'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/${item['id']}.mp3';
    } else {
      soundSource = item['sound'] ?? '';
    }

    _playSound(soundSource, index);
  }

  void _handlePlayPause() async {
    if (_autoplayState == AutoplayState.playing) {
      await _audioPlayer.pause();
      if (mounted) setState(() => _autoplayState = AutoplayState.paused);
    } else if (_autoplayState == AutoplayState.paused) {
      if (mounted) setState(() => _autoplayState = AutoplayState.playing);
      if (_audioPlayer.state == PlayerState.paused) {
        await _audioPlayer.resume();
      } else {
        _playSequentially(_currentlyPlayingIndex);
      }
    } else {
      int startIndex = _currentlyPlayingIndex;
      if (startIndex == -1 || startIndex >= _items.length - 1) {
        startIndex = 0;
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      _startAutoplayFrom(startIndex);
    }
  }

  void _handleStop() {
    _audioPlayer.stop();
    if (mounted) {
      setState(() {
        _autoplayState = AutoplayState.stopped;
        _isAudioLoading = false;
      });
    }
  }

  void _startAutoplayFrom(int index) {
    if (index >= _items.length) {
      _handleStop();
      return;
    }
    if (mounted) setState(() => _autoplayState = AutoplayState.playing);
    _playSequentially(index);
  }

  void _playSequentially(int index) async {
    if (index >= _items.length) {
      _handleStop();
      return;
    }

    _scrollToIndex(index);
    final item = _items[index];

    dynamic soundSource;
    if (widget.itemId == 'small_suras') {
      soundSource =
          'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/${item['id']}.mp3';
    } else {
      soundSource = item['sound'] ?? '';
    }

    if (soundSource.isEmpty) {
      if (mounted) setState(() => _currentlyPlayingIndex = index);
      int delay = _calculateSilentDelay(_items[index]);
      Future.delayed(Duration(milliseconds: delay), () {
        if (_autoplayState == AutoplayState.playing &&
            _currentlyPlayingIndex == index) {
          _playNextInSequence();
        }
      });
      return;
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_autoplayState == AutoplayState.playing) {
        _playSound(soundSource, index);
      }
    });
  }

  void _scrollToIndex(int index) {
    if (index < 0 || index >= _cardKeys.length) return;
    final keyContext = _cardKeys[index].currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
  }

  void _playNextInSequence() {
    if (_autoplayState != AutoplayState.playing) return;
    int nextIndex = _currentlyPlayingIndex + 1;
    if (nextIndex < _items.length) {
      _playSequentially(nextIndex);
    } else {
      _handleStop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabicCategory =
        widget.itemId == 'arabic_alphabets' ||
        widget.itemId == 'arabic_numbers' ||
        widget.itemId == 'small_suras' ||
        widget.itemId == 'allah_names';

    return Scaffold(
      floatingActionButton: _buildFloatingActionButtons(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: .3)),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.white,
                centerTitle: true,
                title: Text(widget.title ?? ""),
              ),
              Expanded(
                child: Directionality(
                  textDirection: isArabicCategory
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: MasonryGridView.count(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 24, 12, 100),
                    crossAxisCount: _getCrossAxisCount(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        key: _cardKeys[index],
                        child: DetailCard(
                          item: _items[index],
                          itemId: widget.itemId,
                          categoryColor: widget.color,
                          isSelected: _currentlyPlayingIndex == index,
                          onTap: () => _handleItemTap(index),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          if (_isAudioLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 20),
                        const Text(
                          "ছোট্ট বন্ধুরা একটু অপেক্ষা করো, সুরা ডাউনলোড হচ্ছে...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    if (_autoplayState == AutoplayState.stopped) {
      return FloatingActionButton.extended(
        onPressed: _handlePlayPause,
        backgroundColor: Colors.green,
        heroTag: 'play_all_tag',
        icon: const Icon(Icons.play_arrow, color: Colors.white),
        label: const Text('Play All', style: TextStyle(color: Colors.white)),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _handlePlayPause,
            backgroundColor: Colors.orange,
            heroTag: 'play_pause_tag',
            icon: Icon(
              _autoplayState == AutoplayState.playing
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
            ),
            label: Text(
              _autoplayState == AutoplayState.playing ? 'Pause' : 'Resume',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _handleStop,
            backgroundColor: Colors.red,
            heroTag: 'stop_tag',
            child: const Icon(Icons.stop, color: Colors.white),
          ),
        ],
      );
    }
  }

  int _getCrossAxisCount() {
    switch (widget.itemId) {
      case 'english_rhymes':
      case 'bangla_rhymes':
      case 'allah_names':
      case 'small_suras':
        return 1;
      case 'bangla_consonants':
        return 3;
      default:
        return 2;
    }
  }
}
