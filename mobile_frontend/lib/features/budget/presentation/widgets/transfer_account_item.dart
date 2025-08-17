import 'package:Finance/features/shared/presentation/widgets/animations/w_scale_animation.dart';
import 'package:flutter/material.dart';
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

  const AccountCardButton({
    super.key,
    required this.boxColor,
    this.selectedBoxColor,
    required this.icon,
    this.iconColor,
    this.selectedIconColor,
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
    this.selectedIconBoxColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
          left: AppSizes.paddingL,
          top: AppSizes.paddingS,
          bottom: AppSizes.paddingS,
          right: AppSizes.paddingS
        ),
        decoration: BoxDecoration(
          color: selected ? (selectedBoxColor ?? boxColor) : boxColor,
          borderRadius: BorderRadius.circular(AppSizes.borderMedium),
          border: Border.all(
            width: 0.5,
            color: selected ? selectedBoxBorderColor : boxBorderColor,
          ),
        ),
        child: Row(
          children: [
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
            Container(
              padding: EdgeInsets.all(AppSizes.paddingM),
              width: AppSizes.buttonIcon,
              height: AppSizes.buttonIcon,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                  color: selected
                    ? selectedIconBoxColor
                    : (iconBoxColor ?? selectedIconBoxColor),
                borderRadius: const BorderRadius.all(Radius.circular(AppSizes.borderButtonIcon))
              ),
              child: SvgPicture.asset(icon,
                color: selected
                  ? (selectedIconColor ?? iconColor)
                  : iconColor,),
            ),
          ],
        ),
      ),
    );
  }
}
