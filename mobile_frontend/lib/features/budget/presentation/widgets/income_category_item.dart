import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IncomeCategoryItem extends StatelessWidget {
  final Color boxColor;
  final Color? selectedBoxColor;
  final String icon;
  final Color iconColor;
  final Color? selectedIconColor;
  final String title;
  final Color? titleColor;
  final Color? selectedTitleColor;
  final String? subtitle;
  final Color? subtitleColor;
  final Color? selectedSubtitleColor;
  final VoidCallback? onTap;
  final bool selected;
  final Color boxBorderColor;
  final Color selectedBoxBorderColor;
  final Color? iconBoxColor;
  final Color? selectedIconBoxColor;

  const IncomeCategoryItem({
    required this.boxColor,
    this.selectedBoxColor,
    required this.icon,
    required this.iconColor,
    this.selectedIconColor,
    this.onTap,
    this.selected = false,
    required this.title,
    this.titleColor,
    this.selectedTitleColor,
    this.subtitle,
    this.subtitleColor,
    this.selectedSubtitleColor,
    required this.boxBorderColor,
    required this.selectedBoxBorderColor,
    this.iconBoxColor,
    this.selectedIconBoxColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingS),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderMedium),
          border: Border.all(
            width: 0.5,
            color: selected ? selectedBoxBorderColor : boxBorderColor,
          ),
          color: selected ? (selectedBoxColor ?? boxColor) : boxColor
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 48.w,
                  width: 48.w,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? selectedIconBoxColor
                        : (iconBoxColor ?? selectedIconBoxColor),

                  ),
                  child: SvgPicture.asset(
                    icon,
                    color: selected
                        ? (selectedIconColor ?? iconColor)
                        : iconColor,
                  ),
                ),
              ],
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(left: AppSizes.paddingM, right: AppSizes.paddingS, bottom: AppSizes.paddingS),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? selectedTitleColor : titleColor,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),

            if(subtitle != null)
              Padding(
                padding: const EdgeInsets.only(left: AppSizes.paddingM, right: AppSizes.paddingS, bottom: AppSizes.paddingS),
                child: Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? selectedSubtitleColor : subtitleColor,
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}
