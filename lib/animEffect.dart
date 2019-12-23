import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class JoFadeIn extends StatelessWidget {
  final double delay;
  final Widget child;
  final bool isVertical;

  JoFadeIn({this.delay, this.isVertical, this.child});

  @override
  Widget build(BuildContext context) {
    final tween = isVertical
        ? MultiTrackTween([
            Track("opacity")
                .add(Duration(milliseconds: 300), Tween(begin: 0.0, end: 1.0)),
            Track("translateX").add(
                Duration(milliseconds: 300), Tween(begin: -150.0, end: 0.0),
                curve: Curves.easeOut)
          ])
        : MultiTrackTween([
            Track("opacity")
                .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
            Track("translateX").add(
                Duration(milliseconds: 500), Tween(begin: 170.0, end: 0.0),
                curve: Curves.easeOut)
          ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (300 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: isVertical
                ? Offset(0, animation["translateX"])
                : Offset(animation["translateX"], 0),
            child: child),
      ),
    );
  }
}
