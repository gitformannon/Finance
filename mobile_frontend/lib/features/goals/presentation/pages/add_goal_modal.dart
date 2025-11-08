import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/get_it.dart';
import '../../presentation/cubit/goals_cubit.dart';
import 'package:Finance/features/shared/presentation/widgets/bottom_sheet_models/w_bottom_widget.dart';
import '../../../../core/widgets/emoji_picker/emoji_picker_button.dart';

class AddGoalModal extends StatefulWidget {
  const AddGoalModal({super.key});

  static Future<T?> show<T>(BuildContext context) {
    return _AddGoalModalSheet().show<T>(context);
  }

  @override
  State<AddGoalModal> createState() => _AddGoalModalState();
}

class _AddGoalModalSheet with BaseBottomSheet {
  Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => BlocProvider(
        create: (_) => getItInstance<GoalsCubit>(),
        child: const AddGoalModal(),
      ),
    );
  }
}

class _AddGoalModalState extends State<AddGoalModal> {
  final _nameCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  DateTime? _targetDate;
  String? _selectedEmoji;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsCubit, GoalsState>(
      builder: (context, state) {
        final media = MediaQuery.of(context);
        final viewInsets = media.viewInsets.bottom;
        final bottomPadding =
            viewInsets > 0 ? AppSizes.spaceM16 : media.padding.bottom;

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.box,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.spaceM16),
              topRight: Radius.circular(AppSizes.spaceM16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Divider
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: AppSizes.spaceS12),
                decoration: BoxDecoration(
                  color: AppColors.def.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.only(bottom: viewInsets),
                child: Container(
                  width: double.infinity,
                  color: AppColors.box,
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _nameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Goal name',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          EmojiPickerButton(
                            selectedEmoji: _selectedEmoji,
                            onEmojiSelected: (emoji) {
                              setState(() => _selectedEmoji = emoji);
                            },
                            size: 48,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _targetCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Target amount (UZS)',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            _targetDate == null
                                ? 'No date'
                                : '${_targetDate!.year}-${_targetDate!.month.toString().padLeft(2, '0')}-${_targetDate!.day.toString().padLeft(2, '0')}',
                          ),
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
                              if (picked != null) {
                                setState(() => _targetDate = picked);
                              }
                            },
                            child: const Text('Pick date'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsets.only(bottom: bottomPadding),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final name = _nameCtrl.text.trim();
                                  final target =
                                      int.tryParse(_targetCtrl.text.trim()) ?? 0;
                                  final dateStr = _targetDate != null
                                      ? '${_targetDate!.year.toString().padLeft(4, '0')}-${_targetDate!.month.toString().padLeft(2, '0')}-${_targetDate!.day.toString().padLeft(2, '0')}'
                                      : null;
                                  if (name.isNotEmpty && target > 0) {
                                    await context.read<GoalsCubit>().create(
                                          name,
                                          target,
                                          targetDate: dateStr,
                                          emoji: _selectedEmoji,
                                        );
                                    if (context.mounted) Navigator.pop(context);
                                  }
                                },
                                child: const Text('Create'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
