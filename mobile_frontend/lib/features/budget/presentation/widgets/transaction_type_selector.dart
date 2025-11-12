import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../cubit/transaction_cubit.dart';
import 'transaction_type_button.dart';

class TransactionTypeSelector extends StatelessWidget {
  final TransactionState state;
  final TransactionCubit cubit;

  const TransactionTypeSelector({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TransactionTypeButton(
          title: 'Income',
          titleColor: AppColors.textSecondary,
          selectedTitleColor: AppColors.textPrimary,
          boxColor: AppColors.box,
          selectedBoxColor: AppColors.primary,
          selected: state.type == TransactionType.income,
          onTap: () => cubit.setType(TransactionType.income),
        ),
        SizedBox(width: AppSizes.spaceXXS5.w),
        TransactionTypeButton(
          title: 'Purchase',
          titleColor: AppColors.textSecondary,
          selectedTitleColor: AppColors.textPrimary,
          boxColor: AppColors.box,
          selectedBoxColor: AppColors.primary,
          selected: state.type == TransactionType.purchase,
          onTap: () => cubit.setType(TransactionType.purchase),
        ),
        SizedBox(width: AppSizes.spaceXXS5.w),
        TransactionTypeButton(
          title: 'Transfer',
          titleColor: AppColors.textSecondary,
          selectedTitleColor: AppColors.textPrimary,
          boxColor: AppColors.box,
          selectedBoxColor: AppColors.primary,
          selected: state.type == TransactionType.transfer,
          onTap: () => cubit.setType(TransactionType.transfer),
        ),
      ],
    );
  }
}

