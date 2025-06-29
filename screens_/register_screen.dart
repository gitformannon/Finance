import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import '../mobile_frontend/lib/features/shared/widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const EdgeInsets _screenPadding = EdgeInsets.all(24.0);
  static const double _buttonHeight = 45.0;
  static const double _spacingHeight = 20.0;

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _verifyPassController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _loginController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _verifyPassController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    if (_passController.text.trim() != _verifyPassController.text.trim()) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }
    final success = await AuthService.register(
      _loginController.text.trim(),
      _emailController.text.trim(),
      _passController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (success) {
      if (mounted) {
        Navigator.pop(context);
        Future.delayed(Duration.zero, () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: AppColors.accent,
            barrierColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
            builder: (_) => const LoginScreen(),
          );
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Registration failed. Please check your information.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          _screenPadding.left,
          _screenPadding.top,
          _screenPadding.right,
          _screenPadding.bottom + bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Register',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.surface),
            ),
            const SizedBox(height: _spacingHeight),
            AppTextField(
              label: 'Username',
              controller: _loginController,
              enabled: !_isLoading,
            ),
            const SizedBox(height: _spacingHeight),
            AppTextField(
              label: 'E-mail',
              controller: _emailController,
              enabled: !_isLoading,
            ),
            const SizedBox(height: _spacingHeight),
            AppTextField(
              label: 'Password',
              controller: _passController,
              isPassword: true,
              enabled: !_isLoading,
            ),
            const SizedBox(height: _spacingHeight),
            AppTextField(
              label: 'Verify password',
              controller: _verifyPassController,
              isPassword: true,
              enabled: !_isLoading,
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child:
                    Text(_errorMessage!, style: const TextStyle(color: AppColors.error)),
              ),
            const SizedBox(height: _spacingHeight),
            SizedBox(
              height: _buttonHeight,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Register', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Have an account?',
                    style: TextStyle(color: AppColors.surface, fontSize: 14)),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Future.delayed(Duration.zero, () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: AppColors.accent,
                        barrierColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
                        builder: (_) => const LoginScreen(),
                      );
                    });
                  },
                  child:
                      const Text('Login', style: TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

