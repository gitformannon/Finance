import 'package:flutter/material.dart';

import '../app_buttons/w_dialog_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        WDialogButton(
          text: 'Cancel',
          onTap: onCancel,
        ),
        WDialogButton(
          text: 'OK',
          onTap: onConfirm,
          isPrimary: true,
        ),
      ],
    );
  }
}
