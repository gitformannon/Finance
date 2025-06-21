import 'package:agro_card_delivery/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../app_buttons/w_button.dart';
import '../app_widgets/w_go_back.dart';

class ConfirmationBottomModal extends StatelessWidget {
  final Function? cancelFunc;
  final Function? acceptFunc;
  final String? label;

  const ConfirmationBottomModal({
    super.key,
    this.label,
    this.acceptFunc,
    this.cancelFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WGoBack(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Text(label ?? "", style: AppTextStyles.bodyRegular, maxLines: 2),
        WButton(
          backgroundColor: AppColors.box,
          borderRadius: AppSizes.borderMedium12,
          textStyle: AppTextStyles.bodyRegular,
          onTap: () {
            if (cancelFunc != null) {
              cancelFunc!();
            } else {
              Navigator.pop(context);
            }
          },
          text: "Bekor qilish",
          margin: EdgeInsets.only(bottom: AppSizes.spaceM16.h),
        ),
        WButton(
          textStyle: AppTextStyles.bodyRegular,
          borderRadius: AppSizes.borderMedium12,
          onTap: () {
            if (acceptFunc != null) {
              acceptFunc!();
            } else {
              Navigator.pop(context);
            }
          },
          text: "Ha",
        ),
      ],
    );
  }
}
