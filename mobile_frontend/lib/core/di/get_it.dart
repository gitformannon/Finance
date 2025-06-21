import 'package:agro_card_delivery/core/di/repositories_init.dart';
import 'package:get_it/get_it.dart';
import 'cubits_init.dart';

final getItInstance = GetIt.I;

init() async {
  await repositoriesInit();
  await cubitsInit();
}
