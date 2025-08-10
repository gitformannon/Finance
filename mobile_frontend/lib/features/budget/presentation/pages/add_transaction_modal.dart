import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

import '../../../shared/presentation/widgets/app_buttons/w_tile_button.dart';
import '../cubit/transaction_cubit.dart';
import '../../data/model/category.dart';
import '../../data/model/account.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';
import 'add_category_modal.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../../../shared/presentation/widgets/app_buttons/w_text_button.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({super.key});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<TransactionCubit>();
    cubit.loadAccounts();
    cubit.loadCategories();
    _amountFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  double _evaluate(String text) {
    try {
      final exp = Parser().parse(text);
      return exp.evaluate(EvaluationType.REAL, ContextModel()).toDouble();
    } catch (_) {
      return 0;
    }
  }

  void _insertText(String value, TransactionCubit cubit) {
    final selection = _amountController.selection;
    final newText =
        _amountController.text.replaceRange(selection.start, selection.end, value);
    final index = selection.start + value.length;
    _amountController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: index),
    );
    cubit.setAmount(_evaluate(newText));
  }

  Widget _buildKeyboardActions(TransactionCubit cubit) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSizes.paddingXS.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final op in ['+', '-', '*', '/'])
            WTextButton(
              text: op == '*' ? 'x' : op,
              onTap: () => _insertText(op, cubit),
            ),
          WTextButton(
            text: 'Done',
            onTap: () {
              final value = _evaluate(_amountController.text);
              _amountController
                ..text = value == value.roundToDouble()
                    ? value.toInt().toString()
                    : value.toString()
                ..selection = TextSelection.collapsed(
                    offset: _amountController.text.length);
              cubit.setAmount(value);
              _amountFocusNode.unfocus();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final cubit = context.read<TransactionCubit>();
        return Container(
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            top: true,
            bottom: false,
            child: Scaffold(
              extendBody: true,
              resizeToAvoidBottomInset: true,
              backgroundColor: AppColors.transparent,
              body: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.borderSM16),
                  topRight: Radius.circular(AppSizes.borderSM16),
                ),
                child: Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.background, AppColors.background],
                    ),
                  ),
                  child: Column(
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSizes.paddingXS.w,
                            horizontal: AppSizes.paddingM.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            DropdownButton<String>(
                              hint: Text('Main', style: AppTextStyles.bodyRegular),
                              menuMaxHeight: 100.h,
                              menuWidth: double.maxFinite,
                              alignment: Alignment.center,
                              underline: Container(),
                              elevation: 2,
                              dropdownColor: AppColors.primary,
                              focusColor: AppColors.secondary,
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(AppSizes.borderSM16),
                                  bottomLeft: Radius.circular(AppSizes.borderSM16)),
                              value: state.accountId.isNotEmpty ? state.accountId : null,
                              onChanged: (val) => cubit.setAccountId(val ?? ''),
                              items: state.accounts
                                .map(
                                  (a) => DropdownMenuItem(
                                    value: a.id,
                                    child: Text(a.name ?? 'Account'),
                                  ),
                                )
                                .toList(),
                            ),
                            Row(
                              children: [
                                _typeButton(context, cubit, TransactionType.income, 'Income'),
                                SizedBox(width: AppSizes.spaceXXS5.w),
                                _typeButton(context, cubit, TransactionType.purchase, 'Purchase'),
                                SizedBox(width: AppSizes.spaceXXS5.w),
                                _typeButton(context, cubit, TransactionType.transfer, 'Transfer'),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _amountFocusNode.hasFocus
                                      ? AppColors.accent
                                      : AppColors.def,
                                    width: _amountFocusNode.hasFocus ? 1 : 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment:
                                  CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _amountController,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.right,
                                      onChanged: (v) =>
                                          cubit.setAmount(_evaluate(v)),
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
                                    padding: EdgeInsets.only(
                                        left: AppSizes.spaceXS8.w),
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
                            ),
                            SizedBox(height: AppSizes.spaceM16.h),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _showCalendarPicker(context, cubit),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.def.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(AppSizes.borderSmall)
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(AppSizes.paddingS),
                                          child: Icon(
                                            Icons.calendar_today,
                                            size: 24,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: AppSizes.spaceXS8.w),
                                      Text(DateFormat('dd MMMM yyyy').format(state.date)),
                                    ],
                                  ),
                                ),
                                SizedBox(width: AppSizes.spaceXL24.w),
                                GestureDetector(
                                  onTap: () => _showNoteModal(context, cubit),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.def.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(AppSizes.borderSmall),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(AppSizes.paddingS),
                                          child: Icon(
                                            Icons.sticky_note_2_rounded,
                                            size: 24,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: AppSizes.spaceXS8.w),
                                      Text('Note'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ),
                      SizedBox(height: AppSizes.space48.h),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingM.h),
                          child: state.type == TransactionType.transfer
                            ? ListView.separated(
                              padding: EdgeInsets.only(
                                bottom: AppSizes.buttonHeight.h + AppSizes.paddingNavBar.h,
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.accounts.length,
                              itemBuilder: (c, i) {
                                final acc = state.accounts[i];
                                return _accountItem(context, cubit, acc);
                              },
                              separatorBuilder: (c, i) => const Divider(
                                color: AppColors.transparent,
                              ),
                            )
                            : GridView.count(
                            padding: EdgeInsets.only(
                              bottom: AppSizes.buttonHeight.h + AppSizes.paddingNavBar.h,
                            ),
                            crossAxisCount: 3,
                            crossAxisSpacing: AppSizes.space3,
                            mainAxisSpacing: AppSizes.space3,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              for (final cat in state.categories)
                                _categoryItem(context, cubit, cat),
                              _addCategoryButton(context, cubit)
                            ],
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Builder(
                builder: (context) {
                  final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
                  final cubit = context.read<TransactionCubit>();

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    height: 56,
                    child: Material(
                      color: AppColors.background,
                      elevation: 8,
                      child: SafeArea(
                        top: false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingM.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (keyboardOpen) ...[
                                _opBtn('+', () => _insertText('+', cubit)),
                                const SizedBox(width: 8),
                                _opBtn('−', () => _insertText('-', cubit)),
                                const SizedBox(width: 8),
                                _opBtn('×', () => _insertText('*', cubit)),
                                const SizedBox(width: 8),
                                _opBtn('÷', () => _insertText('/', cubit)),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => _amountFocusNode.unfocus(),
                                  child: const Text('Done'),
                                ),
                                const SizedBox(width: 8),
                              ] else
                                const Spacer(),
                              SizedBox(
                                height: 40,
                                child: WButton(
                                  onTap: () {
                                    final value = _evaluate(_amountController.text);
                                    cubit
                                      ..setAmount(value)
                                      ..submit();
                                  },
                                  text: 'Save',
                                  isDisabled: !cubit.state.isValid ||
                                      cubit.state.status.isLoading(),
                                  isLoading: cubit.state.status.isLoading(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _opBtn(String label, VoidCallback onTap) {
    return SizedBox(
      height: 36,
      width: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: AppColors.def, width: 0.7),
        ),
        onPressed: onTap,
        child: Text(label, style: AppTextStyles.bodyRegular),
      ),
    );
  }

  Widget _typeButton(BuildContext context, TransactionCubit cubit, TransactionType type, String label) {
    final selected = cubit.state.type == type;
    return Container(
      child: GestureDetector(
        onTap: () {
          cubit.setType(type);
          if (type == TransactionType.transfer) {
            cubit.loadAccounts();
          } else {
            cubit.loadCategories();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS, horizontal: AppSizes.paddingM),
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : AppColors.def.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSizes.borderMedium),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.def,
              width: 0.5
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.bodyRegular.copyWith(
              color: selected ? AppColors.surface : AppColors.textSecondary,
            )
          ),
        ),
      ),
    );
  }

  Widget _categoryItem(BuildContext context, TransactionCubit cubit, Category cat) {
    final selected = cubit.state.categoryId == cat.id;
    return TileButton(
      title: cat.name ?? 'Category',
      subtitle: selected ? null : null,
      icon: Icons.account_balance_wallet,
      selectedIcon: Icons.account_balance_wallet,
      selected: selected,
      onTap: () => cubit.setCategoryId(cat.id),
      height: 90.h,
      color: AppColors.primary,
      selectedColor: AppColors.accent,
    );
  }

  Widget _accountItem(BuildContext context, TransactionCubit cubit, Account acc) {
    final selected = cubit.state.toAccountId == acc.id;
    return TileButton(
      title: acc.name ?? 'Account',
      subtitle: selected ? null : null,
      icon: Icons.account_balance_wallet,
      selectedIcon: Icons.account_balance_wallet,
      selected: selected,
      onTap: () => cubit.setToAccountId(acc.id),
      // If you use it in a vertical ListView, give it a bit more height:
      height: 50.h,
      color: AppColors.primary,
      selectedColor: AppColors.accent,
    );
  }

  Widget _addCategoryButton(BuildContext context, TransactionCubit cubit) {
    final radius = BorderRadius.circular(AppSizes.borderMedium);
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: () async {
          final type = cubit.state.type;
          CategoryType? categoryType;
          if (type == TransactionType.income) {
            categoryType = CategoryType.income;
          } else if (type == TransactionType.purchase) {
            categoryType = CategoryType.purchase;
          }
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSizes.borderSM16),
              ),
            ),
            builder: (_) => AddCategoryModal(type: categoryType),
          );
          cubit.loadCategories();
        },
        child: Ink(
          height: 90.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: radius,
            border: Border.all(color: AppColors.primary, width: 0.5),
          ),
          child: const Center(
            child: Icon(Icons.add, color: AppColors.accent),
          ),
        ),
      ),
    );
  }

  Future<void> _showCalendarPicker(BuildContext context, TransactionCubit cubit) async {
    DateTime tempDate = cubit.state.date;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return ClipRRect(
            borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSizes.borderSM16),
        topRight: Radius.circular(AppSizes.borderSM16),
        ),
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 200.h,
                  color: AppColors.background,
                  child: CupertinoDatePicker(
                    initialDateTime: tempDate,
                    mode: CupertinoDatePickerMode.date,
                    backgroundColor: AppColors.background,
                    onDateTimeChanged: (d) => setState(() => tempDate = d),
                  ),
                ),
                Container(
                  color: AppColors.background,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: AppSizes.paddingM.w,
                        right: AppSizes.paddingM.w,
                      ),
                      child: WButton(
                        onTap: () {
                          cubit.setDate(tempDate);
                          Navigator.of(context).pop();
                        },
                        text: 'Select',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showNoteModal(BuildContext context, TransactionCubit cubit) async {
    _noteController.text = cubit.state.note;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return ClipRRect(
            borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSizes.borderSM16),
        topRight: Radius.circular(AppSizes.borderSM16),
        ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: AppColors.background,
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.paddingM.h),
                    child: TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(labelText: 'Note'),
                      maxLines: null,
                    ),
                  ),
                ),
                Container(
                  color: AppColors.background,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: AppSizes.paddingM.w,
                        right: AppSizes.paddingM.w,
                      ),
                      child: WButton(
                        onTap: () {
                          cubit.setNote(_noteController.text);
                          Navigator.of(context).pop();
                        },
                        text: 'Save',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
