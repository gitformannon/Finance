import 'dart:io';
import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class AppWidgets {
  static Widget text({
    required String text,
    int maxLines = 1,
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
  }) {
    return Text(
      text,
      textAlign: textAlign,
      style: textStyle,
      maxLines: maxLines,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }

  static Widget textLocale({
    required String text,
    int maxLines = 1,
    bool autoResize = true,
    TextAlign textAlign = TextAlign.start,
    List<String> args = const [],
    TextStyle? textStyle,
  }) {
    return Text(
      tr(text, args: args),
      textAlign: textAlign,
      style: textStyle,
      maxLines: maxLines,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }

  static Widget imageAsset({
    required String path,
    double? height,
    double? width,
    Color? color,
    BoxFit fit = BoxFit.scaleDown,
  }) {
    return Image.asset(
      path,
      height: height,
      width: width,
      fit: fit,
      color: color,
    );
  }

  static Widget imageSvg({
    required String path,
    double? height,
    double? width,
    Color? color,
    BoxFit fit = BoxFit.scaleDown,
  }) {
    return SvgPicture.asset(
      path,
      height: height,
      width: width,
      fit: fit,
      color: color,
    );
  }

  static Widget imageNetwork({
    required String path,
    double? height,
    double? width,
    Color? color,
    Widget? errorWidget,
    BoxFit fit = BoxFit.contain,
    Widget? placeholder,
  }) {
    return CachedNetworkImage(
      fit: fit,
      imageUrl: path,
      color: color,
      height: height,
      width: width,
      errorWidget: (_, text, d) => errorWidget ?? Container(),
      placeholder:
          (context, url) => placeholder ?? const CupertinoActivityIndicator(),
    );
  }

  static Widget imageFile({
    required File path,
    double? height,
    double? width,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    return Image.file(
      height: height,
      width: width,
      path,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container();
      },
    );
  }

  static Widget imageNetworkSVG({
    required String path,
    double? height,
    double? width,
    Color? color,
    Color? placeHolderColor,
  }) {
    return SvgPicture.network(
      path,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      height: height,
      width: width,
      placeholderBuilder: (_) {
        return CupertinoPageScaffold(
          backgroundColor: Colors.transparent,
          child: CupertinoActivityIndicator(
            color: placeHolderColor ?? Colors.white,
          ),
        );
      },
    );
  }

  static customShimmerWidget({
    required BuildContext context,
    required double width,
    required double height,
    EdgeInsets? margin,
    double borderRadius = AppSizes.borderSmall,
  }) {
    return Shimmer.fromColors(
      baseColor: AppColors.primary,
      highlightColor: Colors.grey.shade300,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
