import 'package:agro_card_delivery/core/constants/app_images.dart';
import 'package:agro_card_delivery/core/helpers/enums_helpers.dart';
import 'package:agro_card_delivery/features/shared/presentation/cubits/navigate/navigate_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/get_it.dart';
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
            context.read<NavigateCubit>().goToMainPage();
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
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
