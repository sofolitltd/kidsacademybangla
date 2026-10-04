import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../core/data/app_data.dart';
import '../../core/services/speech_service.dart';
import 'widgets/downloaded_badge.dart';
import 'widgets/focus_item_details.dart';
import 'widgets/focus_bottom_list.dart';
import 'package:kidsacademybangla/core/config/app_urls.dart';

class FocusDetailsScreen extends StatefulWidget {
  final String itemId;
  final int initialIndex;
  final String? title;
  final Color color;

  const FocusDetailsScreen({
    super.key,
    required this.itemId,
    required this.initialIndex,
    this.title,
    required this.color,
  });

  @override
  State<FocusDetailsScreen> createState() => _FocusDetailsScreenState();
}

class _FocusDetailsScreenState extends State<FocusDetailsScreen> {
  late List<Map<String, dynamic>> _items;
  late PageController _pageController;
  late ScrollController _bottomListController;
  late SpeechService _speech;
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isAudioLoading = false;
  double? _downloadProgress;
  bool _isAutoPlaying = false;

  /// Bumped on every page change / stop / restart so a cut-off speech call
  /// can't trigger a stale "go to next".
  int _playToken = 0;
  int _activeVerseIndex = -1;
  Duration? _totalDuration;
  Duration? _currentPosition;
  late ScrollController _verseScrollController;

  final List<Color> _letterColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    _items = AppData.getItems(widget.itemId);
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _bottomListController = ScrollController();
    _verseScrollController = ScrollController();
    _speech = SpeechService();
    _speech.initTts();

    _speech.audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) setState(() => _totalDuration = duration);
    });

    _speech.audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _updateActiveVerseIndex();
        });
      }
    });

    _speech.audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
        if (_isAutoPlaying) {
          final token = _playToken;
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted && _isAutoPlaying && token == _playToken) {
              _nextPage();
            }
          });
        }
      }
    });

    _speech.audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state == PlayerState.playing);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottomIndex(_currentIndex);
      _playCurrentSound();
    });
  }

  Future<void> _speak(String text) => _speech.speak(text);
  Future<void> _speakAllahName(Map<String, dynamic> item) =>
      _speech.speakAllahName(item);
  Future<void> _speakArabicItem(Map<String, dynamic> item) =>
      _speech.speakArabicItem(item);
  Future<void> _speakRhyme(Map<String, dynamic> item) =>
      _speech.speakRhyme(item);
  Future<void> _speakEnglishRhyme(Map<String, dynamic> item) =>
      _speech.speakEnglishRhyme(item);
  Future<void> _speakSolarSystem(Map<String, dynamic> item) =>
      _speech.speakSolarSystem(item);
  Future<void> _speakItemWithMeaning(Map<String, dynamic> item) =>
      _speech.speakItemWithMeaning(item);

  @override
  void dispose() {
    _pageController.dispose();
    _bottomListController.dispose();
    _verseScrollController.dispose();
    _speech.audioPlayer.dispose();
    _speech.disposeTts();
    super.dispose();
  }

  void _updateActiveVerseIndex() {
    if (_totalDuration == null || _currentPosition == null) return;

    final item = _items[_currentIndex];
    int newIndex = -1;

    if (widget.itemId.contains('rhymes')) {
      final List<String> lines = (item['text'] as String).split('\n');
      final totalLines = lines.length;
      final progress =
          _currentPosition!.inMilliseconds / _totalDuration!.inMilliseconds;
      newIndex = (progress * totalLines).floor().clamp(0, totalLines - 1);
    }

    if (newIndex != _activeVerseIndex) {
      setState(() => _activeVerseIndex = newIndex);
      _scrollToActiveVerse();
    }
  }

  void _scrollToActiveVerse() {
    if (_activeVerseIndex == -1 || !_verseScrollController.hasClients) return;

    double itemHeight = 40.0;
    double offset = _activeVerseIndex * itemHeight;

    _verseScrollController.animateTo(
      offset.clamp(0.0, _verseScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToBottomIndex(int index) {
    if (_bottomListController.hasClients) {
      // Tile = 90 width + 8 margin. Pin current tile to the left edge so
      // previous items hide and upcoming items fill the strip.
      final offset = index * 98.0;
      _bottomListController.animateTo(
        offset.clamp(0.0, _bottomListController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _playCurrentSound() async {
    final item = _items[_currentIndex];
    final myToken = _playToken;

    if (widget.itemId == 'allah_names') {
      setState(() => _isPlaying = true);
      await _speakAllahName(item);
      if (mounted) {
        setState(() => _isPlaying = false);
        if (_isAutoPlaying && myToken == _playToken) {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted && _isAutoPlaying && myToken == _playToken) _nextPage();
          });
        }
      }
      return;
    }

    if (widget.itemId == 'bangla_rhymes') {
      setState(() => _isPlaying = true);
      await _speakRhyme(item);
      if (mounted) {
        setState(() => _isPlaying = false);
        if (_isAutoPlaying && myToken == _playToken) {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted && _isAutoPlaying && myToken == _playToken) _nextPage();
          });
        }
      }
      return;
    }

    if (widget.itemId == 'english_rhymes') {
      setState(() => _isPlaying = true);
      await _speakEnglishRhyme(item);
      if (mounted) {
        setState(() => _isPlaying = false);
        if (_isAutoPlaying && myToken == _playToken) {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted && _isAutoPlaying && myToken == _playToken) _nextPage();
          });
        }
      }
      return;
    }

    if (widget.itemId == 'arabic_alphabets' ||
        widget.itemId == 'arabic_numbers') {
      setState(() => _isPlaying = true);
      await _speakArabicItem(item);
      if (mounted) {
        setState(() => _isPlaying = false);
        if (_isAutoPlaying && myToken == _playToken) {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted && _isAutoPlaying && myToken == _playToken) _nextPage();
          });
        }
      }
      return;
    }

    dynamic soundSource;

    if (widget.itemId == 'small_suras') {
      soundSource = AppUrls.surahAudio(item['id']);
    } else {
      soundSource = item['sound'] ?? '';
    }

    if (soundSource == null || (soundSource is String && soundSource.isEmpty)) {
      if (widget.itemId == 'solar_system') {
        setState(() => _isPlaying = true);
        await _speakSolarSystem(item);
      } else if (widget.itemId == 'animals' ||
          widget.itemId == 'fruits' ||
          widget.itemId == 'birds' ||
          widget.itemId == 'flowers' ||
          widget.itemId == 'fish' ||
          widget.itemId == 'electronics' ||
          widget.itemId == 'vehicles' ||
          widget.itemId == 'body_parts' ||
          widget.itemId == 'vegetables' ||
          widget.itemId == 'dress' ||
          widget.itemId == 'learning_tools' ||
          widget.itemId == 'flags') {
        setState(() => _isPlaying = true);
        await _speakItemWithMeaning(item);
      } else if (widget.itemId.startsWith('math_')) {
        setState(() => _isPlaying = true);
        await _speech.speakMath(widget.itemId, item);
      } else {
        final text = item['item'] ?? '';
        if (text.isNotEmpty) {
          setState(() => _isPlaying = true);
          await _speak(text);
        }
      }
      if (mounted) {
        setState(() => _isPlaying = false);
        if (_isAutoPlaying && myToken == _playToken) {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted && _isAutoPlaying && myToken == _playToken) _nextPage();
          });
        }
      }
      return;
    }

    try {
      await _speech.audioPlayer.stop();
      if (soundSource is String && soundSource.startsWith('http')) {
        final cache = DefaultCacheManager();
        File? file = (await cache.getFileFromCache(soundSource))?.file;
        if (file == null) {
          setState(() {
            _isAudioLoading = true;
            _downloadProgress = null;
          });
          await for (final event in cache.getFileStream(
            soundSource,
            withProgress: true,
          )) {
            if (!mounted) return;
            if (event is DownloadProgress) {
              setState(() => _downloadProgress = event.progress);
            } else if (event is FileInfo) {
              file = event.file;
            }
          }
        }
        if (!mounted) return;
        setState(() => _isAudioLoading = false);
        if (file != null) {
          await _speech.audioPlayer.play(DeviceFileSource(file.path));
        }
      } else {
        await _speech.audioPlayer.play(
          AssetSource('sounds/${widget.itemId}/$soundSource'),
        );
      }
      setState(() => _isPlaying = true);
    } catch (e) {
      debugPrint("Error playing sound: $e");
      if (!mounted) return;
      setState(() => _isAudioLoading = false);
      if (_isAutoPlaying && myToken == _playToken) {
        // Don't let one bad clip freeze play-all.
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted && _isAutoPlaying && myToken == _playToken) _nextPage();
        });
      }
    }
  }

  void _onPageChanged(int index) {
    _playToken++;
    setState(() {
      _currentIndex = index;
      _activeVerseIndex = -1;
      _totalDuration = null;
      _currentPosition = null;
    });
    if (_verseScrollController.hasClients) {
      _verseScrollController.jumpTo(0);
    }
    _scrollToBottomIndex(index);
    _playCurrentSound();
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPage() {
    if (_currentIndex < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else if (_isAutoPlaying) {
      _stopAutoPlay();
    }
  }

  void _stopAutoPlay() {
    _playToken++;
    _speech.audioPlayer.stop();
    _speech.tts.stop();
    if (mounted) setState(() => _isAutoPlaying = false);
  }

  void _toggleAutoPlay() {
    if (_isAutoPlaying) {
      _stopAutoPlay();
    } else {
      _playToken++;
      if (mounted) setState(() => _isAutoPlaying = true);
      if (_currentIndex >= _items.length - 1 && _items.length > 1) {
        // Finished earlier: restart from the beginning (onPageChanged plays it).
        _pageController.jumpToPage(0);
      } else {
        _playCurrentSound();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: 0.4)),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return SingleChildScrollView(
                                        controller: index == _currentIndex
                                            ? _verseScrollController
                                            : null,
                                        padding: const EdgeInsets.all(16),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight:
                                                constraints.maxHeight - 32,
                                          ),
                                          child: Center(
                                            child: FocusItemDetails(
                                              item: item,
                                              itemId: widget.itemId,
                                              color: widget.color,
                                              activeVerseIndex:
                                                  _activeVerseIndex,
                                              letterColors: _letterColors,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (widget.itemId == 'small_suras')
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: DownloadedBadge(
                                      url: AppUrls.surahAudio(item['id']),
                                      refresh: _isAudioLoading,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      if (_currentIndex > 0)
                        Positioned(
                          left: 4,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: _buildArrow(
                              Icons.chevron_left,
                              _previousPage,
                            ),
                          ),
                        ),
                      if (_currentIndex < _items.length - 1)
                        Positioned(
                          right: 4,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: _buildArrow(Icons.chevron_right, _nextPage),
                          ),
                        ),
                    ],
                  ),
                ),
                FocusBottomList(
                  items: _items,
                  itemId: widget.itemId,
                  color: widget.color,
                  currentIndex: _currentIndex,
                  controller: _bottomListController,
                  letterColors: _letterColors,
                  onPageSelected: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
          ),
          if (_isAudioLoading) _buildDownloadDialog(),
        ],
      ),
    );
  }

  Widget _buildDownloadDialog() {
    final progress = _downloadProgress;
    final percent = progress == null ? null : (progress * 100).round();
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.45),
        alignment: Alignment.center,
        child: Container(
          width: 300,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cloud_download_rounded,
                  size: 38,
                  color: widget.color,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'সূরা ডাউনলোড হচ্ছে...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "SolaimanLipi",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'একটু অপেক্ষা করো, সূরাটি শুনতে প্রস্তুত হচ্ছে ✨',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "SolaimanLipi",
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 12,
                  backgroundColor: widget.color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(widget.color),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                percent == null ? '...' : '$percent%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.white,
      centerTitle: false,
      title: Text(
        widget.title ?? "",
        style: const TextStyle(fontWeight: .bold),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              _buildControlButton(
                icon: _isPlaying ? Icons.volume_up : Icons.volume_mute,
                onPressed: () {
                  final item = _items[_currentIndex];
                  if (widget.itemId == 'allah_names') {
                    _speakAllahName(item);
                  } else if (widget.itemId == 'bangla_rhymes') {
                    _speakRhyme(item);
                  } else if (widget.itemId == 'english_rhymes') {
                    _speakEnglishRhyme(item);
                  } else if (widget.itemId == 'arabic_alphabets' ||
                      widget.itemId == 'arabic_numbers') {
                    _speakArabicItem(item);
                  } else if (widget.itemId == 'solar_system') {
                    _speakSolarSystem(item);
                  } else if (widget.itemId == 'animals' ||
                      widget.itemId == 'fruits' ||
                      widget.itemId == 'birds' ||
                      widget.itemId == 'flowers' ||
                      widget.itemId == 'fish' ||
                      widget.itemId == 'electronics' ||
                      widget.itemId == 'vehicles' ||
                      widget.itemId == 'body_parts' ||
                      widget.itemId == 'vegetables' ||
                      widget.itemId == 'dress' ||
                      widget.itemId == 'learning_tools' ||
                      widget.itemId == 'flags') {
                    _speech.speakItemWithRecording(widget.itemId, item);
                  } else if (widget.itemId == 'kalima' ||
                      widget.itemId == 'namaj' ||
                      widget.itemId == 'wudu' ||
                      widget.itemId == 'pillars' ||
                      widget.itemId == 'daily_dua' ||
                      widget.itemId == 'roja' ||
                      widget.itemId == 'haj' ||
                      widget.itemId == 'jakat') {
                    _speech.speakIslamicContent(item);
                  } else if (widget.itemId.startsWith('math_')) {
                    _speech.speakMath(widget.itemId, item);
                  } else {
                    final text = item['item'] ?? '';
                    if (text.isNotEmpty) _speak(text);
                  }
                },
                color: widget.color,
              ),
              const SizedBox(width: 8),
              _buildControlButton(
                icon: _isAutoPlaying ? Icons.pause : Icons.play_arrow,
                onPressed: _toggleAutoPlay,
                color: Colors.green,
                large: true,
              ),
              const SizedBox(width: 8),
              _buildControlButton(
                icon: Icons.stop,
                onPressed: _isAutoPlaying ? _stopAutoPlay : null,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
    bool large = false,
  }) {
    final size = large ? 48.0 : 40.0;
    final iconSize = large ? 24.0 : 20.0;
    return AnimatedOpacity(
      opacity: onPressed != null ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(icon, color: color, size: iconSize),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _buildArrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 32),
      ),
    );
  }
}
