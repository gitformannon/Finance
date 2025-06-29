import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/local_storage_keys.dart';
import 'secure_storage_service.dart';

class HiveService {
  static Future<HiveService> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    final Uint8List encryptionKey = await SecureStorageService.getEncryptionKey();
    await Hive.openBox(
      LocalStorageKeys.box,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    return HiveService();
  }
}
