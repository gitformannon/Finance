import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/core/helpers/formatters_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/goal.dart';
import '../cubit/goals_cubit.dart';
import 'edit_goal_modal.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  void initState() {
    super.initState();
    context.read<GoalsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Goals'),
      ),
      body: BlocBuilder<GoalsCubit, GoalsState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.goals.isEmpty) {
            return const Center(child: Text('No goals yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            itemCount: state.goals.length,
            itemBuilder: (context, index) {
              final goal = state.goals[index];
              return GestureDetector(
                onLongPress: () async {
                  final changed = await showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                    builder: (_) => EditGoalModal(goal: goal),
                  );
                  if (changed == true && context.mounted) {
                    context.read<GoalsCubit>().load();
                  }
                },
                child: _GoalCard(goal: goal, onContribute: (amt) => context.read<GoalsCubit>().contribute(goal.id, amt)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "goals_fab",
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (ctx) => const _CreateGoalDialog(),
          );
        },
        backgroundColor: AppColors.textPrimary,
        child: const Icon(Icons.add, color: AppColors.surface),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final Goal goal;
  final void Function(int amount) onContribute;
  const _GoalCard({required this.goal, required this.onContribute});

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
      margin: const EdgeInsets.only(bottom: AppSizes.paddingL),
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: AppColors.box,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.def.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  goal.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
          const SizedBox(height: 14),
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
              Text('${Formatters.moneyStringFormatter(current)} UZS',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
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

          const SizedBox(height: 12),
          Row(
            children: [
              _ContribButton(label: '+100', onTap: () => onContribute(100)),
              const SizedBox(width: 10),
              _ContribButton(label: '+500', onTap: () => onContribute(500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContribButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ContribButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 2,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _CreateGoalDialog extends StatefulWidget {
  const _CreateGoalDialog();

  @override
  State<_CreateGoalDialog> createState() => _CreateGoalDialogState();
}

class _CreateGoalDialogState extends State<_CreateGoalDialog> {
  final _nameCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  DateTime? _targetDate;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Goal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _targetCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Target amount (UZS)'),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(_targetDate == null ? 'No date' : '${_targetDate!.year}-${_targetDate!.month.toString().padLeft(2, '0')}-${_targetDate!.day.toString().padLeft(2, '0')}'),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(context: context, firstDate: DateTime(now.year - 1), lastDate: DateTime(now.year + 10), initialDate: now);
                  if (picked != null) setState(() => _targetDate = picked);
                },
                child: const Text('Pick date'),
              )
            ],
          )
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            final name = _nameCtrl.text.trim();
            final target = int.tryParse(_targetCtrl.text.trim()) ?? 0;
            final dateStr = _targetDate != null ? '${_targetDate!.year.toString().padLeft(4, '0')}-${_targetDate!.month.toString().padLeft(2, '0')}-${_targetDate!.day.toString().padLeft(2, '0')}' : null;
            if (name.isNotEmpty && target > 0) {
              await context.read<GoalsCubit>().create(name, target, targetDate: dateStr);
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: const Text('Create'),
        )
      ],
    );
  }
}
