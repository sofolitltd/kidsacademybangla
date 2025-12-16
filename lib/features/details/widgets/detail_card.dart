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
      duration: const Duration(milliseconds: 300),
    );

    // Create a "pop" or "bouncy" animation
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.05), weight: 50),
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

  // --- The rest of the card building logic remains the same ---
  final List<Color> _letterColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
  ];

  Color _darken(Color color, [double amount = .3]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  @override
  Widget build(BuildContext context) {
    // Use a ScaleTransition for the bouncy effect
    return ScaleTransition(
      scale: _scaleAnimation,
      // The rest of the card UI
      child: Card(
        color: Colors.white54,
        elevation: widget.isSelected ? 8.0 : 2.0,
        shadowColor: widget.isSelected
            ? widget.categoryColor.withValues(alpha: 0.6)
            : Colors.black.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          side: widget.isSelected
              ? BorderSide(color: widget.categoryColor, width: 3.0)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: widget.onTap, child: _buildCardContent()),
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _darken(widget.categoryColor),
            ),
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
    final bool isWhite = color == Colors.white;
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
            ),
            // child: CircleAvatar(backgroundColor: color, radius: 40),
          ),
          const SizedBox(height: 12),
          Text(
            widget.item['item']!,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _darken(widget.categoryColor),
            ),
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _darken(widget.categoryColor),
            ),
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
          Text(
            widget.item['item']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: _darken(widget.categoryColor),
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

  Widget _buildDefaultContent() {
    final stableColor =
        _letterColors[((widget.item['id'] as int) - 1) % _letterColors.length];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: widget.itemId == 'bangla_vowels' ? 12 : 0,
          ),
          child: Text(
            widget.item['item']!,
            style: TextStyle(
              fontSize: 54,
              fontWeight: FontWeight.bold,
              color: stableColor,
              fontFamily: widget.itemId == 'bangla_numbers'
                  ? GoogleFonts.tiroBangla().fontFamily
                  : null,
            ),
          ),
        ),
        if (widget.item['pron'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Text(
              widget.item['pron']!,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
            ),
          ),
      ],
    );
  }
}
