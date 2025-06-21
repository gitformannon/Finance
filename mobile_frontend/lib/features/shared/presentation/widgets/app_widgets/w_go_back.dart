import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/locale_keys.dart';
import 'app_widgets.dart';

class WGoBack extends StatelessWidget {
  final Function onTap;

  const WGoBack({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [
          // SvgPicture.asset(
          //   AppSvgConst.arrowLeft,
          //   color: AppColors.blue,
          //   fit: BoxFit.scaleDown,
          // ),
          AppWidgets.textLocale(
            text: "",
            textStyle: AppTextStyles.bodyRegular.copyWith(
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
