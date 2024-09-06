import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPreferences {
  Future<void> setFirstLaunchCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstLaunch', false);
  }

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstLaunch') ?? true;  // Default to true if not set
  }
}
