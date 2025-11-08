import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

/// Universal button component that can be used across the entire app
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.buttonType = ButtonType.primary,
    this.buttonSize = ButtonSize.medium,
    this.elevation,
    this.shadowColor,
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
  final Color? textColor;
  final TextStyle? textStyle;
  final double? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final Widget? icon;
  final IconPosition iconPosition;
  final ButtonType buttonType;
  final ButtonSize buttonSize;
  final double? elevation;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? double.infinity;
    final effectiveHeight = height ?? _getButtonHeight();
    final effectivePadding = padding ?? _getButtonPadding();
    final effectiveBorderRadius = borderRadius ?? AppSizes.borderLarge;
    
    final colors = _getButtonColors(context);
    final effectiveBackgroundColor = backgroundColor ?? colors.backgroundColor;
    final effectiveTextColor = textColor ?? colors.textColor;
    final effectiveBorderColor = borderColor ?? colors.borderColor;

    return GestureDetector(
      onTap: () {
        if (!(isLoading || isDisabled)) {
          onPressed();
        }
      },
      child: Container(
        width: effectiveWidth,
        height: effectiveHeight,
        margin: margin,
        padding: effectivePadding,
        decoration: BoxDecoration(
          color: isDisabled ? AppColors.box : effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          border: effectiveBorderColor != null
              ? Border.all(
                  color: effectiveBorderColor,
                  width: borderWidth ?? 1,
                )
              : null,
          boxShadow: elevation != null
              ? [
                  BoxShadow(
                    color: shadowColor ?? AppColors.textPrimary.withValues(alpha: 0.1),
                    blurRadius: elevation!,
                    offset: Offset(0, elevation! / 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: effectiveHeight * 0.4,
                  width: effectiveHeight * 0.4,
                  child: const CupertinoActivityIndicator(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null && iconPosition == IconPosition.left) ...[
                      icon!,
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        text,
                        style: textStyle ??
                            TextStyle(
                              color: isDisabled ? AppColors.def : effectiveTextColor,
                              fontSize: _getTextSize(),
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    if (icon != null && iconPosition == IconPosition.right) ...[
                      const SizedBox(width: 8),
                      icon!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }

  double _getButtonHeight() {
    switch (buttonSize) {
      case ButtonSize.small:
        return AppSizes.buttonHeight * 0.8;
      case ButtonSize.medium:
        return AppSizes.buttonHeight;
      case ButtonSize.large:
        return AppSizes.buttonHeight * 1.2;
    }
  }

  EdgeInsets _getButtonPadding() {
    switch (buttonSize) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    }
  }

  double _getTextSize() {
    switch (buttonSize) {
      case ButtonSize.small:
        return AppSizes.textSize14;
      case ButtonSize.medium:
        return AppSizes.textSize16;
      case ButtonSize.large:
        return AppSizes.textSize18;
    }
  }

  _ButtonColors _getButtonColors(BuildContext context) {
    switch (buttonType) {
      case ButtonType.primary:
        return _ButtonColors(
          backgroundColor: Theme.of(context).primaryColor,
          textColor: AppColors.surface,
          borderColor: null,
        );
      case ButtonType.secondary:
        return _ButtonColors(
          backgroundColor: AppColors.transparent,
          textColor: Theme.of(context).primaryColor,
          borderColor: Theme.of(context).primaryColor,
        );
      case ButtonType.success:
        return _ButtonColors(
          backgroundColor: AppColors.accent,
          textColor: AppColors.surface,
          borderColor: null,
        );
      case ButtonType.error:
        return _ButtonColors(
          backgroundColor: AppColors.error,
          textColor: AppColors.surface,
          borderColor: null,
        );
      case ButtonType.warning:
        return _ButtonColors(
          backgroundColor: AppColors.accent,
          textColor: AppColors.surface,
          borderColor: null,
        );
      case ButtonType.ghost:
        return _ButtonColors(
          backgroundColor: AppColors.transparent,
          textColor: AppColors.textPrimary,
          borderColor: null,
        );
    }
  }
}

class _ButtonColors {
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  _ButtonColors({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
  });
}

enum ButtonType {
  primary,
  secondary,
  success,
  error,
  warning,
  ghost,
}

enum ButtonSize {
  small,
  medium,
  large,
}

enum IconPosition {
  left,
  right,
}

/// Specialized save button
class AppSaveButton extends StatelessWidget {
  const AppSaveButton({
    super.key,
    required this.onPressed,
    this.text = 'Save',
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.margin,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      text: text,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
      height: height,
      margin: margin,
      buttonType: ButtonType.primary,
      icon: const Icon(Icons.save, size: 18),
    );
  }
}

/// Specialized cancel button
class AppCancelButton extends StatelessWidget {
  const AppCancelButton({
    super.key,
    required this.onPressed,
    this.text = 'Cancel',
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.margin,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      text: text,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
      height: height,
      margin: margin,
      buttonType: ButtonType.secondary,
      icon: const Icon(Icons.close, size: 18),
    );
  }
}

/// Specialized delete button
class AppDeleteButton extends StatelessWidget {
  const AppDeleteButton({
    super.key,
    required this.onPressed,
    this.text = 'Delete',
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.margin,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      text: text,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
      height: height,
      margin: margin,
      buttonType: ButtonType.error,
      icon: const Icon(Icons.delete, size: 18),
    );
  }
}

/// Floating action button component
class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.isExtended = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.heroTag,
  });

  final VoidCallback onPressed;
  final Widget? icon;
  final String? text;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isExtended;
  final bool isLoading;
  final bool isDisabled;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    if (isExtended && text != null) {
      return FloatingActionButton.extended(
        heroTag: heroTag,
        onPressed: isDisabled || isLoading ? null : onPressed,
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        foregroundColor: foregroundColor ?? AppColors.surface,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : icon ?? const Icon(Icons.add),
        label: Text(text!),
      );
    }

    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: isDisabled || isLoading ? null : onPressed,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      foregroundColor: foregroundColor ?? AppColors.surface,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : icon ?? const Icon(Icons.add),
    );
  }
}
