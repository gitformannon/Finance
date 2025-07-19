import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/core/themes/app_text_styles.dart';
import 'package:Finance/core/di/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../cubit/transaction_cubit.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({super.key});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getItInstance<TransactionCubit>(),
      child: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          final cubit = context.read<TransactionCubit>();
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.borderLarge),
                topRight: Radius.circular(AppSizes.borderLarge),
              ),
            ),
            child: SafeArea(
              top: true,
              bottom: false,
              child: Scaffold(
                backgroundColor: AppColors.background,
                body: Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.textSecondary, AppColors.textPrimary],
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
                            menuWidth: double.maxFinite,
                            alignment: Alignment.center,
                            underline: Container(),
                            elevation: 0,
                            dropdownColor: AppColors.primary,
                            focusColor: AppColors.secondary,
                            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(AppSizes.borderSM16), bottomLeft: Radius.circular(AppSizes.borderSM16)),
                            value: state.accountId.isNotEmpty ? state.accountId : null,
                            onChanged: (val) => cubit.setAccountId(val ?? ''),
                            items: const [
                              DropdownMenuItem(value: '1', child: Text('Main')),
                              DropdownMenuItem(value: '2', child: Text('Savings')),
                              DropdownMenuItem(value: '3', child: Text('Cash')),
                              DropdownMenuItem(value: '4', child: Text('Visa')),
                            ],
                          ),
                          Row(
                            children: [
                              _typeButton(context, cubit, TransactionType.income, 'Income'),
                              SizedBox(width: AppSizes.spaceXS8.w),
                              _typeButton(context, cubit, TransactionType.purchase, 'Purchase'),
                              SizedBox(width: AppSizes.spaceXS8.w),
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
                          GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: state.date,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) cubit.setDate(picked);
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 20),
                                SizedBox(width: AppSizes.spaceS12.w),
                                Text(DateFormat('dd MMM yyyy').format(state.date)),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSizes.spaceM16.h),
                          TextField(
                            controller: _noteController,
                            decoration: const InputDecoration(labelText: 'Note'),
                            onChanged: cubit.setNote,
                          ),
                        ),
                        Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.paddingXS.w, horizontal: AppSizes.paddingM.h),
                        child:
                          WButton(
                            onTap: cubit.submit,
                            text: 'Save',
                            isDisabled: !state.isValid || state.status.isLoading(),
                            isLoading: state.status.isLoading(),
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
      ),
    );
  }

  Widget _typeButton(BuildContext context, TransactionCubit cubit, TransactionType type, String label) {
    final selected = cubit.state.type == type;
    return Container(
      child: GestureDetector(
        onTap: () => cubit.setType(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS, horizontal: AppSizes.paddingM),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.secondary,
            border: const Border(
              bottom: BorderSide(color: AppColors.def, width: 0.5)
            ),
            borderRadius: BorderRadius.circular(AppSizes.borderMedium),
            boxShadow: [
              BoxShadow(
                color: !selected? AppColors.transparent : AppColors.primary,
                blurRadius: !selected? 0 : 5,
                spreadRadius: !selected? 0.1 : 0,
                blurStyle: BlurStyle.outer,
                offset: const Offset(0, 0),
              )
            ]
          ),
          alignment: Alignment.center,
          child: Text(label, style: AppTextStyles.bodyRegular),
        ),
      ),
    );
  }
}
