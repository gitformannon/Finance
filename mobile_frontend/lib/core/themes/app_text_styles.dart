import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'font_weights.dart';

class AppTextStyles {
  static const _defaultColor = AppColors.textPrimary;
  static const _defaultFontFamily = 'fontRegular';

  /// Dynamic text style generator
  static TextStyle custom({
    required double fontSize,
    FontWeight fontWeight = FontWeights.regular,
    Color color = _defaultColor,
    String fontFamily = _defaultFontFamily,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: fontFamily,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// 🧩 HEADINGS
  static final TextStyle headlineLarge = custom(
    fontSize: AppSizes.textSize24,
    fontWeight: FontWeights.bold,
  );

  static final TextStyle headlineMedium = custom(
    fontSize: AppSizes.textSize20,
    fontWeight: FontWeights.bold,
  );

  /// 🧾 BODY TEXT
  static final TextStyle bodyRegular = custom(
    fontSize: AppSizes.textSize16,
  );

  static final TextStyle bodyMedium = custom(
    fontSize: AppSizes.textSize16,
    fontWeight: FontWeights.medium,
  );

  static final TextStyle bodyLarge = custom(
    fontSize: AppSizes.textSize18,
    fontWeight: FontWeights.regular,
  );

  static final TextStyle bodySemiBold = custom(
    fontSize: AppSizes.textSize16,
    fontWeight: FontWeights.semiBold,
  );

  /// 🔖 SMALL TEXT (labels, caption)
  static final TextStyle labelRegular = custom(fontSize: AppSizes.textSize14);

  static final TextStyle labelMedium = custom(
    fontSize: AppSizes.textSize14,
    fontWeight: FontWeights.medium,
  );

  static final TextStyle labelSemiBold = custom(
    fontSize: AppSizes.textSize14,
    fontWeight: FontWeights.semiBold,
  );
}
