import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  static const String userId = '_id';

  static const String role = 'role';

  static const String token = 'token';
  static const String firstname = 'firstName';
  static const String lastname = 'lastName';

  static const String _themeModeKey = 'themeMode';
  static const String _isDarkModeKey = 'isDarkMode';

  static final SharedPreferenceManager _instance =
      SharedPreferenceManager._internal();

  factory SharedPreferenceManager() {
    return _instance;
  }

  SharedPreferenceManager._internal();

  Future<dynamic> clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> setUserId(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userId, tokens);
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userId) ?? "";
  }

  Future<bool> setToken(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(token, tokens);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(token) ?? "";
  }

  Future<String> getrole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(role) ?? "";
  }

  Future<bool> setrole(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(role, tokens);
  }

  Future<String> getfirstname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(firstname) ?? "";
  }

  Future<bool> setfirstname(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(firstname, tokens);
  }

  Future<String> getlastname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastname) ?? "";
  }

  Future<bool> setlastname(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(lastname, tokens);
  }

  Future<void> setThemeMode(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeModeKey, isDarkMode);
    await prefs.setBool(_isDarkModeKey, isDarkMode);
  }

  Future<bool?> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey);
  }
}
