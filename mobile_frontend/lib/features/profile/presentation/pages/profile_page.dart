import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';
import '../../../shared/presentation/widgets/appbar/w_main_appbar.dart';
import '../../../../core/constants/app_images.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: 'Profile',
        subtitle: 'Your account',
        profileImage: AssetImage(AppImages.logo),
        onTap: () {},
        onNotificationTap: () {},
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status.isLoading()) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status.isError()) {
            return Center(child: Text(state.errorMessage));
          }
          final p = state.profile;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (p != null) ...[
                  Text('ID: ${p.id}'),
                  const SizedBox(height: 8),
                  Text('Username: ${p.username}'),
                ],
                const Spacer(),
                WButton(
                  width: double.infinity,
                  onTap: () => context.read<ProfileCubit>().logout(),
                  text: 'Logout',
                  backgroundColor: AppColors.primary,
                  textStyle: AppTextStyles.bodyRegular.copyWith(
                    color: AppColors.surface,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
