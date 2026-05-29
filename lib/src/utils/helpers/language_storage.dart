import 'package:shared_preferences/shared_preferences.dart';

class LanguageStorage {
  static const String _key = "current_locale";
  static const String _isLoggedInKey = "current_login_state";

  static Future<void> saveLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale);
  }

  static Future<void> saveLoginCurrentState(String loginState) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_isLoggedInKey, loginState);
  }

  static Future<String?> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  static Future<String?> getLoggedInState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_isLoggedInKey);
  }
}
