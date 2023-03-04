import 'package:athkarapp/models/habitsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class HabitButtonAnimated extends StatefulWidget {
  HabitButtonAnimated(
      {super.key,
      required this.habit,
      required this.onClickedDone,
      required this.isDarkMode,
      required this.onTap,
      required this.color});
  final HabitRecord habit;
  final Color color;
  final Function({required HabitRecord habit, int? value}) onClickedDone;
  final Function({required HabitRecord habit}) onTap;
  final bool isDarkMode;
  @override
  State<HabitButtonAnimated> createState() => _HabitButtonAnimatedState();
}

class _HabitButtonAnimatedState extends State<HabitButtonAnimated>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controllerSize;
  late double _scale;
  bool animationDone = false;
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _controllerSize.dispose();

    super.dispose();
  }

  @override
  void initState() {
    double lowerBoundController = widget.isDarkMode ? 0.15 : 0.40;
    DateTime today = DateTime.now();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 750),
        lowerBound: lowerBoundController,
        upperBound: 1);
    if (widget.habit.records!
        .containsKey(DateTime(today.year, today.month, today.day)))
      animationDone = true;
    else {
      // TODO: implement initState

      _controller.addStatusListener((status) {
        print('$status');
        if (status == AnimationStatus.completed) {
          animationDone = true;

          widget.onClickedDone(habit: widget.habit);

          var _type = FeedbackType.success;
          Vibrate.feedback(_type);
        }
      });
      _controller.addListener(() {
        //print(_controller.value);
        setState(() {});
      });
    }

    _controllerSize = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 30,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  Color getColor(bool isDefaultHabit, bool isBasicHabit) {
    if (isDefaultHabit)
      return Color.fromARGB(255, 210, 178, 126);
    else if (isBasicHabit)
      return Color.fromARGB(255, 125, 173, 212);
    else
      return Color.fromARGB(255, 125, 212, 187);
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controllerSize.value;
    Color anColor =
        widget.color.withOpacity(animationDone ? 1 : _controller.value);
    return GestureDetector(
      child: Transform.scale(
        scale: _scale,
        child: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
              color: anColor,
              // border: Border.all(width: 0),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${widget.habit.calculateStreak()}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                widget.habit.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              // Align(
              //   child: Icon(Icons.done_all),
              //   alignment: Alignment.center,
              // )
            ],
          ),
        ),
      ),
      onTap: () {
        widget.onTap(habit: widget.habit);
      },
      onLongPressStart: (details) {
        if (!animationDone) {
          _controller.forward(from: 0.3);
          _controllerSize.forward();
        }
        print("onLongPressStart");
      },
      onLongPressUp: () {
        if (!animationDone) {
          _controller.reverse();
        }
        print("onForcePressUp");
        _controllerSize.reverse();

        //TODO: add what happens when long press finish
      },
      onForcePressEnd: (details) {
        print("onForcePressEnd");
      },
      onTapDown: (details) {
        if (!animationDone) _controllerSize.forward();
      },
      onTapUp: (details) {
        _controllerSize.reverse();
      },
      onTapCancel: () {
        // if (_controllerSize.status == AnimationStatus.forward ||
        //     _controllerSize.status == AnimationStatus.completed) {
        _controllerSize.reverse();
        // }
      },
    );
  }
}




// class HabitButton extends StatefulWidget {
//   const HabitButton({super.key});

//   @override
//   State<HabitButton> createState() => _HabitButtonState();
// }

// class _HabitButtonState extends State<HabitButton> {
//   bool isVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//       child: SizedBox(
//         width: 100,
//         key: UniqueKey(),
//         child: ElevatedButton(
//           // style: ElevatedButton.styleFrom(
//           //   splashFactory: NoSplash.splashFactory,
//           // ),
//           onPressed: () {
//             setState(() {
//               isVisible = !isVisible;
//             });
//           },
//           child: Text('click'),
//           style: ButtonStyle(
//             //splashFactory: InkRipple.splashFactory,
//             // overlayColor: MaterialStateProperty.resolveWith(
//             //   (states) {
//             //     return states.contains(MaterialState.pressed)
//             //         ? Colors.grey
//             //         : null;
//             //   },
//             // ),
//             backgroundColor: MaterialStateProperty.all(
//               isVisible ? Colors.red : Colors.green,
//             ),
//           ),
//         ),
//       ),
//       duration: Duration(milliseconds: 2000),
//     );
//   }
// }




