import 'package:flutter/material.dart';

class CurvedBottomNavbar extends StatelessWidget {
  /// Index of the currently selected item.
  final int currentIndex;

  /// Called when user taps on an item.
  final ValueChanged<int> onTap;

  /// Icons to display in the navigation bar.
  final List<IconData> icons;

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
    required this.icons,
    this.selectedGradient = const [Colors.yellow, Colors.greenAccent],
    this.inactiveColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.6),
              blurRadius: 20,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(icons.length, (index) {
            final isSelected = index == currentIndex;
            return GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isSelected
                      ? LinearGradient(colors: selectedGradient)
                      : null,
                  color: isSelected ? null : Colors.grey.shade900,
                ),
                child: Icon(
                  icons[index],
                  color: isSelected ? Colors.black : inactiveColor,
                  size: iconSize,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
