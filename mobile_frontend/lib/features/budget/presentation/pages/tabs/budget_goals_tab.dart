import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/helpers/formatters_helpers.dart';
import '../../../../goals/presentation/cubit/goals_cubit.dart';
import '../../../../goals/data/model/goal.dart' as goal_model;
import '../../../../goals/presentation/pages/edit_goal_modal.dart';

class BudgetGoalsTab extends StatelessWidget {
  const BudgetGoalsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
              itemBuilder: (context, index) {
                final goal = state.goals[index];
                return Padding(
                  key: ValueKey('goal-${goal.id ?? goal.name}-$index'),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () async {
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
                    child: _GoalCardBudgetTab(goal: goal),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
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
        borderRadius: BorderRadius.circular(AppSizes.borderSM16),
        border: Border.all(color: AppColors.def, width: 1.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(goal.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              color: overdue ? Colors.red : AppColors.textPrimary,
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: overdue ? Colors.red.withValues(alpha: 0.1) : AppColors.def.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    overdue ? '$daysDiff days overdue' : '${-daysDiff} days left',
                    style: TextStyle(color: overdue ? Colors.red : Colors.black54),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text('${Formatters.moneyStringFormatter(remaining)} UZS to go', style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

