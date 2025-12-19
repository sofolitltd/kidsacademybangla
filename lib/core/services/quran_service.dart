import 'dart:convert';

import 'package:http/http.dart' as http;

class QuranService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';

  static Future<Map<String, dynamic>> getSurahDetails(int surahNumber) async {
    try {
      // Fetching Arabic (simple) and Bengali translation in one call
      final response = await http.get(
        Uri.parse(
          '$baseUrl/surah/$surahNumber/editions/quran-simple,bn.bengali',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Data from alquran.cloud is a list of editions.
        // Index 0: Arabic, Index 1: Bengali
        final arabicAyahs = data['data'][0]['ayahs'] as List;
        final bengaliAyahs = data['data'][1]['ayahs'] as List;

        List<String> arabicLines = [];
        List<String> bengaliLines = [];

        for (int i = 0; i < arabicAyahs.length; i++) {
          arabicLines.add(arabicAyahs[i]['text']);
          // CORRECTED: Access the Bengali translation array at index i
          bengaliLines.add(bengaliAyahs[i]['text']);
        }

        // Surah audio URL from CDN
        final String audioUrl =
            'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/$surahNumber.mp3';

        return {
          'text': arabicLines.join('\n'),
          'trans': bengaliLines.join('\n'),
          'audioUrl': audioUrl,
        };
      }
      throw Exception('Failed to load Surah: Status ${response.statusCode}');
    } catch (e) {
      print('QuranService Error: $e');
      rethrow;
    }
  }
}
