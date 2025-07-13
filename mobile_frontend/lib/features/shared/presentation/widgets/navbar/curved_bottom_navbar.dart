import 'package:flutter/material.dart';

class CurvedBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CurvedBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.home,
      Icons.bar_chart,
      Icons.favorite, // активная
      Icons.settings,
    ];

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
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
                      ? const LinearGradient(
                    colors: [Colors.yellow, Colors.greenAccent],
                  )
                      : null,
                  color: isSelected ? null : Colors.grey.shade900,
                ),
                child: Icon(
                  icons[index],
                  color: isSelected ? Colors.black : Colors.white,
                  size: 28,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
