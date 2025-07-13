import 'package:Finance/core/navigation/navigation_service.dart';
import 'package:Finance/features/main/cubits/main/main_cubit.dart';
import 'package:Finance/features/shared/domain/repository/shared_repository.dart';
import 'package:Finance/features/shared/presentation/cubits/navigate/navigate_cubit.dart';
import '../../features/auth/presentation/cubit/splash/splash_cubit.dart';
import '../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../features/auth/domain/usecase/login_user.dart';
import '../../features/profile/domain/usecase/get_profile.dart';
import '../../features/profile/domain/usecase/logout_user.dart';
import '../../features/profile/domain/usecase/update_profile.dart';
import '../../features/profile/domain/usecase/upload_profile_image.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import 'get_it.dart';

Future<void> cubitsInit() async {
  getItInstance.registerFactory<SplashCubit>(
    () => SplashCubit(getItInstance<SharedRepository>()),
  );
  getItInstance.registerFactory<LoginCubit>(
    () => LoginCubit(getItInstance<LoginUser>()),
  );
  getItInstance.registerFactory<NavigateCubit>(
    () => NavigateCubit(getItInstance<NavigationService>()),
  );
  getItInstance.registerFactory<MainCubit>(
        () => MainCubit(),
  );
  getItInstance.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getItInstance<GetProfile>(),
      getItInstance<LogoutUser>(),
      getItInstance<UpdateProfile>(),
      getItInstance<UploadProfileImage>(),
      getItInstance<NavigateCubit>(),
    ),
  );
}
