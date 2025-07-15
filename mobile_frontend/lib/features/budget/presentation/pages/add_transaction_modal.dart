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
import '../../../shared/presentation/widgets/appbar/w_inner_appbar.dart';

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
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Scaffold(
              backgroundColor: AppColors.background,
              appBar: SubpageAppBar(
                title: 'Add transaction',
                onBackTap: () => Navigator.of(context).pop(),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(AppSizes.paddingL.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: state.accountId.isNotEmpty ? state.accountId : null,
                      hint: Text('Main', style: AppTextStyles.bodyRegular),
                      onChanged: (val) => cubit.setAccountId(val ?? ''),
                      items: const [
                        DropdownMenuItem(value: '1', child: Text('Main')),
                      ],
                    ),
                    SizedBox(height: AppSizes.spaceM16.h),
                    Row(
                      children: [
                        _typeButton(context, cubit, TransactionType.income, 'Income'),
                        SizedBox(width: AppSizes.spaceS12.w),
                        _typeButton(context, cubit, TransactionType.purchase, 'Purchase'),
                        SizedBox(width: AppSizes.spaceS12.w),
                        _typeButton(context, cubit, TransactionType.transfer, 'Transfer'),
                      ],
                    ),
                    SizedBox(height: AppSizes.spaceM16.h),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(prefixText: '\$ ', labelText: 'Amount'),
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
                      decoration: const InputDecoration(labelText: 'Note', prefixIcon: Icon(Icons.note)),
                      onChanged: cubit.setNote,
                    ),
                    if (state.type == TransactionType.transfer) ...[
                      SizedBox(height: AppSizes.spaceM16.h),
                      Text('Where to transfer', style: AppTextStyles.bodyMedium),
                      SizedBox(height: AppSizes.spaceS12.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(AppSizes.spaceM16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSizes.borderMedium),
                          border: Border.all(color: AppColors.def, style: BorderStyle.solid),
                        ),
                        child: const Center(child: Text('+ New account')),
                      ),
                    ],
                    SizedBox(height: AppSizes.spaceL20.h),
                    WButton(
                      onTap: cubit.submit,
                      text: 'Save',
                      isDisabled: !state.isValid || state.status.isLoading(),
                      isLoading: state.status.isLoading(),
                    ),
                  ],
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
    return Expanded(
      child: GestureDetector(
        onTap: () => cubit.setType(type),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSizes.spaceS12.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.borderMedium),
          ),
          alignment: Alignment.center,
          child: Text(label, style: AppTextStyles.bodyRegular),
        ),
      ),
    );
  }
}

