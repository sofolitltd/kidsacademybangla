/// All hard-coded endpoints live here so they can be changed in one place.
class AppUrls {
  AppUrls._();

  // Quran API (text + Bengali translation).
  static const String quranApiBase = 'https://api.alquran.cloud/v1';
  static const String quranEditions = 'quran-simple,bn.bengali';

  // Surah audio CDN.
  static const String quranAudioBase =
      'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy';

  static String surahApi(int surahNumber) =>
      '$quranApiBase/surah/$surahNumber/editions/$quranEditions';

  static String surahAudio(Object? surahNumber) =>
      '$quranAudioBase/$surahNumber.mp3';

  // Store / contact links.
  static String playStoreWeb(String package) =>
      'https://play.google.com/store/apps/details?id=$package';

  static String playStoreMarket(String package) =>
      'market://details?id=$package';

  static String whatsApp(String number) => 'https://wa.me/$number';
}
