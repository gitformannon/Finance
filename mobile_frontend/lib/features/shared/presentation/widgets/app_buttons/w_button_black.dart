import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../animations/w_scale_animation.dart';

class TaskCardButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onArrowTap;

  const TaskCardButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL, vertical: AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.grey.shade400, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      subtitle,
                      style: AppTextStyles.labelRegular.copyWith(color: Colors.grey.shade400),
                    ),
                  ],
                )
              ],
            ),
          ),
          WScaleAnimation(
            onTap: onArrowTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade800,
              ),
              child: const Icon(Icons.chevron_right, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
