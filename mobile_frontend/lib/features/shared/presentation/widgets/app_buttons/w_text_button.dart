import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../animations/w_scale_animation.dart';

/// A simple text button that follows the app design language.
///
/// This widget is similar to [WButton] but renders only a text without
/// a colored background. It is used across pages like the login screen
/// for actions such as navigation links.
class WTextButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool isDisabled;
  final bool isLoading;
  final double? scaleValue;

  const WTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.textStyle,
    this.padding,
    this.margin,
    this.isDisabled = false,
    this.isLoading = false,
    this.scaleValue,
  });

  @override
  Widget build(BuildContext context) {
    return WScaleAnimation(
      onTap: () {
        if (!(isLoading || isDisabled)) {
          onTap();
        }
      },
      isDisabled: isDisabled,
      scaleValue: scaleValue ?? 0.95,
      child: Container(
        margin: margin,
        padding: padding ?? const EdgeInsets.all(AppSizes.paddingXS),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CupertinoActivityIndicator(),
              )
            : Text(
                text,
                style: textStyle ??
                    AppTextStyles.bodyRegular.copyWith(
                      color: AppColors.accent,
                    ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
