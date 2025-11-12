import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/core/helpers/formatters_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/account.dart' as model;
import '../cubit/accounts_list_cubit.dart';
import 'edit_account_modal.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AccountsListCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Accounts'),
      ),
      body: BlocBuilder<AccountsListCubit, AccountsListState>(
        builder: (context, state) {
          if (state.loading) return const Center(child: CircularProgressIndicator());
          if (state.accounts.isEmpty) return const Center(child: Text('No accounts'));
          return ListView.separated(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            itemBuilder: (context, index) {
              final acc = state.accounts[index];
              return GestureDetector(
                onLongPress: () async {
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
                child: _AccountCard(acc: acc),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.paddingM),
            itemCount: state.accounts.length,
          );
        },
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final model.Account acc;
  const _AccountCard({required this.acc});

  @override
  Widget build(BuildContext context) {
    final _TypeMeta meta = _typeMeta(acc.type ?? 6);
    final int bal = acc.balance;
    final bool isCredit = (acc.type == 2);
    final bool isPositive = bal >= 0;
    final Color valueColor = isCredit ? (isPositive ? Colors.red : Colors.green) : (isPositive ? Colors.green : Colors.red);
    final String valuePrefix = isCredit ? '' : (isPositive ? '+ ' : '- ');
    final int valueAbs = isCredit ? bal : bal.abs();

    final String last4 = (acc.number ?? '').replaceAll(RegExp(r'\s+'), '');
    final String masked = last4.length >= 4 ? '****${last4.substring(last4.length - 4)}' : '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: meta.bg,
            child: _buildAccountIcon(acc.emoji_path, meta.icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(meta.label, style: TextStyle(color: meta.chipText, fontWeight: FontWeight.w600))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        acc.name ?? 'Account',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$valuePrefix${Formatters.moneyStringFormatter(valueAbs)} UZS',
                      style: TextStyle(color: valueColor, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: meta.chipBg,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(meta.label, style: TextStyle(color: meta.chipText, fontWeight: FontWeight.w600)),
                    ),
                    Text(acc.institution ?? '', style: const TextStyle(color: Colors.black54)),
                    if (masked.isNotEmpty) Text(masked, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
        ],
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

/// Builds the account icon widget, using emoji if available, otherwise default icon
Widget _buildAccountIcon(String? emojiPath, IconData defaultIcon) {
  if (emojiPath != null && emojiPath.isNotEmpty) {
    return Image.asset(
      emojiPath,
      width: 32,
      height: 32,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to default icon if emoji fails to load
        return Icon(defaultIcon, color: Colors.white);
      },
    );
  }
  return Icon(defaultIcon, color: Colors.white);
}
