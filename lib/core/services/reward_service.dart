import 'package:shared_preferences/shared_preferences.dart';

class RewardService {
  static const String _tokensKey = 'user_tokens';
  static const String _unlockedItemsKey = 'unlocked_items';

  static Future<int> getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_tokensKey) ?? 0;
  }

  static Future<void> addTokens(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_tokensKey) ?? 0;
    await prefs.setInt(_tokensKey, current + amount);
  }

  static Future<bool> spendTokens(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_tokensKey) ?? 0;
    if (current >= amount) {
      await prefs.setInt(_tokensKey, current - amount);
      return true;
    }
    return false;
  }

  static Future<List<String>> getUnlockedItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_unlockedItemsKey) ?? [];
  }

  static Future<void> unlockItem(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_unlockedItemsKey) ?? [];
    if (!current.contains(itemId)) {
      current.add(itemId);
      await prefs.setStringList(_unlockedItemsKey, current);
    }
  }
}
