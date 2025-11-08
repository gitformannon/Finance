import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class TopSegmentedBar extends StatefulWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const TopSegmentedBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  State<TopSegmentedBar> createState() => _TopSegmentedBarState();
}

class _TopSegmentedBarState extends State<TopSegmentedBar> {
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant TopSegmentedBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _current = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.borderSM16),
      ),
      padding: const EdgeInsets.all(AppSizes.paddingS),
      child: SizedBox(
        height: 44,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final int count = widget.items.length;
            final double segmentWidth = constraints.maxWidth / count;
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  left: segmentWidth * _current,
                  top: 0,
                  width: segmentWidth,
                  height: 44,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppSizes.paddingM),
                    ),
                  ),
                ),
                Row(
                  children: List.generate(count, (index) {
                    final bool isSelected = index == _current;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _current = index);
                          widget.onSelected(index);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            child: Text(widget.items[index]),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

