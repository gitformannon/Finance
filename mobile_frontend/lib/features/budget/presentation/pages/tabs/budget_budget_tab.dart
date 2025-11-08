import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/helpers/enums_helpers.dart';
import '../../cubit/categories_list_cubit.dart';
import '../../cubit/category_spending_cubit.dart';
import '../../cubit/budget_cubit.dart';
import '../../widgets/budget_category_card.dart';
import '../edit_category_modal.dart';

class BudgetBudgetTab extends StatefulWidget {
  const BudgetBudgetTab({super.key});

  @override
  State<BudgetBudgetTab> createState() => _BudgetBudgetTabState();
}

class _BudgetBudgetTabState extends State<BudgetBudgetTab> {
  bool _showUnbudgeted = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<CategoriesListCubit, CategoriesListState>(
          builder: (context, categoriesState) {
            if (categoriesState.status == RequestStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            final expenseCategories = categoriesState.expenseCategories;
            
            if (expenseCategories.isEmpty) {
              return const Center(
                child: Text(
                  'No expense categories found.\nCreate some categories to track your budget.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            // Ensure category spending is loaded for current month
            final selectedDate = context.watch<BudgetCubit>().state.selectedDate;
            context.read<CategorySpendingCubit>().loadMonthlyCategorySpent(selectedDate);

            final planned = expenseCategories.where((c) => (c.budget ?? 0) > 0).toList();
            final unbudgeted = expenseCategories.where((c) => (c.budget ?? 0) <= 0).toList();

            return ListView(
              children: [
                // Toggle header for categories with no budget
                GestureDetector(
                  onTap: () => setState(() => _showUnbudgeted = !_showUnbudgeted),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.def.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.borderSM16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Categories without budget (${unbudgeted.length})',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(_showUnbudgeted ? Icons.expand_less : Icons.expand_more),
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: unbudgeted.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.box,
                              borderRadius: BorderRadius.circular(AppSizes.borderSM16),
                              border: Border.all(color: AppColors.def.withValues(alpha: 0.2)),
                            ),
                            child: const Text('All expense categories have a budget', style: TextStyle(color: Colors.black54)),
                          )
                        : Column(
                            children: unbudgeted.map((category) {
                              return Container(
                                key: ValueKey('unbudgeted-${category.id}'),
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.box,
                                  borderRadius: BorderRadius.circular(AppSizes.borderSM16),
                                  border: Border.all(color: AppColors.def.withValues(alpha: 0.2)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(category.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                                    TextButton(
                                      onPressed: () async {
                                        final changed = await showModalBottomSheet(
                                          context: context,
                                          useSafeArea: true,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                                          builder: (_) => EditCategoryModal(category: category),
                                        );
                                        if (changed == true) {
                                          context.read<CategoriesListCubit>().refresh();
                                        }
                                      },
                                      child: const Text('Set budget'),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  crossFadeState: _showUnbudgeted ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
                const SizedBox(height: 8),
                // Planned budgets list
                ...planned.map((category) {
                  return BlocBuilder<CategorySpendingCubit, CategorySpendingState>(
                    builder: (context, spendingState) {
                      final spent = spendingState.getCategorySpent(category.id);
                      final budget = category.budget ?? 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: BudgetCategoryCard(
                          key: ValueKey('planned-${category.id}'),
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
                              context.read<CategoriesListCubit>().refresh();
                            }
                          },
                        ),
                      );
                    },
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}

