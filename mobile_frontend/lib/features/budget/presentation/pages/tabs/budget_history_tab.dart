import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/helpers/formatters_helpers.dart';
import '../../cubit/budget_cubit.dart';
import '../../widgets/balance_chip.dart';
import '../edit_transaction_modal.dart';

class BudgetHistoryTab extends StatefulWidget {
  final PageController weekPageController;
  final DateTime Function(DateTime) mondayOf;
  final DateTime anchorMonday;
  final int centerPage;

  const BudgetHistoryTab({
    super.key,
    required this.weekPageController,
    required this.mondayOf,
    required this.anchorMonday,
    required this.centerPage,
  });

  @override
  State<BudgetHistoryTab> createState() => _BudgetHistoryTabState();
}

class _BudgetHistoryTabState extends State<BudgetHistoryTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCalendarSection(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingM, horizontal: AppSizes.paddingL),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    child: Text('Recent Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    child: Text('Date: ${DateFormat('d MMMM y').format(context.watch<BudgetCubit>().state.selectedDate)}',
                      style: TextStyle(
                        color: AppColors.textWhite
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) {
                  final txs = context.watch<BudgetCubit>().state.transactions;
                  final int incomeSum = txs
                      .where((t) => t.isIncome)
                      .fold(0, (acc, t) => acc + t.amount.abs().round());
                  final int expenseSum = txs
                      .where((t) => !t.isIncome)
                      .fold(0, (acc, t) => acc + t.amount.abs().round());
                  return Row(
                    children: [
                      BalanceChip(prefix: '+ ', value: incomeSum),
                      const SizedBox(width: 6),
                      BalanceChip(prefix: '- ', value: expenseSum),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: context.watch<BudgetCubit>().state.transactions.isEmpty
              ? Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(AppSizes.paddingL),
                child: const Text(
                  'No operations on this day',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: context.watch<BudgetCubit>().state.transactions.length,
                itemBuilder: (context, index) {
                  final tx = context.watch<BudgetCubit>().state.transactions[index];
                    return GestureDetector(
                    onTap: () async {
                      final changed = await showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                        builder: (_) => EditTransactionModal(tx: tx),
                      );
                      if (changed == true && mounted) {
                        final date = context.read<BudgetCubit>().state.selectedDate;
                        context.read<BudgetCubit>().load(date);
                      }
                    },
                    child: Container(
                    key: ValueKey('tx-${tx.id ?? ''}-${index}'),
                    margin: const EdgeInsets.only(bottom: AppSizes.padding8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.borderSM16),
                      color: AppColors.box
                    ),
                    child: ListTile(
                      title: Text(tx.categoryName ?? tx.title),
                      subtitle: Text(tx.accountName ?? ''),
                      trailing: Text(
                        '${tx.isIncome ? '+ ' : '- '}${Formatters.moneyStringFormatter(tx.amount.abs())} UZS',
                        style: TextStyle(
                          color: tx.isIncome ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.textSize14,
                        ),
                      ),
                    ),
                  ),
                  );
                },
              ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarSection() {
    final DateTime selectedDate = context.watch<BudgetCubit>().state.selectedDate;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.box,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 88,
              child: PageView.builder(
                controller: widget.weekPageController,
                physics: const PageScrollPhysics(),
                itemBuilder: (context, pageIndex) {
                  final int delta = pageIndex - widget.centerPage;
                  final DateTime monday = widget.anchorMonday.add(Duration(days: delta * 7));
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
                                  style: const TextStyle(color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 4),
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: isSelected ? AppColors.primary : AppColors.transparent,
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      color: isSelected ? AppColors.textSecondary : AppColors.textPrimary,
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
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.paddingM, right: AppSizes.paddingL, left: AppSizes.paddingL),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOutCubic,
                        alignment: Alignment.centerLeft,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          layoutBuilder: (currentChild, previousChildren) {
                            return Stack(
                              alignment: Alignment.centerLeft,
                              children: <Widget>[
                                ...previousChildren,
                                if (currentChild != null) currentChild,
                              ],
                            );
                          },
                          transitionBuilder: (child, animation) {
                            final Animation<Offset> slide = Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
                            return ClipRect(
                              child: FadeTransition(
                                opacity: animation,
                                child: SlideTransition(position: slide, child: child),
                              ),
                            );
                          },
                          child: Text(
                            DateFormat('MMMM').format(selectedDate),
                            key: ValueKey<String>('month-${DateFormat('yyyyMM').format(selectedDate)}'),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOutCubic,
                        alignment: Alignment.centerRight,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          layoutBuilder: (currentChild, previousChildren) {
                            return Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                ...previousChildren,
                                if (currentChild != null) currentChild,
                              ],
                            );
                          },
                          transitionBuilder: (child, animation) {
                            final Animation<Offset> slide = Tween<Offset>(
                              begin: const Offset(-1, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
                            return ClipRect(
                              child: FadeTransition(
                                opacity: animation,
                                child: SlideTransition(position: slide, child: child),
                              ),
                            );
                          },
                          child: Text(
                            DateFormat('yyyy').format(selectedDate),
                            key: ValueKey<String>('year-${DateFormat('yyyy').format(selectedDate)}'),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

