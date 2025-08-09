import 'package:Finance/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class CurvedBottomNavbar extends StatelessWidget {
  /// Index of the currently selected item.
  final int currentIndex;

  /// Called when user taps on an item.
  final ValueChanged<int> onTap;

  /// Items to display in the navigation bar.
  final List<BottomNavigationBarItem> items;

  /// Gradient colors for the active item.
  final List<Color> selectedGradient;

  /// Color of inactive icons.
  final Color inactiveColor;

  /// Background color of the navbar container.
  final Color backgroundColor;

  /// Size of the icons.
  final double iconSize;

  const CurvedBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.selectedGradient = const [AppColors.primary, AppColors.primary],
    this.inactiveColor = AppColors.def,
    this.backgroundColor = AppColors.textPrimary,
    this.iconSize = AppSizes.navbarIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.paddingL),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingS,
          vertical: AppSizes.paddingM,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppSizes.borderCircle),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 20),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (index) {
            final isSelected = index == currentIndex;
            final item = items[index];
            final icon = isSelected
                ? (item.activeIcon ?? item.icon)
                : item.icon;
            return GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingS),
                width: AppSizes.navbarButtonHeight,
                height: AppSizes.navbarButtonHeight,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                      isSelected ? LinearGradient(colors: selectedGradient) : null,
                  color: isSelected ? null : AppColors.def.withOpacity(0.2),
                ),
                child: IconTheme(
                  data: IconThemeData(
                    color: isSelected ? AppColors.textPrimary : inactiveColor,
                    size: iconSize,
                  ),
                  child: icon,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
