import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._privateConstructor();
  static final SecureStorage instance =
      SecureStorage._privateConstructor(); //This creates one instance of SecureStorage for the entire app lifecycle.

  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();

  // Keys
  static const _tokenKey = 'token';

  // Save tokens
  Future<void> saveTokens({
    required String accessToken,
  }) async {
    await _storage.write(key: _tokenKey, value: accessToken);
  }

  // Get access token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }


  // Clear tokens (logout)
  Future<void> clearTokens() async {
    await _storage.delete(key: _tokenKey);
  }
}
