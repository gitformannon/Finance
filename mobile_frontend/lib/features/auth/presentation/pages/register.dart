import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';
import '../../../shared/presentation/widgets/textfields/w_masked_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    // Registration logic will be implemented later
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WMaskedTextField(
              controller: _usernameController,
              hintText: LocaleKeys.userName.tr(),
            ),
            SizedBox(height: AppSizes.spaceM16.h),
            WMaskedTextField(
              controller: _passwordController,
              hintText: LocaleKeys.password.tr(),
              isPassword: true,
            ),
            SizedBox(height: AppSizes.spaceM16.h),
            WMaskedTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm password',
              isPassword: true,
            ),
            SizedBox(height: AppSizes.spaceM16.h),
            WButton(
              onTap: _register,
              text: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
