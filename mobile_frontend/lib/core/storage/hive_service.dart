import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/local_storage_keys.dart';

class HiveService {
  static Future<HiveService> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.openBox(LocalStorageKeys.box);
    return HiveService();
  }
}
