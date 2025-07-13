import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_sizes.dart';

class WNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const WNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSizes.paddingS,
        left: AppSizes.paddingS,
        right: AppSizes.paddingS,
        bottom: AppSizes.paddingNavBar
      ), // отступ от краёв экрана
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.borderMedium), // ← полностью округлённые края
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            hoverColor: AppColors.transparent,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.def,
              backgroundColor: AppColors.textPrimary,
            )
          ),
          child: SizedBox(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: onTap,
              items: items
            ),
          ),
        ),
      ),
    );
  }
}
