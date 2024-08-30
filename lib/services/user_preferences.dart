import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _onboardingCompleteKey = 'onboardingComplete';

  static Future<void> setOnboardingComplete(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, value);
  }

  static Future<bool> getOnboardingComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }
}
