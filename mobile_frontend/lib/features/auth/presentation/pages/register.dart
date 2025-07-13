import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../shared/presentation/cubits/navigate/navigate_cubit.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';
import '../../../shared/presentation/widgets/app_buttons/w_text_button.dart';
import '../../../shared/presentation/widgets/textfields/w_masked_textfield.dart';
import '../../../shared/presentation/widgets/appbar/w_inner_appbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    // Registration logic will be implemented later
    setState(() {
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: SubpageAppBar(
        title: LocaleKeys.signUp.tr(),
        onBackTap: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingXS),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingS),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WMaskedTextField(
                        controller: _emailController,
                        hintText: LocaleKeys.email.tr(),
                      ),
                      SizedBox(height: AppSizes.spaceXXS5.h),
                      WMaskedTextField(
                        controller: _codeController,
                        hintText: LocaleKeys.totp.tr(),
                      ),
                      SizedBox(height: AppSizes.spaceXXS5.h),
                      WMaskedTextField(
                        controller: _newPasswordController,
                        hintText: LocaleKeys.newPass.tr(),
                        isPassword: true,
                      ),
                      SizedBox(height: AppSizes.spaceXXS5.h),
                      WMaskedTextField(
                        controller: _confirmPasswordController,
                        hintText: LocaleKeys.confirmNewPass.tr(),
                        isPassword: true,
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding:
                              EdgeInsets.only(top: AppSizes.spaceS12.h),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      SizedBox(height: AppSizes.spaceL20.h),
                      WButton(
                        onTap: _register,
                        text: LocaleKeys.signUp.tr(),
                      ),
                      SizedBox(height: AppSizes.spaceL20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(LocaleKeys.enterText.tr(),
                              style: AppTextStyles.bodyMedium
                          ),
                          SizedBox(width: AppSizes.spaceS12.w,),
                          WTextButton(
                            onTap:
                                () => context.read<NavigateCubit>().goToLoginPage(),
                            text: LocaleKeys.enter.tr(),
                          ),
                        ],
                      ),
                    ],
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
