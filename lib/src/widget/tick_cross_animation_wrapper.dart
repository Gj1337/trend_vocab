import 'package:flutter/material.dart';

const _tick = '✅';
const _cross = '❌';

class TickCrossAnimationWrapper extends StatefulWidget {
  const TickCrossAnimationWrapper({
    super.key,
    this.accept,
    this.duration = const Duration(milliseconds: 1500),
  });

  final bool? accept;
  final Duration duration;

  @override
  State<TickCrossAnimationWrapper> createState() =>
      _TickCrossAnimationWrapperState();
}

class _TickCrossAnimationWrapperState extends State<TickCrossAnimationWrapper>
    with SingleTickerProviderStateMixin {
  var text = '';

  late final AnimationController _animationController;
  late final Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 0.5,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 0.5,
      ),
    ]).animate(_animationController);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant TickCrossAnimationWrapper oldWidget) {
    final accept = widget.accept;
    if (accept == null) {
      super.didUpdateWidget(oldWidget);
      return;
    }

    text = accept ? _tick : _cross;

    _animationController.reset();
    _animationController.forward();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _animationController,
        builder:
            (context, child) => Transform.translate(
              offset: Offset(0, (_animation.value * 30) * -1),
              child: Opacity(opacity: _animation.value, child: child),
            ),
        child: Text(text, style: TextStyle(fontSize: 200)),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }
}
