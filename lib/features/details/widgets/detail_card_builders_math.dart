import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'clock_art.dart';
import 'shape_art.dart';

Widget buildShapesContent(Map<String, dynamic> item, Color categoryColor) {
  final String title = item['item'] ?? '';
  final String pron = item['pron'] ?? '';
  final String meaning = item['meaning'] ?? '';

  return Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShapeArt(shape: pron, size: 68),
        const SizedBox(height: 8),
        Text(
          pron,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: categoryColor,
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
        if (meaning.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            meaning,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ],
    ),
  );
}

Widget buildAdditionContent(Map<String, dynamic> item, Color categoryColor) {
  final String equation = item['item'] ?? '';
  final String pron = item['pron'] ?? '';
  final String answer = item['answer'] ?? '';

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          equation,
          style: TextStyle(
            fontFamily: "SolaimanLipi",
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: categoryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(pron, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '= $answer',
            style: TextStyle(
              fontFamily: "SolaimanLipi",
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: categoryColor,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildTimeContent(Map<String, dynamic> item, Color categoryColor) {
  final String time = item['item'] ?? '';
  final String pron = item['pron'] ?? '';
  final int hour = (item['hour'] as int?) ?? 12;
  final int minute = (item['minute'] as int?) ?? 0;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClockArt(hour: hour, minute: minute, size: 92, color: categoryColor),
        const SizedBox(height: 8),
        Text(
          time,
          style: TextStyle(
            fontFamily: "SolaimanLipi",
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: categoryColor,
          ),
        ),
        Text(pron, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
      ],
    ),
  );
}

Widget buildDefaultContent(
  Map<String, dynamic> item,
  String? itemId,
  Color categoryColor,
  List<Color> letterColors,
) {
  final bool isArabic =
      itemId == 'arabic_alphabets' || itemId == 'arabic_numbers';
  final stableColor =
      letterColors[((item['id'] as int) - 1) % letterColors.length];
  final String itemText = item['item'] ?? '';
  final double fontSize = itemText.length > 12
      ? 22
      : (itemText.length > 8 ? 28 : (itemText.length > 5 ? 36 : 54));

  return Padding(
    padding: itemId == 'bangla_vowels' || itemId == 'bangla_consonants'
        ? const EdgeInsets.fromLTRB(16, 32, 16, 32)
        : const EdgeInsets.fromLTRB(16, 16, 16, 16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Text(
            itemText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              height: 1,
              fontWeight: FontWeight.bold,
              color: stableColor,
              fontFamily:
                  itemId == 'bangla_numbers' ||
                      itemId == 'bangla_vowels' ||
                      itemId == 'bangla_consonants'
                  ? 'SolaimanLipi'
                  : (isArabic ? GoogleFonts.amiri().fontFamily : null),
            ),
          ),
        ),
        if (item['pron'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              item['pron']!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1,
              ),
            ),
          ),
      ],
    ),
  );
}
