import 'package:flutter/material.dart';

class FlipAnimation extends StatefulWidget {
  final Widget front;
  final Widget back;
  final bool showFront;

  const FlipAnimation({
    Key? key,
    required this.front,
    required this.back,
    required this.showFront,
  }) : super(key: key);

  @override
  _FlipAnimationState createState() => _FlipAnimationState();
}

class _FlipAnimationState extends State<FlipAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void didUpdateWidget(FlipAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showFront != oldWidget.showFront) {
      if (widget.showFront) {
        _controller.reverse();
      } else {
        _controller.forward();
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
      animation: _animation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_animation.value * 3.14159),
          alignment: Alignment.center,
          child: _animation.value < 0.5
              ? widget.front
              : Transform(
            transform: Matrix4.identity()..rotateY(3.14159),
            alignment: Alignment.center,
            child: widget.back,
          ),
        );
      },
    );
  }
}