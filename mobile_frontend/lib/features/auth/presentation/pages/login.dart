import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/presentation/cubits/navigate/navigate_cubit.dart';
import '../../../shared/presentation/widgets/app_buttons/w_button.dart';
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
          appBar: AppBar(
            title: Text(LocaleKeys.enter.tr()),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.paddingM16),
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
                            BorderRadius.circular(AppSizes.borderLarge20),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppSizes.paddingM16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            WMaskedTextField(
                              controller: _phoneController,
                              hintText: LocaleKeys.userName.tr(),
                            ),
                            SizedBox(height: AppSizes.spaceM16.h),
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
                            SizedBox(height: AppSizes.spaceM16.h),
                            WButton(
                              onTap: _login,
                              isLoading:
                                  state.status == RequestStatus.loading,
                              text: LocaleKeys.enter.tr(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceM16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () =>
                              context.read<NavigateCubit>().goToRegisterPage(),
                          child: const Text('Register'),
                        ),
                        TextButton(
                          onPressed: () => context
                              .read<NavigateCubit>()
                              .goToForgotPasswordPage(),
                          child: const Text('Forgot password?'),
                        ),
                      ],
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
