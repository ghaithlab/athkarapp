import 'package:athkarapp/clicksPerDay.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import "package:flutter/material.dart";

import 'habitButton.dart';
import 'heatMapWidget/data/heatmap_color_mode.dart';
import 'heatMapWidget/heatmap.dart';

import 'package:flutter/animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Map<DateTime, int> heatMapDatasets = {
    DateTime(2023, 1, 6): 3,
    DateTime(2023, 1, 7): 7,
    DateTime(2023, 1, 8): 10,
    DateTime(2023, 2, 9): 13,
    DateTime(2023, 2, 13): 6,
  };

  @override
  Widget build(BuildContext context) {
    //printer();
    //clicksPerDay.fillMorningEveningDummyData();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("عادات المسلم"),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.brightness_6),
            //   onPressed: () {
            //     _showMessage();
            //     //setState(() {});
            //   },
            //   tooltip: 'تبديل السمة',
            // ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                color: Theme.of(context).brightness == Brightness.dark
                    ? null
                    : Color(0xFFFFFFFF),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xFFE1D2CC)),
                    borderRadius: BorderRadius.circular(16.0)),
                margin: const EdgeInsets.all(20),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "جميع الأيام",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      HeatMap(
                        scrollable: true,
                        showText: false,
                        showColorTip: false,
                        defaultColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[700]
                                //: Color.fromARGB(255, 217, 208, 193),
                                : Color(0xFFEEEEEE),
                        textColor:
                            Theme.of(context).textTheme.labelSmall!.color,
                        // startDate: DateTime(2022, 12, 1),
                        // endDate: DateTime(2022, 12, 31),
                        colorMode: ColorMode.opacity,
                        datasets: heatMapDatasets,
                        colorsets: const {
                          //1: Colors.yellow[600]!,
                          1: Color(0xFF73CABA),
                          3: Colors.orange,
                          5: Colors.yellow,
                          7: Colors.green,
                          9: Colors.blue,
                          11: Colors.indigo,
                          13: Colors.purple,
                        },
                        onClick: (value) {
                          // showSnackMessge(
                          //     "${value.year} - ${value.month} - ${value.day}");
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,

                    //surfaceTintColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Hello"),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(25),
                  child: Text("test"),
                  decoration: BoxDecoration(
                      color: Color(0xFFF6DAAE1A).withOpacity(_controller.value),
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(15)),
                ),
                onLongPressStart: (details) {
                  if (!animationDone) _controller.forward(from: 0.0);
                  print("onLongPressStart");
                },
                onLongPressUp: () {
                  if (!animationDone) _controller.reverse();
                  print("onForcePressUp");
                },
                onForcePressEnd: (details) {
                  print("onForcePressEnd");
                },
              ),
              //HabitButton(),
              //IconButton(onPressed: onPressed, icon: icon)
            ],
          ),
        ),
      ),
    );
  }

  late AnimationController _controller;
  bool animationDone = false;
  @override
  void initState() {
    // TODO: implement initState
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _controller.addStatusListener((status) {
      print('$status');
      if (status == AnimationStatus.completed) animationDone = true;
    });
    _controller.addListener(() {
      print(_controller.value);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
