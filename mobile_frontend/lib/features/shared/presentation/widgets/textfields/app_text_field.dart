import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final bool isEmail;
  final bool isNumber;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.isEmail = false,
    this.isNumber = false,
    this.enabled = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  TextInputType _keyboardType() {
    if (widget.isEmail) return TextInputType.emailAddress;
    if (widget.isNumber) return TextInputType.number;
    return TextInputType.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderMedium12),
      ),
      child: TextField(
        controller: widget.controller,
        enabled: widget.enabled,
        keyboardType: _keyboardType(),
        obscureText: widget.isPassword ? _obscure : false,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderMedium12),
            borderSide: const BorderSide(color: AppColors.box),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderMedium12),
            borderSide: const BorderSide(color: AppColors.box),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderMedium12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          suffixIcon: widget.isPassword
              ? Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    splashColor: AppColors.primary,
                    highlightColor: AppColors.primary,
                    onTap: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        _obscure
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
