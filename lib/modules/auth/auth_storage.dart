import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  AuthStorage._();

  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> saveLogin({
    required int userId,
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);

    await _secureStorage.write(key: _passwordKey, value: password);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<String?> getPassword() async {
    return await _secureStorage.read(key: _passwordKey);
  }

  static Future<bool> isLoggedIn() async {
    final userId = await getUserId();
    final password = await getPassword();

    return userId != null && password != null && password.isNotEmpty;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);

    await _secureStorage.delete(key: _passwordKey);
  }
}
