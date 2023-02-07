import 'package:flutter/material.dart';

class NumberCounter extends StatefulWidget {
  final int startValue;
  final int endValue;
  final TextStyle txtStyle;
  const NumberCounter(
      {Key? key,
      this.startValue = 0,
      required this.endValue,
      required TextStyle this.txtStyle})
      : super(key: key);

  @override
  _NumberCounterState createState() => _NumberCounterState();
}

class _NumberCounterState extends State<NumberCounter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    initializeController();
  }

  void initializeController() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = IntTween(
      begin: widget.startValue,
      end: widget.endValue,
    ).animate(_controller)
      ..addStatusListener((status) {
        // if (status == AnimationStatus.completed) {
        //   _controller.stop();
        // }
      });
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.dispose();
    initializeController();

    // setState(() {
    //   _controller.value = 0.0;
    //   _controller.forward();
    // });
    //retrying = false;
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
        return Text(
          _animation.value.toString(),
          style: widget.txtStyle,
        );
      },
    );
  }
}
