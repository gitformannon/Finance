import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import 'emoji_picker_modal.dart';

class EmojiPickerButton extends StatelessWidget {
  final String? selectedEmoji;
  final Function(String) onEmojiSelected;
  final double size;

  const EmojiPickerButton({
    super.key,
    this.selectedEmoji,
    required this.onEmojiSelected,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final emoji = await EmojiPickerModal.show(
          context,
          selectedEmoji: selectedEmoji,
        );
        if (emoji != null) {
          onEmojiSelected(emoji);
        }
      },
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: selectedEmoji != null
              ? AppColors.accent.withValues(alpha: 0.1)
              : AppColors.def.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.borderSM16),
          border: Border.all(
            color: selectedEmoji != null
                ? AppColors.accent
                : AppColors.def.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: selectedEmoji != null
              ? (selectedEmoji!.startsWith('assets/') || selectedEmoji!.startsWith('/'))
                  ? Image.asset(
                      selectedEmoji!,
                      width: (size * 0.5).w,
                      height: (size * 0.5).w,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported,
                          color: AppColors.def,
                          size: (size * 0.5).w,
                        );
                      },
                    )
                  : Text(
                      selectedEmoji!,
                      style: TextStyle(fontSize: (size * 0.5).w),
                    )
              : Icon(
                  Icons.emoji_emotions_outlined,
                  color: AppColors.def,
                  size: (size * 0.5).w,
                ),
        ),
      ),
    );
  }
}

