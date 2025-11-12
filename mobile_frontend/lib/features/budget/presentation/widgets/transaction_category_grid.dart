import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../cubit/transaction_cubit.dart';
import 'add_category_item.dart';
import 'category_item.dart';

class TransactionCategoryGrid extends StatelessWidget {
  final TransactionCubit cubit;
  final TransactionState state;

  const TransactionCategoryGrid({
    super.key,
    required this.cubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: AppSizes.space3,
      mainAxisSpacing: AppSizes.space3,
      children: [
        for (final cat in state.categories)
          CategoryItem(
            icon: 'assets/svg/ic_global.svg',
            iconColor: AppColors.box,
            selectedIconColor: AppColors.primary,
            iconBoxBorderWidth: 1,
            iconBoxBorderColor: AppColors.def,
            selectedIconBoxBorderColor: AppColors.primary,
            selectedIconBoxColor: AppColors.box,
            title: cat.name,
            titleColor: AppColors.textSecondary,
            selectedTitleColor: AppColors.textPrimary,
            boxColor: AppColors.box,
            selectedBoxColor: AppColors.primary,
            boxBorderColor: AppColors.def,
            selectedBoxBorderColor: AppColors.primary,
            selected: cubit.state.categoryId == cat.id,
            onTap: () => cubit.setCategoryId(cat.id),
            emoji: cat.emoji_path,
            defaultEmoji: 'assets/emoji/Triangular Flag.png',
          ),
        AddCategoryItem(
          boxColor: AppColors.box,
          boxBorderColor: AppColors.def,
          type: state.type == TransactionType.income
              ? CategoryType.income
              : state.type == TransactionType.purchase
                  ? CategoryType.purchase
                  : null,
          onCategoryAdded: cubit.loadCategories,
        ),
      ],
    );
  }
}

