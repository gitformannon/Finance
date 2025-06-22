import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

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
  bool _obscurePassword = true;
  bool _obscureVerifyPassword = true;
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
            _buildTextField('Username', _loginController),
            const SizedBox(height: _spacingHeight),
            _buildTextField('E-mail', _emailController),
            const SizedBox(height: _spacingHeight),
            _buildTextField('Password', _passController, isPassword: true),
            const SizedBox(height: _spacingHeight),
            _buildTextField('Verify password', _verifyPassController,
                isPassword: true, isVerify: true),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false, bool isVerify = false}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        enabled: !_isLoading,
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

