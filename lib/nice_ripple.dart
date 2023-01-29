library nice_ripple;

import 'package:flutter/material.dart';

///A Flutter Class For Showing Ripple Effects
class NiceRipple extends StatefulWidget {
  const NiceRipple({
    this.child,
    Key? key,
    this.rippleColor,
    this.duration,
    this.onTap,
    this.rippleShape,
    this.radius,
    this.lowerBound,
    this.rippleLength,
    this.curve,
  }) : super(key: key);

  final Duration? duration;
  final double? radius;
  final Widget? child;
  final Color? rippleColor;
  final BoxShape? rippleShape;
  final VoidCallback? onTap;
  final double? lowerBound;
  final int? rippleLength;
  final Curve? curve;

  @override
  State<NiceRipple> createState() => _NiceRippleState();
}

class _NiceRippleState extends State<NiceRipple>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: widget.lowerBound ?? 0.5,
      duration: widget.duration ?? const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: widget.onTap, child: _rippleWidget());
  }

  Widget _rippleWidget() {
    return AnimatedBuilder(
      animation: CurvedAnimation(
          parent: _controller!, curve: widget.curve ?? Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ...List.generate(
              widget.rippleLength ?? 4,
              (index) => _containerWidget(widget.radius == null
                  ? (100 * index) * _controller!.value
                  : (widget.radius! * index) * _controller!.value),
            ),
            Align(child: widget.child ?? Container()),
          ],
        );
      },
    );
  }

  Widget _containerWidget(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
          shape: widget.rippleShape ?? BoxShape.circle,
          color: widget.rippleColor == null
              ? Colors.blue.withOpacity(1 - _controller!.value)
              : widget.rippleColor!.withOpacity(1 - _controller!.value)),
    );
  }
}
