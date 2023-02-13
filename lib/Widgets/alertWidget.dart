import 'dart:ui';

import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  static Future<bool> showMessage(
      String msg,
      String title,
      bool isNotificationOnly,
      BuildContext context,
      String ok,
      String no) async {
    bool result = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertWidget(
          title: title,
          msg: msg,
          context: context,
          isNotifOnly: isNotificationOnly,
          ok: ok,
          no: no,
        );
      },
    ).then((value) {
      result = value;
    }).onError((error, stackTrace) => null);
    return result;
  }

  late String title;
  late String msg;
  late BuildContext context;
  late bool isNotifOnly;
  late String ok;
  late String no;
  AlertWidget({
    required this.title,
    required this.msg,
    required this.context,
    required this.isNotifOnly,
    required this.ok,
    required this.no,
    super.key,
  });
  List<Widget> buildButtons(bool x) {
    if (x) {
      return [
        TextButton(
          child: Text(ok),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        )
      ];
    } else {
      return [
        TextButton(
          child: Text(ok),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        TextButton(
          child: Text(no),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 28,
          ),
          textDirection: TextDirection.rtl,
        ),
        content: Text(
          msg,
          style: const TextStyle(
            fontSize: 18,
            height: 1.5,
          ),
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),
        actions: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: buildButtons(isNotifOnly),
              ),
            ),
          )
        ],
      ),
    );
  }
}
