import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../animations/w_scale_animation.dart';

/// A small button for dialog actions.
///
/// This widget keeps dialog buttons consistent across the app.
/// Use [isPrimary] to highlight the button with the primary color.
class WDialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPrimary;

  const WDialogButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return WScaleAnimation(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingXS,
        ),
        decoration: BoxDecoration(
          color: isPrimary ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.borderSmall),
        ),
        child: Text(
          text,
          style: AppTextStyles.bodyRegular.copyWith(
            color: isPrimary ? AppColors.surface : AppColors.accent,
          ),
        ),
      ),
    );
  }
}
