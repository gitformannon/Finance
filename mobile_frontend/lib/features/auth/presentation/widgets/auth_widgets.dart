import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/presentation/widgets/app_buttons/w_button.dart';
import '../../../shared/presentation/widgets/textfields/w_masked_textfield.dart';

class AuthWidgets {
  static Widget textField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    return WMaskedTextField(
      controller: controller,
      hintText: hint,
      isPassword: isPassword,
    );
  }

  static Widget actionButton({
    required VoidCallback onTap,
    required String text,
    bool isLoading = false,
  }) {
    return WButton(
      onTap: onTap,
      text: text,
      isLoading: isLoading,
    );
  }

  static Widget navigationButton({
    required VoidCallback onTap,
    required String text,
    required SvgPicture icon,
    bool forward = true,
  }) {
    return WButton(
      onTap: onTap,
      text: text,
      hasNextIcon: forward,
      hasPreviousIcon: !forward,
      nextIcon: forward ? icon : null,
      prevIcon: !forward ? icon : null,
    );
  }
}
