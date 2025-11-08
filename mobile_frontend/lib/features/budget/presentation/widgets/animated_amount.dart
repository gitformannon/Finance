import 'package:flutter/material.dart';
import '../../../../core/helpers/formatters_helpers.dart';

class AnimatedAmount extends StatefulWidget {
  final int value;
  final String prefix;
  final String suffix;
  final TextStyle style;
  const AnimatedAmount({
    super.key,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    required this.style,
  });

  @override
  State<AnimatedAmount> createState() => _AnimatedAmountState();
}

class _AnimatedAmountState extends State<AnimatedAmount> {
  late int _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant AnimatedAmount oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: _previousValue.toDouble(), end: widget.value.toDouble()),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        final int current = animatedValue.round();
        return Text(
          '${widget.prefix}${Formatters.moneyStringFormatter(current)}${widget.suffix}',
          style: widget.style,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        );
      },
    );
  }
}

