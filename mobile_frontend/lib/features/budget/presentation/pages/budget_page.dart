import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/features/budget/presentation/pages/edit_account_modal.dart';
import 'package:Finance/features/budget/presentation/pages/edit_category_modal.dart';
import 'package:Finance/features/budget/presentation/pages/edit_transaction_modal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/helpers/formatters_helpers.dart';

import '../../../../core/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/budget_cubit.dart';
import 'add_transaction_modal.dart';
import 'add_account_modal.dart';
import 'add_category_modal.dart';
import '../../../goals/presentation/pages/add_goal_modal.dart';
import '../../../goals/presentation/pages/edit_goal_modal.dart';
import '../cubit/transaction_cubit.dart';
import '../../../../core/di/get_it.dart';
import '../../../budget/domain/usecase/get_accounts.dart';
import '../../../../core/network/no_params.dart';
import '../../domain/usecase/get_transactions_by_date.dart';
import '../../domain/usecase/get_categories.dart';
import '../../data/model/category.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../cubit/accounts_list_cubit.dart';
import '../../../goals/presentation/cubit/goals_cubit.dart';
import '../../../goals/data/model/goal.dart' as goal_model;

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> with TickerProviderStateMixin {
  late final PageController _weekPageController;
  static const int _initialPage = 100000; // large center for practical infinity

  int _accountsBalance = 0;
  final NumberFormat _numFormat = NumberFormat("#,##0", "ru");

  // Monthly totals cache
  int _monthlyIncome = 0;
  int _monthlyExpense = 0;
  int _monthlyYear = 0;
  int _monthlyMonth = 0;
  bool _isLoadingMonthly = false;
  int _selectedTopTab = 0; // 0: History, 1: Accounts, 2: Budget, 3: Goals
  
  // Categories for budget tab
  List<Category> _expenseCategories = [];
  bool _isLoadingCategories = false;
  // Goals tab support
  late final GoalsCubit _goalsCubit;
  bool _goalsLoaded = false;

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
    // Preload current month totals
    _loadMonthlyTotals(DateTime.now());
    // Load expense categories for budget tab
    _loadExpenseCategories();
    _goalsCubit = getItInstance<GoalsCubit>();
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
    _goalsCubit.close();
    _weekPageController.dispose();
    super.dispose();
  }

  int _getDailyIncome(DateTime selectedDate) {
    final budgetState = context.watch<BudgetCubit>().state;
    return budgetState.transactions
        .where((tx) => tx.isIncome)
        .fold(0, (sum, tx) => sum + tx.amount.abs().round());
  }

  int _getDailyExpense(DateTime selectedDate) {
    final budgetState = context.watch<BudgetCubit>().state;
    return budgetState.transactions
        .where((tx) => !tx.isIncome)
        .fold(0, (sum, tx) => sum + tx.amount.abs().round());
  }

  Future<void> _loadMonthlyTotals(final DateTime monthDate) async {
    _isLoadingMonthly = true;
    try {
      final getTxByDate = getItInstance<GetTransactionsByDate>();
      final DateTime firstDay = DateTime(monthDate.year, monthDate.month, 1);
      final DateTime nextMonthFirst = DateTime(monthDate.year, monthDate.month + 1, 1);
      final int daysInMonth = nextMonthFirst.subtract(const Duration(days: 1)).day;

      int income = 0;
      int expense = 0;

      // Fetch per day and aggregate (simple, minimizes backend changes)
      for (int d = 0; d < daysInMonth; d++) {
        final DateTime day = firstDay.add(Duration(days: d));
        final result = await getTxByDate(GetTransactionsByDateParams(day));
        result.fold((_) {}, (txs) {
          for (final tx in txs) {
            if (tx.isIncome) {
              income += tx.amount.abs().round();
            } else {
              expense += tx.amount.abs().round();
            }
          }
        });
      }

      if (mounted) {
        setState(() {
          _monthlyIncome = income;
          _monthlyExpense = expense;
          _monthlyYear = monthDate.year;
          _monthlyMonth = monthDate.month;
        });
      }
    } finally {
      _isLoadingMonthly = false;
    }
  }

  Future<void> _loadExpenseCategories() async {
    _isLoadingCategories = true;
    try {
      final getCategories = getItInstance<GetCategories>();
      final result = await getCategories(GetCategoriesParams('purchase'));
      result.fold(
        (_) {},
        (categories) {
          if (mounted) {
            setState(() {
              _expenseCategories = categories;
            });
          }
        },
      );
    } finally {
      _isLoadingCategories = false;
    }
  }

  int _getCategorySpent(String categoryId) {
    // TODO: Calculate actual spent amount for this category from transactions
    // For now, return placeholder values
    return 0;
  }

  int _getCategoryBudget(String categoryId) {
    final c = _expenseCategories.firstWhere((e) => e.id == categoryId, orElse: () => Category(id: '', name: '', type: CategoryType.purchase));
    return c.budget ?? 0;
  }


  @override
  Widget build(BuildContext context) {

    final double bottomSafe = MediaQuery.of(context).padding.bottom;
    final double _navbarVisualHeight = AppSizes.navbarButtonHeight + (AppSizes.paddingM * 2); // item + vertical padding
    final double _navbarBottomMargin = AppSizes.paddingL; // navbar external bottom margin
    final double _fabExtraGap = AppSizes.padding8; // small visual gap above navbar

    // Ensure monthly totals match currently selected month
    final DateTime selectedForTotals = context.watch<BudgetCubit>().state.selectedDate;
    if ((_monthlyYear != selectedForTotals.year || _monthlyMonth != selectedForTotals.month) && !_isLoadingMonthly) {
      // Fire and forget; setState inside when done
      _loadMonthlyTotals(selectedForTotals);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: SafeArea(
        bottom: false,
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
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingM, horizontal: AppSizes.padding16),
                          decoration: BoxDecoration(
                            color: AppColors.box,
                            borderRadius: BorderRadius.circular(AppSizes.borderSM16)
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
                                  _AnimatedAmount(
                                    value: _monthlyIncome,
                                    prefix: '',
                                    suffix: ' UZS',
                                    style: TextStyle(
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
                            borderRadius: BorderRadius.circular(AppSizes.borderSM16)
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
                                  _AnimatedAmount(
                                    value: _monthlyExpense,
                                    prefix: '',
                                    suffix: ' UZS',
                                    style: TextStyle(
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
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _TopSegmentedBar(
              items: const ['History', 'Accounts', 'Budget', 'Goals'],
              selectedIndex: _selectedTopTab,
              onSelected: (idx) {
                setState(() => _selectedTopTab = idx);
                if (idx == 3 && !_goalsLoaded) {
                  _goalsCubit.load();
                  _goalsLoaded = true;
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          if (_selectedTopTab == 0) ...[
            // History tab
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
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ],
                  ),
                   Row(
                     children: [
                       Container(
                         child: Text('Date: ${DateFormat('d MMMM y').format(context.watch<BudgetCubit>().state.selectedDate)}'),
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
                          _BalanceChip(prefix: '+ ', value: incomeSum),
                          const SizedBox(width: 6),
                          _BalanceChip(prefix: '- ', value: expenseSum),
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
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSizes.padding8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSizes.borderSM16),
                          color: AppColors.box
                        ),
                        child: ListTile(
                          title: Text(tx.categoryName ?? tx.title),
                          subtitle: Text(tx.accountName ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${tx.isIncome ? '+ ' : '- '}${Formatters.moneyStringFormatter(tx.amount.abs())} UZS',
                                style: TextStyle(
                                  color: tx.isIncome ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSizes.textSize14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () async {
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
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ),
            ),
          ]
          else if (_selectedTopTab == 1) ...[
            // Accounts tab
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocProvider(
                  create: (_) => AccountsListCubit(getItInstance<GetAccounts>())..load(),
                  child: BlocBuilder<AccountsListCubit, AccountsListState>(
                    builder: (context, state) {
                      if (state.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.accounts.isEmpty) {
                        return const Center(child: Text('No accounts'));
                      }
                      final int sum = state.accounts.fold(0, (acc, a) => acc + a.balance);
                      if (sum != _accountsBalance) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) setState(() => _accountsBalance = sum);
                        });
                      }
                      return ListView.separated(
                        itemCount: state.accounts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                              if (changed == true && mounted) {
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
              ),
            ),
          ]
          else if (_selectedTopTab == 2) ...[
            // Budget tab
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _isLoadingCategories
                    ? const Center(child: CircularProgressIndicator())
                    : _expenseCategories.isEmpty
                        ? const Center(
                            child: Text(
                              'No expense categories found.\nCreate some categories to track your budget.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _expenseCategories.length,
                            itemBuilder: (context, index) {
                              final category = _expenseCategories[index];
                              // Calculate spent amount for this category (placeholder logic)
                              final spent = _getCategorySpent(category.id);
                              final budget = _getCategoryBudget(category.id);
                              
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _BudgetCategoryCard(
                                  title: category.name,
                                  spent: spent,
                                  budget: budget,
                                  onEdit: () async {
                                    final changed = await showModalBottomSheet(
                                      context: context,
                                      useSafeArea: true,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                                      builder: (_) => EditCategoryModal(category: category),
                                    );
                                    if (changed == true) {
                                      _loadExpenseCategories();
                                    }
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ),
          ]
          else ...[
            // Goals tab
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocProvider.value(
                  value: _goalsCubit,
                  child: BlocBuilder<GoalsCubit, GoalsState>(
                    builder: (context, state) {
                      if (state.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.goals.isEmpty) {
                        return const Center(child: Text('No goals yet'));
                      }
                      return ListView.builder(
                        itemCount: state.goals.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _GoalCardBudgetTab(goal: state.goals[index]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: FloatingActionButton(
          onPressed: () {
            if (_selectedTopTab == 0) {
              // History -> Add transaction
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
            } else if (_selectedTopTab == 1) {
              // Accounts -> Add account
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => const AddAccountModal(),
              ).then((_) => _loadTotalBalance());
            } else if (_selectedTopTab == 2) {
              // Budget -> Add purchase category (with budget)
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => const AddCategoryModal(type: CategoryType.purchase),
              );
            } else if (_selectedTopTab == 3) {
              // Goals -> Add goal modal
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => const AddGoalModal(),
              ).then((_) {
                if (mounted) {
                  _goalsCubit.load();
                }
              });
            }
          },
          backgroundColor: AppColors.textSecondary,
          child: const Icon(Icons.add_outlined, color: AppColors.surface, size: 28),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
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

class _BalanceChip extends StatefulWidget {
  final String prefix; // '+ ' or '- '
  final int value; // in UZS
  const _BalanceChip({required this.prefix, required this.value});

  @override
  State<_BalanceChip> createState() => _BalanceChipState();
}

class _BalanceChipState extends State<_BalanceChip> {
  late int _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant _BalanceChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.def.withOpacity(0.2), width: 2.0),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.box
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: _previousValue.toDouble(), end: widget.value.toDouble()),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, child) {
          final int current = animatedValue.round();
          return Text(
            '${widget.prefix}${Formatters.moneyStringFormatter(current)} UZS',
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }
}

class _AnimatedAmount extends StatefulWidget {
  final int value;
  final String prefix;
  final String suffix;
  final TextStyle style;
  const _AnimatedAmount({
    required this.value,
    this.prefix = '',
    this.suffix = '',
    required this.style,
  });

  @override
  State<_AnimatedAmount> createState() => _AnimatedAmountState();
}

class _AnimatedAmountState extends State<_AnimatedAmount> {
  late int _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant _AnimatedAmount oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: _previousValue.toDouble(), end: widget.value.toDouble()),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        final int current = animatedValue.round();
        return Text(
          '${widget.prefix}${Formatters.moneyStringFormatter(current)}${widget.suffix}',
          style: widget.style,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        );
      },
    );
  }
}

class _TopSegmentedBar extends StatefulWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _TopSegmentedBar({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  State<_TopSegmentedBar> createState() => _TopSegmentedBarState();
}

class _TopSegmentedBarState extends State<_TopSegmentedBar> {
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant _TopSegmentedBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _current = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.def.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.borderSM16),
      ),
      padding: const EdgeInsets.all(AppSizes.paddingS),
      child: SizedBox(
        height: 44,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final int count = widget.items.length;
            final double segmentWidth = constraints.maxWidth / count;
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  left: segmentWidth * _current,
                  top: 0,
                  width: segmentWidth,
                  height: 44,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.paddingM),
                    ),
                  ),
                ),
                Row(
                  children: List.generate(count, (index) {
                    final bool isSelected = index == _current;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _current = index);
                          widget.onSelected(index);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            ),
                            child: Text(widget.items[index]),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BudgetCategoryCard extends StatelessWidget {
  final String title;
  final int spent;
  final int budget;
  final VoidCallback onEdit;

  const _BudgetCategoryCard({
    required this.title,
    required this.spent,
    required this.budget,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = budget > 0 ? (spent / budget) : 0.0;
    final int remaining = budget - spent;
    final bool isOverBudget = spent > budget;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderSM16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                child: const Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: \$${spent}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Budget: \$${budget}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isOverBudget ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(percentage * 100).toStringAsFixed(1)}% used',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                '\$${remaining.abs()} ${remaining >= 0 ? 'remaining' : 'over budget'}',
                style: TextStyle(
                  fontSize: 12,
                  color: remaining >= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: meta.bg,
            child: Icon(meta.icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: meta.chipBg,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(meta.label, style: TextStyle(color: meta.chipText, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$valuePrefix${Formatters.moneyStringFormatter(valueAbs)} UZS',
                      style: TextStyle(color: valueColor, fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () async {
                        final changed = await showModalBottomSheet(
                          context: context,
                          useSafeArea: true,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                          builder: (_) => EditAccountModal(account: acc),
                        );
                        if (changed == true && context.mounted) {
                          try { context.read<AccountsListCubit>().load(); } catch (_) {}
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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

class _GoalCardBudgetTab extends StatelessWidget {
  final goal_model.Goal goal;
  const _GoalCardBudgetTab({required this.goal});

  @override
  Widget build(BuildContext context) {
    final int target = goal.targetAmount;
    final int current = goal.currentAmount;
    final double progress = target == 0 ? 0 : (current / target).clamp(0, 1).toDouble();
    final int remaining = (target - current).clamp(0, target);
    final DateTime? targetDate = goal.targetDate != null ? DateTime.tryParse(goal.targetDate!) : null;
    final int? daysDiff = targetDate != null ? DateTime.now().difference(targetDate).inDays : null;
    final bool overdue = daysDiff != null && daysDiff > 0 && remaining > 0;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: AppColors.box,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.def.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(goal.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () async {
                  final changed = await showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                    builder: (_) => EditGoalModal(goal: goal),
                  );
                  if (changed == true && context.mounted) {
                    try { context.read<GoalsCubit>().load(); } catch (_) {}
                  }
                },
              ),
            ],
          ),
          if (targetDate != null) ...[
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.event, size: 16),
              const SizedBox(width: 6),
              Text('Target: ${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}'),
            ]),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Progress'),
              Text('${(progress * 100).toStringAsFixed(1)}%'),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${Formatters.moneyStringFormatter(current)} UZS', style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${Formatters.moneyStringFormatter(target)} UZS', style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Remaining'),
              if (daysDiff != null)
                Text(
                  overdue ? '${daysDiff} days overdue' : '${(-daysDiff)} days left',
                  style: TextStyle(color: overdue ? Colors.red : Colors.black54),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text('${Formatters.moneyStringFormatter(remaining)} to go', style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
