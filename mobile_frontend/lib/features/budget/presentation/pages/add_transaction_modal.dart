import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/core/themes/app_text_styles.dart';
import 'package:Finance/features/budget/presentation/widgets/add_category_item.dart';
import 'package:Finance/features/budget/presentation/widgets/bottom_datepicker_modal.dart';
import 'package:Finance/features/budget/presentation/widgets/bottom_note_modal.dart';
import 'package:Finance/features/budget/presentation/widgets/budget_dropdown_field.dart';
import 'package:Finance/features/budget/presentation/widgets/category_item.dart';
import 'package:Finance/features/budget/presentation/widgets/transaction_type_button.dart';
import 'package:Finance/features/budget/presentation/widgets/transfer_account_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/transaction_cubit.dart';
import '../../../shared/presentation/widgets/app_buttons/save_button.dart';
import '../../../shared/presentation/widgets/bottom_sheet_models/w_bottom_widget.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/helpers/enums_helpers.dart';
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
  late final CurrencyTextInputFormatter _amountFormatter;

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
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  double _parseAmount(String text) {
    final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return 0;
    try {
      return double.parse(digitsOnly);
    } catch (_) {
      return 0;
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
      },
      builder: (context, state) {
        final cubit = context.read<TransactionCubit>();
        final media = MediaQuery.of(context);
        final viewInsets = media.viewInsets.bottom;
        final bottomPadding =
            viewInsets > 0 ? AppSizes.spaceM16.h : media.padding.bottom;

        return SafeArea(
          top: false,
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
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.background, AppColors.background],
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
                            _buildAccountDropdown(state, cubit),
                            SizedBox(height: AppSizes.spaceM16.h),
                            _buildTypeSelector(state, cubit),
                            SizedBox(height: AppSizes.spaceM16.h),
                            _buildAmountInput(cubit),
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
                            SizedBox(height: AppSizes.spaceXL24.h),
                            if (state.type == TransactionType.transfer)
                              _buildTransferAccounts(cubit, state)
                            else
                              _buildCategoryGrid(cubit, state),
                            SizedBox(height: AppSizes.spaceXL24.h),
                          ],
                        ),
                      ),
                    ),
                    BlocBuilder<TransactionCubit, TransactionState>(
                      builder: (context, submitState) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: AppSizes.paddingM.w,
                            right: AppSizes.paddingM.w,
                            bottom: bottomPadding,
                            top: AppSizes.spaceS12.h,
                          ),
                          child: SaveButton(
                            onPressed: () {
                              final value = _parseAmount(
                                _amountController.text,
                              );
                              cubit.setAmount(value);
                              cubit.submit();
                            },
                            isDisabled:
                                !submitState.isValid ||
                                submitState.status.isLoading(),
                            isLoading: submitState.status.isLoading(),
                          ),
                        );
                      },
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

  Widget _buildAccountDropdown(TransactionState state, TransactionCubit cubit) {
    return BudgetDropdownField<String>(
      label: 'Account',
      value: state.accountId.isNotEmpty ? state.accountId : null,
      hintText: 'Select account',
      onChanged: (val) => cubit.setAccountId(val ?? ''),
      items:
          state.accounts
              .map(
                (a) => DropdownMenuItem(
                  value: a.id,
                  child: Text(a.name ?? 'Account'),
                ),
              )
              .toList(),
    );
  }

  Widget _buildTypeSelector(TransactionState state, TransactionCubit cubit) {
    return Row(
      children: [
        TransactionTypeButton(
          title: 'Income',
          titleColor: AppColors.textSecondary,
          selectedTitleColor: AppColors.surface,
          boxColor: AppColors.def.withValues(alpha: 0.2),
          selectedBoxColor: AppColors.accent,
          boxBorderColor: AppColors.def,
          selectedBoxBorderColor: AppColors.accent,
          selected: state.type == TransactionType.income,
          onTap: () {
            cubit.setType(TransactionType.income);
            cubit.loadCategories();
          },
        ),
        SizedBox(width: AppSizes.spaceXXS5.w),
        TransactionTypeButton(
          title: 'Purchase',
          titleColor: AppColors.textSecondary,
          selectedTitleColor: AppColors.surface,
          boxColor: AppColors.def.withValues(alpha: 0.2),
          selectedBoxColor: AppColors.accent,
          boxBorderColor: AppColors.def,
          selectedBoxBorderColor: AppColors.accent,
          selected: state.type == TransactionType.purchase,
          onTap: () {
            cubit.setType(TransactionType.purchase);
            cubit.loadCategories();
          },
        ),
        SizedBox(width: AppSizes.spaceXXS5.w),
        TransactionTypeButton(
          title: 'Transfer',
          titleColor: AppColors.textSecondary,
          selectedTitleColor: AppColors.surface,
          boxColor: AppColors.def.withValues(alpha: 0.2),
          selectedBoxColor: AppColors.accent,
          boxBorderColor: AppColors.def,
          selectedBoxBorderColor: AppColors.accent,
          selected: state.type == TransactionType.transfer,
          onTap: () {
            cubit.setType(TransactionType.transfer);
            cubit.loadAccounts();
          },
        ),
      ],
    );
  }

  Widget _buildAmountInput(TransactionCubit cubit) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _amountFocusNode.hasFocus ? AppColors.accent : AppColors.def,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              inputFormatters: [_amountFormatter],
              textAlign: TextAlign.right,
              onChanged: (v) => cubit.setAmount(_parseAmount(v)),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              focusNode: _amountFocusNode,
              decoration: const InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(
                  color: AppColors.def,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: AppSizes.spaceXS8.w),
            child: const Text(
              'UZS',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferAccounts(
    TransactionCubit cubit,
    TransactionState state,
  ) {
    return Column(
      children: [
        for (final acc in state.accounts)
          Container(
            margin: const EdgeInsets.only(bottom: AppSizes.padding8),
            child: AccountCardButton(
              iconColor: AppColors.box,
              selectedIconColor: AppColors.accent,
              iconBoxColor: AppColors.def.withValues(alpha: 0.1),
              selectedIconBoxColor: AppColors.surface,
              titleColor: AppColors.textPrimary,
              selectedTitleColor: AppColors.surface,
              boxColor: AppColors.def.withValues(alpha: 0.2),
              selectedBoxColor: AppColors.accent,
              boxBorderColor: AppColors.def,
              selectedBoxBorderColor: AppColors.accent,
              title: acc.name ?? 'Account',
              subtitle: acc.number ?? '',
              icon: 'assets/svg/ic_more.svg',
              selected: cubit.state.toAccountId == acc.id,
              onTap: () => cubit.setToAccountId(acc.id),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryGrid(TransactionCubit cubit, TransactionState state) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: AppSizes.space3,
      mainAxisSpacing: AppSizes.space3,
      children: [
        for (final cat in state.categories)
          CategoryItem(
            icon: 'assets/svg/ic_global.svg',
            iconColor: AppColors.box,
            selectedIconColor: AppColors.accent,
            iconBoxColor: AppColors.def.withValues(alpha: 0.1),
            selectedIconBoxColor: AppColors.surface,
            title: cat.name,
            titleColor: AppColors.textPrimary,
            selectedTitleColor: AppColors.surface,
            boxColor: AppColors.def.withValues(alpha: 0.2),
            selectedBoxColor: AppColors.accent,
            boxBorderColor: AppColors.def,
            selectedBoxBorderColor: AppColors.accent,
            selected: cubit.state.categoryId == cat.id,
            onTap: () => cubit.setCategoryId(cat.id),
          ),
        AddCategoryItem(
          boxColor: AppColors.def.withValues(alpha: 0.2),
          boxBorderColor: AppColors.def,
          type:
              state.type == TransactionType.income
                  ? CategoryType.income
                  : state.type == TransactionType.purchase
                  ? CategoryType.purchase
                  : null,
          onCategoryAdded: cubit.loadCategories,
        ),
      ],
    );
  }
}
