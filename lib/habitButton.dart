import 'package:flutter/material.dart';

class HabitButton extends StatefulWidget {
  const HabitButton({super.key});

  @override
  State<HabitButton> createState() => _HabitButtonState();
}

class _HabitButtonState extends State<HabitButton> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      child: SizedBox(
        width: 100,
        key: UniqueKey(),
        child: ElevatedButton(
          // style: ElevatedButton.styleFrom(
          //   splashFactory: NoSplash.splashFactory,
          // ),
          onPressed: () {
            setState(() {
              isVisible = !isVisible;
            });
          },
          child: Text('click'),
          style: ButtonStyle(
            //splashFactory: InkRipple.splashFactory,
            // overlayColor: MaterialStateProperty.resolveWith(
            //   (states) {
            //     return states.contains(MaterialState.pressed)
            //         ? Colors.grey
            //         : null;
            //   },
            // ),
            backgroundColor: MaterialStateProperty.all(
              isVisible ? Colors.red : Colors.green,
            ),
          ),
        ),
      ),
      duration: Duration(milliseconds: 2000),
    );
  }
}
