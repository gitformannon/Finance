import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/helpers/enums_helpers.dart';
import '../pages/add_category_modal.dart';

class AddCategoryItem extends StatelessWidget {
  final CategoryType? type;
  final VoidCallback? onCategoryAdded;
  final Color boxBorderColor;
  final Color boxColor;

  const AddCategoryItem({
    this.type,
    this.onCategoryAdded,
    required this.boxBorderColor,
    required this.boxColor,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        await AddCategoryModal.show(context, type: type);
        onCategoryAdded?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingS),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderMedium),
          border: Border.all(
            width: 0.5,
            color: boxBorderColor,
          ),
          color: boxColor
        ),
        child: Column(
          children: [
            const Spacer(),

            Container(
              padding: const EdgeInsets.all(AppSizes.paddingS),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.box,
              ),
              height: 28.w,
              width: 28.w,
              child: SvgPicture.asset(
                'assets/svg/ic_add.svg',
                color: AppColors.textSecondary,
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}