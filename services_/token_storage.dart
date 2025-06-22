// lib/services/token_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final _storage = const FlutterSecureStorage();
  static const _kRefresh = 'refresh_token';

  static Future<void> saveRefresh(String value) =>
      _storage.write(key: _kRefresh, value: value);

  static Future<String?> readRefresh() =>
      _storage.read(key: _kRefresh);

  static Future<void> clear() =>
      _storage.delete(key: _kRefresh);
}