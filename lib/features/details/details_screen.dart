import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/app_data.dart';
import '../../core/services/speech_service.dart';
import './widgets/detail_card.dart';
import './widgets/details_autoplay_controller.dart';

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

class _DetailsScreenState extends State<DetailsScreen> {
  late List<Map<String, dynamic>> _items;
  late SpeechService _speech;
  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _cardKeys;
  late DetailsAutoplayController _autoplay;
  int _currentlyPlayingIndex = -1;
  bool _isAudioLoading = false;

  @override
  void initState() {
    super.initState();
    _items = AppData.getItems(widget.itemId ?? '');
    _speech = SpeechService();
    _speech.initTts();
    _cardKeys = List.generate(_items.length, (_) => GlobalKey());

    _autoplay = DetailsAutoplayController(
      speech: _speech,
      itemId: widget.itemId ?? '',
      items: _items,
      scrollController: _scrollController,
      onIndexChanged: (i) {
        setState(() => _currentlyPlayingIndex = i);
        _scrollToCard(i);
      },
      onLoadingChanged: (v) => setState(() => _isAudioLoading = v),
      onStateChanged: (_) {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _autoplay.dispose();
    _speech.audioPlayer.dispose();
    _speech.disposeTts();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCard(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _cardKeys[index].currentContext;
      if (!mounted || ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.3,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  /// Highlights the tapped card while its speech plays (cards with no focus page).
  Future<void> _speakAndHighlight(
    int index,
    Future<void> Function() speak,
  ) async {
    setState(() => _currentlyPlayingIndex = index);
    await speak();
    if (mounted &&
        _currentlyPlayingIndex == index &&
        _autoplay.state == AutoplayState.stopped) {
      setState(() => _currentlyPlayingIndex = -1);
    }
  }

  void _handleItemTap(int index) {
    if (_autoplay.state != AutoplayState.stopped) {
      _speech.audioPlayer.stop();
      _autoplay.handleStop();
      setState(() {});
    }

    final itemId = widget.itemId;
    if (itemId == 'bangla_weeks' ||
        itemId == 'bangla_months' ||
        itemId == 'bangla_seasons') {
      _speakAndHighlight(
        index,
        () => _speech.speakBangla(_items[index]['item'] ?? ''),
      );
      return;
    }
    if (itemId == 'english_weeks' ||
        itemId == 'english_months' ||
        itemId == 'english_seasons') {
      _speakAndHighlight(
        index,
        () => _speech.speakItemWithMeaning(_items[index]),
      );
      return;
    }
    if (itemId == 'arabic_weeks' ||
        itemId == 'arabic_months' ||
        itemId == 'arabic_seasons') {
      _speakAndHighlight(
        index,
        () => _speech.speakArabicWithMeaning(_items[index]),
      );
      return;
    }
    if (itemId == 'allah_names') {
      _speakAndHighlight(index, () => _speech.speakAllahName(_items[index]));
      return;
    }
    if (itemId == 'kalima' ||
        itemId == 'namaj' ||
        itemId == 'wudu' ||
        itemId == 'pillars' ||
        itemId == 'daily_dua' ||
        itemId == 'roja' ||
        itemId == 'haj' ||
        itemId == 'jakat') {
      _speakAndHighlight(
        index,
        () => _speech.speakIslamicContent(_items[index]),
      );
      return;
    }

    context.push(
      '/details/${widget.itemId}/focus/$index',
      extra: {'title': widget.title, 'color': widget.color},
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabicCategory =
        widget.itemId == 'arabic_alphabets' ||
        widget.itemId == 'arabic_numbers' ||
        widget.itemId == 'arabic_weeks' ||
        widget.itemId == 'arabic_months' ||
        widget.itemId == 'arabic_seasons' ||
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
                title: Text(
                  widget.title ?? "",
                  style: const TextStyle(fontWeight: .bold),
                ),
              ),
              Expanded(
                child: Directionality(
                  textDirection: isArabicCategory
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: MasonryGridView.count(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                    crossAxisCount: _getCrossAxisCount(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        key: _cardKeys[index],
                        height: _fixedCardHeight(),
                        child: DetailCard(
                          item: _items[index],
                          itemId: widget.itemId,
                          categoryColor: widget.color,
                          isSelected: _currentlyPlayingIndex == index,
                          isAudioLoading: _isAudioLoading,
                          onTap: () => _handleItemTap(index),
                          onSpeak: widget.itemId == 'allah_names'
                              ? (_) => _speech.speakAllahName(_items[index])
                              : widget.itemId == 'kalima' ||
                                    widget.itemId == 'namaj' ||
                                    widget.itemId == 'wudu' ||
                                    widget.itemId == 'pillars' ||
                                    widget.itemId == 'daily_dua' ||
                                    widget.itemId == 'roja' ||
                                    widget.itemId == 'haj' ||
                                    widget.itemId == 'jakat'
                              ? (_) =>
                                    _speech.speakIslamicContent(_items[index])
                              : widget.itemId == 'bangla_rhymes'
                              ? (_) => _speech.speakRhyme(_items[index])
                              : widget.itemId == 'english_rhymes'
                              ? (_) => _speech.speakEnglishRhyme(_items[index])
                              : widget.itemId == 'arabic_alphabets' ||
                                    widget.itemId == 'arabic_numbers'
                              ? (_) => _speech.speakArabicItem(_items[index])
                              : widget.itemId == 'solar_system'
                              ? (_) => _speech.speakSolarSystem(_items[index])
                              : widget.itemId == 'bangla_weeks' ||
                                    widget.itemId == 'bangla_months' ||
                                    widget.itemId == 'bangla_seasons'
                              ? (_) => _speech.speakBangla(
                                  _items[index]['item'] ?? '',
                                )
                              : widget.itemId == 'animals' ||
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
                                    widget.itemId == 'flags' ||
                                    widget.itemId == 'english_weeks' ||
                                    widget.itemId == 'english_months' ||
                                    widget.itemId == 'english_seasons'
                              ? (_) => _speech.speakItemWithRecording(
                                  widget.itemId ?? '',
                                  _items[index],
                                )
                              : (text) => _speech.speak(text),
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
              color: Colors.black.withValues(alpha: 0.5),
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
    if (_autoplay.state == AutoplayState.stopped) {
      return FloatingActionButton.extended(
        onPressed: () {
          _autoplay.handlePlayPause();
          setState(() {});
        },
        backgroundColor: Colors.green,
        heroTag: 'play_all_tag',
        icon: const Icon(Icons.play_arrow, color: Colors.white),
        label: const Text('সব শুনুন', style: TextStyle(color: Colors.white)),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          onPressed: () {
            _autoplay.handlePlayPause();
            setState(() {});
          },
          backgroundColor: Colors.orange,
          heroTag: 'play_pause_tag',
          icon: Icon(
            _autoplay.state == AutoplayState.playing
                ? Icons.pause
                : Icons.play_arrow,
            color: Colors.white,
          ),
          label: Text(
            _autoplay.state == AutoplayState.playing ? 'বিরতি' : 'চালু',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          onPressed: () {
            _autoplay.handleStop();
            setState(() {});
          },
          backgroundColor: Colors.red,
          heroTag: 'stop_tag',
          child: const Icon(Icons.stop, color: Colors.white),
        ),
      ],
    );
  }

  /// Categories whose card text length varies get one fixed height so the
  /// grid rows stay even.
  double? _fixedCardHeight() {
    switch (widget.itemId) {
      case 'math_shapes':
        return 224;
      default:
        return null;
    }
  }

  int _getCrossAxisCount() {
    switch (widget.itemId) {
      case 'bangla_rhymes':
      case 'english_rhymes':
      case 'bangla_weeks':
      case 'bangla_months':
      case 'bangla_seasons':
      case 'english_weeks':
      case 'english_months':
      case 'english_seasons':
      case 'arabic_weeks':
      case 'arabic_months':
      case 'arabic_seasons':
      case 'allah_names':
      case 'small_suras':
      case 'kalima':
      case 'namaj':
      case 'wudu':
      case 'pillars':
      case 'daily_dua':
      case 'roja':
      case 'haj':
      case 'jakat':
        return 1;
      default:
        return 2;
    }
  }
}
