import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../focus/focus_manager.dart';

/// Universal input field component that can be used across the entire app
class AppInputField extends StatelessWidget {
  const AppInputField({
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
    this.onSubmitted,
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
    this.borderRadius,
    this.borderColor,
    this.focusedBorderColor,
    this.labelStyle,
    this.hintStyle,
    this.validator,
    this.onSaved,
    this.initialValue,
    this.isRequired = false,
    this.showCharacterCount = false,
    this.focusKey,
    this.nextFocusKey,
    this.previousFocusKey,
    this.enableKeyboardNavigation = true,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
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
  final double? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String? initialValue;
  final bool isRequired;
  final bool showCharacterCount;
  final String? focusKey;
  final String? nextFocusKey;
  final String? previousFocusKey;
  final bool enableKeyboardNavigation;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? AppSizes.borderSM16.toDouble();
    final effectiveFillColor = fillColor ?? AppColors.surface;
    final effectiveBorderColor = borderColor ?? AppColors.transparent;
    final effectiveFocusedBorderColor = focusedBorderColor ?? AppColors.accent;

    // Get or create focus node
    final effectiveFocusNode = focusNode ?? 
        (focusKey != null ? AppFocusManager().registerFocusNode(focusKey!) : null);

    OutlineInputBorder buildBorder(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    final bool interactive = enabled && !readOnly;
    final Color effectiveFillColorValue = interactive ? effectiveFillColor : AppColors.box;

    final EdgeInsetsGeometry effectivePadding = contentPadding ??
        const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingL,
          vertical: AppSizes.padding16,
        );

    final TextStyle effectiveStyle = textStyle ??
        const TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppSizes.textSize16,
        );

    final TextStyle effectiveLabelStyle = labelStyle ??
        const TextStyle(
          color: AppColors.def,
          fontWeight: FontWeight.w500,
        );

    final TextStyle effectiveHintStyle = hintStyle ??
        const TextStyle(
          color: AppColors.def,
          fontSize: AppSizes.textSize16,
        );

    // Enhanced onSubmitted handler
    void handleSubmitted(String value) {
      onSubmitted?.call(value);
      
      if (enableKeyboardNavigation) {
        // Move to next field if specified
        if (nextFocusKey != null) {
          AppFocusManager().focusField(nextFocusKey!);
        } else {
          AppFocusManager().nextFocus(context);
        }
      }
    }

    Widget field = TextFormField(
      controller: controller,
      focusNode: effectiveFocusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction ?? (nextFocusKey != null || enableKeyboardNavigation 
          ? TextInputAction.next 
          : TextInputAction.done),
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onFieldSubmitted: handleSubmitted,
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
      validator: validator,
      onSaved: onSaved,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        filled: true,
        fillColor: effectiveFillColorValue,
        contentPadding: effectivePadding,
        border: buildBorder(effectiveBorderColor),
        enabledBorder: buildBorder(effectiveBorderColor),
        disabledBorder: buildBorder(AppColors.def.withValues(alpha: 0.4)),
        focusedBorder: buildBorder(effectiveFocusedBorderColor, 1.5),
        errorBorder: buildBorder(AppColors.error),
        focusedErrorBorder: buildBorder(AppColors.error, 1.5),
        floatingLabelStyle: TextStyle(
          color: effectiveFocusedBorderColor,
          fontWeight: FontWeight.w600,
        ),
        labelStyle: effectiveLabelStyle,
        hintStyle: effectiveHintStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        counterText: showCharacterCount ? null : '',
      ),
    );

    // Wrap with focus management if keyboard navigation is enabled
    if (enableKeyboardNavigation && effectiveFocusNode != null) {
      field = Focus(
        focusNode: effectiveFocusNode,
        onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.tab) {
            if (HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
                HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.shiftRight)) {
              // Move to previous field
              if (previousFocusKey != null) {
                AppFocusManager().focusField(previousFocusKey!);
              } else {
                AppFocusManager().previousFocus(context);
              }
            } else {
              // Move to next field
              if (nextFocusKey != null) {
                AppFocusManager().focusField(nextFocusKey!);
              } else {
                AppFocusManager().nextFocus(context);
              }
            }
            return KeyEventResult.handled;
          }
        }
          return KeyEventResult.ignored;
        },
        child: field,
      );
    }

    // Add character count if enabled
    if (showCharacterCount && maxLength != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          field,
          if (controller != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${controller!.text.length}/$maxLength',
                style: const TextStyle(
                  color: AppColors.def,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      );
    }

    return field;
  }
}

/// Specialized input field for numbers
class AppNumberField extends StatelessWidget {
  const AppNumberField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.isRequired = false,
    this.decimalPlaces = 0,
    this.minValue,
    this.maxValue,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool isRequired;
  final int decimalPlaces;
  final double? minValue;
  final double? maxValue;

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      label: label,
      controller: controller,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      keyboardType: decimalPlaces > 0 
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(decimalPlaces > 0 ? r'^\d*\.?\d*' : r'^\d*'),
        ),
      ],
      onChanged: onChanged,
      enabled: enabled,
      isRequired: isRequired,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        if (value != null && value.isNotEmpty) {
          final number = double.tryParse(value);
          if (number == null) {
            return 'Please enter a valid number';
          }
          if (minValue != null && number < minValue!) {
            return 'Value must be at least $minValue';
          }
          if (maxValue != null && number > maxValue!) {
            return 'Value must be at most $maxValue';
          }
        }
        return null;
      },
    );
  }
}

/// Specialized input field for email
class AppEmailField extends StatelessWidget {
  const AppEmailField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.isRequired = false,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      label: label,
      controller: controller,
      hintText: hintText ?? 'Enter your email',
      helperText: helperText,
      errorText: errorText,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      enabled: enabled,
      isRequired: isRequired,
      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.def),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Email is required';
        }
        if (value != null && value.isNotEmpty) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) {
            return 'Please enter a valid email address';
          }
        }
        return null;
      },
    );
  }
}

/// Specialized input field for password
class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.isRequired = false,
    this.showStrengthIndicator = false,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool isRequired;
  final bool showStrengthIndicator;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      label: widget.label,
      controller: widget.controller,
      hintText: widget.hintText ?? 'Enter your password',
      helperText: widget.helperText,
      errorText: widget.errorText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      isRequired: widget.isRequired,
      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.def),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.def,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
      validator: (value) {
        if (widget.isRequired && (value == null || value.isEmpty)) {
          return 'Password is required';
        }
        if (value != null && value.isNotEmpty && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}
