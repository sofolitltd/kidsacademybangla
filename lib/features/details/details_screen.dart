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

  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _cardKeys;
  AutoplayState _autoplayState = AutoplayState.stopped;
  int _currentlyPlayingIndex = -1;

  @override
  void initState() {
    super.initState();
    _items = AppData.getItems(widget.itemId ?? '');
    _audioPlayer = AudioPlayer();
    _cardKeys = List.generate(_items.length, (_) => GlobalKey());

    // Use onPlayerComplete stream for more reliable sequence handling
    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (_autoplayState == AutoplayState.playing) {
        _playNextInSequence();
      } else {
        if (mounted) setState(() => _currentlyPlayingIndex = -1);
      }
    });
  }

  @override
  void dispose() {
    _playerCompleteSubscription?.cancel();
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _playSound(String soundFile, int index) async {
    if (soundFile.isEmpty) return;
    if (mounted) setState(() => _currentlyPlayingIndex = index);

    try {
      final String soundPath = 'sounds/${widget.itemId}/$soundFile';
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      print("Error playing sound: $e");
      if (mounted) setState(() => _currentlyPlayingIndex = -1);
    }
  }

  void _handlePlayPause() {
    switch (_autoplayState) {
      case AutoplayState.playing:
        _audioPlayer.pause();
        if (mounted) setState(() => _autoplayState = AutoplayState.paused);
        break;
      case AutoplayState.paused:
        _audioPlayer.resume();
        if (mounted) setState(() => _autoplayState = AutoplayState.playing);
        break;
      case AutoplayState.stopped:
        _startAutoplayFrom(0);
        break;
    }
  }

  void _handleStop() {
    if (mounted) {
      setState(() {
        _autoplayState = AutoplayState.stopped;
        _currentlyPlayingIndex = -1;
      });
      _audioPlayer.stop();
    }
  }

  // New function to start autoplay from any index
  void _startAutoplayFrom(int index) {
    if (mounted) {
      setState(() {
        _autoplayState = AutoplayState.playing;
      });
      _playSequentially(index);
    }
  }

  void _playSequentially(int index) {
    if (index >= _items.length) {
      _handleStop();
      return;
    }

    final keyContext = _cardKeys[index].currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }

    final soundFile = _items[index]['sound'] as String? ?? '';
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_autoplayState == AutoplayState.playing) {
        _playSound(soundFile, index);
      }
    });
  }

  void _playNextInSequence() {
    if (_autoplayState != AutoplayState.playing) return;
    _playSequentially(_currentlyPlayingIndex + 1);
  }

  @override
  Widget build(BuildContext context) {
    bool isArabicCategory =
        widget.itemId == 'arabic_alphabets' ||
        widget.itemId == 'arabic_numbers' ||
        widget.itemId == 'allah_names';

    return Scaffold(
      floatingActionButton: _buildFloatingActionButtons(),
      body: Stack(
        children: [
          //
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          //
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: .3)),
          ),

          //
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
                      final item = _items[index];
                      return Container(
                        key: _cardKeys[index],
                        child: DetailCard(
                          item: item,
                          itemId: widget.itemId,
                          categoryColor: widget.color,
                          isSelected: _currentlyPlayingIndex == index,
                          onTap: () =>
                              _startAutoplayFrom(index), // Updated onTap
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
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
        return 1;
      case 'bangla_consonants':
        return 3;
      default:
        return 2;
    }
  }
}
