import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../app_buttons/w_circular_icon_button.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String firstName;
  final String lastName;
  final String username;
  final ImageProvider profileImage;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final bool showNotificationDot;
  final Gradient? gradient;
  final Color? backgroundColor;

  const MainAppBar({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.profileImage,
    this.onProfileTap,
    this.onNotificationTap,
    this.showNotificationDot = false,
    this.gradient,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        gradient: gradient ??
            const LinearGradient(
              colors: [AppColors.primary, AppColors.background],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onProfileTap,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: profileImage,
              ),
            ),
            const SizedBox(width: AppSizes.spaceM16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$firstName $lastName',
                    style: AppTextStyles.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '@$username',
                    style: AppTextStyles.labelRegular,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.spaceM16),
            CircularIconButton(
              icon: Icons.notifications,
              onTap: onNotificationTap ?? () {},
              backgroundColor: AppColors.surface,
              iconColor: AppColors.textPrimary,
              showNotificationDot: showNotificationDot,
            ),
          ],
        ),
      ),
    );
  }
}
