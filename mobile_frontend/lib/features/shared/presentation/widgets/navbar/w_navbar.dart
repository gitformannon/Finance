import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_sizes.dart';

/// A reusable navigation bar styled according to the
/// design used on [MainPage]. It accepts a list of navigation
/// items and notifies about index changes via [onTap].
class WNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  /// List of navigation destinations displayed inside the [NavigationBar].
  final List<NavigationDestination> destinations;

  const WNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.paddingS,
        right: AppSizes.paddingS,
        top: AppSizes.paddingS,
        bottom: AppSizes.paddingNavBar
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(AppSizes.borderMedium),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: AppColors.primary.withOpacity(0.2),
            highlightColor: AppColors.primary.withOpacity(0.1),
          ),
          child: Container(
            height: 87,
            child: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: onTap,
              indicatorColor: AppColors.textSecondary,
              destinations: destinations,
              backgroundColor: AppColors.textPrimary,
              elevation: 4.0,
            ),
          ),
        ),
      ),
    );
  }
}
