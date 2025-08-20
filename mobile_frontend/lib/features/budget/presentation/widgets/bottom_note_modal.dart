import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/features/shared/presentation/widgets/app_buttons/w_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNoteModal extends StatefulWidget {
  const BottomNoteModal({
    super.key,
    required this.onTap,
  });

  final VoidCall__ onTap;

  static Future<void> show(BuildContext context, {
    required VoidCallback onTap,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.borderSM16)
          )
      ),
      builder: (_) =>
          BottomNoteModal(
            onTap: onTap,
          ),
    );
  }

  State<BottomNoteModal> createState() => _BottomNoteModal();
}

class _BottomNoteModal extends State<BottomNoteModal> {

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppSizes.borderSM16),
        topRight: Radius.circular(AppSizes.borderSM16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 200.h,
            color: AppColors.background,
            child: TextField(),
            ),

          Container(
            color: AppColors.background,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppSizes.paddingM.w,
                  right: AppSizes.paddingM.w,
                ),
                child: WButton(
                  onTap: () {
                    widget.onTap();
                    Navigator.of(context).pop();
                  },
                  text: 'Select',
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

