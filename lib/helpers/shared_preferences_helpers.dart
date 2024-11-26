import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
    static const String _isLoggedInKey = 'isLoggedIn';
  static const String _ssOrgId = "ssOrgId";
  static const String _ssUserName = "ssUserName";
  static const String _ssRole = "ssRole";
  static const String _ssRegion = "ssRegion";
  static const String _ssInstance = "ssInstance";



static Future<void> setIsLoggedIn(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  // Get a boolean value (e.g., login status)
  static Future<bool> getIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;  // Default to false if not set
  }
  // Save a string value (e.g., username)
  static Future<void> setUsername(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ssUserName, username);
  }

  // Get a string value (e.g., username)
  static Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ssUserName);
  }

  // Save a string value (e.g., email)
  static Future<void> setOrgId(String orgId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ssOrgId, orgId);
  }

  // Save a string value (e.g., email)
  static Future<void> setRegion(String region) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ssRegion, region);
  }
   // Get a string value (e.g., email)
  static Future<String?> getRegion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ssRegion);
  }

 // Save a string value (e.g., email)
  static Future<void> setInstance(String instance) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ssInstance, instance);
  }
   // Get a string value (e.g., email)
  static Future<String?> getInstance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ssInstance);
  }

  // Get a string value (e.g., email)
  static Future<String?> getOrgId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ssOrgId);
  }

  

  static Future<void> setRole(String ssRole) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ssRole, ssRole);
  } 
  static Future<String?> getRole() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ssRole);
  }


  // Clear all shared preferences
  static Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
      // AppConstants.jwtToken = "";
  }
}
