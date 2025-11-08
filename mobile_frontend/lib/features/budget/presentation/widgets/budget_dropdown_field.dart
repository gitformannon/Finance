import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Dropdown field styled to match [BudgetInputField].
class BudgetDropdownField<T> extends StatelessWidget {
  const BudgetDropdownField({
    super.key,
    this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.hintText,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.focusNode,
    this.dropdownColor,
    this.menuMaxHeight,
    this.onTap,
    this.icon,
    this.autovalidateMode,
    this.validator,
  });

  final String? label;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final List<DropdownMenuItem<T>> items;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final FocusNode? focusNode;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final VoidCallback? onTap;
  final Widget? icon;
  final AutovalidateMode? autovalidateMode;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppSizes.borderSM16);

    OutlineInputBorder buildBorder(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    final bool interactive = enabled;
    final Color effectiveFillColor =
        interactive ? AppColors.surface : AppColors.box;

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      focusNode: focusNode,
      onTap: onTap,
      autovalidateMode: autovalidateMode,
      validator: validator,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppSizes.textSize16,
        fontWeight: FontWeight.w500,
      ),
      icon:
          icon ??
          const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
      dropdownColor: dropdownColor ?? AppColors.surface,
      isExpanded: true,
      menuMaxHeight: menuMaxHeight,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        filled: true,
        fillColor: effectiveFillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.padding16,
          vertical: AppSizes.padding16,
        ),
        border: buildBorder(AppColors.transparent),
        enabledBorder: buildBorder(AppColors.transparent),
        disabledBorder: buildBorder(AppColors.def.withValues(alpha: 0.4)),
        focusedBorder: buildBorder(AppColors.accent, 1.5),
        floatingLabelStyle: const TextStyle(
          color: AppColors.def,
          fontWeight: FontWeight.w600,
        ),
        labelStyle: const TextStyle(
          color: AppColors.def,
          fontWeight: FontWeight.w500,
        ),
      ),
      borderRadius: borderRadius,
    );
  }
}
