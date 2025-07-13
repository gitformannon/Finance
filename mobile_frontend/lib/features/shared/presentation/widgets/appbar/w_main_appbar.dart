import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../app_buttons/w_circular_icon_button.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final ImageProvider profileImage;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final bool showNotificationDot;
  final Gradient? gradient;
  final Color? backgroundColor;

  const MainAppBar({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.profileImage,
    this.onProfileTap,
    this.onNotificationTap,
    this.showNotificationDot = false,
    this.gradient,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight56);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        gradient: gradient ?? const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
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
                radius: 20,
                backgroundImage: profileImage,
              ),
            ),
            const SizedBox(width: AppSizes.spaceM16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium,
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.labelRegular,
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
