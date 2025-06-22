import 'package:Finance/features/main/presentation/pages/main_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/splash.dart';
import '../../features/auth/presentation/pages/login.dart';
import '../../features/auth/presentation/pages/register.dart';
import '../../features/auth/presentation/pages/forgot_password.dart';
import '../../features/main/cubits/main/main_cubit.dart';
import '../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../constants/app_routes.dart';
import '../di/get_it.dart';

class AppPages {
  final GoRouter router;

  AppPages()
    : router = GoRouter(
        initialLocation: AppRoutes.splashScreen,
        routes: [
          GoRoute(
            path: AppRoutes.splashScreen,
            builder: (context, state) => const SplashScreen(),
          ),

          GoRoute(
            path: AppRoutes.login,
            builder: (context, state) => BlocProvider(
              create: (context) => getItInstance<LoginCubit>(),
              child: const LoginPage(),
            ),
          ),

          GoRoute(
            path: AppRoutes.register,
            builder: (context, state) => const RegisterPage(),
          ),

          GoRoute(
            path: AppRoutes.forgotPassword,
            builder: (context, state) => const ForgotPasswordPage(),
          ),

          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) {
              int page = state.extra != null ? state.extra as int : 0;
              return BlocProvider(
                create: (context) => getItInstance<MainCubit>(),
                child: MainPage(initialPage: page),
              );
            },
          ),

          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => BlocProvider(
              create: (context) => getItInstance<ProfileCubit>(),
              child: const ProfilePage(),
            ),
          ),
        ],
      );
  }
