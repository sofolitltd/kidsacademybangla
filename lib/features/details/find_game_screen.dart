import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../../core/data/app_data.dart';
import '../../core/services/age_service.dart';
import '../../core/services/reward_service.dart';
import '../../core/services/speech_service.dart';

/// "খুঁজে বের করো": the child hears a name and taps the matching picture,
/// letter or number. The number of choices grows with the child's level.
///
/// There is no failure state: a wrong tap dims that choice and repeats the
/// question, so every round ends in success.
class FindGameScreen extends StatefulWidget {
  final String itemId;
  final String? title;
  final Color color;

  const FindGameScreen({
    super.key,
    required this.itemId,
    this.title,
    this.color = Colors.blueGrey,
  });

  /// Categories whose items are shown as a picture.
  static const Set<String> _imageCategories = {
    'animals',
    'fruits',
    'birds',
    'fish',
    'flowers',
    'vegetables',
    'vehicles',
    'dress',
    'electronics',
    'body_parts',
    'learning_tools',
  };

  /// Categories whose items are shown as a big glyph and asked by recording.
  static const Set<String> _glyphCategories = {
    'bangla_vowels',
    'bangla_consonants',
    'bangla_numbers',
    'english_alphabets',
    'english_numbers',
    'arabic_alphabets',
    'arabic_numbers',
  };

  static bool supports(String itemId) =>
      _imageCategories.contains(itemId) ||
      _glyphCategories.contains(itemId) ||
      itemId == 'colors';

  @override
  State<FindGameScreen> createState() => _FindGameScreenState();
}

class _FindGameScreenState extends State<FindGameScreen> {
  static const int _questionsPerRound = 5;
  static const int _starsPerRound = 1;

  final Random _random = Random();
  late final SpeechService _speech;
  late final List<Map<String, dynamic>> _pool;
  late final int _choiceCount;

  late List<Map<String, dynamic>> _targets;
  List<Map<String, dynamic>> _choices = [];
  final Set<int> _wrongIds = {};
  int _question = 0;
  bool _answered = false;
  bool _finished = false;

  bool get _isGlyph => FindGameScreen._glyphCategories.contains(widget.itemId);

  @override
  void initState() {
    super.initState();
    _speech = SpeechService();

    final level = AgeService.level.value;
    // 3–4 yrs: two choices; 4–5: three; 5+ (or unknown): four.
    _choiceCount = level == null ? 4 : (level - 1).clamp(2, 4);

    // Quiz only what the child has been shown at this level.
    final all = AppData.getItemsForLevel(widget.itemId);
    final cap = AgeService.initialItemCount(widget.itemId, level);
    _pool = cap != null && cap >= _choiceCount && cap < all.length
        ? all.sublist(0, cap)
        : all;

    _speech.initTts().then((_) {
      if (mounted) _startRound();
    });
  }

  @override
  void dispose() {
    _speech.audioPlayer.dispose();
    _speech.disposeTts();
    super.dispose();
  }

  void _startRound() {
    final shuffled = [..._pool]..shuffle(_random);
    _targets = shuffled.take(min(_questionsPerRound, shuffled.length)).toList();
    _question = 0;
    _finished = false;
    _loadQuestion();
  }

  Map<String, dynamic> get _target => _targets[_question];

  void _loadQuestion() {
    final target = _target;
    final others = _pool.where((it) => it['id'] != target['id']).toList()
      ..shuffle(_random);
    final choices = [target, ...others.take(_choiceCount - 1)]
      ..shuffle(_random);
    setState(() {
      _choices = choices;
      _wrongIds.clear();
      _answered = false;
    });
    _ask();
  }

  /// Says the question aloud. Children at this age can't read it.
  Future<void> _ask() async {
    final target = _target;
    if (_isGlyph) {
      // Letters and numbers have recorded voices; fall back to the name.
      if (await _speech.playItemSound(widget.itemId, target)) return;
      final name = (target['pron'] ?? target['item'] ?? '').toString();
      await _speech.speakBangla(name);
      return;
    }
    final name = (target['pron'] ?? target['item'] ?? '').toString();
    await _speech.speakBangla('কোনটা $name?');
  }

  Future<void> _onChoice(Map<String, dynamic> choice) async {
    if (_answered || _finished) return;
    final id = choice['id'] as int;
    if (id != _target['id']) {
      if (_wrongIds.add(id)) setState(() {});
      _ask();
      return;
    }

    setState(() => _answered = true);
    final askedFor = _question;
    await _speech.speakBangla('সাবাশ!');
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted || askedFor != _question) return;

    if (_question + 1 < _targets.length) {
      _question++;
      _loadQuestion();
    } else {
      await RewardService.addTokens(_starsPerRound);
      if (!mounted) return;
      setState(() => _finished = true);
      _speech.speakBangla('খুব ভালো! তুমি একটা তারা পেয়েছ।');
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
            child: Container(color: Colors.white.withValues(alpha: .4)),
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.white,
                  centerTitle: true,
                  title: Text(
                    widget.title ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (_choices.isEmpty)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_finished)
                  Expanded(child: _buildFinished())
                else ...[
                  _buildProgress(),
                  const SizedBox(height: 12),
                  _buildAskButton(),
                  Expanded(child: _buildChoices()),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < _targets.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              i < _question || (i == _question && _answered)
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              size: 32,
              color: const Color(0xFFFFA928),
            ),
          ),
      ],
    );
  }

  /// Big "hear it again" button; the question is never shown as text only.
  Widget _buildAskButton() {
    return GestureDetector(
      onTap: _ask,
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.volume_up_rounded,
          color: Colors.white,
          size: 52,
        ),
      ),
    );
  }

  Widget _buildChoices() {
    final columns = _choices.length <= 2 ? 1 : 2;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, box) {
            final rows = (_choices.length / columns).ceil();
            const gap = 16.0;
            final side = min(
              (box.maxWidth - gap * (columns - 1)) / columns,
              (box.maxHeight - gap * (rows - 1)) / rows,
            );
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              alignment: WrapAlignment.center,
              children: [
                for (final choice in _choices)
                  SizedBox(
                    width: side,
                    height: side,
                    child: _buildChoice(choice),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChoice(Map<String, dynamic> choice) {
    final id = choice['id'] as int;
    final isWrong = _wrongIds.contains(id);
    final isRight = _answered && id == _target['id'];
    return GestureDetector(
      onTap: () => _onChoice(choice),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: isWrong ? 0.3 : 1,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 250),
          scale: isRight ? 1.05 : 1,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isRight ? Colors.green : Colors.white,
                width: isRight ? 6 : 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: _buildChoiceContent(choice),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceContent(Map<String, dynamic> choice) {
    final hex = choice['hex'];
    if (widget.itemId == 'colors' && hex is String) {
      final code = hex.replaceAll('#', '');
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(int.parse('FF$code', radix: 16)),
          border: Border.all(color: Colors.black12, width: 2),
        ),
      );
    }
    final image = choice['image'];
    if (image is String && image.isNotEmpty) {
      return Image.asset(image, fit: BoxFit.contain);
    }
    return FittedBox(
      child: Text(
        (choice['item'] ?? '').toString(),
        style: TextStyle(
          fontSize: 96,
          fontWeight: FontWeight.bold,
          color: Color.lerp(widget.color, Colors.black, 0.25),
        ),
      ),
    );
  }

  Widget _buildFinished() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 96)),
          const SizedBox(height: 8),
          const Text(
            'খুব ভালো!',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.star_rounded, size: 40, color: Color(0xFFFFA928)),
              SizedBox(width: 6),
              Text(
                '+$_starsPerRound',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _roundButton(
                icon: Icons.arrow_back_rounded,
                color: Colors.blueGrey,
                onTap: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 28),
              _roundButton(
                icon: Icons.replay_rounded,
                color: Colors.green,
                onTap: _startRound,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Icon(icon, color: Colors.white, size: 44),
      ),
    );
  }
}
