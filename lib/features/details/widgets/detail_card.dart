import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final String? itemId;
  final Color categoryColor;
  final bool isSelected;
  final VoidCallback onTap;

  const DetailCard({
    super.key,
    required this.item,
    required this.itemId,
    required this.categoryColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<DetailCard> createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 33),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.05), weight: 33),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 34),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant DetailCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Color> _letterColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
  ];

  // Color _darken(Color color, [double amount = .3]) {
  //   final hsl = HSLColor.fromColor(color);
  //   final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  //   return hslDark.toColor();
  // }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        color: widget.isSelected ? Colors.white : Colors.white38,
        elevation: widget.isSelected ? 6 : 2,
        shadowColor: widget.isSelected
            ? widget.categoryColor.withValues(alpha: 0.3)
            : Colors.black.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: widget.isSelected ? widget.categoryColor : Colors.white38,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: widget.isSelected
                ? widget.categoryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            child: _buildCardContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    switch (widget.itemId) {
      case 'animals':
      case 'fruits':
        return _buildImageContent();
      case 'colors':
        return _buildColorContent();
      case 'english_rhymes':
      case 'bangla_rhymes':
        return _buildRhymeContent();
      case 'allah_names':
        return _buildAllahNameContent();
      case 'small_suras':
        return _buildSuraContent();
      default:
        return _buildDefaultContent();
    }
  }

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Padding _buildImageContent() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(widget.item['image']!, height: 100, fit: BoxFit.contain),
          const SizedBox(height: 12),
          Text(
            widget.item['item']!,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.item['pron']!,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Padding _buildColorContent() {
    final color = _colorFromHex(widget.item['hex']!);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.item['item']!,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.item['pron']!,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Padding _buildRhymeContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item['title']!,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            widget.item['text']!,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Padding _buildAllahNameContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              widget.item['item']!,
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '(${widget.item['pron']!})',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.item['meaning']!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSuraContent() {
    final String arabicText = widget.item['text'] ?? '';
    final String transText = widget.item['trans'] ?? '';

    final List<String> arabicLines = arabicText.split('\n');
    final List<String> transLines = transText.split('\n');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            widget.item['item']!,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.item['pron']!,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade700,
            ),
          ),
          const Divider(height: 32),
          ...List.generate(arabicLines.length, (index) {
            return Column(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    arabicLines[index].trim(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.8,
                    ),
                  ),
                ),
                if (index < transLines.length)
                  Text(
                    transLines[index].trim(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDefaultContent() {
    final bool isArabic =
        widget.itemId == 'arabic_alphabets' ||
        widget.itemId == 'arabic_numbers';
    final stableColor =
        _letterColors[((widget.item['id'] as int) - 1) % _letterColors.length];

    return Padding(
      padding: widget.itemId == 'bangla_vowels'
          ? const EdgeInsets.fromLTRB(16, 24, 16, 24)
          : const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Text(
              widget.item['item']!,
              style: TextStyle(
                fontSize: 54,
                height: 1,
                fontWeight: FontWeight.bold,
                color: stableColor,
                fontFamily: widget.itemId == 'bangla_numbers'
                    ? GoogleFonts.tiroBangla().fontFamily
                    : (isArabic ? GoogleFonts.amiri().fontFamily : null),
              ),
            ),
          ),
          if (widget.item['pron'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                widget.item['pron']!,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                  height: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
