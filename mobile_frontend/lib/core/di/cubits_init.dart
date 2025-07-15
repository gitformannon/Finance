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
import '../../features/profile/presentation/cubit/totp_cubit.dart';
import '../../features/profile/domain/usecase/totp/get_totp_status.dart';
import '../../features/profile/domain/usecase/totp/enable_totp.dart';
import '../../features/profile/domain/usecase/totp/confirm_totp.dart';
import '../../features/profile/domain/usecase/totp/disable_totp.dart';
import 'get_it.dart';
import '../../features/budget/presentation/cubit/budget_cubit.dart';
import '../../features/budget/domain/usecase/get_transactions_by_date.dart';

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

  getItInstance.registerFactory<TotpCubit>(
    () => TotpCubit(
      getItInstance<GetTotpStatus>(),
      getItInstance<EnableTotp>(),
      getItInstance<ConfirmTotp>(),
      getItInstance<DisableTotp>(),
    ),
  );

  getItInstance.registerFactory<BudgetCubit>(
    () => BudgetCubit(
      getItInstance<GetTransactionsByDate>(),
    ),
  );
}
