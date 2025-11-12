import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class TransactionErrorBanner extends StatelessWidget {
  final String errorMessage;

  const TransactionErrorBanner({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.spaceM16.h),
      padding: EdgeInsets.all(AppSizes.spaceS12.h),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderSM16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          SizedBox(width: AppSizes.spaceXS8.w),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(
                color: AppColors.error,
                fontSize: AppSizes.textSize14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

