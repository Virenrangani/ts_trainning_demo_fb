import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static const String _themeKey = "isDarkMode";
  static const String _userKey = "userData";


  static Future<void> saveTheme(bool isDark)async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey,isDark);
  }

  static Future<bool> getTheme()async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  static Future<void> saveUser({
    required String name,
    required String email,
    required String password,
})async{
    final prefs=await SharedPreferences.getInstance();
    Map<String,dynamic> userMap={
      "name":name,
      "email":email,
      "password":password
    };

    final userJson=jsonEncode(userMap);
    await prefs.setString(_userKey, userJson);
  }

  static Future<Map<String,dynamic>?> getUser()async{
    final prefs=await SharedPreferences.getInstance();
    String? userJson=prefs.getString(_userKey);
    if (userJson ==null) return null;
    return jsonDecode(userJson);
  }

  static Future<void> clearUser()async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

}