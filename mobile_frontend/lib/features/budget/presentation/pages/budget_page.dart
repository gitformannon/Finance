import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/get_it.dart';
import '../cubit/budget_cubit.dart';
import '../cubit/accounts_list_cubit.dart';
import '../cubit/monthly_totals_cubit.dart';
import '../cubit/category_spending_cubit.dart';
import '../cubit/categories_list_cubit.dart';
import '../cubit/transaction_cubit.dart';
import '../widgets/budget_summary_header.dart';
import '../widgets/top_segmented_bar.dart';
import 'tabs/budget_history_tab.dart';
import 'tabs/budget_accounts_tab.dart';
import 'tabs/budget_budget_tab.dart';
import 'tabs/budget_goals_tab.dart';
import '../../../goals/presentation/cubit/goals_cubit.dart';
import 'add_transaction_modal.dart';
import 'add_account_modal.dart';
import 'add_category_modal.dart';
import '../../../goals/presentation/pages/add_goal_modal.dart';
import '../../../../core/helpers/enums_helpers.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> with TickerProviderStateMixin {
  late final PageController _weekPageController;
  static const int _initialPage = 100000; // large center for practical infinity
  static const int _centerPage = _initialPage;

  int _selectedTopTab = 0; // 0: History, 1: Accounts, 2: Budget, 3: Goals

  // Anchor Monday to compute page indices. 2000-01-03 is a Monday.
  final DateTime _anchorMonday = DateTime(2000, 1, 3);

  // Cubits
  late final AccountsListCubit _accountsListCubit;
  late final MonthlyTotalsCubit _monthlyTotalsCubit;
  late final CategorySpendingCubit _categorySpendingCubit;
  late final CategoriesListCubit _categoriesListCubit;
  late final GoalsCubit _goalsCubit;
  
  // Track last loaded dates to avoid redundant calls
  DateTime? _lastMonthlyTotalsDate;
  DateTime? _lastCategorySpendingDate;

  DateTime _mondayOf(DateTime date) {
    final int weekday = date.weekday; // 1 Mon ... 7 Sun
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: weekday - 1));
  }

  @override
  void initState() {
    super.initState();
    final DateTime todayMonday = _mondayOf(DateTime.now());
    final int weekDelta = todayMonday.difference(_anchorMonday).inDays ~/ 7;
    _weekPageController = PageController(initialPage: _centerPage + weekDelta);

    // Initialize cubits
    _accountsListCubit = getItInstance<AccountsListCubit>()..load();
    _monthlyTotalsCubit = getItInstance<MonthlyTotalsCubit>();
    _categorySpendingCubit = getItInstance<CategorySpendingCubit>();
    _categoriesListCubit = getItInstance<CategoriesListCubit>();
    _goalsCubit = getItInstance<GoalsCubit>();

    // Load initial data
    final now = DateTime.now();
    context.read<BudgetCubit>().load(now);
    _monthlyTotalsCubit.loadMonthlyTotals(now);
    _lastMonthlyTotalsDate = now;
    _categoriesListCubit.loadExpenseCategories();
    
    // Balance is now handled reactively via BlocBuilder in BudgetSummaryHeader
  }

  @override
  void dispose() {
    _goalsCubit.close();
    _accountsListCubit.close();
    _monthlyTotalsCubit.close();
    _categorySpendingCubit.close();
    _categoriesListCubit.close();
    _weekPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sync monthly totals with selected date (only if date changed)
    final DateTime selectedDate = context.watch<BudgetCubit>().state.selectedDate;
    
    // Only load if date changed to avoid redundant calls
    if (_lastMonthlyTotalsDate == null || 
        _lastMonthlyTotalsDate!.year != selectedDate.year || 
        _lastMonthlyTotalsDate!.month != selectedDate.month) {
      _monthlyTotalsCubit.loadMonthlyTotals(selectedDate);
      _lastMonthlyTotalsDate = selectedDate;
    }
    
    if (_lastCategorySpendingDate == null || 
        _lastCategorySpendingDate!.year != selectedDate.year || 
        _lastCategorySpendingDate!.month != selectedDate.month) {
      _categorySpendingCubit.loadMonthlyCategorySpent(selectedDate);
      _lastCategorySpendingDate = selectedDate;
    }

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Summary header
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: _monthlyTotalsCubit),
                BlocProvider.value(value: _accountsListCubit),
              ],
              child: BudgetSummaryHeader(),
            ),
            const SizedBox(height: 12),
            // Tab selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TopSegmentedBar(
                items: const ['History', 'Accounts', 'Budget', 'Goals'],
                selectedIndex: _selectedTopTab,
                onSelected: (idx) {
                  setState(() => _selectedTopTab = idx);
                  if (idx == 2) {
                    // Ensure categories are fresh when opening Budget tab
                    _categoriesListCubit.loadExpenseCategories();
                    final selectedDate = context.read<BudgetCubit>().state.selectedDate;
                    _categorySpendingCubit.loadMonthlyCategorySpent(selectedDate);
                    _lastCategorySpendingDate = selectedDate;
                  }
                  if (idx == 3) {
                    _goalsCubit.load();
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            // Tab content
            Expanded(
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: FloatingActionButton(
          heroTag: "budget_fab",
          onPressed: () => _handleFabPressed(),
          backgroundColor: AppColors.textSecondary,
          child: const Icon(Icons.add_outlined, color: AppColors.surface, size: 28),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTopTab) {
      case 0:
        return BlocProvider.value(
          value: _accountsListCubit,
          child: BudgetHistoryTab(
            weekPageController: _weekPageController,
            mondayOf: _mondayOf,
            anchorMonday: _anchorMonday,
            centerPage: _centerPage,
          ),
        );
      case 1:
        return BlocProvider.value(
          value: _accountsListCubit,
          child: BudgetAccountsTab(),
        );
      case 2:
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _categoriesListCubit),
            BlocProvider.value(value: _categorySpendingCubit),
          ],
          child: const BudgetBudgetTab(),
        );
      case 3:
        return BlocProvider.value(
          value: _goalsCubit,
          child: const BudgetGoalsTab(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _handleFabPressed() {
    switch (_selectedTopTab) {
      case 0:
        // History -> Add transaction
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => BlocProvider(
            create: (_) => getItInstance<TransactionCubit>()
              ..loadAccounts()
              ..loadCategories(),
            child: const AddTransactionModal(),
          ),
        ).then((_) {
          _accountsListCubit.load();
        });
        break;
      case 1:
        // Accounts -> Add account
        AddAccountModal.show(context).then((_) {
          _accountsListCubit.load();
        });
        break;
      case 2:
        // Budget -> Add purchase category
        AddCategoryModal.show(context, type: CategoryType.purchase).then((_) {
          _categoriesListCubit.loadExpenseCategories();
        });
        break;
      case 3:
        // Goals -> Add goal
        AddGoalModal.show(context).then((_) {
          if (mounted) {
            _goalsCubit.load();
          }
        });
        break;
    }
  }
}

