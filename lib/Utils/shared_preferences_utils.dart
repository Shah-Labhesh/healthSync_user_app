import 'package:shared_preferences/shared_preferences.dart';

class SharedUtils{
  static Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    return isFirstTime;
  }

  static Future<void> setFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
  }


  // store token in shared preferences
  static Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // get token from shared preferences
  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";
    return token;
  }

  // store user role in shared preferences
  static Future<void> setRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }

  // get user role from shared preferences
  static Future<String> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String role = prefs.getString('role') ?? "";
    return role;
  }


  // authType
  static Future<void> setAuthType(String authType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authType', authType);
  }

  // get authType from shared preferences
  static Future<String> getAuthType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authType = prefs.getString('authType') ?? "";
    return authType;
  }

  // get amout hide from shared preferences
  static Future<bool> getAmountHide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool amountHide = prefs.getBool('amountHide') ?? false;
    return amountHide;
  }

  // store amount hide in shared preferences
  static Future<void> setAmountHide(bool amountHide) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('amountHide', amountHide);
  }
  
}