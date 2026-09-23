import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  AuthStorage._();

  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';

  static Future<void> saveLogin({
    required int userId,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<bool> isLoggedIn() async {
    return await getUserId() != null;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
  }
}
