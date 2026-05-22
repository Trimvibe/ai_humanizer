import 'package:shared_preferences/shared_preferences.dart';

class CreditService {
  static const int dailyFreeLimit = 1000;
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String _getTodayKey() {
    final now = DateTime.now();
    return 'words_used_${now.year}_${now.month}_${now.day}';
  }

  static bool isPro() {
    return false; // Force false to hide premium feature for now
  }

  static Future<void> setProStatus(bool status) async {
    await _prefs?.setBool('is_pro_member', status);
  }

  static int getWordsUsedToday() {
    final key = _getTodayKey();
    return _prefs?.getInt(key) ?? 0;
  }

  static int getRemainingCredits() {
    if (isPro()) return 999999; // Unlimited
    final used = getWordsUsedToday();
    final remaining = dailyFreeLimit - used;
    return remaining < 0 ? 0 : remaining;
  }

  static bool hasEnoughCredits(int wordCount) {
    if (isPro()) return true;
    return getRemainingCredits() >= wordCount;
  }

  static Future<void> consumeCredits(int wordCount) async {
    if (isPro()) return;
    final key = _getTodayKey();
    final current = getWordsUsedToday();
    await _prefs?.setInt(key, current + wordCount);
  }
}
