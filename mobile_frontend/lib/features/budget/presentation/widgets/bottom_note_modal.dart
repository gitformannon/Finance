import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/features/shared/presentation/widgets/app_buttons/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'budget_input_field.dart';

class BottomNoteModal extends StatefulWidget {
  const BottomNoteModal({
    super.key,
    required this.initialNote,
    required this.onSelect,
  });

  final String? initialNote;
  final ValueChanged<String> onSelect;

  static Future<void> show(
    BuildContext context, {
    required String initialNote,
    required ValueChanged<String> onSelect,
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
          (_) => BottomNoteModal(initialNote: initialNote, onSelect: onSelect),
    );
  }

  @override
  State<BottomNoteModal> createState() => _BottomNoteModal();
}

class _BottomNoteModal extends State<BottomNoteModal> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
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
            color: AppColors.box,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 60,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: AppSizes.spaceS12),
                  decoration: BoxDecoration(
                    color: AppColors.def.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: media.size.height * 0.6,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(AppSizes.paddingM.h),
                    child: BudgetInputField(
                      label: 'Note',
                      controller: _controller,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      minLines: 4,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: AppSizes.paddingM.w,
                    right: AppSizes.paddingM.w,
                    bottom: bottomPadding,
                    top: AppSizes.spaceS12.h,
                  ),
                  child: SaveButton(
                    onPressed: () {
                      widget.onSelect(_controller.text);
                      Navigator.of(context).pop();
                    },
                    text: 'Add note',
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

class BottomNoteField extends StatelessWidget {
  const BottomNoteField({
    super.key,
    required this.note,
    required this.onSelect,
    this.onTap,
  });

  final String note;
  final ValueChanged<String> onSelect;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
        BottomNoteModal.show(context, initialNote: note, onSelect: onSelect);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.box,
              borderRadius: BorderRadius.circular(AppSizes.borderSmall),
              border: Border.all(color: AppColors.def, width: 1.0)
            ),
            child: const Padding(
              padding: EdgeInsets.all(AppSizes.paddingS),
              child: Icon(
                Icons.sticky_note_2_rounded,
                size: 24,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: AppSizes.spaceXS8.w),
          Expanded(
            child: Text(
              note.isEmpty ? 'Note' : note,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
