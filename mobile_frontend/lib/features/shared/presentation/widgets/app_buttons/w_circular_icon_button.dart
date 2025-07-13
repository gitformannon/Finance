import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class CircularIconButton extends StatelessWidget {
  final dynamic icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final bool showNotificationDot;

  const CircularIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.backgroundColor = AppColors.accent,
    this.iconColor = AppColors.textPrimary,
    this.size = 60,
    this.showNotificationDot = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;
    if (icon is IconData) {
      iconWidget = Icon(icon as IconData, color: iconColor);
    } else if (icon is Widget) {
      iconWidget = icon as Widget;
    } else {
      throw ArgumentError('icon must be IconData or Widget');
    }

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: iconWidget,
          ),
          if (showNotificationDot)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: size * 0.25,
                height: size * 0.25,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
