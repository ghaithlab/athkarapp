import 'package:athkarapp/clicksPerDay.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import "package:flutter/material.dart";

import 'heatMapWidget/data/heatmap_color_mode.dart';
import 'heatMapWidget/heatmap.dart';

import 'package:flutter/animation.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  bool isOpacityMode = true;
  Map<DateTime, int> heatMapDatasets = {
    DateTime(2022, 5, 6): 3,
    DateTime(2022, 5, 7): 7,
    DateTime(2022, 6, 8): 10,
    DateTime(2022, 7, 9): 13,
    DateTime(2022, 12, 13): 6,
  };
  Map morningStats = {'daysCount': 0, 'consistency': 0, 'streak': 0};
  Map eveningStats = {'daysCount': 0, 'consistency': 0, 'streak': 0};
  ClicksPerDay clicksPerDay = ClicksPerDay();
  @override
  void initState() {
    clicksPerDay = ClicksPerDay();
    super.initState();
    function();
  }

  void function() async {
    await clicksPerDay.init();
    setState(() {
      morningStats = clicksPerDay.morningStats;
      eveningStats = clicksPerDay.eveningStats;
    });
    // {'daysCount': 0, 'consistency': 0, 'streak': 0};
    await FirebaseAnalytics.instance.logEvent(
      name: "report_shown",
      parameters: {
        "morning_consistency": clicksPerDay.morningStats['consistency'],
        "morning_days_count": clicksPerDay.morningStats['daysCount'],
        "morning_streak": clicksPerDay.morningStats['streak'],
        "evening_consistency": clicksPerDay.eveningStats['consistency'],
        "evening_days_count": clicksPerDay.eveningStats['daysCount'],
        "evening_streak": clicksPerDay.eveningStats['streak'],
      },
    );
  }

  void printer() {
    clicksPerDay.splitClicksOfDays();
    print(clicksPerDay.morningClicksOfDays);
    print(clicksPerDay.afternoonClicksOfDays);
    print(heatMapDatasets);
  }

  void _showMessage() {
    //clicksPerDay.fillMorningEveningDummyData();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('This is a message'),
          actions: <Widget>[
            TextButton(
              child: Text(
                  "afternoon:total -> ${clicksPerDay.eveningStats['daysCount']} consistency ->${clicksPerDay.eveningStats['consistency']} streak -> ${clicksPerDay.eveningStats['streak']}" +
                      "\n morning:total -> ${clicksPerDay.morningStats['daysCount']} consistency ->${clicksPerDay.morningStats['consistency']} streak -> ${clicksPerDay.morningStats['streak']}"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showSnackMessge(String str) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color.fromARGB(255, 45, 45, 45),
        duration: const Duration(milliseconds: 500),
        content: Text(
          str,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        )));
  }

  @override
  Widget build(BuildContext context) {
    //printer();
    clicksPerDay.fillMorningEveningDummyData();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إحصاءات الأذكار"),
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
                  borderRadius: BorderRadius.circular(16.0),
                ),
                margin: const EdgeInsets.all(20),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("أذكار الصباح",
                          style: Theme.of(context).textTheme.labelLarge),
                      StatsRow(mp: clicksPerDay.morningStats),
                      SizedBox(
                        height: 4,
                      ),
                      Divider(
                        thickness: 1,
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
                        colorMode:
                            isOpacityMode ? ColorMode.opacity : ColorMode.color,
                        datasets: clicksPerDay.morningClicksOfDays,
                        colorsets: {
                          //1: Colors.red[400]!,
                          1: Color(0xFFFFD89B),
                          3: Colors.orange,
                          5: Colors.yellow,
                          7: Colors.green,
                          9: Colors.blue,
                          11: Colors.indigo,
                          13: Colors.purple,
                        },
                        onClick: (value) {
                          showSnackMessge(
                              "${value.year} - ${value.month} - ${value.day}");
                        },
                      ),
                    ],
                  ),
                ),
              ),
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
                    children: [
                      Text(
                        "أذكار المساء",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      StatsRow(mp: clicksPerDay.eveningStats),
                      SizedBox(
                        height: 4,
                      ),
                      Divider(
                        thickness: 1,
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
                        colorMode:
                            isOpacityMode ? ColorMode.opacity : ColorMode.color,
                        datasets: clicksPerDay.afternoonClicksOfDays,
                        colorsets: {
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
                          showSnackMessge(
                              "${value.year} - ${value.month} - ${value.day}");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatsRow extends StatelessWidget {
  const StatsRow({
    Key? key,
    required this.mp,
  }) : super(key: key);

  final Map mp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                // NumberCounter(
                //     startValue: 0,
                //     endValue: mp['daysCount'],
                //     txtStyle: Theme.of(context)
                //         .textTheme
                //         .labelLarge!
                //         .copyWith(fontSize: 28)),
                Text("${mp['daysCount']}",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 24)),
                Text("الأيام",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 16))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Text("${mp['consistency']}%",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 24)),
                // NumberCounter(
                //     startValue: 0,
                //     endValue: clicksPerDay.eveningStats['consistency'],
                //     txtStyle: Theme.of(context)
                //         .textTheme
                //         .labelLarge!
                //         .copyWith(fontSize: 28)),
                Text("الثبات",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 16))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // NumberCounter(
                    //     startValue: 0,
                    //     endValue: mp['streak'],
                    //     txtStyle: Theme.of(context)
                    //         .textTheme
                    //         .labelLarge!
                    //         .copyWith(fontSize: 28)),
                    Text("${mp['streak']}",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 24)),
                    SizedBox(
                      width: 3,
                    ),
                    Text("يوم",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 12))
                  ],
                ),
                Text("المداومة",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 16))
              ],
            ),
          )
        ],
      ),
    );
  }
}

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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
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
