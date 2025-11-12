import 'package:Finance/features/shared/presentation/widgets/animations/w_scale_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/themes/app_text_styles.dart';

class AccountCardButton extends StatelessWidget {
  final Color boxColor;
  final Color? selectedBoxColor;
  final String icon;
  final Color? iconColor;
  final Color? selectedIconColor;
  final Color? iconBoxBorderColor;
  final Color? selectedIconBoxBorderColor;
  final double? iconBoxBorderWidth;
  final String title;
  final Color? titleColor;
  final Color? selectedTitleColor;
  final String? subtitle;
  final Color? subtitleColor;
  final Color? selectedSubtitleColor;
  final VoidCallback onTap;
  final bool selected;
  final Color boxBorderColor;
  final Color selectedBoxBorderColor;
  final Color? iconBoxColor;
  final Color? selectedIconBoxColor;
  final String? emoji;
  final String? defaultEmoji;

  const AccountCardButton({
    super.key,
    required this.boxColor,
    this.selectedBoxColor,
    required this.icon,
    this.iconColor,
    this.selectedIconColor,
    this.iconBoxBorderColor,
    this.selectedIconBoxBorderColor,
    this.iconBoxBorderWidth,
    required this.title,
    this.titleColor,
    this.selectedTitleColor,
    this.subtitle,
    this.subtitleColor,
    this.selectedSubtitleColor,
    required this.onTap,
    required this.selected,
    required this.boxBorderColor,
    required this.selectedBoxBorderColor,
    this.iconBoxColor,
    this.selectedIconBoxColor,
    this.emoji,
    this.defaultEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
          left: AppSizes.paddingS,
          top: AppSizes.paddingS,
          bottom: AppSizes.paddingS,
          right: AppSizes.paddingS
        ),
        decoration: BoxDecoration(
          color: selected ? (selectedBoxColor ?? boxColor) : boxColor,
          borderRadius: BorderRadius.circular(AppSizes.borderMedium),
          border: Border.all(
            color: selected
                ? (selectedBoxBorderColor)
                : boxBorderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.paddingM),
              width: AppSizes.buttonIcon,
              height: AppSizes.buttonIcon,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: selected
                    ? selectedIconBoxColor
                    : (iconBoxColor ?? selectedIconBoxColor),
                borderRadius: const BorderRadius.all(Radius.circular(AppSizes.borderButtonIcon)),
                border: Border.all(
                  color: selected
                    ? (selectedIconBoxBorderColor ?? iconBoxBorderColor ?? AppColors.transparent)
                    : (iconBoxBorderColor ?? AppColors.transparent),
                  width: iconBoxBorderWidth ?? 0,
                )
              ),
              child: Center(
                child: (emoji ?? defaultEmoji) != null
                    ? Image.asset(
                        emoji ?? defaultEmoji!,
                        width: 24.w,
                        height: 24.w,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to icon if emoji fails to load
                          return SvgPicture.asset(
                            icon,
                            color: selected
                                ? (selectedIconColor ?? iconColor)
                                : iconColor,
                            width: 24.w,
                            height: 24.w,
                          );
                        },
                      )
                    : SvgPicture.asset(
                        icon,
                        color: selected
                            ? (selectedIconColor ?? iconColor)
                            : iconColor,
                      ),
              ),
            ),
            SizedBox(width: AppSizes.spaceM16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyLarge.copyWith(color: selected ? selectedTitleColor : titleColor,),
                      ),
                    ],
                  ),

                  if(subtitle !=null)
                    Row(
                      children: [
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelRegular.copyWith(color: selected ? selectedTitleColor : titleColor,),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
