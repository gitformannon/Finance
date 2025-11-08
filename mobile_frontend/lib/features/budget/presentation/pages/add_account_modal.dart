import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Finance/core/di/get_it.dart';
import '../cubit/account_cubit.dart';
import '../widgets/budget_dropdown_field.dart';
import '../widgets/budget_input_field.dart';
import '../../../shared/presentation/widgets/app_buttons/save_button.dart';
import '../../../shared/presentation/widgets/bottom_sheet_models/w_bottom_widget.dart';
import '../../../../core/widgets/emoji_picker/emoji_picker_button.dart';

class AddAccountModal extends StatefulWidget {
  const AddAccountModal({super.key});

  static Future<T?> show<T>(BuildContext context) {
    return _AddAccountModalSheet().show<T>(context);
  }

  @override
  State<AddAccountModal> createState() => _AddAccountModalState();
}

class _AddAccountModalSheet with BaseBottomSheet {
  Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => BlocProvider(
        create: (_) => getItInstance<AccountCubit>(),
        child: const AddAccountModal(),
      ),
    );
  }
}

class _AddAccountModalState extends State<AddAccountModal> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _institutionController = TextEditingController();
  final _balanceController = TextEditingController();

  final Map<int, String> _types = const {
    1: 'Debit card',
    2: 'Credit card',
    3: 'Savings',
    4: 'Investment',
    5: 'Cash',
    6: 'Other',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _institutionController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        final cubit = context.read<AccountCubit>();
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
              Expanded(
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.only(bottom: viewInsets),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.box, AppColors.box],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingM.w,
                              vertical: AppSizes.spaceS12.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: AppSizes.spaceM16.h,
                                  ),
                                  child: Text(
                                    'Add account',
                                    style: TextStyle(
                                      fontSize: AppSizes.textSize20,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: BudgetInputField(
                                        label: 'Name',
                                        controller: _nameController,
                                        onChanged: cubit.setName,
                                      ),
                                    ),
                                    SizedBox(width: AppSizes.spaceM16.w),
                                    EmojiPickerButton(
                                      selectedEmoji: state.emoji,
                                      onEmojiSelected: cubit.setEmoji,
                                      size: 48,
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.spaceM16.h),
                                BudgetInputField(
                                  label: 'Account number',
                                  controller: _numberController,
                                  onChanged: cubit.setNumber,
                                ),
                                SizedBox(height: AppSizes.spaceM16.h),
                                BudgetInputField(
                                  label: 'Institution (Bank)',
                                  controller: _institutionController,
                                  onChanged: cubit.setInstitution,
                                ),
                                SizedBox(height: AppSizes.spaceM16.h),
                                BudgetDropdownField<int>(
                                  label: 'Account type',
                                  value: state.type,
                                  hintText: 'Select account type',
                                  onChanged: cubit.setType,
                                  items: _types.entries
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.key,
                                          child: Text(e.value),
                                        ),
                                      )
                                      .toList(),
                                ),
                                SizedBox(height: AppSizes.spaceM16.h),
                                BudgetInputField(
                                  label: 'Initial balance',
                                  controller: _balanceController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) =>
                                      cubit.setBalance(int.tryParse(v) ?? 0),
                                ),
                                SizedBox(height: AppSizes.spaceM16.h),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: AppSizes.paddingM.w,
                            right: AppSizes.paddingM.w,
                            bottom: bottomPadding,
                            top: AppSizes.spaceS12.h,
                          ),
                          child: SaveButton(
                            onPressed: cubit.submit,
                            isDisabled:
                                state.name.isEmpty || state.status.isLoading(),
                            isLoading: state.status.isLoading(),
                          ),
                        ),
                      ],
                    ),
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
