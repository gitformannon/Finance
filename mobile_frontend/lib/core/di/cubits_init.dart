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
import '../../features/budget/presentation/cubit/transaction_cubit.dart';
import '../../features/budget/domain/usecase/add_transaction.dart';
import '../../features/budget/domain/usecase/get_categories.dart';
import '../../features/budget/domain/usecase/add_account.dart';
import '../../features/budget/domain/usecase/get_accounts.dart';
import '../../features/budget/domain/usecase/add_category.dart';
import '../../features/budget/presentation/cubit/account_cubit.dart';
import '../../features/budget/presentation/cubit/category_cubit.dart';
import '../../features/budget/presentation/cubit/accounts_list_cubit.dart';
import '../../features/budget/presentation/cubit/monthly_totals_cubit.dart';
import '../../features/budget/presentation/cubit/category_spending_cubit.dart';
import '../../features/budget/presentation/cubit/categories_list_cubit.dart';
import '../../features/budget/domain/usecase/get_transactions_by_query.dart';
import '../../features/goals/presentation/cubit/goals_cubit.dart';
import '../../features/goals/domain/usecase/get_goals.dart';
import '../../features/goals/domain/usecase/create_goal.dart';
import '../../features/goals/domain/usecase/contribute_goal.dart';
import '../../features/goals/domain/usecase/update_goal.dart';

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

  getItInstance.registerFactory<TransactionCubit>(
    () => TransactionCubit(
      getItInstance<AddTransaction>(),
      getItInstance<GetCategories>(),
      getItInstance<GetAccounts>(),
    ),
  );
  getItInstance.registerFactory<AccountCubit>(
    () => AccountCubit(
      getItInstance<AddAccount>(),
    ),
  );
  getItInstance.registerFactory<CategoryCubit>(
    () => CategoryCubit(
      getItInstance<AddCategory>(),
    ),
  );
  getItInstance.registerFactory<AccountsListCubit>(
    () => AccountsListCubit(
      getItInstance<GetAccounts>(),
    ),
  );

  getItInstance.registerFactory<MonthlyTotalsCubit>(
    () => MonthlyTotalsCubit(
      getItInstance<GetTransactionsByQuery>(),
    ),
  );

  getItInstance.registerFactory<CategorySpendingCubit>(
    () => CategorySpendingCubit(
      getItInstance<GetTransactionsByQuery>(),
    ),
  );

  getItInstance.registerFactory<CategoriesListCubit>(
    () => CategoriesListCubit(
      getItInstance<GetCategories>(),
    ),
  );

  // Goals
  getItInstance.registerFactory<GoalsCubit>(
    () => GoalsCubit(
      getItInstance<GetGoals>(),
      getItInstance<CreateGoal>(),
      getItInstance<ContributeGoal>(),
      getItInstance<UpdateGoal>(),
    ),
  );
}
