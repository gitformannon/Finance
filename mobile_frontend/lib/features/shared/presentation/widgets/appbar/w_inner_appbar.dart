import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../app_buttons/w_circular_icon_button.dart';

class SubpageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackTap;
  final VoidCallback? onNotificationTap;
  final bool showNotificationDot;
  final Gradient? gradient;
  final Color? backgroundColor;

  const SubpageAppBar({
    Key? key,
    required this.title,
    required this.onBackTap,
    this.onNotificationTap,
    this.showNotificationDot = false,
    this.gradient,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight);

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
          children: [
            CircularIconButton(
              icon: Icons.arrow_back,
              onTap: onBackTap,
              backgroundColor: AppColors.surface,
              iconColor: AppColors.textPrimary,
            ),
            const SizedBox(width: AppSizes.spaceM16),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium,
                ),
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
