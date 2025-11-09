import 'package:shared_preferences/shared_preferences.dart';

/// Guarda/lee tokens de forma cross-platform (incluye Flutter Web).
class TokenStorage {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';

  static Future<void> saveAccessToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kAccess, token);
  }

  static Future<void> saveRefreshToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kRefresh, token);
  }

  static Future<String?> getAccessToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kAccess);
  }

  static Future<String?> getRefreshToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kRefresh);
  }

  static Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kAccess);
    await sp.remove(_kRefresh);
  }
}