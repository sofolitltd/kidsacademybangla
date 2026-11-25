import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kidsacademybangla/core/data/app_data.dart';
import 'package:kidsacademybangla/core/data/letter_examples.dart';

/// ড় ঢ় য় can be stored as one code point or as letter + dot; compare as one.
String _norm(String s) =>
    s.replaceAll('ড়', 'ড়').replaceAll('ঢ়', 'ঢ়').replaceAll('য়', 'য়');

void main() {
  for (final key in [
    'bangla_vowels',
    'bangla_consonants',
    'english_alphabets',
  ]) {
    test('$key: each example contains its letter and its picture exists', () {
      final missing = <String>[];
      for (final item in AppData.getItems(key)) {
        final letter = item['item'] as String;
        final example = letterExampleFor(key, item);
        if (example == null) {
          missing.add(letter);
          continue;
        }
        expect(
          _norm(example.word.toLowerCase()),
          contains(_norm(letter.toLowerCase())),
          reason: '$letter → ${example.word}',
        );
        final image = example.image;
        if (image != null) {
          expect(File(image).existsSync(), isTrue, reason: image);
        }
      }
      expect(missing, key == 'bangla_consonants' ? ['ঞ'] : isEmpty);
    });
  }

  test('"তে" and "for" are used only when the word starts with the letter', () {
    String phrase(String key, int id) {
      final item = AppData.getItems(key).firstWhere((i) => i['id'] == id);
      return letterExamplePhrase(key, item, letterExampleFor(key, item)!);
    }

    expect(phrase('bangla_consonants', 1), 'ক-তে কলা');
    expect(phrase('bangla_consonants', 5), 'ব্যাঙ');
    expect(phrase('english_alphabets', 1), 'A for Apple');
    expect(phrase('english_alphabets', 24), 'Fox');
  });
}
