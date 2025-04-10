import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService extends GetxService {
  late SharedPreferences _prefs;

  Future<SharedPreferencesService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // ===== خيارات الثيم =====
  String? getThemeString() {
    return _prefs.getString('theme');
  }

  Future<void> setThemeString(String theme) async {
    await _prefs.setString('theme', theme);
  }

  // ===== خيارات اللغة =====
  String getLanguage() {
    return _prefs.getString('language') ?? 'ar';
  }

  Future<void> setLanguage(String language) async {
    await _prefs.setString('language', language);
  }

  // التوافق مع الأسماء القديمة
  Future<void> saveLanguage(String language) async {
    await setLanguage(language);
  }

  // ===== طرق عامة للتخزين =====
  String getString(String key, {String defaultVal = ''}) {
    return _prefs.getString(key) ?? defaultVal;
  }

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  bool getBool(String key, {bool defaultVal = false}) {
    return _prefs.getBool(key) ?? defaultVal;
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  int getInt(String key, {int defaultVal = 0}) {
    return _prefs.getInt(key) ?? defaultVal;
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  double getDouble(String key, {double defaultVal = 0.0}) {
    return _prefs.getDouble(key) ?? defaultVal;
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}
