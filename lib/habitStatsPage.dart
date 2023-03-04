import 'package:athkarapp/Widgets/alertWidget.dart';
import 'package:athkarapp/Widgets/numberCounter.dart';
import 'package:athkarapp/clicksPerDay.dart';
import 'package:athkarapp/habitAddDialogue.dart';
import 'package:athkarapp/homeScreen.dart';
import 'package:athkarapp/models/boxes.dart';
import 'package:athkarapp/models/habitsModel.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import "package:flutter/material.dart";
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'heatMapWidget/data/heatmap_color_mode.dart';
import 'heatMapWidget/heatmap.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/animation.dart';

class HabitStatsPage extends StatefulWidget {
  final HabitRecord habit;
  const HabitStatsPage({super.key, required this.habit});

  @override
  State<HabitStatsPage> createState() => _HabitStatsPageState();
}

class _HabitStatsPageState extends State<HabitStatsPage> {
  bool isOpacityMode = true;
  // Map<DateTime, int> heatMapDatasets = {
  //   DateTime(2022, 5, 6): 3,
  //   DateTime(2022, 5, 7): 7,
  //   DateTime(2022, 6, 8): 10,
  //   DateTime(2022, 7, 9): 13,
  //   DateTime(2022, 12, 13): 6,
  // };
  // Map morningStats = {'daysCount': 0, 'consistency': 0, 'streak': 0};
  // Map eveningStats = {'daysCount': 0, 'consistency': 0, 'streak': 0};
  // ClicksPerDay clicksPerDay = ClicksPerDay();
  bool light0 = false;
  late bool animate = true;

  @override
  void initState() {
    // clicksPerDay = ClicksPerDay();
    Future.delayed(Duration(milliseconds: 200)).then((value) => setState(() {
          animate = !animate;
        }));
    light0 = widget.habit.hasToday();
    super.initState();
    //function();
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

  // Color sabah = Color.fromARGB(255, 222, 185, 127);
  // Color masa = Color.fromARGB(255, 180, 111, 113);

  @override
  Widget build(BuildContext context) {
    Color sabah = Color.fromARGB(255, 123, 167, 216);
    Color masa = Color.fromARGB(255, 180, 111, 113);
    Color defaultColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]!.withOpacity(0.25)
        : Color.fromARGB(255, 217, 208, 193).withOpacity(0.25);
    var datesListSorted = widget.habit.records!.keys.toList();
    datesListSorted.sort((a, b) => a.compareTo(b));
    DateTime start = DateTime.now();
    DateTime last = DateTime.now();
    if (datesListSorted.isNotEmpty) {
      start = datesListSorted.first;
      //last = datesListSorted.last;
    }
    //printer();
    //clicksPerDay.fillMorningEveningDummyData();
    return ValueListenableBuilder<Box<HabitRecord>>(
      valueListenable: Boxes.getHabits().listenable(),
      builder: (context, box, _) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text("إحصاءات - ${widget.habit.name}"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    //_showMessage();
                    if (await AlertWidget.showMessage(
                        "هل أنت متأكد من حذف العادة ${widget.habit.name}؟\n\nلا يمكن استعادة بيانات هذه العادة إذا تم حذفها.",
                        "تنبيه",
                        false,
                        context,
                        "نعم",
                        "لا")) {
                      widget.habit.delete();
                      Navigator.of(context).pop();
                    }
                    //setState(() {});
                  },
                  tooltip: 'حذف العادة',
                ),
                // if (widget.habit.isDefaultHabit! == false)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => TransactionDialog(
                        onClickedDone: saveHabit,
                        transaction: widget.habit,
                      ),
                    );
                  },
                  tooltip: 'تعديل العادة',
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? null
                        : //Color(0xFFFFFFFF),
                        //
                        // Color.fromARGB(255, 251, 249, 245),
                        Color.fromARGB(255, 247, 240, 226),
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
                          Text("جميع الأيام",
                              style: Theme.of(context).textTheme.labelLarge),
                          StatsRow(
                            mp: {
                              'daysCount': widget.habit.calculateDaysCount(),
                              'consistency':
                                  widget.habit.calculateConsistency(),
                              'streak': widget.habit.calculateStreak()
                            },
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          HeatMap(
                            startDate: start,
                            endDate: last,
                            scrollable: true,
                            showText: false,
                            showColorTip: false,
                            defaultColor: defaultColor,
                            //: Color(0xFFEEEEEE),
                            textColor:
                                Theme.of(context).textTheme.labelSmall!.color,
                            // startDate: DateTime(2022, 12, 1),
                            // endDate: DateTime(2022, 12, 31),
                            colorMode: isOpacityMode
                                ? ColorMode.opacity
                                : ColorMode.color,
                            datasets: widget.habit.records,
                            colorsets: {
                              //1: Colors.red[400]!,
                              //1: Color(0xFFFFD89B),
                              //1: Color.fromARGB(255, 180, 111, 113), try1
                              1: animate ? defaultColor : sabah,
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
                  // HabitButtonAnimated(
                  //   habit: widget.habit,
                  //   onClickedDone: habitCheckIn,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          activeColor: sabah,
                          value: light0,
                          onChanged: (bool value) {
                            toggleToday(habit: widget.habit);
                            setState(() {
                              light0 = value;
                            });
                          },
                        ),
                        Container(
                          width: 80,
                          child: Text(
                            light0 ? "اكتملت" : "غير مكتملة",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // HabitButtonAnimated1(
                  //   habit: widget.habit,
                  //   onClickedDone: (
                  //       {required HabitRecord habit, int? value}) {},
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  saveHabit(String name, String id) {
    print("name: $name - id: $id");
    widget.habit.name = name;
    widget.habit.save();
  }

  void toggleToday({required HabitRecord habit, int? value}) {
    if (habit.id == "###1") habit.maxValue = 183;
    if (habit.id == "###2") habit.maxValue = 184;
    var today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    if (habit.records!.containsKey(today))
      habit.records!.remove(today);
    else
      habit.records![today] = value ?? habit.maxValue;
    habit.save();
    setState(() {
      light0 = !light0;
    });
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
                NumberCounter(
                  startValue: 0,
                  endValue: mp['daysCount'],
                  txtStyle: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontSize: 24),
                ),
                // Text("${mp['daysCount']}",
                //     style: Theme.of(context)
                //         .textTheme
                //         .labelLarge!
                //         .copyWith(fontSize: 24)),
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
                // Text("${mp['consistency']}%",
                //     style: Theme.of(context)
                //         .textTheme
                //         .labelLarge!
                //         .copyWith(fontSize: 24)),
                Row(
                  children: [
                    Text("%",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 24)),
                    NumberCounter(
                        startValue: 0,
                        endValue: mp['consistency'],
                        txtStyle: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 24)),
                  ],
                ),
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
                    NumberCounter(
                        startValue: 0,
                        endValue: mp['streak'],
                        txtStyle: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 24)),
                    // Text("${mp['streak']}",
                    //     style: Theme.of(context)
                    //         .textTheme
                    //         .labelLarge!
                    //         .copyWith(fontSize: 24)),
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

class HabitButtonAnimated1 extends StatefulWidget {
  HabitButtonAnimated1(
      {super.key, required this.habit, required this.onClickedDone});
  final HabitRecord habit;
  final Function({required HabitRecord habit, int? value}) onClickedDone;

  @override
  State<HabitButtonAnimated1> createState() => _HabitButtonAnimatedState1();
}

class _HabitButtonAnimatedState1 extends State<HabitButtonAnimated1>
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
    DateTime today = DateTime.now();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 750),
        lowerBound: 0.15,
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

    return GestureDetector(
      child: Transform.scale(
        scale: _scale,
        child: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
              color: widget.habit.isDefaultHabit!
                  ? Color.fromARGB(255, 210, 178, 126)
                      .withOpacity(animationDone ? 1 : _controller.value)
                  : Color.fromARGB(255, 125, 173, 212)
                      .withOpacity(animationDone ? 1 : _controller.value),
              // border: Border.all(width: 0),
              borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                print(constraints.maxWidth);
                print(constraints.maxHeight);

                if (constraints.maxWidth > 200.0) {
                  return new Text('BIG');
                } else {
                  return new Text('SMALL');
                }
              }),
              Container(
                //width: double.maxFinite,
                decoration: BoxDecoration(
                    color: widget.habit.isDefaultHabit!
                        ? Color.fromARGB(255, 210, 178, 126)
                        : Color.fromARGB(255, 125, 173, 212),
                    // border: Border.all(width: 0),
                    borderRadius: BorderRadius.circular(15)),
                child: Text(""),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "${widget.habit.calculateStreak()}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 38,
                        //color: fontColorLight,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    widget.habit.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22,
                        //color: fontColorLight,
                        fontWeight: FontWeight.w600),
                  ),
                  // Align(
                  //   child: Icon(Icons.done_all),
                  //   alignment: Alignment.center,
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        // if (widget.habit.id == "###1" || widget.habit.id == "###2") {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) {
        //     return AthkarPage(
        //         habit: widget.habit,
        //         isMorningAthkar: widget.habit.id == "###1" ? true : false);
        //   }));
        // } else {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) {
        //     return HabitStatsPage(
        //       habit: widget.habit,
        //     );
        //   }));
        // }
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
