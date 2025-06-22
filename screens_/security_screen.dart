import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/auth_service.dart';
import 'enable_2fa_screen.dart';
import 'disable_2fa_screen.dart';
import 'reset_password_screen.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool? _enabled;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final s = await AuthService.getTOTPStatus();
    setState(() {
      _enabled = s;
    });
  }

  void _navigate() {
    final sheet = _enabled == true ? const Disable2FAScreen() : const Enable2FAScreen();
    showModalBottomSheet(
      backgroundColor: AppColors.accent,
      barrierColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => sheet,
    ).then((_) => _loadStatus());
  }

  void _openResetPassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.accent,
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => const ResetPasswordScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _navigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.primary,
                  overlayColor: AppColors.primary.withOpacity(0.2),
                  shadowColor: AppColors.primary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16)
                ),
                label: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ImageIcon(
                        AssetImage('Assets/Icons/Icon - totp_auth.png'),
                        size: 28,
                        color: AppColors.primary,
                      ),
                    ),
                    const Text(
                      'Authenticator',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: _enabled == null
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              _enabled! ? Icons.check_circle : Icons.cancel,
                              color: _enabled! ? Colors.green : AppColors.error,
                              size: 24,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openResetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.primary,
                  overlayColor: AppColors.primary.withOpacity(0.2),
                  shadowColor: AppColors.primary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                label: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ImageIcon(
                        AssetImage('Assets/Icons/Icon - reset_pwd.png'),
                        size: 28,
                        color: AppColors.primary,
                      )
                    ),
                    const Text('Reset Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
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
    );
  }
}
