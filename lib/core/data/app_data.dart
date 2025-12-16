import './sources/animals_data.dart';
import './sources/arabic_alphabets_data.dart';
import './sources/arabic_numbers_data.dart';
import './sources/bangla_consonants_data.dart';
import './sources/bangla_numbers_data.dart';
import './sources/bangla_rhymes_data.dart';
import './sources/bangla_vowels_data.dart';
import './sources/colors_data.dart';
import './sources/english_alphabets_data.dart';
import './sources/english_numbers_data.dart';
import './sources/english_rhymes_data.dart';
import './sources/fruits_data.dart';
import './sources/allah_names_data.dart'; // New import

class AppData {
  // Combine all data sources into one map
  static final Map<String, List<Map<String, dynamic>>> _data = {
    ...banglaVowelsData,
    ...banglaConsonantsData,
    ...banglaNumbersData,
    ...englishAlphabetsData,
    ...englishNumbersData,
    ...arabicAlphabetsData,
    ...arabicNumbersData,
    ...animalsData,
    ...fruitsData,
    ...colorsData,
    ...banglaRhymesData,
    ...englishRhymesData,
    ...allahNamesData, // New data added
  };

  static List<Map<String, dynamic>> getItems(String categoryKey) {
    final items = _data[categoryKey] ?? [];
    // Ensure the list is sorted by ID, just in case the individual files are not.
    items.sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
    return items;
  }
}
