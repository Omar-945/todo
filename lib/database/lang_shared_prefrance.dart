import 'package:shared_preferences/shared_preferences.dart';

class LangSharedPreference {
  Future<void> setLang(bool lang) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isEnglish', lang);
  }
}
