import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/core/themes/app_text_styles.dart';
import 'package:Finance/features/budget/presentation/widgets/add_category_item.dart';
import 'package:Finance/features/budget/presentation/widgets/bottom_datepicker_modal.dart';
import 'package:Finance/features/budget/presentation/widgets/bottom_note_modal.dart';
import 'package:Finance/features/budget/presentation/widgets/category_item.dart';
import 'package:Finance/features/budget/presentation/widgets/transaction_type_button.dart';
import 'package:Finance/features/budget/presentation/widgets/transfer_account_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_expressions/math_expressions.dart';

import '../cubit/transaction_cubit.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';
import '../../../../core/helpers/enums_helpers.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({super.key});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _noteFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<TransactionCubit>();
    cubit.loadAccounts();
    cubit.loadCategories();
    _amountFocusNode.addListener(() {
      setState(() {});
    });
    _noteFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    _noteFocusNode.dispose();
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
                      SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.paddingXS.w,
                          horizontal: AppSizes.paddingM.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              hint: Text(
                                'Main',
                                style: AppTextStyles.bodyRegular,
                              ),
                              menuMaxHeight: 100.h,
                              menuWidth: double.maxFinite,
                              alignment: Alignment.center,
                              underline: Container(),
                              elevation: 2,
                              dropdownColor: AppColors.primary,
                              focusColor: AppColors.secondary,
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(
                                  AppSizes.borderSM16,
                                ),
                                bottomLeft: Radius.circular(
                                  AppSizes.borderSM16,
                                ),
                              ),
                              value:
                                state.accountId.isNotEmpty
                                  ? state.accountId
                                  : null,
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
                            ),
                            Row(
                              children: [
                                TransactionTypeButton(
                                  title: 'Income',
                                  titleColor: AppColors.textSecondary,
                                  selectedTitleColor: AppColors.surface,
                                  boxColor: AppColors.def.withOpacity(0.2),
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
                                  boxColor: AppColors.def.withOpacity(0.2),
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
                                  boxColor: AppColors.def.withOpacity(0.2),
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
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                      _amountFocusNode.hasFocus
                                        ? AppColors.accent
                                        : AppColors.def,
                                    width: _amountFocusNode.hasFocus ? 1 : 1,
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
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      textAlign: TextAlign.right,
                                      onChanged:
                                          (v) => cubit.setAmount(_evaluate(v)),
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
                                      left: AppSizes.spaceXS8.w,
                                    ),
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
                                  onTap: () {
                                    setState(() {
                                      _amountFocusNode.unfocus();
                                    });}
                                  )
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSizes.space48.h),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingM.h,
                          ),
                          child:
                            state.type == TransactionType.transfer
                              ? ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: state.accounts.length,
                                itemBuilder: (c, i) {
                                  final acc = state.accounts[i];
                                  return AccountCardButton(
                                    iconColor: AppColors.box,
                                    selectedIconColor: AppColors.accent,
                                    iconBoxColor: AppColors.def.withOpacity(0.1),
                                    selectedIconBoxColor: AppColors.surface,
                                    titleColor: AppColors.textPrimary,
                                    selectedTitleColor: AppColors.surface,
                                    boxColor: AppColors.def.withOpacity(0.2),
                                    selectedBoxColor: AppColors.accent,
                                    boxBorderColor: AppColors.def,
                                    selectedBoxBorderColor: AppColors.accent,
                                    title: acc.name ?? 'Account',
                                    subtitle: acc.number ?? '',
                                    icon: 'assets/svg/ic_more.svg',
                                    selected: cubit.state.toAccountId == acc.id,
                                    onTap: () => cubit.setToAccountId(acc.id)
                                  );
                                },
                                separatorBuilder:
                                  (c, i) => const Divider(
                                    color: AppColors.transparent,
                                    height: AppSizes.space3,
                                  ),
                              )
                              : GridView.count(
                                padding: EdgeInsets.only(
                                  bottom:
                                      AppSizes.buttonHeight.h +
                                      AppSizes.paddingNavBar.h,
                                ),
                                crossAxisCount: 3,
                                crossAxisSpacing: AppSizes.space3,
                                mainAxisSpacing: AppSizes.space3,
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  for (final cat in state.categories)
                                    CategoryItem(
                                      icon: 'assets/svg/ic_global.svg',
                                      iconColor: AppColors.box,
                                      selectedIconColor: AppColors.accent,
                                      iconBoxColor: AppColors.def.withOpacity(0.1),
                                      selectedIconBoxColor: AppColors.surface,
                                      title: cat.name,
                                      titleColor: AppColors.textPrimary,
                                      selectedTitleColor: AppColors.surface,
                                      boxColor: AppColors.def.withOpacity(0.2),
                                      selectedBoxColor: AppColors.accent,
                                      boxBorderColor: AppColors.def,
                                      selectedBoxBorderColor: AppColors.accent,
                                      selected: cubit.state.categoryId == cat.id,
                                      onTap: () => cubit.setCategoryId(cat.id),
                                    ),
                                    AddCategoryItem(
                                      boxColor: AppColors.def.withOpacity(0.2),
                                      boxBorderColor: AppColors.def,
                                      type: state.type == TransactionType.income
                                        ? CategoryType.income
                                        : state.type == TransactionType.purchase
                                        ? CategoryType.purchase
                                        : null,
                                      onCategoryAdded: cubit.loadCategories,
                                    ),
                                ],
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(
                  bottom:
                      _amountFocusNode.hasFocus
                          ? MediaQuery.of(context).viewInsets.bottom + AppSizes.spaceM16
                          : MediaQuery.of(context).padding.bottom,
                  left: AppSizes.paddingM.w,
                  right: AppSizes.paddingM.w,
                ),
                child: BlocBuilder<TransactionCubit, TransactionState>(
                  builder: (context, state) {
                    final cubit = context.read<TransactionCubit>();
                    return WButton(
                      onTap: () {
                        final value = _evaluate(_amountController.text);
                        cubit.setAmount(value);
                        cubit.submit();
                      },
                      text: 'Save',
                      isDisabled: !state.isValid || state.status.isLoading(),
                      isLoading: state.status.isLoading(),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }




  // Widget _typeButton(
  //   BuildContext context,
  //   TransactionCubit cubit,
  //   TransactionType type,
  //   String label,
  // ) {
  //   final selected = cubit.state.type == type;
  //   return Container(
  //     child: GestureDetector(
  //       onTap: () {
  //         cubit.setType(type);
  //         if (type == TransactionType.transfer) {
  //           cubit.loadAccounts();
  //         } else {
  //           cubit.loadCategories();
  //         }
  //       },
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(
  //           vertical: AppSizes.paddingS,
  //           horizontal: AppSizes.paddingM,
  //         ),
  //         decoration: BoxDecoration(
  //           color: selected ? AppColors.accent : AppColors.def.withOpacity(0.2),
  //           borderRadius: BorderRadius.circular(AppSizes.borderMedium),
  //           border: Border.all(
  //             color: selected ? AppColors.accent : AppColors.def,
  //             width: 0.5,
  //           ),
  //         ),
  //         alignment: Alignment.center,
  //         child: Text(
  //           label,
  //           style: AppTextStyles.bodyRegular.copyWith(
  //             color: selected ? AppColors.surface : AppColors.textSecondary,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _categoryItem(
  //   BuildContext context,
  //   TransactionCubit cubit,
  //   Category cat,
  // ) {
  //   final selected = cubit.state.categoryId == cat.id;
  //   return TileButton(
  //     title: cat.name ?? 'Category',
  //     subtitle: selected ? null : null,
  //     icon: Icons.account_balance_wallet,
  //     selectedIcon: Icons.account_balance_wallet,
  //     selected: selected,
  //     onTap: () => cubit.setCategoryId(cat.id),
  //     height: 90.h,
  //     color: AppColors.primary,
  //     selectedColor: AppColors.accent,
  //   );
  // }

  // Widget _accountItem(
  //   BuildContext context,
  //   TransactionCubit cubit,
  //   Account acc,
  // ) {
  //   final selected = cubit.state.toAccountId == acc.id;
  //   return TileButton(
  //     title: acc.name ?? 'Account',
  //     subtitle: selected ? null : null,
  //     icon: Icons.account_balance_wallet,
  //     selectedIcon: Icons.account_balance_wallet,
  //     selected: selected,
  //     onTap: () => cubit.setToAccountId(acc.id),
  //     // If you use it in a vertical ListView, give it a bit more height:
  //     height: 50.h,
  //     color: AppColors.primary,
  //     selectedColor: AppColors.accent,
  //   );
  // }

  // Widget _addCategoryButton(BuildContext context, TransactionCubit cubit) {
  //   final radius = BorderRadius.circular(AppSizes.borderMedium);
  //   return Material(
  //     color: AppColors.transparent,
  //     child: InkWell(
  //       borderRadius: radius,
  //       onTap: () async {
  //         final type = cubit.state.type;
  //         CategoryType? categoryType;
  //         if (type == TransactionType.income) {
  //           categoryType = CategoryType.income;
  //         } else if (type == TransactionType.purchase) {
  //           categoryType = CategoryType.purchase;
  //         }
  //         await showModalBottomSheet(
  //           context: context,
  //           isScrollControlled: true,
  //           useSafeArea: true,
  //           shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.vertical(
  //               top: Radius.circular(AppSizes.borderSM16),
  //             ),
  //           ),
  //           builder: (_) => AddCategoryModal(type: categoryType),
  //         );
  //         cubit.loadCategories();
  //       },
  //       child: Ink(
  //         height: 90.h,
  //         decoration: BoxDecoration(
  //           color: AppColors.primary,
  //           borderRadius: radius,
  //           border: Border.all(color: AppColors.primary, width: 0.5),
  //         ),
  //         child: const Center(child: Icon(Icons.add, color: AppColors.accent)),
  //       ),
  //     ),
  //   );
  // }

//   Future<void> _showNoteModal(
//     BuildContext context,
//     TransactionCubit cubit,
//   ) async {
//     _noteController.text = cubit.state.note;
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       useSafeArea: true,
//       builder: (_) {
//         return Padding(
//           padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//           child: ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(AppSizes.borderSM16),
//               topRight: Radius.circular(AppSizes.borderSM16),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   color: AppColors.background,
//                   child: Padding(
//                     padding: EdgeInsets.all(AppSizes.paddingM.h),
//                     child: TextField(
//                       controller: _noteController,
//                       decoration: const InputDecoration(labelText: 'Note'),
//                       maxLines: null,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   color: AppColors.background,
//                   child: SafeArea(
//                     top: false,
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                         left: AppSizes.paddingM.w,
//                         right: AppSizes.paddingM.w,
//                       ),
//                       child: WButton(
//                         onTap: () {
//                           cubit.setNote(_noteController.text);
//                           Navigator.of(context).pop();
//                         },
//                         text: 'Save',
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
}
