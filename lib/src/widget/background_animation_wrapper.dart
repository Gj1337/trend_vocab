import 'package:flutter/material.dart';

final _rightColor = Colors.green.withAlpha(100);
final _wrongColor = Colors.red.withAlpha(100);
const _defaultColor = Colors.transparent;

class BackgroundAnimationWrapper extends StatefulWidget {
  const BackgroundAnimationWrapper({
    super.key,
    this.accept,
    this.duration = const Duration(milliseconds: 750),
  });

  final bool? accept;
  final Duration duration;

  @override
  State<BackgroundAnimationWrapper> createState() =>
      _BackgroundAnimationWrapperState();
}

class _BackgroundAnimationWrapperState extends State<BackgroundAnimationWrapper>
    with SingleTickerProviderStateMixin {
  var _color = _defaultColor;

  @override
  void didUpdateWidget(covariant BackgroundAnimationWrapper oldWidget) {
    final accept = widget.accept;

    if (accept != null) {
      setState(() => _color = accept ? _rightColor : _wrongColor);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    color: _color,
    duration: widget.duration,
    onEnd: () => setState(() => _color = _defaultColor),
  );
}
