import './sources/allah_names_data.dart';
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
import './sources/small_suras_data.dart';

class AppData {
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
    ...allahNamesData,
    ...smallSurasData,
  };

  static List<Map<String, dynamic>> getItems(String categoryKey) {
    final items = _data[categoryKey] ?? [];
    if (categoryKey != 'small_suras') {
      items.sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
    }
    return items;
  }
}
