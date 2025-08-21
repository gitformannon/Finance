import 'package:Finance/core/constants/app_colors.dart';
import 'package:Finance/core/constants/app_sizes.dart';
import 'package:Finance/features/shared/presentation/widgets/app_buttons/w_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            top: Radius.circular(AppSizes.borderSM16)
        )
      ),
      builder: (_) => BottomNoteModal(
        initialNote: initialNote,
        onSelect: onSelect,
      ),
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.borderSM16),
          topRight: Radius.circular(AppSizes.borderSM16)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.box,
              child: Padding(
                padding: EdgeInsets.all(AppSizes.paddingM.h),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(labelText: 'Note'),
                  maxLines: null,
                ),
              ),
            ),
            Container(
              color: AppColors.box,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AppSizes.paddingM.w,
                    right: AppSizes.paddingM.w,
                    bottom: _focusNode.hasFocus ? AppSizes.paddingM : 0,
                  ),
                  child: WButton(
                    onTap: () {
                      widget.onSelect(_controller.text);
                      Navigator.of(context).pop();
                    },
                    text: 'Save',
                  ),
                ),
              ),
            )
          ],
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
        BottomNoteModal.show(
          context,
          initialNote: note,
          onSelect: onSelect,
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.def.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.borderSmall),
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
          SizedBox(width: AppSizes.spaceXS8.w,),
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
