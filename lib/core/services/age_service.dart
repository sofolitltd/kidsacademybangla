import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_service.dart';

/// The child's learning level, expressed as the lower bound of an age band:
/// 2 (2–3 yrs), 3 (3–4), 4 (4–5), 5 (5+).
///
/// A level picked by hand wins; otherwise it follows the first child profile
/// that has a birth date, so it grows with the child.
class AgeService {
  static const String _manualKey = 'age_level_manual';
  static const List<int> levels = [2, 3, 4, 5];

  /// Current level, or null when nothing is known yet (show everything).
  static final ValueNotifier<int?> level = ValueNotifier<int?>(null);

  static int levelForAge(int age) => age.clamp(2, 5);

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final manual = prefs.getInt(_manualKey);
    if (manual != null) {
      level.value = levelForAge(manual);
      return;
    }
    final profiles = await ProfileService.getAllProfiles();
    for (final p in profiles) {
      if (p.age > 0) {
        level.value = levelForAge(p.age);
        return;
      }
    }
    level.value = null;
  }

  static Future<void> setLevel(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_manualKey, value);
    level.value = levelForAge(value);
  }

  static String label(int level) {
    switch (level) {
      case 2:
        return '২–৩ বছর';
      case 3:
        return '৩–৪ বছর';
      case 4:
        return '৪–৫ বছর';
      default:
        return '৫ বছর+';
    }
  }

  static String emoji(int level) {
    switch (level) {
      case 2:
        return '🐣';
      case 3:
        return '🐥';
      case 4:
        return '🧒';
      default:
        return '🎒';
    }
  }

  // ---- Content rules -------------------------------------------------------

  /// Youngest level a category suits. Anything not listed is for 5+.
  static const Map<String, int> _categoryMinAge = {
    // 2–3: naming familiar, concrete things.
    'animals': 2,
    'fruits': 2,
    'birds': 2,
    'vehicles': 2,
    'body_parts': 2,
    'colors': 2,
    // 3–4: first counting, shapes, first letters, wider vocabulary.
    'math_counting': 3,
    'math_shapes': 3,
    'bangla_vowels': 3,
    'vegetables': 3,
    'flowers': 3,
    'fish': 3,
    'dress': 3,
    // 4–5: letter–sound mapping, numerals, sequences.
    'bangla_consonants': 4,
    'bangla_numbers': 4,
    'english_alphabets': 4,
    'english_numbers': 4,
    'arabic_alphabets': 4,
    'bangla_weeks': 4,
    'bangla_seasons': 4,
    'electronics': 4,
    'learning_tools': 4,
    'wudu': 4,
    'small_suras': 4,
  };

  static int minAgeFor(String categoryKey) => _categoryMinAge[categoryKey] ?? 5;

  static const Set<String> _vocabCategories = {
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
    'colors',
  };

  /// How many items to show at first for [categoryKey] at [level]; null means
  /// all of them. Young children hold only a few new things in mind at once,
  /// so they get a short set and can ask for more.
  static int? initialItemCount(String categoryKey, int? level) {
    if (level == null) return null;
    if (categoryKey == 'math_counting') {
      if (level <= 3) return 5;
      if (level == 4) return 10;
      return null;
    }
    if (_vocabCategories.contains(categoryKey)) {
      if (level == 2) return 6;
      if (level == 3) return 8;
    }
    return null;
  }

  /// Item ids to show first for the two youngest levels: things a child in
  /// Bangladesh meets in daily life come before zoo animals.
  static const Map<String, List<int>> _familiarFirst = {
    'animals': [7, 6, 5, 8, 18, 19], // cow, cat, dog, goat, bird, fish
  };

  static List<Map<String, dynamic>> orderItems(
    String categoryKey,
    List<Map<String, dynamic>> items,
    int? level,
  ) {
    final first = _familiarFirst[categoryKey];
    if (level == null || level > 3 || first == null) return items;
    final byId = {for (final it in items) it['id']: it};
    final head = [
      for (final id in first)
        if (byId[id] != null) byId[id]!,
    ];
    return [...head, ...items.where((it) => !first.contains(it['id']))];
  }
}
