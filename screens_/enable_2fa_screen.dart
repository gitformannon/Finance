import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/auth_service.dart';
import '../theme.dart';

class Enable2FAScreen extends StatefulWidget {
  const Enable2FAScreen({super.key});

  @override
  State<Enable2FAScreen> createState() => _Enable2FAScreenState();
}

class _Enable2FAScreenState extends State<Enable2FAScreen> {
  static const double _qrImageSize = 200.0;
  static const double _buttonHeight = 45.0;
  static const double _contentPadding = 24.0;
  static const double _spacingHeight = 16.0;
  static const EdgeInsets _screenPadding = EdgeInsets.all(_contentPadding);

  TOTPData? _totpData;
  String _verificationCode = '';
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _secretController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeTOTP();
  }

  Future<void> _initializeTOTP() async {
    final data = await AuthService.enableTOTP();
    setState(() {
      _isLoading = false;
      if (data != null) {
        _totpData = TOTPData(
          uri: data['uri'],
          qrImage: data['image'],
        );
        _secretController.text = _totpData!.secret;
      }
    });
  }

  Future<void> _confirmTOTP() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final isConfirmed = await AuthService.confirmTOTP(_verificationCode);

    if (isConfirmed) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _isLoading = false;
      _errorMessage = 'Invalid code';
    });
  }

  @override
  void dispose() {
    _secretController.dispose();
    super.dispose();
  }

  Widget _buildQRSection() {
    final data = _totpData;
    if (data == null) return const SizedBox.shrink();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: QrImageView(
            data: data.uri,
            size: _qrImageSize,
            backgroundColor: AppColors.surface,
          ),
        ),
        const SizedBox(height: _spacingHeight),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _secretController,
            readOnly: true,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              label: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Secret key',
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: _secretController.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Secret copied')),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationSection() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            onChanged: (value) => _verificationCode = value,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              label: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
                _errorMessage!, style: TextStyle(color: AppColors.error)),
          ),
        const SizedBox(height: _spacingHeight),
        SizedBox(
          height: _buttonHeight,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _confirmTOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
            ),
            child: const Text('Confirm',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          _contentPadding,
          _contentPadding,
          _contentPadding,
          _contentPadding + bottomInset,
        ),
        child: _isLoading
          ? SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
            )
          : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enable 2FA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.surface
                ),
              ),
              const SizedBox(height: _spacingHeight),
              _buildQRSection(),
              const SizedBox(height: _spacingHeight),
              _buildVerificationSection(),
            ],
            ),
      ),
    );
  }
}

class TOTPData {
  final String uri;
  final Uint8List qrImage;

  const TOTPData({
    required this.uri,
    required this.qrImage,
  });

  String get secret => Uri.parse(uri).queryParameters['secret'] ?? '';
}
