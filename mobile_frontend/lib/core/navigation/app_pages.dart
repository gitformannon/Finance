import 'package:agro_card_delivery/features/main/presentation/pages/main_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/splash.dart';
import '../../features/main/cubits/main/main_cubit.dart';
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
            path: AppRoutes.home,
            builder: (context, state) {
              int page = state.extra != null ? state.extra as int : 0;
              return BlocProvider(
                create: (context) => getItInstance<MainCubit>(),
                child: MainPage(initialPage: page),
              );
            },
          ),
        ],
      );
}
