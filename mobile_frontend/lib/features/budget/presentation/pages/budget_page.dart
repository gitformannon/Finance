import 'package:Finance/core/constants/app_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/helpers/formatters_helpers.dart';

import '../../../../core/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/budget_cubit.dart';
import 'add_transaction_modal.dart';
import 'add_account_modal.dart';
import '../cubit/transaction_cubit.dart';
import '../../../../core/di/get_it.dart';
import '../../../budget/domain/usecase/get_accounts.dart';
import '../../../../core/network/no_params.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  late final PageController _weekPageController;
  static const int _initialPage = 100000; // large center for practical infinity

  int _accountsBalance = 0;
  final NumberFormat _numFormat = NumberFormat("#,##0", "ru");

  DateTime _mondayOf(DateTime date) {
    final int weekday = date.weekday; // 1 Mon ... 7 Sun
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: weekday - 1));
  }

  // Anchor Monday to compute page indices. 2000-01-03 is a Monday.
  final DateTime _anchorMonday = DateTime(2000, 1, 3);
  static const int _centerPage = _initialPage;

  @override
  void initState() {
    super.initState();
    final DateTime todayMonday = _mondayOf(DateTime.now());
    final int weekDelta = todayMonday.difference(_anchorMonday).inDays ~/ 7;
    _weekPageController = PageController(initialPage: _centerPage + weekDelta);
    context.read<BudgetCubit>().load(DateTime.now());
    _loadTotalBalance();
  }

  Future<void> _loadTotalBalance() async {
    final getAccounts = getItInstance<GetAccounts>();
    final result = await getAccounts(const NoParams());
    result.fold(
      (_) {},
      (accounts) {
        final int sum = accounts.fold(0, (acc, a) => acc + a.balance);
        if (mounted) {
          setState(() {
            _accountsBalance = sum;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _weekPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.def.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total balance', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('${Formatters.moneyStringFormatter(_accountsBalance)} UZS',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.def.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('Main'),
                          subtitle: const Text('0 UZS'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            builder: (_) => const AddAccountModal(),
                          ).then((_) => _loadTotalBalance());
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.def, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.add, color: AppColors.def),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildCalendarSection(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd MMM yyyy').format(
                    context.watch<BudgetCubit>().state.selectedDate,
                  ),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Row(
                  children: [
                    _BalanceChip(text: '+ 0 UZS'),
                    SizedBox(width: 8),
                    _BalanceChip(text: '- 0 UZS'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: context.watch<BudgetCubit>().state.transactions.isEmpty
                ? Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.def,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Text(
                    'No operations on this day',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                : ListView.separated(
                  itemCount: context.watch<BudgetCubit>().state.transactions.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final tx = context.watch<BudgetCubit>().state.transactions[index];
                    return ListTile(
                      title: Text(tx.title),
                      subtitle: Text(
                        DateFormat('dd MMM yyyy').format(tx.date),
                      ),
                      trailing: Text(
                        '${tx.isIncome ? '+' : '-'}${Formatters.moneyStringFormatter(tx.amount.abs())} UZS',
                        style: TextStyle(
                          color: tx.isIncome ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
            ),
          ),
          ],
        ),
      ),
          floatingActionButton: Builder(
        builder: (context) => Transform.translate(
          offset: Offset(
            -MediaQuery.of(context).padding.right,
            -(MediaQuery.of(context).padding.bottom + 12),
          ),
          child: FloatingActionButton(
            onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              builder: (_) => BlocProvider(
                create: (_) => getItInstance<TransactionCubit>()
                  ..loadAccounts()
                  ..loadCategories(),
                child: const AddTransactionModal(),
              ),
            ).then((_) => _loadTotalBalance());
            },
            backgroundColor: AppColors.accent,
            child: const Icon(Icons.add, color: AppColors.surface),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    final DateTime selectedDate = context.watch<BudgetCubit>().state.selectedDate;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.def.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: 88,
          child: PageView.builder(
            controller: _weekPageController,
            physics: const PageScrollPhysics(),
            // no itemCount for effectively infinite weeks
            itemBuilder: (context, pageIndex) {
              final int delta = pageIndex - _centerPage;
              final DateTime monday = _anchorMonday.add(Duration(days: delta * 7));
              final List<DateTime> days = List.generate(7, (i) => monday.add(Duration(days: i)));
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.padding8, horizontal: AppSizes.padding8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: days.map((date) {
                    final bool isSelected = date.year == selectedDate.year &&
                      date.month == selectedDate.month &&
                      date.day == selectedDate.day;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => context.read<BudgetCubit>().load(date),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.E().format(date),
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: isSelected ? Colors.blue : Colors.transparent,
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BalanceChip extends StatelessWidget {
  final String text;
  const _BalanceChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
