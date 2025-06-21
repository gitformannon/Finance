import 'package:Finance/core/navigation/navigation_service.dart';
import 'package:Finance/features/main/cubits/main/main_cubit.dart';
import 'package:Finance/features/shared/domain/repository/shared_repository.dart';
import 'package:Finance/features/shared/presentation/cubits/navigate/navigate_cubit.dart';
import '../../features/auth/presentation/cubit/splash/splash_cubit.dart';
import 'get_it.dart';

Future<void> cubitsInit() async {
  getItInstance.registerFactory<SplashCubit>(
    () => SplashCubit(getItInstance<SharedRepository>()),
  );
  getItInstance.registerFactory<NavigateCubit>(
    () => NavigateCubit(getItInstance<NavigationService>()),
  );
  getItInstance.registerFactory<MainCubit>(
        () => MainCubit(),
  );
}
