import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';

class WBottomSheetDivider extends StatelessWidget {
  final EdgeInsets? margin;

  const WBottomSheetDivider({super.key, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: AppSizes.spaceS12.h),
      height: 5.h,
      width: 30.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderMedium),
          color: AppColors.box),
    );
  }
}
