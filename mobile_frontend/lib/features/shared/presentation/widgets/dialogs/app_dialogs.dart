import 'package:flutter/material.dart';

import 'confirmation_dialog.dart';
import 'error_dialog.dart';
import 'loadind_dialog.dart';

class AppDialogs {
  /// Generic show method
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget dialog,
    bool dismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (_) => dialog,
    );
  }

  /// Shortcut for error dialog
  static Future<void> showError(BuildContext context, String message) {
    return show(
      context: context,
      dialog: ErrorDialog(message: message),
    );
  }

  /// Shortcut for confirmation
  static Future<void> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return show(
      context: context,
      dialog: ConfirmationDialog(
        title: title,
        message: message,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  /// Shortcut for loading
  static Future<void> showLoading(BuildContext context) {
    return show(
      context: context,
      dialog: const LoadingDialog(),
      dismissible: false,
    );
  }

  /// Universal hide
  static void hideDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
