import '../../features/shared/data/repository/shared_repository_impl.dart';
import '../../features/shared/domain/repository/shared_repository.dart';
import '../navigation/app_pages.dart';
import '../navigation/navigation_service.dart';
import '../network/api_client.dart';
import '../storage/local_data_source.dart';
import '../storage/local_data_source_impl.dart';
import 'get_it.dart';

Future<void> repositoriesInit() async {
  getItInstance.registerLazySingleton<ApiClient>(
    () => ApiClient(
      getItInstance<NavigationService>(),
      getItInstance<LocalDataSource>(),
    ),
  );
  getItInstance.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(),
  );

  getItInstance.registerLazySingleton<AppPages>(() => AppPages());
  getItInstance.registerLazySingleton<NavigationService>(
    () => NavigationService(getItInstance<AppPages>().router),
  );

  getItInstance.registerFactory<SharedRepository>(
    () => SharedRepositoryImpl(getItInstance<LocalDataSource>()),
  );
}
