import 'package:agro_card_delivery/core/navigation/navigation_service.dart';
import 'package:agro_card_delivery/features/main/cubits/main/main_cubit.dart';
import 'package:agro_card_delivery/features/shared/domain/repository/shared_repository.dart';
import 'package:agro_card_delivery/features/shared/presentation/cubits/navigate/navigate_cubit.dart';
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
