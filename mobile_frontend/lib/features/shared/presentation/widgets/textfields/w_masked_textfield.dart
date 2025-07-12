import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';

class WMaskedTextField extends StatefulWidget {
  final String? hintText;
  final Function? onTap;
  final SvgPicture? prefixIcon;
  final SvgPicture? suffixIcon;
  final bool enable;
  final bool isPassword;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final String? errorText;
  final OutlineInputBorder? border;
  final OutlineInputBorder? focusBorder;
  final OutlineInputBorder? enabledBorder;
  final Color? backgroundColor;
  final Function? onSubmit;
  final TextInputAction? textInputAction;
  final double height;
  final TextStyle? hintTextStyle;
  final EdgeInsets? contentPadding;
  final bool? isError;
  final bool autofocus;
  final List<TextInputFormatter>? formater;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final TextStyle? style;
  final int? maxLines;
  final String? suffixText;
  final TextStyle? suffixStyle;

  const WMaskedTextField({
    super.key,
    this.focusNode,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.border,
    this.enabledBorder,
    this.focusBorder,
    this.backgroundColor,
    this.onSubmit,
    this.textInputAction,
    this.height = AppSizes.textFieldHeight,
    this.hintTextStyle,
    this.contentPadding,
    this.suffixIcon,
    this.enable = true,
    this.onTap,
    this.isError = false,
    this.autofocus = false,
    this.formater,
    this.prefixText,
    this.prefixStyle,
    this.style,
    this.maxLines,
    this.suffixStyle,
    this.suffixText,
  });

  @override
  State<WMaskedTextField> createState() => _WMaskedTextFieldState();
}

class _WMaskedTextFieldState extends State<WMaskedTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: SizedBox(
        child: TextField(
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          autofocus: widget.autofocus,
          style: widget.style ??
              AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary),
          controller: widget.controller,
          enabled: widget.enable,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscure : false,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          onSubmitted: (val) {
            if (widget.onSubmit != null) {
              widget.onSubmit!(val);
            }
          },
          inputFormatters: widget.formater,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: widget.hintTextStyle ??
                AppTextStyles.bodyRegular.copyWith(
                  color: AppColors.def,
                ),
            prefixIcon: widget.prefixIcon,
            prefixText: widget.prefixText,
            prefixStyle: widget.prefixStyle,
            suffixText: widget.suffixText,
            suffixStyle: widget.suffixStyle,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.def,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  )
                : widget.suffixIcon,
            fillColor: widget.backgroundColor ?? AppColors.surface,
            filled: true,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingL, vertical: 17),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderMedium),
              borderSide: const BorderSide(color: AppColors.background),
            ),
            disabledBorder: widget.isError ?? false
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderMedium),
                    borderSide: BorderSide(
                      color: AppColors.error,
                      width: 1.w,
                    ),
                  )
                : OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderMedium),
                    borderSide: BorderSide(
                      color: AppColors.surface,
                      width: 1.w,
                    ),
                  ),
            focusedBorder: widget.focusBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderMedium),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                ),
            enabledBorder: widget.isError ?? false
                ? OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderMedium),
                    borderSide: BorderSide(
                      color: AppColors.error,
                      width: 1.w,
                    ),
                  )
                : widget.enabledBorder ??
                    OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderMedium),
                      borderSide: const BorderSide(
                        color: AppColors.background,
                        width: 1,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
