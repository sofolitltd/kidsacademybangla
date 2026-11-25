import 'package:flutter_test/flutter_test.dart';
import 'package:kidsacademybangla/core/data/app_data.dart';
import 'package:kidsacademybangla/core/services/age_service.dart';
import 'package:kidsacademybangla/core/services/profile_service.dart';
import 'package:kidsacademybangla/features/details/find_game_screen.dart';
import 'package:kidsacademybangla/features/home/data/home_category_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _dobYearsAgo(int years) {
  final now = DateTime.now();
  return '1/1/${now.year - years}';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AgeService.level.value = null;
  });

  test('age maps onto the four levels', () {
    expect(AgeService.levelForAge(1), 2);
    expect(AgeService.levelForAge(2), 2);
    expect(AgeService.levelForAge(4), 4);
    expect(AgeService.levelForAge(9), 5);
  });

  test('no profile and no choice leaves the level unknown', () async {
    await AgeService.load();
    expect(AgeService.level.value, isNull);
  });

  test('level follows the profile birth date', () async {
    await ProfileService.saveProfile(
      ChildProfile(
        id: 'a',
        childName: 'রাফি',
        fatherName: '',
        motherName: '',
        dob: _dobYearsAgo(3),
      ),
    );
    await AgeService.load();
    expect(AgeService.level.value, 3);
  });

  test('a hand-picked level wins over the profile and persists', () async {
    await ProfileService.saveProfile(
      ChildProfile(
        id: 'a',
        childName: 'রাফি',
        fatherName: '',
        motherName: '',
        dob: _dobYearsAgo(3),
      ),
    );
    await AgeService.setLevel(5);
    AgeService.level.value = null;
    await AgeService.load();
    expect(AgeService.level.value, 5);
  });

  test('every category has a level, and each level adds categories', () {
    final all = [for (final g in groupedCategories) ...g.items];
    int visibleAt(int level) => all.where((c) => c.minAge <= level).length;
    expect(all.every((c) => c.minAge >= 2 && c.minAge <= 5), isTrue);
    expect(visibleAt(2), 6);
    expect(visibleAt(2) < visibleAt(3), isTrue);
    expect(visibleAt(3) < visibleAt(4), isTrue);
    expect(visibleAt(4) < visibleAt(5), isTrue);
    expect(visibleAt(5), all.length);
    // Abstract content stays out of the youngest levels.
    expect(AgeService.minAgeFor('math_addition'), 5);
    expect(AgeService.minAgeFor('jakat'), 5);
  });

  test('young levels get a short first set', () {
    expect(AgeService.initialItemCount('animals', 2), 6);
    expect(AgeService.initialItemCount('animals', 3), 8);
    expect(AgeService.initialItemCount('animals', 4), isNull);
    expect(AgeService.initialItemCount('math_counting', 3), 5);
    expect(AgeService.initialItemCount('math_counting', 4), 10);
    expect(AgeService.initialItemCount('bangla_consonants', 2), isNull);
    expect(AgeService.initialItemCount('animals', null), isNull);
  });

  test('familiar animals come first for the youngest, same items overall', () {
    AgeService.level.value = 2;
    final young = AppData.getItemsForLevel('animals');
    expect(young.take(4).map((e) => e['item']), ['Cow', 'Cat', 'Dog', 'Goat']);

    AgeService.level.value = 5;
    final old = AppData.getItemsForLevel('animals');
    expect(old.first['item'], 'Lion');
    expect(young.length, old.length);
    expect(young.map((e) => e['id']).toSet(), old.map((e) => e['id']).toSet());
  });

  test('game categories all have enough items and something to show', () {
    for (final g in groupedCategories) {
      for (final c in g.items) {
        if (!FindGameScreen.supports(c.categoryKey)) continue;
        final items = AppData.getItems(c.categoryKey);
        expect(items.length >= 4, isTrue, reason: c.categoryKey);
        for (final it in items) {
          final shown = it['image'] ?? it['hex'] ?? it['item'];
          expect(shown, isNotNull, reason: '${c.categoryKey} ${it['id']}');
        }
      }
    }
  });
}
