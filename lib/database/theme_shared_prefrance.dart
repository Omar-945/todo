import 'package:shared_preferences/shared_preferences.dart';

class ThemeSharedPreference {
  Future<void> setTheme(bool theme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isDark', theme);
  }
}
