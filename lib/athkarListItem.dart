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
    return Stack(
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
          bottom: -14,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[700]
                    : Colors.grey[400],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  text2,
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
