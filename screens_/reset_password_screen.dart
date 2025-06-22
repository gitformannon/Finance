import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

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
  bool _obscurePassword = true;
  bool _obscureVerifyPassword = true;
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
            _buildTextField('E-mail', _emailController, isEmail: true),
            const SizedBox(height: _spacingHeight),
            _buildTextField('TOTP code', _codeController, isNumber: true),
            const SizedBox(height: _spacingHeight),
            _buildTextField('New password', _passController, isPassword: true),
            const SizedBox(height: _spacingHeight),
            _buildTextField('Verify password', _verifyPassController,
                isPassword: true, isVerify: true),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    bool isVerify = false,
    bool isNumber = false,
    bool isEmail = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        enabled: !_isLoading && !_isSent,
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : isNumber
                ? TextInputType.number
                : TextInputType.text,
        obscureText:
            isPassword ? (isVerify ? _obscureVerifyPassword : _obscurePassword) : false,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: AppColors.background,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon: isPassword
              ? Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                    splashColor: AppColors.primary,
                    highlightColor: AppColors.primary,
                    onTap: () {
                      setState(() {
                        if (isVerify) {
                          _obscureVerifyPassword = !_obscureVerifyPassword;
                        } else {
                          _obscurePassword = !_obscurePassword;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        (isVerify ? _obscureVerifyPassword : _obscurePassword)
                            ? 'Assets/Icons/Icon - pwd_hide.png'
                            : 'Assets/Icons/Icon - pwd_show.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

