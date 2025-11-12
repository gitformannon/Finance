import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/features/budget/presentation/widgets/bottom_datepicker_modal.dart';
import 'package:Finance/features/budget/presentation/widgets/bottom_note_modal.dart';
import 'package:Finance/features/budget/presentation/widgets/transaction_error_banner.dart';
import 'package:Finance/features/budget/presentation/widgets/transaction_account_dropdown.dart';
import 'package:Finance/features/budget/presentation/widgets/transaction_type_selector.dart';
import 'package:Finance/features/budget/presentation/widgets/transaction_amount_input.dart';
import 'package:Finance/features/budget/presentation/widgets/transaction_transfer_accounts_list.dart';
import 'package:Finance/features/budget/presentation/widgets/transaction_category_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/transaction_cubit.dart';
import '../../../shared/presentation/widgets/app_buttons/save_button.dart';
import '../../../../core/helpers/formatters_helpers.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({super.key});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _isAmountFocused = ValueNotifier<bool>(false);
  late final CurrencyTextInputFormatter _amountFormatter;
  bool _isUpdatingController = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<TransactionCubit>();
    cubit.loadAccounts();
    cubit.loadCategories();
    _amountFormatter = Formatters.currencyFormatter(
      locale: 'ru',
      decimalDigits: 0,
    );
    _amountFocusNode.addListener(() {
      _isAmountFocused.value = _amountFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    _isAmountFocused.dispose();
    super.dispose();
  }

  void _updateAmountControllerFromState(double amount) {
    if (!_isUpdatingController) {
      final formatted = amount > 0 ? _amountFormatter.formatDouble(amount) : '';
      if (_amountController.text != formatted) {
        _isUpdatingController = true;
        _amountController.text = formatted;
        _isUpdatingController = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state.status.isLoaded()) {
          FocusScope.of(context).unfocus();
          Navigator.of(context).maybePop();
        }
        // Sync controller with cubit state when amount changes externally
        if (!_amountFocusNode.hasFocus) {
          _updateAmountControllerFromState(state.amount);
        }
      },
      builder: (context, state) {
        final cubit = context.read<TransactionCubit>();
        final media = MediaQuery.of(context);
        final viewInsets = media.viewInsets.bottom;
        final bottomPadding =
            viewInsets > 0 ? AppSizes.spaceM16.h : media.padding.bottom;
        
        // Show error message if present
        final hasError = state.errorMessage.isNotEmpty && state.status.isError();

        return SafeArea(
          top: false,
          bottom: false,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.only(bottom: viewInsets),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSizes.borderSM16),
                topRight: Radius.circular(AppSizes.borderSM16),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background
                ),
                child: Stack(
                  children: [
                    // Main content
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Sticky section at the top
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingM.w,
                            vertical: AppSizes.spaceS12.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasError)
                                TransactionErrorBanner(errorMessage: state.errorMessage),
                              TransactionAccountDropdown(state: state, cubit: cubit),
                              SizedBox(height: AppSizes.spaceM16.h),
                              TransactionTypeSelector(state: state, cubit: cubit),
                              TransactionAmountInput(
                                cubit: cubit,
                                isFocused: _isAmountFocused,
                                controller: _amountController,
                                focusNode: _amountFocusNode,
                                isUpdatingController: _isUpdatingController,
                              ),
                              SizedBox(height: AppSizes.spaceM16.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: BottomDatepickerField(
                                      date: state.date,
                                      onSelect: cubit.setDate,
                                      maximumDate: DateTime.now(),
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.spaceXL24.w),
                                  Expanded(
                                    child: BottomNoteField(
                                      note: state.note,
                                      onSelect: cubit.setNote,
                                      onTap: _amountFocusNode.unfocus,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Scrollable section
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(
                              left: AppSizes.paddingM.w,
                              right: AppSizes.paddingM.w,
                              top: AppSizes.spaceS12.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state.type == TransactionType.transfer)
                                  TransactionTransferAccountsList(cubit: cubit, state: state)
                                else
                                  TransactionCategoryGrid(cubit: cubit, state: state),
                                SizedBox(height: AppSizes.spaceXL24.h),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Save button overlaying the content
                    // Button is enabled when:
                    // - Account is selected
                    // - Amount > 0
                    // - For transfer: transfer account is selected
                    // - For income/purchase: category is selected
                    Positioned(
                      left: AppSizes.paddingM.w,
                      right: AppSizes.paddingM.w,
                      bottom: bottomPadding,
                      child: SaveButton(
                        onPressed: () {
                          // Ensure amount is synced before submit
                          cubit.setAmountFromString(_amountController.text);
                          cubit.submit();
                        },
                        isDisabled: !state.isValid || state.status.isLoading(),
                        isLoading: state.status.isLoading(),
                        disabledBackgroundColor: AppColors.def,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
