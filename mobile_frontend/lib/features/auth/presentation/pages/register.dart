import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';
import '../../../shared/presentation/widgets/textfields/w_masked_textfield.dart';
import '../../../shared/presentation/cubits/navigate/navigate_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    AppImages.logo,
                    height: AppSizes.logoSmall60.h,
                  ),
                ),
                SizedBox(height: AppSizes.spaceXL24.h),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderLarge),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(AppSizes.paddingM),
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
                        SizedBox(height: AppSizes.spaceM16.h),
                        WButton(
                          onTap: () =>
                              context.read<NavigateCubit>().goToLoginPage(),
                          text: 'Back to login',
                          hasPreviousIcon: true,
                          prevIcon: SvgPicture.asset(
                            'assets/svg/ic_arrow_left.svg',
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ],
                    ),
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
