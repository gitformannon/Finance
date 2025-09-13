import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/get_it.dart';
import '../../presentation/cubit/goals_cubit.dart';

class AddGoalModal extends StatefulWidget {
  const AddGoalModal({super.key});

  @override
  State<AddGoalModal> createState() => _AddGoalModalState();
}

class _AddGoalModalState extends State<AddGoalModal> {
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
    return BlocProvider(
      create: (_) => getItInstance<GoalsCubit>(),
      child: BlocBuilder<GoalsCubit, GoalsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.transparent,
            body: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSizes.borderSM16),
                topRight: Radius.circular(AppSizes.borderSM16),
              ),
              child: Container(
                color: AppColors.box,
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Goal name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _targetCtrl,
                      decoration: const InputDecoration(labelText: 'Target amount (UZS)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(_targetDate == null
                            ? 'No date'
                            : '${_targetDate!.year}-${_targetDate!.month.toString().padLeft(2, '0')}-${_targetDate!.day.toString().padLeft(2, '0')}'),
                        const Spacer(),
                        TextButton(
                          onPressed: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime(now.year - 1),
                              lastDate: DateTime(now.year + 10),
                              initialDate: now,
                            );
                            if (picked != null) setState(() => _targetDate = picked);
                          },
                          child: const Text('Pick date'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final name = _nameCtrl.text.trim();
                              final target = int.tryParse(_targetCtrl.text.trim()) ?? 0;
                              final dateStr = _targetDate != null
                                  ? '${_targetDate!.year.toString().padLeft(4, '0')}-${_targetDate!.month.toString().padLeft(2, '0')}-${_targetDate!.day.toString().padLeft(2, '0')}'
                                  : null;
                              if (name.isNotEmpty && target > 0) {
                                await context.read<GoalsCubit>().create(name, target, targetDate: dateStr);
                                if (context.mounted) Navigator.pop(context);
                              }
                            },
                            child: const Text('Create'),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

