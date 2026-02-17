import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


/// Wraps [FlutterSecureStorage] for auth tokens and other secrets.
class StorageService {
  StorageService._internal();

  static final StorageService instance = StorageService._internal();

  static const _storage = FlutterSecureStorage();

  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _keyRefreshToken, value: refreshToken);
    }
  }

  Future<String?> readAccessToken() async {
    debugPrint('[Storage] readAccessToken started');
    try {
      final value = await _storage.read(key: _keyAccessToken);
      debugPrint('[Storage] readAccessToken finished: ${value != null ? 'TOKEN_PRESENT' : 'NULL'}');
      return value;
    } catch (e) {
      debugPrint('[Storage] readAccessToken error: $e');
      rethrow;
    }
  }

  Future<String?> readRefreshToken() {
    return _storage.read(key: _keyRefreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
  }
}

