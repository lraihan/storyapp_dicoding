import 'package:get_storage/get_storage.dart';
import '../models/user.dart';

class PreferencesService {
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _languageKey = 'language';
  final GetStorage _storage = GetStorage();
  Future<void> saveUser(User user) async {
    await _storage.write(_userKey, user.toJson());
    await _storage.write(_tokenKey, user.token);
    await _storage.write(_isLoggedInKey, true);
  }

  User? getUser() {
    final userData = _storage.read(_userKey);
    if (userData != null) {
      return User.fromJson(Map<String, dynamic>.from(userData));
    }
    return null;
  }

  String? getToken() {
    return _storage.read(_tokenKey);
  }

  bool isLoggedIn() {
    return _storage.read(_isLoggedInKey) ?? false;
  }

  Future<void> logout() async {
    await _storage.remove(_userKey);
    await _storage.remove(_tokenKey);
    await _storage.write(_isLoggedInKey, false);
  }

  Future<void> setLanguage(String languageCode) async {
    await _storage.write(_languageKey, languageCode);
  }

  String getLanguage() {
    return _storage.read(_languageKey) ?? 'en';
  }
}
