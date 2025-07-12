import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';
/// A reusable navigation bar styled according to the design used on
/// [MainPage]. It accepts a list of [NavigationDestination]s and notifies
/// about index changes via [onTap].
class WNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavigationDestination> destinations;

  const WNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      indicatorColor: AppColors.primary.withOpacity(0.2),
      destinations: destinations,
    );
  }
}
