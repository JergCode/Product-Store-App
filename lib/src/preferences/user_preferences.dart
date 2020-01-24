import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = new UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // Token GET y SET
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }
}
