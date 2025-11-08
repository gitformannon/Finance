import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/helpers/formatters_helpers.dart';

class BudgetCategoryCard extends StatelessWidget {
  final String title;
  final int spent;
  final int budget;
  final VoidCallback onEdit;

  const BudgetCategoryCard({
    super.key,
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

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        padding: const EdgeInsets.all(16),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: AppColors.def.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: ${Formatters.moneyStringFormatter(spent)} UZS',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Budget: ${Formatters.moneyStringFormatter(budget)} UZS',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Container(
                  height: 10,
                  color: Colors.grey.shade200,
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double w = constraints.maxWidth * percentage.clamp(0.0, 1.0);
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      width: w,
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isOverBudget
                              ? [Colors.red.shade300, Colors.red]
                              : [Colors.blue.shade300, Colors.blue],
                        ),
                      ),
                    );
                  },
                ),
              ],
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
                '${Formatters.moneyStringFormatter(remaining.abs())} UZS ${remaining >= 0 ? 'remaining' : 'over budget'}',
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
      ),
    );
  }
}

