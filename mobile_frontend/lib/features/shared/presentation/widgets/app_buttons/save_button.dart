import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import 'w_button.dart';

/// App-wide "Save" button wrapper that enforces consistent styling and behavior.
class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.onPressed,
    this.text = 'Save',
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.textStyle,
    this.borderRadius,
    this.hasError = false,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double? borderRadius;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return WButton(
      onTap: onPressed,
      text: text,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width ?? double.infinity,
      height: height ?? AppSizes.buttonHeight,
      margin: margin,
      padding: padding,
      backgroundColor: backgroundColor ?? AppColors.transparent,
      textStyle: textStyle,
      borderRadius: borderRadius ?? AppSizes.borderLarge,
      hasError: hasError,
    );
  }
}
