import 'package:flutter/material.dart';

final _rightColor = Colors.green.withAlpha(100);
final _wrongColor = Colors.red.withAlpha(100);
const _defaultColor = Colors.transparent;

class BackgroundAnimationWrapper extends StatefulWidget {
  const BackgroundAnimationWrapper({super.key, this.accept});

  final bool? accept;

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
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: _color,
      duration: Duration(milliseconds: 500),
      onEnd: () => setState(() => _color = _defaultColor),
    );
  }
}
