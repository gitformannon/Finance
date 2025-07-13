import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_sizes.dart';

class WBottomAppBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const WBottomAppBar({
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
        bottom: AppSizes.paddingNavBar,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.borderMedium),
        child: BottomAppBar(
          color: AppColors.textPrimary,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: AppColors.transparent,
              highlightColor: AppColors.transparent,
              hoverColor: AppColors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isSelected = index == currentIndex;
                return Expanded(
                  child: IconButton(
                    onPressed: () => onTap(index),
                    iconSize: AppSizes.navbarIcon,
                    color: isSelected ? AppColors.primary : AppColors.def,
                    icon: item.icon,
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
