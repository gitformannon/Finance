import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import '../mobile_frontend/lib/features/shared/widgets/app_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  static const EdgeInsets _screenPadding = EdgeInsets.all(24.0);
  static const double _buttonHeight = 45.0;
  static const double _spacingHeight = 20.0;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _verifyPassController = TextEditingController();

  bool _isLoading = false;
  bool _isSent = false;
  String? _infoMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passController.dispose();
    _verifyPassController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    setState(() {
      _isLoading = true;
      _infoMessage = null;
    });

    final email = _emailController.text.trim();
    final code = _codeController.text.trim();
    final newPass = _passController.text;
    final verifyPass = _verifyPassController.text;

    if (email.isEmpty) {
      setState(() {
        _isLoading = false;
        _infoMessage = 'Enter e‑mail';
      });
      return;
    }
    if (code.isEmpty || newPass.isEmpty || verifyPass.isEmpty) {
      setState(() {
        _isLoading = false;
        _infoMessage = 'Enter code and new password';
      });
      return;
    }

    if (newPass != verifyPass) {
      setState(() {
        _isLoading = false;
        _infoMessage = 'Passwords do not match';
      });
      return;
    }

    final ok = await AuthService.resetPassword(email, code, newPass);
    if (ok) _isSent = true;
    setState(() {
      _isLoading = false;
      _infoMessage = ok ? 'Password updated!' : 'Failed to reset password.';
    });
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
              'Reset Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.surface),
            ),
            const SizedBox(height: _spacingHeight),
            AppTextField(
              label: 'E-mail',
              controller: _emailController,
              isEmail: true,
              enabled: !_isLoading && !_isSent,
            ),
            const SizedBox(height: _spacingHeight),
            AppTextField(
              label: 'TOTP code',
              controller: _codeController,
              isNumber: true,
              enabled: !_isLoading && !_isSent,
            ),
            const SizedBox(height: _spacingHeight),
            AppTextField(
              label: 'New password',
              controller: _passController,
              isPassword: true,
              enabled: !_isLoading && !_isSent,
            ),
            const SizedBox(height: _spacingHeight),
            AppTextField(
              label: 'Verify password',
              controller: _verifyPassController,
              isPassword: true,
              enabled: !_isLoading && !_isSent,
            ),
            const SizedBox(height: _spacingHeight),
            SizedBox(
              height: _buttonHeight,
              child: ElevatedButton(
                onPressed: _isLoading || _isSent ? null : _sendReset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                child: Text(_isSent ? 'Done' : 'Reset',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            if (_infoMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _infoMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _infoMessage!.startsWith('Password')
                      ? AppColors.surface
                      : AppColors.error,
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Remember password?',
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
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
                        builder: (_) => const LoginScreen(),
                      );
                    });
                  },
                  child: const Text('Login',
                      style: TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

