import 'package:Finance/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/presentation/widgets/appbar/w_main_appbar.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_api.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/cubit/profile_state.dart';
import '../../../shared/presentation/cubits/navigate/navigate_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        ImageProvider provider = const AssetImage(AppImages.profileDefault);
        final path = profile?.profileImage;
        if (path != null && path.isNotEmpty) {
          if (path == AppImages.profileDefault) {
            provider = const AssetImage(AppImages.profileDefault);
          } else if (path.startsWith('http')) {
            provider = NetworkImage(path);
          } else {
            provider = NetworkImage('${AppApi.baseUrlProd}/$path');
          }
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: MainAppBar(
            firstName: profile?.firstName ?? 'User',
            lastName: profile?.lastName ?? '',
            username: profile?.username ?? '',
            profileImage: provider,
            onProfileTap: () =>
                context.read<NavigateCubit>().goToProfilePage(),
            onNotificationTap: () {},
          ),
          body: const Center(
            child: Text('Home Page'),
          ),
        );
      },
    );
  }
}
