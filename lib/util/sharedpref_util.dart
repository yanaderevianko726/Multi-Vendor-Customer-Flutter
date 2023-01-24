import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedPrefUtil._();

  static final SharedPrefUtil _instance = SharedPrefUtil._();

  factory SharedPrefUtil() => _instance;

  Future<void> init() async {
    if (_prefs == null) {
      _prefs = SharedPreferences.getInstance();
    }
  }

  Future<void> setAppInForeground(bool flag) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('app_in_foreground', flag);
  }

  Future<bool> getAppInForeground() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('app_in_foreground') ?? false;
  }
}
