import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/helpers/formatters_helpers.dart';
import '../../cubit/accounts_list_cubit.dart';
import '../edit_account_modal.dart';

class BudgetAccountsTab extends StatelessWidget {
  const BudgetAccountsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<AccountsListCubit, AccountsListState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.accounts.isEmpty) {
              return const Center(child: Text('No accounts'));
            }
            return ListView.separated(
              itemCount: state.accounts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final acc = state.accounts[index];
                return GestureDetector(
                  key: ValueKey('acc-${acc.id ?? acc.name ?? index}'),
                  onTap: () async {
                    final changed = await showModalBottomSheet(
                      context: context,
                      useSafeArea: true,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                      builder: (_) => EditAccountModal(account: acc),
                    );
                    if (changed == true && context.mounted) {
                      context.read<AccountsListCubit>().load();
                    }
                  },
                  child: _AccountCardInline(acc: acc),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _AccountCardInline extends StatelessWidget {
  final dynamic acc; // using generated Account model
  const _AccountCardInline({required this.acc});

  @override
  Widget build(BuildContext context) {
    final _TypeMeta meta = _typeMeta(acc.type ?? 6);
    final int bal = acc.balance;
    final bool isCredit = (acc.type == 2);
    final bool isPositive = bal >= 0;
    final Color valueColor = isCredit
        ? (isPositive ? Colors.red : Colors.green)
        : (isPositive ? Colors.green : Colors.red);
    final int valueAbs = isCredit ? bal : bal.abs();

    final String last4 = (acc.number ?? '').replaceAll(RegExp(r'\s+'), '');
    final String masked = last4.length >= 4 ? '**** **** **** ${last4.substring(last4.length - 4)}' : '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.borderSM16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.padding16),
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.borderSM16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                AppColors.background,
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: AppSizes.padding16),
                    child: CircleAvatar(
                        radius: 24,
                        backgroundColor: meta.bg,
                        child: Icon(meta.icon, color: Colors.white),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          acc.name ?? 'Account',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: AppSizes.textSize18, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        child: Text(meta.label, style: TextStyle(fontSize: AppSizes.textSize12, color: meta.chipText, fontWeight: FontWeight.w600))
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceXS8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${Formatters.moneyStringFormatter(valueAbs)} UZS',
                          style: TextStyle(color: valueColor, fontWeight: FontWeight.w900, fontSize: AppSizes.textSize20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceM16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                        color: AppColors.def.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      children: [
                        Text(acc.institution ?? '', style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                        color: AppColors.def.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      children: [
                        if (masked.isNotEmpty) Text(masked, style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeMeta {
  final String label;
  final IconData icon;
  final Color bg;
  final Color chipBg;
  final Color chipText;
  const _TypeMeta(this.label, this.icon, this.bg, this.chipBg, this.chipText);
}

_TypeMeta _typeMeta(int type) {
  switch (type) {
    case 1:
      return _TypeMeta('Checking', Icons.account_balance_wallet, Colors.blue, Colors.blue.shade50, Colors.blue.shade700);
    case 2:
      return _TypeMeta('Credit Card', Icons.credit_card, Colors.red, Colors.red.shade50, Colors.red.shade700);
    case 3:
      return _TypeMeta('Savings', Icons.savings, Colors.green, Colors.green.shade50, Colors.green.shade700);
    case 4:
      return _TypeMeta('Investment', Icons.trending_up, Colors.purple, Colors.purple.shade50, Colors.purple.shade700);
    case 5:
      return _TypeMeta('Cash', Icons.payments, Colors.teal, Colors.teal.shade50, Colors.teal.shade700);
    default:
      return _TypeMeta('Other', Icons.account_balance, Colors.grey, Colors.grey.shade200, Colors.grey.shade800);
  }
}

