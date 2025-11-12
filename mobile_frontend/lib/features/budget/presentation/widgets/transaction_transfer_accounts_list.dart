import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../cubit/transaction_cubit.dart';
import 'transfer_account_item.dart';

class TransactionTransferAccountsList extends StatelessWidget {
  final TransactionCubit cubit;
  final TransactionState state;

  const TransactionTransferAccountsList({
    super.key,
    required this.cubit,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final acc in state.accounts)
          Container(
            margin: const EdgeInsets.only(bottom: AppSizes.padding8),
            child: AccountCardButton(
              iconColor: AppColors.box,
              selectedIconColor: AppColors.primary,
              iconBoxColor: AppColors.box,
              iconBoxBorderWidth: 1,
              iconBoxBorderColor: AppColors.def,
              selectedIconBoxBorderColor: AppColors.primary,
              selectedIconBoxColor: AppColors.box,
              titleColor: AppColors.textPrimary,
              selectedTitleColor: AppColors.textPrimary,
              boxColor: AppColors.box,
              selectedBoxColor: AppColors.primary,
              boxBorderColor: AppColors.def,
              selectedBoxBorderColor: AppColors.primary,
              title: acc.name ?? 'Account',
              subtitle: acc.number ?? '',
              icon: 'assets/svg/ic_more.svg',
              emoji: acc.emoji_path,
              selected: cubit.state.toAccountId == acc.id,
              onTap: () => cubit.setToAccountId(acc.id),
            ),
          ),
      ],
    );
  }
}

