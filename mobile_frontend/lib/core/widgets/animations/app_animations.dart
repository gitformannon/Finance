import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

/// Universal scale animation component
class AppScaleAnimation extends StatefulWidget {
  const AppScaleAnimation({
    super.key,
    required this.child,
    required this.onTap,
    this.scaleValue = 0.95,
    this.duration = const Duration(milliseconds: 100),
    this.isDisabled = false,
  });

  final Widget child;
  final VoidCallback onTap;
  final double scaleValue;
  final Duration duration;
  final bool isDisabled;

  @override
  State<AppScaleAnimation> createState() => _AppScaleAnimationState();
}

class _AppScaleAnimationState extends State<AppScaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isDisabled) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.isDisabled) {
      _controller.reverse();
      widget.onTap();
    }
  }

  void _onTapCancel() {
    if (!widget.isDisabled) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: widget.isDisabled ? 0.6 : 1.0,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// Universal fade animation component
class AppFadeAnimation extends StatefulWidget {
  const AppFadeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.beginOpacity = 0.0,
    this.endOpacity = 1.0,
    this.curve = Curves.easeInOut,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final double beginOpacity;
  final double endOpacity;
  final Curve curve;

  @override
  State<AppFadeAnimation> createState() => _AppFadeAnimationState();
}

class _AppFadeAnimationState extends State<AppFadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: widget.beginOpacity,
      end: widget.endOpacity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Universal slide animation component
class AppSlideAnimation extends StatefulWidget {
  const AppSlideAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.beginOffset = const Offset(0, 1),
    this.endOffset = Offset.zero,
    this.curve = Curves.easeInOut,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset beginOffset;
  final Offset endOffset;
  final Curve curve;

  @override
  State<AppSlideAnimation> createState() => _AppSlideAnimationState();
}

class _AppSlideAnimationState extends State<AppSlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: widget.endOffset,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        );
      },
    );
  }
}

/// Universal rotation animation component
class AppRotationAnimation extends StatefulWidget {
  const AppRotationAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.beginAngle = 0.0,
    this.endAngle = 1.0,
    this.curve = Curves.easeInOut,
    this.repeat = false,
    this.reverse = false,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final double beginAngle;
  final double endAngle;
  final Curve curve;
  final bool repeat;
  final bool reverse;

  @override
  State<AppRotationAnimation> createState() => _AppRotationAnimationState();
}

class _AppRotationAnimationState extends State<AppRotationAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: widget.beginAngle,
      end: widget.endAngle,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.repeat) {
      _controller.repeat(reverse: widget.reverse);
    } else {
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        Future.delayed(widget.delay, () {
          if (mounted) {
            _controller.forward();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * 3.14159,
          child: widget.child,
        );
      },
    );
  }
}

/// Universal shimmer animation component
class AppShimmerAnimation extends StatefulWidget {
  const AppShimmerAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor = AppColors.box,
    this.highlightColor = AppColors.surface,
    this.direction = ShimmerDirection.ltr,
  });

  final Widget child;
  final Duration duration;
  final Color baseColor;
  final Color highlightColor;
  final ShimmerDirection direction;

  @override
  State<AppShimmerAnimation> createState() => _AppShimmerAnimationState();
}

class _AppShimmerAnimationState extends State<AppShimmerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: widget.direction == ShimmerDirection.ltr 
                  ? Alignment.centerLeft 
                  : Alignment.centerRight,
              end: widget.direction == ShimmerDirection.ltr 
                  ? Alignment.centerRight 
                  : Alignment.centerLeft,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                _shimmerAnimation.value - 0.3,
                _shimmerAnimation.value,
                _shimmerAnimation.value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

enum ShimmerDirection {
  ltr,
  rtl,
}

/// Universal bounce animation component
class AppBounceAnimation extends StatefulWidget {
  const AppBounceAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.beginScale = 0.0,
    this.endScale = 1.0,
    this.curve = Curves.bounceOut,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final double beginScale;
  final double endScale;
  final Curve curve;

  @override
  State<AppBounceAnimation> createState() => _AppBounceAnimationState();
}

class _AppBounceAnimationState extends State<AppBounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _bounceAnimation = Tween<double>(
      begin: widget.beginScale,
      end: widget.endScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}
