import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/helpers/formatters_helpers.dart';
import '../cubit/transaction_cubit.dart';

class TransactionAmountInput extends StatefulWidget {
  final TransactionCubit cubit;
  final ValueNotifier<bool> isFocused;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isUpdatingController;
  final Color? focusedColor;
  final Color? unfocusedColor;

  const TransactionAmountInput({
    super.key,
    required this.cubit,
    required this.isFocused,
    required this.controller,
    required this.focusNode,
    required this.isUpdatingController,
    this.focusedColor,
    this.unfocusedColor
  });

  @override
  State<TransactionAmountInput> createState() => _TransactionAmountInputState();
}

class _TransactionAmountInputState extends State<TransactionAmountInput> {
  late final CurrencyTextInputFormatter _amountFormatter;

  @override
  void initState() {
    super.initState();
    _amountFormatter = Formatters.currencyFormatter(
      locale: 'ru',
      decimalDigits: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isFocused,
      builder: (context, isFocused, _) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isFocused
                  ? (widget.focusedColor ?? AppColors.primary)
                  : (widget.unfocusedColor ?? AppColors.def),
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
                  controller: widget.controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                  ),
                  inputFormatters: [_amountFormatter],
                  textAlign: TextAlign.right,
                  onChanged: (v) {
                    if (!widget.isUpdatingController) {
                      widget.cubit.setAmountFromString(v);
                    }
                  },
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  focusNode: widget.focusNode,
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
      },
    );
  }
}

