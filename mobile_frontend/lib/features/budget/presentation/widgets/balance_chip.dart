import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/helpers/formatters_helpers.dart';

class BalanceChip extends StatefulWidget {
  final String prefix; // '+ ' or '- '
  final int value; // in UZS
  const BalanceChip({super.key, required this.prefix, required this.value});

  @override
  State<BalanceChip> createState() => _BalanceChipState();
}

class _BalanceChipState extends State<BalanceChip> {
  late int _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant BalanceChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.box
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: _previousValue.toDouble(), end: widget.value.toDouble()),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, child) {
          final int current = animatedValue.round();
          return Text(
            '${widget.prefix}${Formatters.moneyStringFormatter(current)} UZS',
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }
}

