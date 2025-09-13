import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/get_it.dart';
import '../../data/model/goal.dart';
import '../cubit/goals_cubit.dart';

class EditGoalModal extends StatefulWidget {
  final Goal goal;
  const EditGoalModal({super.key, required this.goal});

  @override
  State<EditGoalModal> createState() => _EditGoalModalState();
}

class _EditGoalModalState extends State<EditGoalModal> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _targetCtrl;
  DateTime? _targetDate;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.goal.name);
    _targetCtrl = TextEditingController(text: widget.goal.targetAmount.toString());
    _targetDate = widget.goal.targetDate != null ? DateTime.tryParse(widget.goal.targetDate!) : null;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    try {
      final name = _nameCtrl.text.trim();
      final target = int.tryParse(_targetCtrl.text.trim());
      String? dateStr;
      if (_targetDate != null) {
        dateStr = '${_targetDate!.year.toString().padLeft(4, '0')}-${_targetDate!.month.toString().padLeft(2, '0')}-${_targetDate!.day.toString().padLeft(2, '0')}';
      }
      await context.read<GoalsCubit>().update(id: widget.goal.id, name: name.isEmpty ? null : name, targetAmount: target, targetDate: dateStr);
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getItInstance<GoalsCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        body: SafeArea(
          top: false,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppSizes.borderSM16), topRight: Radius.circular(AppSizes.borderSM16)),
            child: Container(
              color: AppColors.box,
              padding: const EdgeInsets.all(AppSizes.paddingM),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Goal name')),
                  const SizedBox(height: 12),
                  TextField(controller: _targetCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Target amount (UZS)')),
                  const SizedBox(height: 12),
                  Row(children: [
                    Text(_targetDate == null ? 'No date' : '${_targetDate!.year}-${_targetDate!.month.toString().padLeft(2, '0')}-${_targetDate!.day.toString().padLeft(2, '0')}'),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(context: context, firstDate: DateTime(now.year - 1), lastDate: DateTime(now.year + 10), initialDate: _targetDate ?? now);
                        if (picked != null) setState(() => _targetDate = picked);
                      },
                      child: const Text('Pick date'),
                    )
                  ]),
                  const SizedBox(height: 16),
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _saving ? null : _submit, child: _saving ? const CircularProgressIndicator() : const Text('Save')))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

