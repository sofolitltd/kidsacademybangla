import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_flags/country_flags.dart';

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

Widget buildFlagContent(Map<String, dynamic> item, Color categoryColor) {
  final String title = item['item'] ?? '';
  final String pron = item['pron'] ?? '';
  final String countryCode = item['countryCode'] ?? '';

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CountryFlag.fromCountryCode(
          countryCode,
          shape: const RoundedRectangle(6),
          width: 64,
          height: 44,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: categoryColor,
          ),
        ),
        Text(pron, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
      ],
    ),
  );
}

Widget buildSolarSystemContent(Map<String, dynamic> item, Color categoryColor) {
  final String title = item['item'] ?? '';
  final String pron = item['pron'] ?? '';
  final String icon = item['icon'] ?? 'assets/images/solar_system/earth.png';

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset(icon, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          pron,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
        ),
      ],
    ),
  );
}

Widget buildWeeksMonthsContent(Map<String, dynamic> item, Color categoryColor) {
  final String itemText = item['item'] ?? '';
  final String pron = item['pron'] ?? '';
  final String translit = item['translit'] ?? '';

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          itemText,
          textAlign: TextAlign.center,
          style: translit.isNotEmpty
              ? GoogleFonts.amiri(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: categoryColor,
                  height: 1.2,
                )
              : TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: categoryColor,
                  height: 1.2,
                ),
        ),
        if (translit.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '($translit)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
        if (pron.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            pron,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ],
    ),
  );
}

Widget buildCountingContent(Map<String, dynamic> item, Color categoryColor) {
  final String bangla = item['item'] ?? '';
  final String pron = item['pron'] ?? '';
  final int count = item['count'] ?? 0;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          bangla,
          style: TextStyle(
            fontFamily: "SolaimanLipi",
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: categoryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(pron, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: List.generate(
            count > 10 ? 10 : count,
            (i) => Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: i < count ? categoryColor : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
