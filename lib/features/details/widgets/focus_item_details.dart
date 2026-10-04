import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_flags/country_flags.dart';

import 'clock_art.dart';
import 'shape_art.dart';
import 'tilt_3d_image.dart';

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

class FocusItemDetails extends StatelessWidget {
  final Map<String, dynamic> item;
  final String itemId;
  final Color color;
  final int activeVerseIndex;
  final List<Color> letterColors;

  const FocusItemDetails({
    super.key,
    required this.item,
    required this.itemId,
    required this.color,
    this.activeVerseIndex = -1,
    required this.letterColors,
  });

  @override
  Widget build(BuildContext context) {
    switch (itemId) {
      case 'animals':
      case 'fruits':
      case 'birds':
      case 'flowers':
      case 'fish':
      case 'body_parts':
      case 'vegetables':
      case 'electronics':
      case 'vehicles':
      case 'dress':
      case 'learning_tools':
        return _buildImageDetail();
      case 'colors':
        return _buildColorDetail();
      case 'english_rhymes':
      case 'bangla_rhymes':
        return _buildRhymeDetail();
      case 'allah_names':
        return _buildAllahNameDetail();
      case 'small_suras':
        return _buildSuraDetail();
      case 'kalima':
      case 'namaj':
      case 'wudu':
      case 'pillars':
      case 'daily_dua':
      case 'roja':
      case 'haj':
      case 'jakat':
        return _buildIslamicDetail();
      case 'math_counting':
        return _buildCountingDetail();
      case 'math_shapes':
        return _buildIconDetail();
      case 'math_addition':
        return _buildAdditionDetail();
      case 'math_time':
        return _buildTimeDetail();
      case 'flags':
        return _buildFlagDetail();
      case 'solar_system':
        return _buildSolarSystemDetail();
      default:
        return _buildDefaultDetail();
    }
  }

  Widget _buildImageDetail() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tilt3DImage(
          height: 320,
          child: Image.asset(item['image']!, fit: BoxFit.contain),
        ),
        const SizedBox(height: 16),
        Text(
          item['item']!,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          item['pron']!,
          style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildColorDetail() {
    final c = colorFromHex(item['hex']!);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black12, width: 2),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          item['item']!,
          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          item['pron']!,
          style: TextStyle(fontSize: 28, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildRhymeDetail() {
    final List<String> lines = item['text']!.split('\n');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (item['image'] != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              item['image']!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
        ],
        Text(
          item['title']!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: itemId == 'bangla_rhymes' ? "SolaimanLipi" : null,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(lines.length, (index) {
          final isHighlighted = activeVerseIndex == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Text(
              lines[index].trim(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: itemId == 'bangla_rhymes' ? "SolaimanLipi" : null,
                fontSize: 19,
                height: 1.6,
                fontWeight: isHighlighted ? FontWeight.bold : null,
                color: isHighlighted ? color : Colors.black87,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAllahNameDetail() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item['item']!,
          textAlign: TextAlign.center,
          style: GoogleFonts.amiri(fontSize: 80, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Text(
          '(${item['pron']!})',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontStyle: FontStyle.italic,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          item['meaning']!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildSuraDetail() {
    final String arabicText = item['text'] ?? '';
    final String transText = item['trans'] ?? '';
    final List<String> arabicLines = arabicText.split('\n');
    final List<String> transLines = transText.split('\n');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item['item']!,
          style: const TextStyle(
            fontFamily: "SolaimanLipi",
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          item['pron']!,
          style: TextStyle(
            fontFamily: "SolaimanLipi",
            fontSize: 18,
            color: Colors.grey.shade700,
          ),
        ),
        const Divider(height: 24, thickness: 2),
        ...List.generate(arabicLines.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                Text(
                  arabicLines[index].trim(),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    height: 1.8,
                    color: Colors.black,
                  ),
                ),
                if (index < transLines.length)
                  Text(
                    transLines[index].trim(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "SolaimanLipi",
                      fontSize: 18,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildIslamicDetail() {
    final String title = item['item'] ?? '';
    final String? text = item['text'];
    final String? arabic = item['arabic'];
    final String? meaning = item['meaning'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "SolaimanLipi",
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        if (arabic != null && arabic.isNotEmpty) ...[
          const SizedBox(height: 24),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              arabic,
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                fontSize: 26,
                height: 2.0,
                color: Colors.black87,
              ),
            ),
          ),
        ],
        if (text != null && text.isNotEmpty) ...[
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "SolaimanLipi",
                fontSize: 22,
                height: 2.0,
                color: Colors.black87,
              ),
            ),
          ),
        ],
        if (meaning != null && meaning.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            meaning,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCountingDetail() {
    final String bangla = item['item'] ?? '';
    final String pron = item['pron'] ?? '';
    final int count = item['count'] ?? 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          bangla,
          style: TextStyle(
            fontFamily: "SolaimanLipi",
            fontSize: 120,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 16),
        Text(pron, style: TextStyle(fontSize: 32, color: Colors.grey.shade700)),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: List.generate(
            count > 20 ? 20 : count,
            (i) => Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: i < count ? color : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconDetail() {
    final String title = item['item'] ?? '';
    final String pron = item['pron'] ?? '';
    final String meaning = item['meaning'] ?? '';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tilt3DImage(height: 190, child: ShapeArt(shape: pron, size: 190)),
        const SizedBox(height: 24),
        Text(
          pron,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: "SolaimanLipi",
            fontSize: 28,
            color: Colors.grey.shade700,
          ),
        ),
        if (meaning.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            meaning,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "SolaimanLipi",
              fontSize: 20,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAdditionDetail() {
    final String equation = item['item'] ?? '';
    final String pron = item['pron'] ?? '';
    final String answer = item['answer'] ?? '';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          equation,
          style: TextStyle(
            fontFamily: "SolaimanLipi",
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 12),
        Text(pron, style: TextStyle(fontSize: 24, color: Colors.grey.shade700)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '= $answer',
            style: TextStyle(
              fontFamily: "SolaimanLipi",
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeDetail() {
    final String time = item['item'] ?? '';
    final String pron = item['pron'] ?? '';
    final int hour = (item['hour'] as int?) ?? 12;
    final int minute = (item['minute'] as int?) ?? 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tilt3DImage(
          height: 240,
          child: ClockArt(hour: hour, minute: minute, size: 240, color: color),
        ),
        const SizedBox(height: 24),
        Text(
          time,
          style: TextStyle(
            fontFamily: "SolaimanLipi",
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(pron, style: TextStyle(fontSize: 32, color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildFlagDetail() {
    final String title = item['item'] ?? '';
    final String pron = item['pron'] ?? '';
    final String countryCode = item['countryCode'] ?? '';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CountryFlag.fromCountryCode(
          countryCode,
          shape: const RoundedRectangle(6),
          width: 160,
          height: 110,
        ),
        const SizedBox(height: 32),
        Text(
          title,
          style: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(pron, style: TextStyle(fontSize: 32, color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildSolarSystemDetail() {
    final String title = item['item'] ?? '';
    final String pron = item['pron'] ?? '';
    final String meaning = item['meaning'] ?? '';
    final String icon = item['icon'] ?? 'assets/images/solar_system/earth.png';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tilt3DImage(
          height: 220,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              icon,
              width: 220,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          pron,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: "SolaimanLipi",
            fontSize: 32,
            color: Colors.grey.shade700,
          ),
        ),
        if (meaning.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            meaning,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultDetail() {
    final stableColor =
        letterColors[((item['id'] as int) - 1) % letterColors.length];
    final isArabic = itemId.contains('arabic');
    final isBangla = const [
      'bangla_numbers',
      'bangla_vowels',
      'bangla_consonants',
    ].contains(itemId);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item['item']!,
          style: TextStyle(
            fontSize: 180,
            fontWeight: FontWeight.bold,
            color: stableColor,
            fontFamily: isBangla
                ? "SolaimanLipi"
                : (isArabic ? GoogleFonts.amiri().fontFamily : null),
          ),
        ),
        if (item['pron'] != null)
          Text(
            item['pron']!,
            style: TextStyle(fontSize: 40, color: Colors.grey.shade700),
          ),
      ],
    );
  }
}
