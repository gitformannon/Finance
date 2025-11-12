import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// A bottom sheet selector widget that replaces standard dropdowns
/// with a more modern bottom sheet interface
class BudgetBottomSheetSelector<T> extends StatelessWidget {
  final String? label;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final List<BudgetSelectorItem<T>> items;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final Widget Function(T item)? itemBuilder;
  final String Function(T item)? displayText;

  const BudgetBottomSheetSelector({
    super.key,
    this.label,
    this.value,
    this.onChanged,
    required this.items,
    this.hintText,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.itemBuilder,
    this.displayText,
  });

  void _showBottomSheet(BuildContext context) {
    if (!enabled || onChanged == null) return;

    showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.borderSM16)),
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.box,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.borderSM16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 60,
              height: 6,
              margin: const EdgeInsets.symmetric(vertical: AppSizes.spaceS12),
              decoration: BoxDecoration(
                color: AppColors.def.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            if (label != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM,
                  vertical: AppSizes.spaceS12,
                ),
                child: Text(
                  label!,
                  style: const TextStyle(
                    fontSize: AppSizes.textSize18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM,
                  vertical: AppSizes.spaceS12,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = value != null && item.value == value;
                  
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop(item.value);
                      onChanged?.call(item.value);
                    },
                    borderRadius: BorderRadius.circular(AppSizes.borderSM16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingM,
                        vertical: AppSizes.padding16,
                      ),
                      margin: const EdgeInsets.only(bottom: AppSizes.spaceXS8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accent.withValues(alpha: 0.1)
                            : AppColors.transparent,
                        borderRadius: BorderRadius.circular(AppSizes.borderSM16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.def.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (item.emoji != null) ...[
                            _buildEmojiWidget(item.emoji!),
                            const SizedBox(width: AppSizes.spaceM16),
                          ],
                          Expanded(
                            child: itemBuilder != null
                                ? itemBuilder!(item.value)
                                : Text(
                                    displayText != null
                                        ? displayText!(item.value)
                                        : item.label,
                                    style: TextStyle(
                                      fontSize: AppSizes.textSize16,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.accent
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.accent,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppSizes.borderSM16);
    final bool interactive = enabled;

    final selectedItem = value != null && items.isNotEmpty
        ? items.firstWhere(
            (item) => item.value == value,
            orElse: () => items.first,
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spaceXS8),
            child: Text(
              label!,
              style: const TextStyle(
                fontSize: AppSizes.textSize14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
        GestureDetector(
          onTap: enabled ? () => _showBottomSheet(context) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.padding16,
              vertical: AppSizes.padding16,
            ),
            decoration: BoxDecoration(
              color: interactive ? AppColors.box : AppColors.def.withValues(alpha: 0.1),
              borderRadius: borderRadius,
              border: Border.all(
                color: interactive
                    ? AppColors.def.withValues(alpha: 0.2)
                    : AppColors.def.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
                    child: Row(
                      children: [
                        if (selectedItem?.emoji != null) ...[
                          _buildEmojiWidget(selectedItem!.emoji!, size: 20),
                          const SizedBox(width: AppSizes.spaceM16),
                        ],
                Expanded(
                  child: Text(
                    selectedItem != null
                        ? (displayText != null
                            ? displayText!(selectedItem.value)
                            : selectedItem.label)
                        : (hintText ?? 'Select'),
                    style: TextStyle(
                      fontSize: AppSizes.textSize16,
                      fontWeight: FontWeight.w500,
                      color: selectedItem != null
                          ? AppColors.textPrimary
                          : AppColors.def,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: AppSizes.spaceXS8),
          Text(
            helperText!,
            style: TextStyle(
              fontSize: AppSizes.textSize12,
              color: AppColors.def,
            ),
          ),
        ],
        if (errorText != null) ...[
          const SizedBox(height: AppSizes.spaceXS8),
          Text(
            errorText!,
            style: TextStyle(
              fontSize: AppSizes.textSize12,
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }
}

/// Item model for the bottom sheet selector
class BudgetSelectorItem<T> {
  final T value;
  final String label;
  final String? emoji;

  const BudgetSelectorItem({
    required this.value,
    required this.label,
    this.emoji,
  });
}

/// Builds the emoji widget, using Image.asset for PNG files
/// Falls back to SvgPicture.asset if the file is an SVG
Widget _buildEmojiWidget(String emojiPath, {double size = 24}) {
  // Check if it's an SVG file
  if (emojiPath.endsWith('.svg')) {
    return SvgPicture.asset(
      emojiPath,
      width: size,
      height: size,
    );
  }
  
  // Otherwise, treat it as a PNG/image
  return Image.asset(
    emojiPath,
    width: size,
    height: size,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) {
      // Fallback to a placeholder icon if image fails to load
      return Icon(
        Icons.image_not_supported_outlined,
        size: size,
        color: AppColors.def.withValues(alpha: 0.5),
      );
    },
  );
}

