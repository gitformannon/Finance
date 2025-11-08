import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Consistent text input used across budget-related forms.
class BudgetInputField extends StatelessWidget {
  const BudgetInputField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.helperText,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.inputFormatters,
    this.focusNode,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.autocorrect = true,
    this.autofillHints,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.textStyle,
    this.fillColor,
    this.contentPadding,
    this.cursorColor,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final bool autocorrect;
  final Iterable<String>? autofillHints;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? textStyle;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final Color? cursorColor;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppSizes.borderSM16);

    OutlineInputBorder buildBorder(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    final bool interactive = enabled && !readOnly;
    final Color effectiveFillColor =
        fillColor ?? (interactive ? AppColors.surface : AppColors.box);

    final EdgeInsetsGeometry effectivePadding =
        contentPadding ??
        const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingL,
          vertical: AppSizes.padding16,
        );

    final TextStyle effectiveStyle =
        textStyle ??
        const TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppSizes.textSize16,
        );

    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      autofocus: autofocus,
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? 1 : minLines,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      textAlign: textAlign,
      autocorrect: autocorrect,
      autofillHints: autofillHints,
      onTap: onTap,
      style: effectiveStyle,
      cursorColor: cursorColor ?? AppColors.accent,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        filled: true,
        fillColor: effectiveFillColor,
        contentPadding: effectivePadding,
        border: buildBorder(AppColors.transparent),
        enabledBorder: buildBorder(AppColors.transparent),
        disabledBorder: buildBorder(AppColors.def.withValues(alpha: 0.4)),
        focusedBorder: buildBorder(AppColors.accent, 1.5),
        floatingLabelStyle: const TextStyle(
          color: AppColors.accent,
          fontWeight: FontWeight.w600,
        ),
        labelStyle: const TextStyle(
          color: AppColors.def,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
