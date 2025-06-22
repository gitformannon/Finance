import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';

class Disable2FAScreen extends StatefulWidget {
  const Disable2FAScreen({super.key});

  @override
  State<Disable2FAScreen> createState() => _Disable2FAScreenState();
}

class _Disable2FAScreenState extends State<Disable2FAScreen> {
  static const double _buttonHeight = 45.0;
  static const EdgeInsets _screenPadding = EdgeInsets.all(24.0);
  static const double _spacingHeight = 16.0;

  String _code = '';
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _disable() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final ok = await AuthService.disableTOTP(_code);
    if (ok) {
      if (mounted) Navigator.pop(context);
      return;
    }

    setState(() {
      _isLoading = false;
      _errorMessage = 'Invalid code';
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
            _screenPadding.bottom + bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Disable 2FA',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.surface
              ),
            ),
            const SizedBox(height: _spacingHeight),
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (v) => _code = v,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  label: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Code',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: _spacingHeight),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_errorMessage!, style: TextStyle(color: AppColors.error)),
              ),
            const SizedBox(height: _spacingHeight),
            SizedBox(
              height: _buttonHeight,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _disable,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                ),
                child: const Text('Disable',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
