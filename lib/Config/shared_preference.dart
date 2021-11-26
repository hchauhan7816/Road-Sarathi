import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUsedApp = "HAVEUSEDAPP";

  static Future<void> saveUsedAppSharedPreference(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(sharedPreferenceUsedApp, isUserLoggedIn);
  }

  static Future<bool?> getUsedAppSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUsedApp);
  }
}
