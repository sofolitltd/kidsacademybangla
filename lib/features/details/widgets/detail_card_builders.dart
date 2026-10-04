import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'detail_card_builders_ext.dart';
import 'detail_card_builders_math.dart';

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

Widget buildCardContent({
  required Map<String, dynamic> item,
  required String? itemId,
  required Color categoryColor,
  required List<Color> letterColors,
}) {
  switch (itemId) {
    case 'animals':
    case 'fruits':
    case 'birds':
    case 'flowers':
    case 'fish':
    case 'electronics':
    case 'vehicles':
    case 'body_parts':
    case 'vegetables':
    case 'dress':
    case 'learning_tools':
      return _buildImageContent(item);
    case 'flags':
      return buildFlagContent(item, categoryColor);
    case 'solar_system':
      return buildSolarSystemContent(item, categoryColor);
    case 'colors':
      return _buildColorContent(item);
    case 'english_rhymes':
    case 'bangla_rhymes':
      return _buildRhymeContent(item, categoryColor);
    case 'allah_names':
      return _buildAllahNameContent(item, categoryColor);
    case 'small_suras':
      return _buildSuraContent(item, categoryColor);
    case 'kalima':
    case 'namaj':
    case 'wudu':
    case 'pillars':
    case 'daily_dua':
    case 'roja':
    case 'haj':
    case 'jakat':
      return _buildIslamicContent(item, categoryColor);
    case 'bangla_weeks':
    case 'bangla_months':
    case 'bangla_seasons':
    case 'english_weeks':
    case 'english_months':
    case 'english_seasons':
    case 'arabic_weeks':
    case 'arabic_months':
    case 'arabic_seasons':
      return buildWeeksMonthsContent(item, categoryColor);
    case 'math_counting':
      return buildCountingContent(item, categoryColor);
    case 'math_shapes':
      return buildShapesContent(item, categoryColor);
    case 'math_addition':
      return buildAdditionContent(item, categoryColor);
    case 'math_time':
      return buildTimeContent(item, categoryColor);
    default:
      return buildDefaultContent(item, itemId, categoryColor, letterColors);
  }
}

Padding _buildImageContent(Map<String, dynamic> item) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(item['image']!, height: 150, fit: BoxFit.contain, scale: 1),
        const SizedBox(height: 8),
        Text(
          item['item']!,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          item['pron']!,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
        ),
      ],
    ),
  );
}

Padding _buildColorContent(Map<String, dynamic> item) {
  final color = _colorFromHex(item['hex']!);
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item['item']!,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          item['pron']!,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
        ),
      ],
    ),
  );
}

Widget _buildRhymeContent(Map<String, dynamic> item, Color categoryColor) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (item['image'] != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item['image']!,
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
          )
        else
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: categoryColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.music_note_rounded,
              size: 48,
              color: categoryColor.withValues(alpha: 0.5),
            ),
          ),
        const SizedBox(height: 8),
        Text(
          item['title']!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

String _toBanglaDigits(String input) {
  const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return input.replaceAllMapped(RegExp(r'\d'), (m) => bn[int.parse(m[0]!)]);
}

Padding _buildAllahNameContent(Map<String, dynamic> item, Color categoryColor) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  item['item']!,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.amiri(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '(${item['pron']!})',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item['meaning']!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: item['id'] != null
                ? BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: categoryColor.withValues(alpha: 0.4),
                      width: 2,
                    ),
                  )
                : null,
            child: Text(
              _toBanglaDigits('${item['id']}'),
              style: TextStyle(
                fontFamily: "SolaimanLipi",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: categoryColor,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildSuraContent(Map<String, dynamic> item, Color categoryColor) {
  final int suraNo = item['id'] ?? 0;
  final String banglaTitle = item['item'] ?? '';
  final String englishTitle = item['pron'] ?? '';
  final String arabicTitle = item['pronAr'] ?? '';

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: categoryColor.withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              suraNo.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                banglaTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                englishTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            arabicTitle,
            textAlign: TextAlign.right,
            style: GoogleFonts.amiri(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildIslamicContent(Map<String, dynamic> item, Color categoryColor) {
  final String title = item['item'] ?? '';
  final String? pron = item['pron'];
  final String? arabic = item['arabic'];
  final String? text = item['text'];
  final String? meaning = item['meaning'];

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "SolaimanLipi",
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: categoryColor,
          ),
        ),
        if (pron != null && pron.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            pron,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade600,
            ),
          ),
        ],
        if (arabic != null && arabic.isNotEmpty) ...[
          const SizedBox(height: 12),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              arabic,
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                fontSize: 20,
                height: 2.0,
                color: Colors.black87,
              ),
            ),
          ),
        ],
        if (text != null && text.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: categoryColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "SolaimanLipi",
                fontSize: 16,
                height: 1.8,
                color: Colors.black87,
              ),
            ),
          ),
        ],
        if (meaning != null && meaning.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            meaning,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ],
    ),
  );
}
