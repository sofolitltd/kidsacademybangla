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
import './sources/bangla_weeks_data.dart';
import './sources/bangla_months_data.dart';
import './sources/english_weeks_data.dart';
import './sources/english_months_data.dart';
import './sources/birds_data.dart';
import './sources/fish_data.dart';
import './sources/flowers_data.dart';
import './sources/electronics_data.dart';
import './sources/vehicles_data.dart';
import './sources/body_parts_data.dart';
import './sources/kalima_data.dart';
import './sources/namaj_data.dart';
import './sources/wudu_data.dart';
import './sources/pillars_data.dart';
import './sources/daily_dua_data.dart';
import './sources/roja_data.dart';
import './sources/haj_data.dart';
import './sources/jakat_data.dart';
import './sources/bangla_seasons_data.dart';
import './sources/english_seasons_data.dart';
import './sources/arabic_weeks_data.dart';
import './sources/arabic_months_data.dart';
import './sources/arabic_seasons_data.dart';
import './sources/math_counting_data.dart';
import './sources/math_shapes_data.dart';
import './sources/math_addition_data.dart';
import './sources/math_time_data.dart';
import './sources/vegetables_data.dart';
import './sources/dress_data.dart';
import './sources/flags_data.dart';
import './sources/learning_tools_data.dart';
import './sources/solar_system_data.dart';

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
    ...banglaWeeksData,
    ...banglaMonthsData,
    ...englishWeeksData,
    ...englishMonthsData,
    ...birdsData,
    ...flowersData,
    ...fishData,
    ...electronicsData,
    ...vehiclesData,
    ...bodyPartsData,
    ...kalimaData,
    ...namajData,
    ...wuduData,
    ...pillarsData,
    ...duaData,
    ...rojaData,
    ...hajData,
    ...jakatData,
    ...banglaSeasonsData,
    ...englishSeasonsData,
    ...arabicWeeksData,
    ...arabicMonthsData,
    ...arabicSeasonsData,
    ...mathCountingData,
    ...mathShapesData,
    ...mathAdditionData,
    ...mathTimeData,
    ...vegetablesData,
    ...dressData,
    ...flagsData,
    ...learningToolsData,
    ...solarSystemData,
  };

  static List<Map<String, dynamic>> getItems(String categoryKey) {
    final items = _data[categoryKey] ?? [];
    if (categoryKey != 'small_suras') {
      items.sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
    }
    return items;
  }
}
