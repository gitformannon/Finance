import 'package:agro_card_delivery/core/constants/app_sizes.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';

class WMaskedTextField extends StatelessWidget {
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
    this.height = AppSizes.textFieldHeight60,
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: SizedBox(
        height: height.h,
        child: TextField(
          maxLines: maxLines,
          autofocus: autofocus,
          style: style ?? AppTextStyles.bodyRegular,
          controller: controller,
          enabled: enable,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: isPassword,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onSubmitted: (val) {
            if (onSubmit != null) {
              onSubmit!(val);
            }
          },
          inputFormatters: formater,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                hintTextStyle ??
                AppTextStyles.bodyRegular.copyWith(
                  color: AppColors.box,
                ),
            prefixIcon: prefixIcon,
            prefixText: prefixText,
            prefixStyle: prefixStyle,
            suffixText: suffixText,
            suffixStyle: suffixStyle,
            // suffixIcon: isError ?? false
            //     ? SvgPicture.asset(
            //         AppSvgs.isCircleError,
            //         fit: BoxFit.scaleDown,
            //       )
            //     : suffixIcon,
            fillColor: backgroundColor ?? AppColors.box,
            filled: true,
            contentPadding: contentPadding ?? EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderLarge20),
              borderSide: BorderSide(color: AppColors.box, width: 1.w),
            ),
            disabledBorder:
                isError ?? false
                    ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderLarge20),
                      borderSide: BorderSide(
                        color: AppColors.error,
                        width: 1.w,
                      ),
                    )
                    : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderLarge20),
                      borderSide: BorderSide(
                        color: AppColors.box,
                        width: 1.w,
                      ),
                    ),
            focusedBorder:
                focusBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderLarge20),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.w),
                ),
            enabledBorder:
                isError ?? false
                    ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderLarge20),
                      borderSide: BorderSide(
                        color: AppColors.error,
                        width: 1.w,
                      ),
                    )
                    : enabledBorder ??
                        OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.borderLarge20,
                          ),
                          borderSide: BorderSide(
                            color: AppColors.box,
                            width: 1.w,
                          ),
                        ),
          ),
        ),
      ),
    );
  }
}
