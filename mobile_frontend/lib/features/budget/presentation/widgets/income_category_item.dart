import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IncomeCategoryItem extends StatelessWidget {
  const IncomeCategoryItem({
    super.key,
    required this.boxColor,
    this.selectedBoxColor,
    required this.icon,
    required this.iconColor,
    this.selectedIconColor,
    required this.title,
    this.onTap,
    this.selected = false,
    this.titleColor,
    this.subtitle,
    this.subtitleColor
  });

  final Color boxColor;
  final Color? selectedBoxColor;
  final String icon;
  final Color iconColor;
  final Color? selectedIconColor;
  final String title;
  final Color? titleColor;
  final String? subtitle;
  final Color? subtitleColor;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingS),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.borderMedium),
        color: boxColor,
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
                  color: selectedBoxColor,
                ),
                child: SvgPicture.asset(icon, color: Colors.black),
              ),
            ],
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(left: AppSizes.paddingM, bottom: AppSizes.paddingS),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.bold
              ),
            ),
          ),

          if(subtitle != null)
            Padding(
              padding: const EdgeInsets.only(left: AppSizes.paddingM, bottom: AppSizes.paddingS),
              child: Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: subtitleColor,
                ),
              ),
            ),

        ],
      ),
    );
  }
}
