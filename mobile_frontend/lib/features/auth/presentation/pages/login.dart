import 'package:Finance/core/themes/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/presentation/cubits/navigate/navigate_cubit.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';
import '../../../shared/presentation/widgets/app_buttons/w_text_button.dart';
import '../../../shared/presentation/widgets/textfields/w_masked_textfield.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/locale_keys.dart';
import '../../../../core/helpers/enums_helpers.dart';
import '../cubit/login/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    context.read<LoginCubit>().login(
          username: _phoneController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == RequestStatus.loaded) {
          context.read<NavigateCubit>().goToMainPage();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.background,
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
                      padding:
                        const EdgeInsets.all(AppSizes.paddingS),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          WMaskedTextField(
                            controller: _phoneController,
                            hintText: LocaleKeys.userName.tr(),
                          ),
                          SizedBox(height: AppSizes.spaceXXS5.h),
                          WMaskedTextField(
                            controller: _passwordController,
                            hintText: LocaleKeys.password.tr(),
                            isPassword: true,
                          ),
                          if (state.status == RequestStatus.error)
                            Padding(
                              padding:
                                  EdgeInsets.only(top: AppSizes.spaceS12.h),
                              child: Text(
                                state.errorMessage ?? '',
                                style:
                                    const TextStyle(color: AppColors.error),
                              ),
                            ),
                          SizedBox(height: AppSizes.spaceL20.h),
                          WButton(
                            onTap: _login,
                            isLoading:
                                state.status == RequestStatus.loading,
                            text: LocaleKeys.enter.tr(),
                          ),
                          SizedBox(height: AppSizes.spaceS12.h),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WTextButton(
                                onTap: () =>
                                  context.read<NavigateCubit>().goToForgotPasswordPage(),
                                text: LocaleKeys.resetPassword.tr(),
                              ),
                              SizedBox(height: AppSizes.spaceXL24.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(LocaleKeys.signUpText.tr(),
                                    style: AppTextStyles.bodyMedium
                                  ),
                                  SizedBox(width: AppSizes.spaceS12.w,),
                                  WTextButton(
                                    onTap: () =>
                                      context.read<NavigateCubit>().goToRegisterPage(),
                                    text: LocaleKeys.signUp.tr(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.spaceL20.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
