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
                child: Container(
                  decoration: BoxDecoration(
                    // color: Theme.of(context).brightness == Brightness.dark
                    //     ? Colors.grey[700]
                    //     : Colors.grey[400],#C8AE91

                    color: Theme.of(context).brightness == Brightness.dark
                        //? Colors.grey[700]
                        //: Color.fromARGB(255, 215, 197, 176),
                        ? Color(0xFFF6DAAE)
                        : Color(0xFFF6DAAE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Text(
                      text2,
                      style: TextStyle(
                          fontSize: 15,
                          color: fontColorLight,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
