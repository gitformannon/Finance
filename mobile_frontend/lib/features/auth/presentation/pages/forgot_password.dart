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

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _send() {
    // Forgot password logic will be implemented later
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot password')),
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
                          controller: _usernameController,
                          hintText: LocaleKeys.userName.tr(),
                        ),
                        SizedBox(height: AppSizes.spaceM16.h),
                        WButton(
                          onTap: _send,
                          text: 'Send',
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
