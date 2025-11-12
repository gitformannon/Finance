import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/helpers/formatters_helpers.dart';
import '../cubit/monthly_totals_cubit.dart';
import '../cubit/accounts_list_cubit.dart';
import 'animated_amount.dart';

class BudgetSummaryHeader extends StatelessWidget {
  const BudgetSummaryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsListCubit, AccountsListState>(
      builder: (context, accountsState) {
        final accountsBalance = accountsState.accounts.isEmpty
            ? 0
            : accountsState.accounts.fold(0, (acc, a) => acc + a.balance);
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.borderSM16),
            border: Border.all(color: AppColors.def, width: 1.0)
          ),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total balance', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('${Formatters.moneyStringFormatter(accountsBalance)} UZS',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            BlocBuilder<MonthlyTotalsCubit, MonthlyTotalsState>(
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingM, horizontal: AppSizes.padding16),
                        decoration: BoxDecoration(
                          color: AppColors.box,
                          borderRadius: BorderRadius.circular(AppSizes.borderSM16),
                          border: Border.all(color: AppColors.def, width: 1.0)
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(
                                  Icons.trending_up,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.padding8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AnimatedAmount(
                                  value: state.income,
                                  prefix: '',
                                  suffix: ' UZS',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingM, horizontal: AppSizes.padding16),
                        decoration: BoxDecoration(
                          color: AppColors.box,
                          borderRadius: BorderRadius.circular(AppSizes.borderSM16),
                          border: Border.all(color: AppColors.def, width: 1.0)
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(
                                  Icons.trending_down,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.padding8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AnimatedAmount(
                                  value: state.expense,
                                  prefix: '',
                                  suffix: ' UZS',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
        );
      },
    );
  }
}

