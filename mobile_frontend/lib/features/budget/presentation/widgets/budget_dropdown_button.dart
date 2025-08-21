import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BudgetDropdownButton extends StatelessWidget {
  final T? value;
  final Widget? hint;
  final ValueChanged<T?> onChanged;
  final List<DropdownMenuItem<T>> items;

  const BudgetDropdownButton({
    super.key,
    this.value,
    this.hint,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: value,
      hint: hint,
      menuMaxHeight: 100.h,
      menuWidth: double.maxFinite,
      alignment: Alignment.center,
      underline: Container(),
      elevation: 2,
      dropdownColor: AppColors.primary,
      focusColor: AppColors.secondary,
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(AppSizes.borderSM16),
        bottomLeft: Radius.circular(AppSizes.borderSM16)
      ),
      onChanged: onChanged,
      items: items,
    );
  }
}
