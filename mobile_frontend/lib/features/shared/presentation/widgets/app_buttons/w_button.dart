import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/themes/app_text_styles.dart';
import '../animations/w_scale_animation.dart';

class WButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final Color? textColor;
  final TextStyle? textStyle;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final GestureTapCallback onTap;
  final BoxBorder? border;
  final double borderRadius;
  final Widget? child;
  final bool isDisabled;
  final bool isLoading;
  final double? scaleValue;
  final List<BoxShadow>? shadow;
  final Color? backgroundColor;
  final bool hasError;
  final bool hasNextIcon;
  final bool hasPreviousIcon;
  final SvgPicture? prevIcon;
  final SvgPicture? nextIcon;

  const WButton({
    required this.onTap,
    this.text = '',
    this.textColor,
    this.borderRadius = AppSizes.borderLarge,
    this.isDisabled = false,
    this.isLoading = false,
    this.hasError = false,
    this.hasNextIcon = false,
    this.hasPreviousIcon = false,
    this.width = double.infinity,
    this.height = AppSizes.buttonHeight,
    this.margin,
    this.padding,
    this.textStyle,
    this.border,
    this.child,
    this.scaleValue,
    this.shadow,
    this.backgroundColor,
    this.nextIcon,
    this.prevIcon,
    super.key,
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
      child: Container(
        width: width,
        height: height ?? AppSizes.buttonHeight,
        margin: margin,
        padding: padding ?? EdgeInsets.zero,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
            isDisabled
              ? AppColors.box
              : (backgroundColor ?? Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(borderRadius),
          border: hasError ? Border.all(color: AppColors.error) : border,
          boxShadow: shadow,
        ),
        child:
          isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : child ??
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  hasPreviousIcon
                    ? Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: prevIcon ?? Container(),
                    )
                    : const SizedBox(),
                  child ??
                    Text(
                      text,
                      style: textStyle ?? AppTextStyles.bodyLarge,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  hasNextIcon
                    ? Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: nextIcon ?? Container(),
                    )
                    : const SizedBox(),
                ],
            ),
      ),
    );
  }
}
