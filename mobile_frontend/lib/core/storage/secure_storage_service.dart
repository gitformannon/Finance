import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import '../constants/local_storage_keys.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<Uint8List> getEncryptionKey() async {
    String? encodedKey =
        await _storage.read(key: LocalStorageKeys.encryptionKey);
    if (encodedKey == null) {
      final Uint8List key = Uint8List.fromList(Hive.generateSecureKey());
      encodedKey = base64UrlEncode(key);
      await _storage.write(key: LocalStorageKeys.encryptionKey, value: encodedKey);
      return key;
    }
    return Uint8List.fromList(base64Url.decode(encodedKey));
  }
}
