import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/features/shared/presentation/widgets/app_buttons/w_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BottomDatepickerModal extends StatefulWidget {
  const BottomDatepickerModal({
    super.key,
    required this.initialDate,
    required this.onSelect,
    this.minimumDate,
    this.maximumDate,
  });

  final DateTime initialDate;
  final ValueChanged<DateTime> onSelect;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  static Future<void> show(
    BuildContext context, {
    required DateTime initialDate,
    required ValueChanged<DateTime> onSelect,
    DateTime? minimumDate,
    DateTime? maximumDate,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.borderSM16),
        ),
      ),
      builder:
          (_) => BottomDatepickerModal(
            initialDate: initialDate,
            onSelect: onSelect,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
          ),
    );
  }

  State<BottomDatepickerModal> createState() => _BottomDatepickerModalState();
}

class _BottomDatepickerModalState extends State<BottomDatepickerModal> {
  late DateTime _tempDate;

  @override
  void initState() {
    super.initState();
    _tempDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final viewInsets = media.viewInsets.bottom;
    final bottomPadding =
        viewInsets > 0 ? AppSizes.spaceM16.h : media.padding.bottom;

    return SafeArea(
      top: false,
      bottom: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(bottom: viewInsets),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSizes.borderSM16),
            topRight: Radius.circular(AppSizes.borderSM16),
          ),
          child: Container(
            color: AppColors.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: AppSizes.spaceS12),
                  decoration: BoxDecoration(
                    color: AppColors.def.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(
                  height: 200.h,
                  child: CupertinoDatePicker(
                    initialDateTime: _tempDate,
                    minimumDate: widget.minimumDate,
                    maximumDate: widget.maximumDate,
                    mode: CupertinoDatePickerMode.date,
                    backgroundColor: AppColors.background,
                    onDateTimeChanged: (d) => setState(() => _tempDate = d),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: AppSizes.paddingM.w,
                    right: AppSizes.paddingM.w,
                    bottom: bottomPadding,
                  ),
                  child: WButton(
                    onTap: () {
                      widget.onSelect(_tempDate);
                      Navigator.of(context).pop();
                    },
                    text: 'Select',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomDatepickerField extends StatelessWidget {
  const BottomDatepickerField({
    super.key,
    required this.date,
    required this.onSelect,
    this.minimumDate,
    this.maximumDate,
    this.dateFormat = 'dd MMM yyyy',
  });

  final DateTime date;
  final ValueChanged<DateTime> onSelect;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final String dateFormat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => BottomDatepickerModal.show(
            context,
            initialDate: date,
            onSelect: onSelect,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
          ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.box,
              borderRadius: BorderRadius.circular(AppSizes.borderSmall),
              border: Border.all(color: AppColors.def, width: 1)
            ),
            child: const Padding(
              padding: EdgeInsets.all(AppSizes.paddingS),
              child: Icon(
                Icons.calendar_today,
                size: 24,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: AppSizes.spaceXS8.w),
          Text(DateFormat(dateFormat).format(date)),
        ],
      ),
    );
  }
}
