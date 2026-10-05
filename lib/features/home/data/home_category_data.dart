import 'package:flutter/material.dart';

class Category {
  final String title;
  final String imagePath;
  final Color color;
  final String categoryKey;

  /// Temporary icon shown instead of [imagePath] while a category still uses
  /// a shared placeholder image. Remove once a real image is added.
  final String? emoji;

  Category({
    required this.title,
    required this.imagePath,
    required this.color,
    required this.categoryKey,
    this.emoji,
  });
}

class CategoryGroup {
  final String groupName;
  final List<Category> items;

  CategoryGroup({required this.groupName, required this.items});
}

final List<CategoryGroup> groupedCategories = [
  CategoryGroup(
    groupName: 'বাংলা শিক্ষা',
    items: [
      Category(
        title: 'স্বরবর্ণ',
        imagePath: 'assets/images/categories/bangla_vowels.png',
        color: Colors.deepOrange,
        categoryKey: 'bangla_vowels',
      ),
      Category(
        title: 'ব্যঞ্জনবর্ণ',
        imagePath: 'assets/images/categories/bangla_consonants.png',
        color: Colors.green,
        categoryKey: 'bangla_consonants',
      ),
      Category(
        title: 'বাংলা সংখ্যা',
        imagePath: 'assets/images/categories/bangla_numbers.png',
        color: Colors.blue,
        categoryKey: 'bangla_numbers',
      ),
      // Disabled for now; re-enable in a future release.
      // Category(
      //   title: 'বাংলা ছড়া',
      //   imagePath: 'assets/images/categories/bangla_rhymes.png',
      //   color: Colors.amber,
      //   categoryKey: 'bangla_rhymes',
      // ),
      Category(
        title: 'বাংলা সপ্তাহ',
        imagePath: 'assets/images/categories/bangla_weeks.png',
        color: Colors.teal,
        categoryKey: 'bangla_weeks',
      ),
      Category(
        title: 'বাংলা মাস',
        imagePath: 'assets/images/categories/bangla_months.png',
        color: Colors.indigo,
        categoryKey: 'bangla_months',
      ),
      Category(
        title: 'বাংলা ঋতু',
        imagePath: 'assets/images/categories/bangla_seasons.png',
        color: Colors.green,
        categoryKey: 'bangla_seasons',
      ),
    ],
  ),
  CategoryGroup(
    groupName: 'English Learning',
    items: [
      Category(
        title: 'Alphabets',
        imagePath: 'assets/images/categories/english_alphabets.png',
        color: Colors.red,
        categoryKey: 'english_alphabets',
      ),
      Category(
        title: 'Numbers',
        imagePath: 'assets/images/categories/english_numbers.png',
        color: Colors.purple,
        categoryKey: 'english_numbers',
      ),
      // Disabled for now; re-enable in a future release.
      // Category(
      //   title: 'Rhymes',
      //   imagePath: 'assets/images/categories/english_rhymes.png',
      //   color: Colors.blueAccent,
      //   categoryKey: 'english_rhymes',
      // ),
      Category(
        title: 'Weeks',
        imagePath: 'assets/images/categories/english_weeks.png',
        color: Colors.deepOrange,
        categoryKey: 'english_weeks',
      ),
      Category(
        title: 'Months',
        imagePath: 'assets/images/categories/english_months.png',
        color: Colors.brown,
        categoryKey: 'english_months',
      ),
      Category(
        title: 'Seasons',
        imagePath: 'assets/images/categories/english_seasons.png',
        color: Colors.green,
        categoryKey: 'english_seasons',
      ),
    ],
  ),
  CategoryGroup(
    groupName: 'আরবি শিক্ষা',
    items: [
      Category(
        title: 'আরবি হরফ',
        imagePath: 'assets/images/categories/arabic_alphabets.png',
        color: Colors.teal,
        categoryKey: 'arabic_alphabets',
      ),
      Category(
        title: 'আরবি সংখ্যা',
        imagePath: 'assets/images/categories/arabic_numbers.png',
        color: Colors.indigo,
        categoryKey: 'arabic_numbers',
      ),
      Category(
        title: 'আরবি সপ্তাহ',
        imagePath: 'assets/images/categories/arabic_weeks.png',
        color: Colors.deepOrange,
        categoryKey: 'arabic_weeks',
      ),
      Category(
        title: 'আরবি মাস',
        imagePath: 'assets/images/categories/arabic_months.png',
        color: Colors.brown,
        categoryKey: 'arabic_months',
      ),
      Category(
        title: 'আরবি ঋতু',
        imagePath: 'assets/images/categories/arabic_seasons.png',
        color: Colors.green,
        categoryKey: 'arabic_seasons',
      ),
    ],
  ),
  CategoryGroup(
    groupName: 'সাধারণ শিক্ষা',
    items: [
      Category(
        title: 'প্রাণী',
        imagePath: 'assets/images/categories/animals.png',
        color: Colors.orange,
        categoryKey: 'animals',
      ),
      Category(
        title: 'ফল',
        imagePath: 'assets/images/categories/fruits.png',
        color: Colors.pink,
        categoryKey: 'fruits',
      ),
      Category(
        title: 'পাখি',
        imagePath: 'assets/images/categories/birds.png',
        color: Colors.lightBlue,
        categoryKey: 'birds',
      ),
      Category(
        title: 'মাছ',
        imagePath: 'assets/images/categories/fish.png',
        color: Colors.lightBlue,
        categoryKey: 'fish',
      ),
      Category(
        title: 'ফুল',
        imagePath: 'assets/images/categories/flowers.png',
        color: Colors.pinkAccent,
        categoryKey: 'flowers',
      ),
      Category(
        title: 'ইলেকট্রনিক্স',
        imagePath: 'assets/images/categories/electronics.png',
        color: Colors.blueGrey,
        categoryKey: 'electronics',
      ),
      Category(
        title: 'যানবাহন',
        imagePath: 'assets/images/categories/vehicles.png',
        color: Colors.amber,
        categoryKey: 'vehicles',
      ),
      Category(
        title: 'শরীরের অংশ',
        imagePath: 'assets/images/categories/body_parts.png',
        color: Colors.redAccent,
        categoryKey: 'body_parts',
      ),
      Category(
        title: 'সবজি',
        imagePath: 'assets/images/categories/vegetables.png',
        color: Colors.lightGreen,
        categoryKey: 'vegetables',
      ),
      Category(
        title: 'পোশাক',
        imagePath: 'assets/images/categories/dress.png',
        color: Colors.purpleAccent,
        categoryKey: 'dress',
      ),
      Category(
        title: 'রঙ',
        imagePath: 'assets/images/categories/colors.png',
        color: Colors.cyan,
        categoryKey: 'colors',
      ),
      Category(
        title: 'পতাকা',
        imagePath: 'assets/images/categories/flags.png',
        color: Colors.blueAccent,
        categoryKey: 'flags',
      ),
      Category(
        title: 'শিক্ষার উপকরণ',
        imagePath: 'assets/images/categories/learning_tools.png',
        color: Colors.teal,
        categoryKey: 'learning_tools',
      ),
      Category(
        title: 'সৌরজগৎ',
        imagePath: 'assets/images/categories/solar_system.png',
        color: Colors.deepPurple,
        categoryKey: 'solar_system',
      ),
    ],
  ),
  CategoryGroup(
    groupName: 'গণিত শিক্ষা',
    items: [
      Category(
        title: 'গণনা',
        imagePath: 'assets/images/categories/math_counting.png',
        color: Colors.blue,
        categoryKey: 'math_counting',
      ),
      Category(
        title: 'আকৃতি',
        imagePath: 'assets/images/categories/math_shapes.png',
        color: Colors.orange,
        categoryKey: 'math_shapes',
      ),
      Category(
        title: 'যোগ',
        imagePath: 'assets/images/categories/math_addition.png',
        color: Colors.green,
        categoryKey: 'math_addition',
        emoji: '➕',
      ),
      Category(
        title: 'সময়',
        imagePath: 'assets/images/categories/math_time.png',
        color: Colors.indigo,
        categoryKey: 'math_time',
        emoji: '⏰',
      ),
    ],
  ),
  CategoryGroup(
    groupName: 'ইসলামিক',
    items: [
      Category(
        title: 'ইসলামের ৫ স্তম্ভ',
        imagePath: 'assets/images/categories/pillars.png',
        color: const Color(0xFF6A1B9A),
        categoryKey: 'pillars',
        emoji: '🕋',
      ),
      Category(
        title: '৬ কালিমা',
        imagePath: 'assets/images/categories/kalima.png',
        color: const Color(0xFFC62828),
        categoryKey: 'kalima',
        emoji: '☝️',
      ),
      Category(
        title: 'দৈনিক নামাজ',
        imagePath: 'assets/images/categories/namaj.png',
        color: const Color(0xFF1565C0),
        categoryKey: 'namaj',
        emoji: '🕌',
      ),
      Category(
        title: 'রোজা',
        imagePath: 'assets/images/categories/namaj.png',
        color: const Color(0xFFC2185B),
        categoryKey: 'roja',
        emoji: '🌙',
      ),
      Category(
        title: 'হজ',
        imagePath: 'assets/images/categories/namaj.png',
        color: const Color(0xFF6D4C41),
        categoryKey: 'haj',
        emoji: '🐪',
      ),
      Category(
        title: 'যাকাত',
        imagePath: 'assets/images/categories/namaj.png',
        color: const Color(0xFFAD6A00),
        categoryKey: 'jakat',
        emoji: '🤲',
      ),
      Category(
        title: 'ওযু',
        imagePath: 'assets/images/categories/wudu.png',
        color: const Color(0xFF00838F),
        categoryKey: 'wudu',
        emoji: '💧',
      ),
      Category(
        title: 'দৈনিক দোয়া',
        imagePath: 'assets/images/categories/daily_dua.png',
        color: const Color(0xFFE65100),
        categoryKey: 'daily_dua',
        emoji: '📿',
      ),
      Category(
        title: 'ছোট সূরা',
        imagePath: 'assets/images/categories/small_suras.png',
        color: const Color(0xFF2E8B6E),
        categoryKey: 'small_suras',
      ),
      Category(
        title: 'আল্লাহর ৯৯ নাম',
        imagePath: 'assets/images/categories/allah_names.png',
        color: const Color(0xFF283593),
        categoryKey: 'allah_names',
        emoji: '☪️',
      ),
    ],
  ),
];
