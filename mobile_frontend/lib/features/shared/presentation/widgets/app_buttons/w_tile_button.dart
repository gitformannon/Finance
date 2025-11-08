import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/themes/app_text_styles.dart';

/// Reusable rounded, tappable stat-like tile.
/// Uses your AppColors/AppSizes/AppTextStyles + ScreenUtil.
class TileButton extends StatelessWidget {
  const TileButton({
    required this.title,
    required this.icon,
    required this.selectedIcon,
    this.subtitle,
    this.selected = false,
    this.onTap,
    this.height,
    this.padding,
    required this.color,
    required this.selectedColor,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback? onTap;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color color;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSizes.borderMedium);

    final Color baseColor = selected ? selectedColor : color;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Ink(
          height: height ?? 110.h,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: radius,
            border: Border.all(color: color, width: 0.5),
          ),
          child: Stack(
            children: [
              // top-right neon icon badge
              Positioned(
                top: 3.h,
                right: 3.w,
                child: Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: baseColor,
                    border: Border.all(color: color.withValues(alpha: .35)),
                  ),
                  child: Icon(selected ? icon : selectedIcon, size: 18.sp, color: selected ? color : selectedColor),
                ),
              ),

              // bottom-left text
              Padding(
                padding:
                    padding ??
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyRegular.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: selected ? AppColors.primary : AppColors.textPrimary, // Colors.white.withValues(alpha: .65)
                          letterSpacing: -0.2,
                          height: 1.0,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyRegular.copyWith(
                            fontSize: 8.sp,
                            color: selected ? AppColors.surface : AppColors.textPrimary, // Colors.white.withValues(alpha: .65)
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
