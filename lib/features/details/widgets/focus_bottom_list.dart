import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FocusBottomList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String itemId;
  final Color color;
  final int currentIndex;
  final ScrollController controller;
  final List<Color> letterColors;
  final ValueChanged<int> onPageSelected;

  const FocusBottomList({
    super.key,
    required this.items,
    required this.itemId,
    required this.color,
    required this.currentIndex,
    required this.controller,
    required this.letterColors,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 20),
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final isSelected = index == currentIndex;
          return GestureDetector(
            onTap: () => onPageSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 90,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Colors.white
                      : color.withValues(alpha: 0.3),
                  width: 3,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Center(child: _buildThumbnail(index)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThumbnail(int index) {
    final item = items[index];
    if (itemId == 'animals' ||
        itemId == 'fruits' ||
        itemId == 'birds' ||
        itemId == 'fish' ||
        itemId == 'flowers' ||
        itemId == 'body_parts' ||
        itemId == 'vegetables' ||
        itemId == 'electronics' ||
        itemId == 'vehicles' ||
        itemId == 'dress' ||
        itemId == 'learning_tools') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(item['image']!, height: 40, fit: BoxFit.contain),
          const SizedBox(height: 4),
          Text(
            item['item']!,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: index == currentIndex ? Colors.white : Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    } else if (itemId == 'solar_system') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              item['icon'] ?? 'assets/images/solar_system/earth.png',
              height: 44,
              width: 44,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item['item']!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: "SolaimanLipi",
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: index == currentIndex ? Colors.white : Colors.black87,
            ),
          ),
        ],
      );
    } else if (itemId == 'colors') {
      final hexCode = (item['hex'] ?? '').replaceAll('#', '');
      final c = Color(int.parse('FF$hexCode', radix: 16));
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );
    } else if (itemId == 'allah_names') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 4,
        children: [
          Text(
            item['item']!,
            style: GoogleFonts.amiri(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: index == currentIndex ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            item['pron']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: index == currentIndex ? Colors.white : Colors.black87,
            ),
          ),
        ],
      );
    } else if (itemId == 'small_suras' ||
        itemId == 'bangla_rhymes' ||
        itemId == 'english_rhymes') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Text(
          (itemId == 'small_suras' ? item['item'] : item['title']) ?? '',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: itemId == 'bangla_rhymes' ? "SolaimanLipi" : null,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            height: 1.3,
            color: index == currentIndex ? Colors.white : Colors.black87,
          ),
        ),
      );
    } else {
      return Text(
        item['item']!,
        style: TextStyle(
          fontFamily:
              const [
                'bangla_numbers',
                'bangla_vowels',
                'bangla_consonants',
              ].contains(itemId)
              ? "SolaimanLipi"
              : null,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: index == currentIndex
              ? Colors.white
              : letterColors[((item['id'] as int) - 1) % letterColors.length],
        ),
      );
    }
  }
}
