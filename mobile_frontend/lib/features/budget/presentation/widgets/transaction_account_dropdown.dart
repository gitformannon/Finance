import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../cubit/transaction_cubit.dart';
import 'budget_bottom_sheet_selector.dart';

class TransactionAccountDropdown extends StatelessWidget {
  final TransactionState state;
  final TransactionCubit cubit;

  const TransactionAccountDropdown({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.box,
        borderRadius: BorderRadius.circular(AppSizes.borderSM16),
        border: Border.all(color: AppColors.def, width: 1.0)
      ),
      child: BudgetBottomSheetSelector<String>(
        value: state.accountId.isNotEmpty ? state.accountId : null,
        hintText: 'Select account',
        onChanged: (val) => cubit.setAccountId(val ?? ''),
        items: state.accounts
            .map(
              (a) => BudgetSelectorItem(
                value: a.id,
                label: a.name ?? 'Account',
                emoji: a.emoji_path,
              ),
            )
            .toList(),
      ),
    );
  }
}

