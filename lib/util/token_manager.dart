import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static final String _token = 'user_token';

  // lưu token vào Shared Preferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_token, token);
  }

  
  // Đọc token đã lưu
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_token);
  }

  // Xoá token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_token);
  }
}
