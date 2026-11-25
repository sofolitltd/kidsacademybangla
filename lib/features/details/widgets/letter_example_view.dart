import 'package:material_ui/material_ui.dart';

import '../../../core/data/letter_examples.dart';

/// Picture and caption for a letter's example word. Draws nothing for items
/// that have no example.
class LetterExampleView extends StatelessWidget {
  final String itemId;
  final Map<String, dynamic> item;
  final double pictureSize;
  final double fontSize;

  /// Called with the phrase to speak. Omit on cards, where a tap on the
  /// picture should behave like a tap on the card.
  final ValueChanged<String>? onSpeak;

  const LetterExampleView({
    super.key,
    required this.itemId,
    required this.item,
    required this.pictureSize,
    required this.fontSize,
    this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    final example = letterExampleFor(itemId, item);
    if (example == null) return const SizedBox.shrink();
    final phrase = letterExamplePhrase(itemId, item, example);
    final image = example.image;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: pictureSize,
          height: pictureSize,
          child: image != null
              ? Image.asset(image, fit: BoxFit.contain)
              : FittedBox(child: Text(example.emoji!)),
        ),
        const SizedBox(height: 6),
        Text(
          phrase,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF3D2A1E),
          ),
        ),
      ],
    );

    final onSpeak = this.onSpeak;
    if (onSpeak == null) return content;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onSpeak(phrase),
      child: content,
    );
  }
}
