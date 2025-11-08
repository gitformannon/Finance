import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../buttons/app_button.dart';
import '../focus/focus_manager.dart';

/// Universal modal component that can be used across the entire app
class AppModal extends StatelessWidget {
  const AppModal({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions,
    this.isDismissible = true,
    this.enableDrag = true,
    this.maxHeight,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.showCloseButton = true,
    this.onClose,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget>? actions;
  final bool isDismissible;
  final bool enableDrag;
  final double? maxHeight;
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final bool showCloseButton;
  final VoidCallback? onClose;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    String? subtitle,
    List<Widget>? actions,
    bool isDismissible = true,
    bool enableDrag = true,
    double? maxHeight,
    Color? backgroundColor,
    double? borderRadius,
    EdgeInsets? padding,
    bool showCloseButton = true,
    VoidCallback? onClose,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius ?? AppSizes.borderSM16),
        ),
      ),
      builder: (context) => AppModal(
        title: title,
        subtitle: subtitle,
        child: child,
        actions: actions,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        maxHeight: maxHeight,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        padding: padding,
        showCloseButton: showCloseButton,
        onClose: onClose,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final viewInsets = media.viewInsets.bottom;
    final effectiveMaxHeight = maxHeight ?? media.size.height * 0.8;
    final effectivePadding = padding ?? EdgeInsets.symmetric(
      horizontal: AppSizes.paddingM.w,
      vertical: AppSizes.spaceS12.h,
    );

    return KeyboardShortcutHandler(
      onEscape: () {
        if (isDismissible) {
          if (onClose != null) {
            onClose!();
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: FocusScopeWrapper(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.only(bottom: viewInsets),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: effectiveMaxHeight - viewInsets,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  backgroundColor ?? AppColors.box,
                  backgroundColor ?? AppColors.box,
                ],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius ?? AppSizes.borderSM16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _buildHeader(context),
                
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: effectivePadding,
                    child: child,
                  ),
                ),
                
                // Actions
                if (actions != null) _buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM.w,
        vertical: AppSizes.spaceS12.h,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.def,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppSizes.textSize20,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: AppSizes.textSize14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (showCloseButton)
            IconButton(
              onPressed: () {
                if (onClose != null) {
                  onClose!();
                } else {
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM.w,
        vertical: AppSizes.spaceS12.h,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.def,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: actions!
            .map((action) => Expanded(child: action))
            .toList(),
      ),
    );
  }
}

/// Specialized form modal for input forms
class AppFormModal extends StatefulWidget {
  const AppFormModal({
    super.key,
    required this.title,
    required this.fields,
    required this.onSubmit,
    this.subtitle,
    this.submitText = 'Save',
    this.cancelText = 'Cancel',
    this.isLoading = false,
    this.isDismissible = true,
    this.maxHeight,
    this.onCancel,
  });

  final String title;
  final String? subtitle;
  final List<Widget> fields;
  final VoidCallback onSubmit;
  final String submitText;
  final String cancelText;
  final bool isLoading;
  final bool isDismissible;
  final double? maxHeight;
  final VoidCallback? onCancel;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<Widget> fields,
    required VoidCallback onSubmit,
    String? subtitle,
    String submitText = 'Save',
    String cancelText = 'Cancel',
    bool isLoading = false,
    bool isDismissible = true,
    double? maxHeight,
    VoidCallback? onCancel,
  }) {
    return AppModal.show<T>(
      context: context,
      title: title,
      subtitle: subtitle,
      maxHeight: maxHeight,
      isDismissible: isDismissible,
      child: AppFormModal(
        title: title,
        subtitle: subtitle,
        fields: fields,
        onSubmit: onSubmit,
        submitText: submitText,
        cancelText: cancelText,
        isLoading: isLoading,
        isDismissible: isDismissible,
        maxHeight: maxHeight,
        onCancel: onCancel,
      ),
      actions: [
        AppCancelButton(
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            } else {
              Navigator.of(context).pop();
            }
          },
          text: cancelText,
          isDisabled: isLoading,
        ),
        const SizedBox(width: 12),
        AppSaveButton(
          onPressed: onSubmit,
          text: submitText,
          isLoading: isLoading,
        ),
      ],
    );
  }

  @override
  State<AppFormModal> createState() => _AppFormModalState();
}

class _AppFormModalState extends State<AppFormModal> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.fields.map((field) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: field,
        )),
      ],
    );
  }
}

/// Specialized confirmation modal
class AppConfirmationModal extends StatelessWidget {
  const AppConfirmationModal({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDestructive = false,
    this.isLoading = false,
  });

  final String title;
  final String message;
  final VoidCallback onConfirm;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final bool isLoading;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
    bool isLoading = false,
  }) {
    return AppModal.show<T>(
      context: context,
      title: title,
      child: AppConfirmationModal(
        title: title,
        message: message,
        onConfirm: onConfirm,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        isLoading: isLoading,
      ),
      actions: [
        AppCancelButton(
          onPressed: () => Navigator.of(context).pop(),
          text: cancelText,
          isDisabled: isLoading,
        ),
        const SizedBox(width: 12),
        AppButton(
          onPressed: onConfirm,
          text: confirmText,
          isLoading: isLoading,
          buttonType: isDestructive ? ButtonType.error : ButtonType.primary,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: AppSizes.textSize16,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Specialized loading modal
class AppLoadingModal extends StatelessWidget {
  const AppLoadingModal({
    super.key,
    this.message = 'Loading...',
    this.isDismissible = false,
  });

  final String message;
  final bool isDismissible;

  static Future<void> show({
    required BuildContext context,
    String message = 'Loading...',
    bool isDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => AppLoadingModal(
        message: message,
        isDismissible: isDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.box,
          borderRadius: BorderRadius.circular(AppSizes.borderSM16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: AppSizes.textSize16,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
