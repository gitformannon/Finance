import 'package:Finance/features/shared/presentation/widgets/animations/w_scale_animation.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/themes/app_text_styles.dart';

class AccountCardButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AccountCardButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.only(left: AppSizes.paddingL, top: AppSizes.paddingS, bottom: AppSizes.paddingS, right: AppSizes.paddingS),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(AppSizes.borderMedium),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.surface),
                ),
                Row(
                  children: [
                    Text(
                      subtitle,
                      style: AppTextStyles.labelRegular.copyWith(color: AppColors.box),
                    ),
                  ],
                )
              ],
            ),
          ),
          WScaleAnimation(
            onTap: onTap,
            child: Container(
              width: AppSizes.buttonIcon,
              height: AppSizes.buttonIcon,
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.all(Radius.circular(AppSizes.borderButtonIcon))
              ),
              child: const Icon(Icons.chevron_right, color: AppColors.surface),
            ),
          )
        ],
      ),
    );
  }
}
