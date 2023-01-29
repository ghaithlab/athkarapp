import 'package:athkarapp/main.dart';
import "package:flutter/material.dart";

class AthkarListItem extends StatelessWidget {
  const AthkarListItem({
    Key? key,
    required this.text1,
    required this.text2,
    required this.fontSize,
  }) : super(key: key);

  final String text1;
  final String text2;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey
                : Color(0xFFC8AE91),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: 36,
              ),
              child: Center(
                child: Text(
                  text1,
                  style: TextStyle(
                    fontSize: fontSize,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            Positioned(
              bottom: -17,
              left: 0,
              right: 0,
              child: Center(
                child: NumberContainer(
                  txt: text2,
                  startValue: Color(0xFFF6DAAE),
                  endValue: Color.fromARGB(255, 242, 236, 225),
                ),
                // child: Container(
                //   decoration: BoxDecoration(
                //     // color: Theme.of(context).brightness == Brightness.dark
                //     //     ? Colors.grey[700]
                //     //     : Colors.grey[400],#C8AE91

                //     color: Theme.of(context).brightness == Brightness.dark
                //         //? Colors.grey[700]
                //         //: Color.fromARGB(255, 215, 197, 176),
                //         ? Color(0xFFF6DAAE)
                //         : Color(0xFFF6DAAE),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Padding(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                //     child: Text(
                //       text2,
                //       style: TextStyle(
                //           fontSize: 15,
                //           color: fontColorLight,
                //           fontWeight: FontWeight.w700),
                //       textAlign: TextAlign.center,
                //       textDirection: TextDirection.rtl,
                //     ),
                //   ),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NumberContainer extends StatefulWidget {
  final Color startValue;
  final Color endValue;
  final String txt;
  const NumberContainer(
      {Key? key,
      required this.startValue,
      required this.endValue,
      required this.txt})
      : super(key: key);

  @override
  _NumberContainerState createState() => _NumberContainerState();
}

class _NumberContainerState extends State<NumberContainer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late String _oldTxt;
  @override
  void initState() {
    super.initState();
    _oldTxt = widget.txt;
    initializeController();
  }

  void initializeController() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    var _curveAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _animation = ColorTween(
      begin: widget.startValue,
      end: widget.endValue,
    ).animate(_curveAnimation)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.txt != _oldTxt) {
      _oldTxt = widget.txt;
      _controller.dispose();

      // Perform some action here, such as updating the UI
      initializeController();
      _controller.forward();

      // print("Value has changed to: ${widget.txt}");
    }

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
        return Container(
          decoration: BoxDecoration(
            // color: Theme.of(context).brightness == Brightness.dark
            //     ? Colors.grey[700]
            //     : Colors.grey[400],#C8AE91

            color: _animation.value,

            //Theme.of(context).brightness == Brightness.dark

            //    ? Color(0xFFF6DAAE)
            //    : Color(0xFFF6DAAE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Text(
              widget.txt,
              style: const TextStyle(
                  fontSize: 15,
                  color: fontColorLight,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
        );

        // return Text(
        //   _animation.value.toString(),
        //   style: widget.txtStyle,
        // );
      },
    );
  }
}
