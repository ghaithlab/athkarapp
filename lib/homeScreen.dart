import 'package:athkarapp/athkar/athkarPage.dart';
import 'package:athkarapp/clicksPerDay.dart';
import 'package:athkarapp/models/boxes.dart';
import 'package:athkarapp/models/habitsModel.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'habitAddDialogue.dart';
import 'habitButton.dart';
import 'heatMapWidget/data/heatmap_color_mode.dart';
import 'heatMapWidget/heatmap.dart';

import 'package:flutter/animation.dart';

import 'main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Map<DateTime, int> heatMapDatasets = {
  //   DateTime(2023, 1, 6): 3,
  //   DateTime(2023, 1, 7): 7,
  //   DateTime(2023, 1, 8): 10,
  //   DateTime(2023, 2, 9): 13,
  //   DateTime(2023, 2, 13): 6,
  // };
  Map<DateTime, int> heatMapDatasets = {};
  Map<DateTime, int> combineMaps(List<Map<DateTime, int>?> maps) {
    Map<DateTime, int> combinedMap = {};
    maps.forEach((map) {
      map!.forEach((key, value) {
        // combinedMap.update(key, (existingValue) => existingValue + value,
        //     ifAbsent: () => value);
        combinedMap.update(key, (existingValue) => existingValue + 1,
            ifAbsent: () => 1);
      });
    });
    return combinedMap;
  }

  void initializeDefaultHabits() {
    if (Boxes.getHabits().values.isEmpty) {
      var defaultHabits = [
        HabitRecord(
            id: UniqueKey().toString(),
            name: "صلاة الضحى",
            isBasicHabit: true,
            isDefaultHabit: true),
        HabitRecord(
            id: "###1",
            name: "أذكار الصباح",
            isBasicHabit: false,
            isDefaultHabit: true),
        HabitRecord(
            id: UniqueKey().toString(),
            name: "قراءة ١٠ صفحات",
            isBasicHabit: true,
            isDefaultHabit: false),
        HabitRecord(
            id: UniqueKey().toString(),
            name: "رياضة: ضغط",
            isBasicHabit: true,
            isDefaultHabit: false),
        HabitRecord(
            id: UniqueKey().toString(),
            name: "رياضة: ثابت",
            isBasicHabit: true,
            isDefaultHabit: false),
        HabitRecord(
            id: "###2",
            name: "أذكار المساء",
            isBasicHabit: false,
            isDefaultHabit: true),
      ];
      Box box = Boxes.getHabits();
      defaultHabits.forEach((e) async {
        print("in map");
        await box.add(e);

        //return 1;
      });
    }
  }

  void mmmain() async {
    initializeDefaultHabits();
    print("main");
    print(Boxes.getHabits().values);
    //await Boxes.getHabits().clear();
    // var habit = HabitRecord(id: UniqueKey().toString(), name: "firstHabit1");
    // await Boxes.getHabits().add(habit);
    // habitCheckIn(habit: habit);
    var habits = Boxes.getHabits().values.toList();
    var listOfMaps = habits.map((e) => e.records).toList();
    print("ids:");
    print(habits.map((e) => e.id));

    //habits[0].save();
    print("maps:");
    print(habits.map((e) => e.records));

    print("combined map:");
    var combinedMaps = combineMaps(listOfMaps);
    print(combinedMaps);
    var datesListSorted = combinedMaps.keys.toList();
    datesListSorted.sort((a, b) => a.compareTo(b));
    print(datesListSorted);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("عادات المسلم"),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                var habits = Boxes.getHabits().values.toList();
                habits.forEach((element) async {
                  element.records = {};
                  await element.save();
                  setState(() {});
                });
                //setState(() {});
              },
              tooltip: 'تبديل السمة',
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => TransactionDialog(
                          onClickedDone: addNewHabit,
                        ));
              },
              //setState(() {});

              tooltip: 'تبديل السمة',
            ),
          ],
        ),

        body: ValueListenableBuilder<Box<HabitRecord>>(
          valueListenable: Boxes.getHabits().listenable(),
          builder: (context, box, _) {
            final habits = box.values.toList().cast<HabitRecord>();

            var listOfMaps = habits.map((e) => e.records).toList();

            var combinedMaps = combineMaps(listOfMaps);
            heatMapDatasets = {
              ...combinedMaps,
              DateTime(2020, 2, 1): habits.length,
            };
            // TODO: DateTime(2020, 2, 1): 6 this is an adhoc sulition for the max value of the grid,
            //when adding new habit all colors of max value will be disrubted
            var datesListSorted = combinedMaps.keys.toList();
            datesListSorted.sort((a, b) => a.compareTo(b));
            DateTime start = datesListSorted.first;
            DateTime last = datesListSorted.last;

            return Column(
              children: [
                buildStatusCard(start, last),
                Expanded(
                  //height: MediaQuery.of(context).size.height,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: habits.map((e) {
                      return HabitButtonAnimated(
                        key: UniqueKey(),
                        habit: e,
                        onClickedDone: habitCheckIn,
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
        //HabitButtonAnimated(controller: _controller, animationDone: animationDone),
        //HabitButton(),
        //IconButton(onPressed: onPressed, icon: icon)

        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: () => showDialog(
        //     context: context,
        //     builder: (context) => TransactionDialog(
        //       onClickedDone: addNewHabit,
        //     ),
        //   ),
        // ),
      ),
    );
  }

  Widget buildStatusCard(DateTime start, DateTime end) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? null
          : Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFFE1D2CC)),
          borderRadius: BorderRadius.circular(16.0)),
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  "جميع الأيام",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Divider(
              thickness: 1,
            ),
            HeatMap(
              startDate: start,
              endDate: end,
              scrollable: true,
              showText: false,
              showColorTip: false,
              defaultColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[700]
                  //: Color.fromARGB(255, 217, 208, 193),
                  : Color(0xFFEEEEEE),
              textColor: Theme.of(context).textTheme.labelSmall!.color,
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
    );
  }

  addNewHabit(String name, String id) {
    print("name: $name - id: $id");
    final habit = HabitRecord(id: id, name: name);
    Boxes.getHabits().add(habit);
  }

  void habitCheckIn({required HabitRecord habit, int? value}) {
    var today = DateTime.now();
    habit.records![DateTime(today.year, today.month, today.day)] = value ?? 1;
    habit.save();
  }

  @override
  void initState() {
    mmmain();

    super.initState();
  }
}

class HabitButtonAnimated extends StatefulWidget {
  HabitButtonAnimated(
      {super.key, required this.habit, required this.onClickedDone});
  final HabitRecord habit;
  final Function({required HabitRecord habit, int? value}) onClickedDone;

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
    DateTime today = DateTime.now();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 750),
        lowerBound: 0.3,
        upperBound: 0.75);
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
                  ? Color.fromARGB(255, 215, 171, 102)
                      .withOpacity(animationDone ? 0.75 : _controller.value)
                  : Color.fromARGB(255, 102, 164, 215)
                      .withOpacity(animationDone ? 0.75 : _controller.value),
              // border: Border.all(width: 0),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
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
            ],
          ),
        ),
      ),
      onTap: () {
        if (widget.habit.id == "###1" || widget.habit.id == "###2") {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AthkarPage();
          }));
        }
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
