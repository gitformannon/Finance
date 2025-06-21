import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/core/helpers/exception_helpers.dart';
import 'package:Finance/features/shared/presentation/widgets/bottom_sheet_models/w_bottom_sheet_divder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';

mixin BaseBottomSheet {
  customBottomSheet({
    required BuildContext context,
    required Widget baseWidget,
    Color background = AppColors.surface,
    double borderTopLeft = AppSizes.spaceM16,
    double borderTopRight = AppSizes.spaceM16,
    double? height,
    bool useSafeArea = true,
    bool isDismissible = true,
    bool userRootNavigator = true,
    bool isScrollControlled = true,
    bool enableDrag = true,
    Function? goBackFunc,
    Function? thenFunc,
    double? horizontal,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderTopLeft),
          topRight: Radius.circular(borderTopRight),
        ),
      ),
      useSafeArea: useSafeArea,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      useRootNavigator: userRootNavigator,
      isScrollControlled: isScrollControlled,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [const WBottomSheetDivider(), baseWidget],
          ).paddingSymmetric(
            horizontal: horizontal ?? AppSizes.spaceL20.w,
            vertical: AppSizes.spaceL20.h,
          ),
    ).then((value) => {if (thenFunc != null) thenFunc(value)});
  }

  draggableScrollBottomSheet({
    required BuildContext context,
    required Widget baseWidget,
    EdgeInsets? contentPadding,
    Color background = AppColors.surface,
    double borderTopLeft = AppSizes.spaceL20,
    double borderTopRight = AppSizes.spaceL20,
    double? maxChildSize,
    double? minChildSize,
    bool useSafeArea = true,
    bool isDismissible = true,
    bool useRootNavigator = true,
    bool isScrollControlled = true,
    bool enableDrag = true,
    Function? goBackFunc,
    Function? thenFunc,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderTopLeft),
          topRight: Radius.circular(borderTopRight),
        ),
      ),
      useSafeArea: useSafeArea,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      useRootNavigator: useRootNavigator,
      isScrollControlled: isScrollControlled,
      builder:
          (context) => DraggableScrollableSheet(
            expand: false,
            maxChildSize: maxChildSize ?? 0.9,
            minChildSize: minChildSize ?? 0.5,
            builder: (_, controller) {
              return SingleChildScrollView(
                padding:
                    contentPadding ??
                    EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceM16.w,
                      vertical: AppSizes.spaceL20.h,
                    ),
                controller: controller,
                child: Column(
                  children: [const WBottomSheetDivider(), baseWidget],
                ),
              );
            },
          ),
    ).then((value) => {if (thenFunc != null) thenFunc()});
  }
}
