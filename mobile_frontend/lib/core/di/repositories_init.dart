import '../../features/shared/data/repository/shared_repository_impl.dart';
import '../../features/shared/domain/repository/shared_repository.dart';
import '../../features/auth/data/repository/login_repository_impl.dart';
import '../../features/auth/domain/data_source/login_data_source.dart';
import '../../features/auth/domain/repository/login_repository.dart';
import '../../features/auth/domain/usecase/login_user.dart';
import '../../features/auth/domain/usecase/refresh_token.dart';
import '../../features/profile/data/repository/profile_repository_impl.dart';
import '../../features/profile/domain/repository/profile_repository.dart';
import '../../features/profile/domain/usecase/get_profile.dart';
import '../../features/profile/domain/usecase/logout_user.dart';
import '../../features/profile/domain/usecase/update_profile.dart';
import '../../features/profile/domain/usecase/upload_profile_image.dart';
import '../../features/profile/domain/usecase/totp/get_totp_status.dart';
import '../../features/profile/domain/usecase/totp/enable_totp.dart';
import '../../features/profile/domain/usecase/totp/confirm_totp.dart';
import '../../features/profile/domain/usecase/totp/disable_totp.dart';
import '../../features/profile/domain/repository/totp_repository.dart';
import '../../features/profile/data/repository/totp_repository_impl.dart';
import '../../features/budget/domain/repository/budget_repository.dart';
import '../../features/budget/data/repository/budget_repository_impl.dart';
import '../../features/budget/domain/usecase/get_transactions_by_date.dart';
import '../../features/budget/domain/usecase/add_transaction.dart';
import '../../features/budget/domain/usecase/get_categories.dart';
import '../../features/budget/domain/usecase/add_account.dart';
import '../../features/budget/domain/usecase/add_category.dart';
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

  getItInstance.registerLazySingleton<LoginDataSource>(
    () => LoginDataSourceImpl(),
  );

  getItInstance.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      getItInstance<LocalDataSource>(),
      getItInstance<LoginDataSource>(),
    ),
  );

  getItInstance.registerLazySingleton<LoginUser>(
    () => LoginUser(getItInstance<LoginRepository>()),
  );

  getItInstance.registerLazySingleton<RefreshToken>(
    () => RefreshToken(getItInstance<LoginRepository>()),
  );

  getItInstance.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      getItInstance<ApiClient>(),
      getItInstance<LocalDataSource>(),
    ),
  );

  getItInstance.registerLazySingleton<GetProfile>(
    () => GetProfile(getItInstance<ProfileRepository>()),
  );

  getItInstance.registerLazySingleton<LogoutUser>(
    () => LogoutUser(getItInstance<ProfileRepository>()),
  );

  getItInstance.registerLazySingleton<UpdateProfile>(
    () => UpdateProfile(getItInstance<ProfileRepository>()),
  );

  getItInstance.registerLazySingleton<UploadProfileImage>(
    () => UploadProfileImage(getItInstance<ProfileRepository>()),
  );

  getItInstance.registerLazySingleton<TotpRepository>(
    () => TotpRepositoryImpl(getItInstance<ApiClient>()),
  );

  getItInstance.registerLazySingleton<GetTotpStatus>(
    () => GetTotpStatus(getItInstance<TotpRepository>()),
  );

  getItInstance.registerLazySingleton<EnableTotp>(
    () => EnableTotp(getItInstance<TotpRepository>()),
  );

  getItInstance.registerLazySingleton<ConfirmTotp>(
    () => ConfirmTotp(getItInstance<TotpRepository>()),
  );

  getItInstance.registerLazySingleton<DisableTotp>(
    () => DisableTotp(getItInstance<TotpRepository>()),
  );

  getItInstance.registerLazySingleton<BudgetRepository>(
    () => BudgetRepositoryImpl(getItInstance<ApiClient>()),
  );

  getItInstance.registerLazySingleton<GetTransactionsByDate>(
    () => GetTransactionsByDate(getItInstance<BudgetRepository>()),
  );

  getItInstance.registerLazySingleton<AddTransaction>(
    () => AddTransaction(getItInstance<BudgetRepository>()),
  );
  getItInstance.registerLazySingleton<AddAccount>(
    () => AddAccount(getItInstance<BudgetRepository>()),
  );
  getItInstance.registerLazySingleton<AddCategory>(
    () => AddCategory(getItInstance<BudgetRepository>()),
  );
  getItInstance.registerLazySingleton<GetCategories>(
    () => GetCategories(getItInstance<BudgetRepository>()),
  );
}
