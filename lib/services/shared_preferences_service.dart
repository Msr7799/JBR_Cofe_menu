import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService extends GetxService {
  late SharedPreferences _prefs;

  Future<SharedPreferencesService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // General methods
  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String getString(String key, {String defaultValue = ''}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  Future<bool> saveDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  Future<bool> removeKey(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  // App-specific methods
  Future<bool> saveThemeMode(String mode) async {
    return await saveString('theme_mode', mode);
  }

  String getThemeMode() {
    return getString('theme_mode', defaultValue: 'system');
  }

  Future<bool> saveLanguage(String languageCode) async {
    return await saveString('language', languageCode);
  }

  String getLanguage() {
    return getString('language', defaultValue: 'ar');
  }

  Future<bool> saveIsLoggedIn(bool value) async {
    return await saveBool('is_logged_in', value);
  }

  bool getIsLoggedIn() {
    return getBool('is_logged_in', defaultValue: false);
  }

  Future<bool> saveUserId(String userId) async {
    return await saveString('user_id', userId);
  }

  String getUserId() {
    return getString('user_id');
  }
}
