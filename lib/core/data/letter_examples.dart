/// A familiar word, with a picture, that goes with a letter: "ক-তে কলা",
/// "A for Apple". A letter on its own is abstract; a known object gives the
/// child something to hang it on.
class LetterExample {
  final String word;

  /// Picture asset; when null, [emoji] is shown instead.
  final String? image;
  final String? emoji;

  const LetterExample.image(this.word, String this.image) : emoji = null;
  const LetterExample.emoji(this.word, String this.emoji) : image = null;
}

const String _a = 'assets/images';

/// Keyed by the item id in `bangla_vowels_data.dart`.
const Map<int, LetterExample> _vowels = {
  1: LetterExample.image('অজগর', '$_a/animals/snake.png'),
  2: LetterExample.image('আম', '$_a/fruits/mango.png'),
  3: LetterExample.image('ইলিশ', '$_a/fish/hilsa.png'),
  4: LetterExample.image('ঈগল', '$_a/birds/eagle.png'),
  5: LetterExample.emoji('উট', '🐫'),
  6: LetterExample.emoji('ঊষা', '🌅'),
  7: LetterExample.emoji('ঋষি', '🧘'),
  8: LetterExample.emoji('এক', '☝️'),
  9: LetterExample.emoji('ঐরাবত', '🐘'),
  10: LetterExample.emoji('ওজন', '⚖️'),
  11: LetterExample.emoji('ঔষধ', '💊'),
};

/// Keyed by the item id in `bangla_consonants_data.dart`. ঞ has no everyday
/// word a small child knows, so it has none.
const Map<int, LetterExample> _consonants = {
  1: LetterExample.image('কলা', '$_a/fruits/banana.png'),
  2: LetterExample.emoji('খরগোশ', '🐇'),
  3: LetterExample.image('গরু', '$_a/animals/cow.png'),
  4: LetterExample.image('ঘোড়া', '$_a/animals/horse.png'),
  5: LetterExample.emoji('ব্যাঙ', '🐸'),
  6: LetterExample.image('চোখ', '$_a/body_parts/eye.png'),
  7: LetterExample.image('ছাগল', '$_a/animals/goat.png'),
  8: LetterExample.image('জাহাজ', '$_a/vehicles/ship.png'),
  9: LetterExample.emoji('ঝুড়ি', '🧺'),
  11: LetterExample.image('টমেটো', '$_a/vegetables/tomato.png'),
  12: LetterExample.emoji('ঠোঁট', '👄'),
  13: LetterExample.image('ডালিম', '$_a/fruits/pomegranate.png'),
  14: LetterExample.emoji('ঢোল', '🥁'),
  15: LetterExample.image('হরিণ', '$_a/animals/deer.png'),
  16: LetterExample.image('তরমুজ', '$_a/fruits/watermelon.png'),
  17: LetterExample.emoji('থালা', '🍽️'),
  18: LetterExample.image('দাঁত', '$_a/body_parts/tooth.png'),
  19: LetterExample.emoji('ধান', '🌾'),
  20: LetterExample.image('নৌকা', '$_a/vehicles/boat.png'),
  21: LetterExample.image('পেঁপে', '$_a/fruits/papaya.png'),
  22: LetterExample.image('ফুলকপি', '$_a/vegetables/cauliflower.png'),
  23: LetterExample.emoji('বই', '📚'),
  24: LetterExample.image('ভাল্লুক', '$_a/animals/bear.png'),
  25: LetterExample.image('মাছ', '$_a/animals/fish.png'),
  26: LetterExample.emoji('যানবাহন', '🚌'),
  27: LetterExample.image('রকেট', '$_a/vehicles/rocket.png'),
  28: LetterExample.image('লেবু', '$_a/fruits/lemon.png'),
  29: LetterExample.image('শাপলা', '$_a/flowers/water_lily.png'),
  30: LetterExample.emoji('ষাঁড়', '🐂'),
  31: LetterExample.image('সাপ', '$_a/animals/snake.png'),
  32: LetterExample.image('হাতি', '$_a/animals/elephant.png'),
  33: LetterExample.emoji('পাহাড়', '⛰️'),
  34: LetterExample.emoji('আষাঢ়', '🌧️'),
  35: LetterExample.image('ময়ূর', '$_a/birds/peacock.png'),
  36: LetterExample.emoji('উৎসব', '🎉'),
  37: LetterExample.image('সিংহ', '$_a/animals/lion.png'),
  38: LetterExample.emoji('দুঃখ', '😢'),
  39: LetterExample.emoji('চাঁদ', '🌙'),
};

/// Keyed by the item id in `english_alphabets_data.dart` (A = 1).
const Map<int, LetterExample> _english = {
  1: LetterExample.image('Apple', '$_a/fruits/apple.png'),
  2: LetterExample.image('Banana', '$_a/fruits/banana.png'),
  3: LetterExample.image('Cat', '$_a/animals/cat.png'),
  4: LetterExample.image('Dog', '$_a/animals/dog.png'),
  5: LetterExample.image('Elephant', '$_a/animals/elephant.png'),
  6: LetterExample.image('Fish', '$_a/animals/fish.png'),
  7: LetterExample.image('Goat', '$_a/animals/goat.png'),
  8: LetterExample.image('Horse', '$_a/animals/horse.png'),
  9: LetterExample.emoji('Ice cream', '🍦'),
  10: LetterExample.image('Jackfruit', '$_a/fruits/jackfruit.png'),
  11: LetterExample.image('Kangaroo', '$_a/animals/kangaroo.png'),
  12: LetterExample.image('Lion', '$_a/animals/lion.png'),
  13: LetterExample.image('Mango', '$_a/fruits/mango.png'),
  14: LetterExample.image('Nose', '$_a/body_parts/nose.png'),
  15: LetterExample.image('Orange', '$_a/fruits/orange.png'),
  16: LetterExample.image('Parrot', '$_a/birds/parrot.png'),
  17: LetterExample.emoji('Queen', '👸'),
  18: LetterExample.image('Rocket', '$_a/vehicles/rocket.png'),
  19: LetterExample.image('Snake', '$_a/animals/snake.png'),
  20: LetterExample.image('Tiger', '$_a/animals/tiger.png'),
  21: LetterExample.emoji('Umbrella', '☂️'),
  22: LetterExample.emoji('Violin', '🎻'),
  23: LetterExample.image('Watermelon', '$_a/fruits/watermelon.png'),
  // Few words a child knows start with X, so show it at the end of one.
  24: LetterExample.image('Fox', '$_a/animals/fox.png'),
  25: LetterExample.emoji('Yo-yo', '🪀'),
  26: LetterExample.image('Zebra', '$_a/animals/zebra.png'),
};

LetterExample? letterExampleFor(String itemId, Map<String, dynamic> item) {
  final id = item['id'];
  switch (itemId) {
    case 'bangla_vowels':
      return _vowels[id];
    case 'bangla_consonants':
      return _consonants[id];
    case 'english_alphabets':
      return _english[id];
    default:
      return null;
  }
}

/// The caption under the picture, which is also what gets spoken.
/// "for"/"তে" is only used when the word really starts with the letter.
String letterExamplePhrase(
  String itemId,
  Map<String, dynamic> item,
  LetterExample example,
) {
  final letter = (item['item'] ?? '').toString();
  if (!example.word.startsWith(letter)) return example.word;
  return itemId == 'english_alphabets'
      ? '$letter for ${example.word}'
      : '$letter-তে ${example.word}';
}
