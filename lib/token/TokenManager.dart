import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager extends ChangeNotifier{
  // Singleton instance
  static final TokenManager _instance = TokenManager._internal();

  String? _accessToken;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Private constructor
  TokenManager._internal();

  // Public accessor for the instance
  static TokenManager get instance => _instance;

  // Getter for the token
  String? get accessToken => _accessToken;

  // Save a new token (overwrite old one)
  Future<void> saveAccessToken(String token) async {
    _accessToken = token;
    await _secureStorage.write(key: 'accessToken', value: token);
  }

  // Load token from storage (e.g. at app start)
  Future<String?> loadAccessToken() async {
    _accessToken = await _secureStorage.read(key: 'accessToken');
    return _accessToken;
  }

  // Clear token (logout)
  Future<void> clearAccessToken() async {
    _accessToken = null;
    await _secureStorage.delete(key: 'accessToken');
  }
}
