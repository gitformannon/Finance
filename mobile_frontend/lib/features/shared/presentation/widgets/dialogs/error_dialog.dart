import 'package:flutter/material.dart';

import '../app_buttons/w_dialog_button.dart';

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        WDialogButton(
          text: 'OK',
          onTap: () => Navigator.pop(context),
          isPrimary: true,
        ),
      ],
    );
  }
}
