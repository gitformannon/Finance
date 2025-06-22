import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_images.dart';
import 'package:Finance/core/helpers/enums_helpers.dart';
import 'package:Finance/features/shared/presentation/cubits/navigate/navigate_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/get_it.dart';
import '../../../shared/domain/repository/shared_repository.dart';
import '../cubit/splash/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getItInstance<SplashCubit>(),
      child: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state.status == RequestStatus.loaded) {
            final token = getItInstance<SharedRepository>().getToken();
            if (token.isNotEmpty) {
              context.read<NavigateCubit>().goToMainPage();
            } else {
              context.read<NavigateCubit>().goToLoginPage();
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.primary,
            body: SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(AppImages.logo),
              ),
            ),
          );
        },
      ),
    );
  }
}
