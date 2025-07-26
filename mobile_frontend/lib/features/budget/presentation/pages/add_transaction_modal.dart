import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../cubit/transaction_cubit.dart';
import '../../data/model/category.dart';
import '../../data/model/account.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';
import 'add_category_modal.dart';
import '../../../../core/helpers/enums_helpers.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({super.key});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<TransactionCubit>();
    cubit.loadAccounts();
    cubit.loadCategories();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
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
                        Expanded(
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
                                TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.right,
                                  onChanged: (v) => cubit.setAmount(double.tryParse(v) ?? 0),
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
                                              color: AppColors.def,
                                              borderRadius: BorderRadius.circular(AppSizes.borderSmall)
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(AppSizes.paddingS),
                                              child: Icon(
                                                Icons.calendar_today,
                                                size: 24,
                                                color: AppColors.secondary,
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
                                              color: AppColors.def,
                                              borderRadius: BorderRadius.circular(AppSizes.borderSmall),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(AppSizes.paddingS),
                                              child: Icon(
                                                Icons.sticky_note_2_rounded,
                                                size: 24,
                                                color: AppColors.secondary,
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
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(AppSizes.paddingM.h),
                            child: state.type == TransactionType.transfer
                              ? ListView.separated(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: state.accounts.length,
                                separatorBuilder: (c, i) => const Divider(),
                                itemBuilder: (c, i) {
                                  final acc = state.accounts[i];
                                  return _accountItem(context, cubit, acc);
                                },
                              )
                              : GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 3,
                                crossAxisSpacing: AppSizes.spaceXS8.w,
                                mainAxisSpacing: AppSizes.spaceXS8.w,
                                children: [
                                  for (final cat in state.categories) _categoryItem(context, cubit, cat),
                                  _addCategoryButton(context, cubit)
                                ],
                              ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(AppSizes.paddingM.h),
                          child: SafeArea(
                            top: false,
                            child: WButton(
                              onTap: cubit.submit,
                              text: 'Save',
                              isDisabled: !state.isValid ||
                                  state.status.isLoading(),
                              isLoading: state.status.isLoading(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
            color: selected ? AppColors.def : AppColors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.borderMedium),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.def,
              width: 0.5
            ),
          ),
          alignment: Alignment.center,
          child: Text(label, style: selected ? AppTextStyles.bodyRegular : AppTextStyles.bodyRegular),
        ),
      ),
    );
  }

  Widget _categoryItem(BuildContext context, TransactionCubit cubit, Category cat) {
    final selected = cubit.state.categoryId == cat.id;
    return GestureDetector(
      onTap: () => cubit.setCategoryId(cat.id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS, horizontal: AppSizes.paddingM),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.secondary,
          border: Border.all(

          ),
          borderRadius: BorderRadius.circular(AppSizes.borderMedium),
        ),
        alignment: Alignment.center,
        child: Text(cat.name, style: AppTextStyles.bodyRegular),
      ),
    );
  }

  Widget _accountItem(BuildContext context, TransactionCubit cubit, Account acc) {
    final selected = cubit.state.toAccountId == acc.id;
    return GestureDetector(
      onTap: () => cubit.setToAccountId(acc.id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS, horizontal: AppSizes.paddingM),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.secondary,
          border: const Border(
            bottom: BorderSide(color: AppColors.def, width: 0.5),
          ),
          borderRadius: BorderRadius.circular(AppSizes.borderMedium),
          boxShadow: [
            BoxShadow(
              color: !selected ? AppColors.transparent : AppColors.primary,
              blurRadius: !selected ? 0 : 5,
              spreadRadius: !selected ? 0.1 : 0,
              blurStyle: BlurStyle.outer,
              offset: const Offset(0, 0),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(acc.name ?? 'Account', style: AppTextStyles.bodyRegular),
      ),
    );
  }

  Widget _addCategoryButton(BuildContext context, TransactionCubit cubit) {
    return GestureDetector(
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.borderSM16)),
          ),
          builder: (_) => AddCategoryModal(type: categoryType),
        );
        cubit.loadCategories();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS, horizontal: AppSizes.paddingM),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          border: const Border(
            bottom: BorderSide(color: AppColors.def, width: 0.5),
          ),
          borderRadius: BorderRadius.circular(AppSizes.borderMedium),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<void> _showCalendarPicker(BuildContext context, TransactionCubit cubit) async {
    DateTime tempDate = cubit.state.date;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.borderSM16),
        ),
      ),
      builder: (_) {
        return StatefulBuilder(
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
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.paddingM.h),
                  child: WButton(
                    onTap: () {
                      cubit.setDate(tempDate);
                      Navigator.of(context).pop();
                    },
                    text: 'Select',
                  ),
                ),
              ),
            ],
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.borderSM16),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(AppSizes.paddingM.h),
                child: TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(labelText: 'Note'),
                  maxLines: null,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppSizes.paddingM.h),
                child: WButton(
                  onTap: () {
                    cubit.setNote(_noteController.text);
                    Navigator.of(context).pop();
                  },
                  text: 'Save',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
