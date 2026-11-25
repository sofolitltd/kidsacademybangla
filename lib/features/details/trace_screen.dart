import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';

import '../../core/data/app_data.dart';
import '../../core/services/reward_service.dart';
import '../../core/services/speech_service.dart';
import 'widgets/trace_grid.dart';

/// "আঁকো": the child paints over a big faint letter or number with a finger.
///
/// Paint only shows in full colour inside the letter, so the result always
/// looks tidy, and the letter counts as done once most of it is covered.
/// There is no failure state and no stroke-order checking.
class TraceScreen extends StatefulWidget {
  final String itemId;
  final String? title;
  final Color color;

  const TraceScreen({
    super.key,
    required this.itemId,
    this.title,
    this.color = Colors.blueGrey,
  });

  static const Set<String> _categories = {
    'bangla_vowels',
    'bangla_consonants',
    'bangla_numbers',
    'english_alphabets',
    'english_numbers',
    'arabic_alphabets',
    'arabic_numbers',
  };

  static bool supports(String itemId) => _categories.contains(itemId);

  @override
  State<TraceScreen> createState() => _TraceScreenState();
}

class _TraceScreenState extends State<TraceScreen> {
  /// Letters to finish for one star.
  static const int _lettersPerStar = 5;

  late final SpeechService _speech;
  late final List<Map<String, dynamic>> _items;
  int _index = 0;
  int _attempt = 0; // bumped to wipe the pad
  double _coverage = 0;
  bool _done = false;
  int _completed = 0;

  Map<String, dynamic> get _item => _items[_index];
  String get _glyph => (_item['item'] ?? '').toString();

  @override
  void initState() {
    super.initState();
    _items = AppData.getItemsForLevel(widget.itemId);
    _speech = SpeechService();
    _speech.initTts().then((_) {
      if (mounted) _sayLetter();
    });
  }

  @override
  void dispose() {
    _speech.audioPlayer.dispose();
    _speech.disposeTts();
    super.dispose();
  }

  Future<void> _sayLetter() async {
    final item = _item;
    if (await _speech.playItemSound(widget.itemId, item)) return;
    if (widget.itemId.startsWith('arabic_')) {
      await _speech.speakArabicItem(item);
    } else {
      await _speech.speakBangla(
        (item['pron'] ?? item['item'] ?? '').toString(),
      );
    }
  }

  void _goTo(int index) {
    setState(() {
      _index = (index + _items.length) % _items.length;
      _attempt++;
      _coverage = 0;
      _done = false;
    });
    _sayLetter();
  }

  void _clear() {
    setState(() {
      _attempt++;
      _coverage = 0;
      _done = false;
    });
  }

  Future<void> _onDone() async {
    if (_done) return;
    final finishedIndex = _index;
    final earnedStar = (_completed + 1) % _lettersPerStar == 0;
    setState(() {
      _done = true;
      _coverage = 1;
      _completed++;
    });
    if (earnedStar) await RewardService.addTokens(1);
    await _speech.speakBangla(
      earnedStar ? 'সাবাশ! তুমি একটা তারা পেয়েছ।' : 'সাবাশ!',
    );
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted && _done && _index == finishedIndex) _goTo(_index + 1);
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
                _buildStars(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _coverage,
                      minHeight: 14,
                      backgroundColor: Colors.white.withValues(alpha: 0.7),
                      color: _done ? Colors.green : widget.color,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: LayoutBuilder(
                      builder: (context, box) {
                        final side = box.biggest.shortestSide;
                        return Center(
                          child: SizedBox(
                            width: side,
                            height: side,
                            child: _TracePad(
                              key: ValueKey('$_index-$_attempt-$side'),
                              glyph: _glyph,
                              side: side,
                              color: widget.color,
                              done: _done,
                              onCoverage: (v) {
                                if (!_done) setState(() => _coverage = v);
                              },
                              onDone: _onDone,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                _buildControls(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Stars filling up toward the next reward.
  Widget _buildStars() {
    final filled = _completed % _lettersPerStar;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < _lettersPerStar; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              i < filled ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 30,
              color: const Color(0xFFFFA928),
            ),
          ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _roundButton(
          Icons.arrow_back_rounded,
          Colors.blueGrey,
          () => _goTo(_index - 1),
        ),
        _roundButton(Icons.volume_up_rounded, widget.color, _sayLetter),
        _roundButton(Icons.refresh_rounded, Colors.orange, _clear),
        _roundButton(
          Icons.arrow_forward_rounded,
          Colors.green,
          () => _goTo(_index + 1),
        ),
      ],
    );
  }

  Widget _roundButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 36),
      ),
    );
  }
}

/// The square drawing surface for one letter. Recreated (via its key) for
/// every new letter, retry, or size change, so its state starts clean.
class _TracePad extends StatefulWidget {
  final String glyph;
  final double side;
  final Color color;
  final bool done;
  final ValueChanged<double> onCoverage;
  final VoidCallback onDone;

  const _TracePad({
    super.key,
    required this.glyph,
    required this.side,
    required this.color,
    required this.done,
    required this.onCoverage,
    required this.onDone,
  });

  @override
  State<_TracePad> createState() => _TracePadState();
}

class _TracePadState extends State<_TracePad> {
  static const int _gridSize = 64;

  /// Share of the letter that must be painted to count as done. Below 1
  /// because thin tails and dots are hard for small fingers to hit.
  static const double _doneAt = 0.82;

  static const Color _guideColor = Color(0xFFD8D2CC);

  late final TextPainter _guide;
  late final TextPainter _filled;
  late final Offset _glyphOffset;
  late final double _brush;
  final List<List<Offset>> _strokes = [];
  final ValueNotifier<int> _repaint = ValueNotifier(0);
  TraceGrid? _grid;

  @override
  void initState() {
    super.initState();
    final side = widget.side;
    _brush = side * 0.1;

    // Fit the letter inside the pad; wide Bangla letters get scaled down.
    double fontSize = side * 0.72;
    TextPainter build(Color color) => TextPainter(
      text: TextSpan(
        text: widget.glyph,
        style: TextStyle(
          fontFamily: 'SolaimanLipi',
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1.1,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    var guide = build(_guideColor);
    final maxWidth = side * 0.88;
    if (guide.width > maxWidth) {
      fontSize *= maxWidth / guide.width;
      guide = build(_guideColor);
    }
    _guide = guide;
    _filled = build(widget.color);
    _glyphOffset = Offset((side - guide.width) / 2, (side - guide.height) / 2);
    _buildGrid();
  }

  /// Rasterises the letter into the coverage grid.
  Future<void> _buildGrid() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(_gridSize / widget.side);
    _guide.paint(canvas, _glyphOffset);
    final image = await recorder.endRecording().toImage(_gridSize, _gridSize);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    if (!mounted || bytes == null) return;
    _grid = TraceGrid.fromRgba(_gridSize, bytes.buffer.asUint8List());
  }

  @override
  void dispose() {
    _repaint.dispose();
    _guide.dispose();
    _filled.dispose();
    super.dispose();
  }

  void _addPoint(Offset point, {required bool newStroke}) {
    if (widget.done) return;
    Offset from = point;
    if (newStroke || _strokes.isEmpty) {
      _strokes.add([point]);
    } else {
      from = _strokes.last.last;
      _strokes.last.add(point);
    }
    _repaint.value++;

    final grid = _grid;
    if (grid == null) return;
    final scale = _gridSize / widget.side;
    // A little wider than the visible brush, to forgive small fingers.
    final radius = _brush / 2 * scale + 1;
    grid.markSegment(
      from.dx * scale,
      from.dy * scale,
      point.dx * scale,
      point.dy * scale,
      radius,
    );
    final coverage = grid.coverage;
    if (coverage >= _doneAt) {
      widget.onDone();
    } else {
      widget.onCoverage(coverage / _doneAt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (d) => _addPoint(d.localPosition, newStroke: true),
      onPanUpdate: (d) => _addPoint(d.localPosition, newStroke: false),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: widget.done ? Colors.green : Colors.white,
            width: widget.done ? 6 : 3,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.2),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: RepaintBoundary(
          child: CustomPaint(
            size: Size.square(widget.side),
            painter: _TracePainter(
              guide: _guide,
              filled: _filled,
              glyphOffset: _glyphOffset,
              strokes: _strokes,
              brush: _brush,
              color: widget.color,
              done: widget.done,
              repaint: _repaint,
            ),
          ),
        ),
      ),
    );
  }
}

class _TracePainter extends CustomPainter {
  final TextPainter guide;
  final TextPainter filled;
  final Offset glyphOffset;
  final List<List<Offset>> strokes;
  final double brush;
  final Color color;
  final bool done;

  _TracePainter({
    required this.guide,
    required this.filled,
    required this.glyphOffset,
    required this.strokes,
    required this.brush,
    required this.color,
    required this.done,
    required Listenable repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    if (done) {
      filled.paint(canvas, glyphOffset);
      return;
    }
    guide.paint(canvas, glyphOffset);
    if (strokes.isEmpty) return;

    final path = Path();
    for (final stroke in strokes) {
      path.moveTo(stroke.first.dx, stroke.first.dy);
      if (stroke.length == 1) {
        // A tap: a zero-length line draws as a round dot.
        path.lineTo(stroke.first.dx, stroke.first.dy + 0.01);
      }
      for (final p in stroke.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
    }
    final ink = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = brush
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Paint outside the letter stays faint...
    canvas.drawPath(path, ink..color = color.withValues(alpha: 0.15));

    // ...and shows in full colour only where it lies on the letter.
    final bounds = Offset.zero & size;
    canvas.saveLayer(bounds, Paint());
    canvas.drawPath(path, ink..color = color);
    canvas.saveLayer(bounds, Paint()..blendMode = BlendMode.dstIn);
    guide.paint(canvas, glyphOffset);
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(_TracePainter old) =>
      old.done != done || old.strokes != strokes;
}
