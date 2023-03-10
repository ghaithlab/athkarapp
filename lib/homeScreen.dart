import 'dart:math';

import 'package:athkarapp/HabitAddPage.dart';
import 'package:athkarapp/Widgets/HabitStatsPagePopUp.dart';
import 'package:athkarapp/Widgets/alertWidget.dart';
import 'package:athkarapp/athkar/athkarPage.dart';
import 'package:athkarapp/clicksPerDay.dart';
import 'package:athkarapp/habitStatsPage.dart';
import 'package:athkarapp/mockGenerator.dart';
import 'package:athkarapp/models/boxes.dart';
import 'package:athkarapp/models/habitsModel.dart';
import 'package:athkarapp/utils/colorPalet.dart';
import 'package:athkarapp/utils/habitsList.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'habitAddDialogue.dart';
import 'package:athkarapp/habitButton.dart';
import 'heatMapWidget/data/heatmap_color_mode.dart';
import 'heatMapWidget/heatmap.dart';

import 'package:flutter/animation.dart';
import 'package:share_plus/share_plus.dart';

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
  Map<DateTime, int> combineMaps(List<HabitRecord> habits) {
    Map<DateTime, int> combinedMap = {};
    var maps = habits.map((e) => e.records).toList();

    maps.forEach((map) {
      map!.forEach((key, value) {
        // combinedMap.update(key, (existingValue) => existingValue + value,
        //     ifAbsent: () => value);
        combinedMap.update(key, (existingValue) => existingValue + 1,
            ifAbsent: () => 1);
      });
    });
    print("sorted List Of Dates Lists Of Habits");
    print(maps);
    //get first date of each hatbit so we know when each habit started so we can know the count of habits each day
    // var sortedListOfDatesListsOfHabits = maps.map((e) {
    //   var l = e!.keys.toList();
    //   l.sort((a, b) => a.compareTo(b));
    //   return l;
    // });
    //previous code didnt work
    var sortedListOfDatesListsOfHabits = habits.map((e) {
      return e.creationDate;
    });
    print("sorted List Of Dates Lists Of Habits");
    print(sortedListOfDatesListsOfHabits);
    print("old combined");
    print(combinedMap);
    //calculate percentage for each day by checking count of habits each day (using starting date)
    Map<DateTime, int> calculatedPercentageEveryday =
        combinedMap.map((key, value) {
      int habitsThisDay = 0;
      sortedListOfDatesListsOfHabits.forEach((element) {
        if (element != null) if (key.compareTo(element) >= 0) habitsThisDay++;
      });
      if (habitsThisDay == 0) print("this key!!!!!!!!!!! $key"); //TODO: Delete
      print("$value / $habitsThisDay = ${value / habitsThisDay}");
      return MapEntry(key, ((value / habitsThisDay) * 100).toInt());
    });

    print("calculated Percentage Everyday");
    print(calculatedPercentageEveryday);

    print("old combined");
    print(combinedMap);
    return calculatedPercentageEveryday;
  }

  HabitRecord? getHabitById(String id) {
    var habits = Boxes.getHabits().values.toList();
    HabitRecord? item;
    habits.forEach((element) {
      if (element.id == id) item = element;
    });
    return item;
  }

  bool mock = false;

  // String morningAthkarId = "###1";
  // String eveningAthkarId = "###2";
  // String salatDuha = "###3";
  // String salatWitr = "###4";

  void portOldStatsToDatabase() async {
    ClicksPerDay clicksPerDay = ClicksPerDay();
    await clicksPerDay.init();
    var morningAthkarListOld = clicksPerDay.morningClicksOfDays;

    var eveningAthkarLastOld = clicksPerDay.afternoonClicksOfDays;
    Box box = Boxes.getHabits();
    if (morningAthkarListOld.keys.isNotEmpty) {
      //var morningAthkarHabitRecord = box.getAt(1) as HabitRecord;
      var morningAthkarHabitRecord =
          getHabitById(defaultHabitsIds["morningAthkarId"]);
      if (morningAthkarHabitRecord != null) {
        morningAthkarListOld.forEach((key, value) {
          morningAthkarHabitRecord.records![key] = value;
        });
        var listOfKeys = morningAthkarListOld.keys.toList();
        listOfKeys.sort((a, b) => a.compareTo(b));
        morningAthkarHabitRecord.creationDate = listOfKeys.first;
        await morningAthkarHabitRecord.save();
        print("morning athkar first key:");
        print(morningAthkarListOld.keys.first);
      }
    }
    if (eveningAthkarLastOld.keys.isNotEmpty) {
      //var eveningAthkarHabitRecord = box.getAt(5) as HabitRecord;
      var eveningAthkarHabitRecord =
          getHabitById(defaultHabitsIds["eveningAthkarId"]);
      if (eveningAthkarHabitRecord != null) {
        eveningAthkarLastOld.forEach((key, value) {
          eveningAthkarHabitRecord.records![key] = value;
        });
        var listOfKeys = eveningAthkarLastOld.keys.toList();
        listOfKeys.sort((a, b) => a.compareTo(b));
        eveningAthkarHabitRecord.creationDate = listOfKeys.first;
        await eveningAthkarHabitRecord.save();
        print("evening athkar first key:");
        print(eveningAthkarLastOld.keys.first);
      }
    }
  }

  void initializeDefaultHabits() async {
    if (Boxes.getHabits().values.isEmpty) {
      var today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      var defaultHabits = [
        HabitRecord(
          id: defaultHabitsIds["salatDuha"],
          name: "???????? ??????????",
          isBasicHabit: true,
          isDefaultHabit: true,
          creationDate: today,
        ),
        HabitRecord(
          id: defaultHabitsIds["morningAthkarId"],
          name: "?????????? ????????????",
          isBasicHabit: false,
          isDefaultHabit: true,
          creationDate: today,
          maxValue: 183,
        ),
        HabitRecord(
          id: defaultHabitsIds["salatWitr"],
          name: "???????? ??????????",
          isBasicHabit: true,
          isDefaultHabit: true,
          creationDate: today,
        ),
        HabitRecord(
          id: defaultHabitsIds["eveningAthkarId"],
          name: "?????????? ????????????",
          isBasicHabit: false,
          isDefaultHabit: true,
          creationDate: today,
          maxValue: 184,
        ),
        HabitRecord(
          id: UniqueKey().toString(),
          name: "?????????? ?????? ????????",
          isBasicHabit: true,
          isDefaultHabit: true,
          creationDate: today,
        ),
      ];
      Box box = Boxes.getHabits();
      defaultHabits.forEach((e) async {
        await box.add(e);
      });
      if (mock) mockData();
    } else {
      //backward compatibility to fix defaultHabitIds for version 2.0.2+13
      Boxes.getHabits().values.forEach((element) {
        switch (element.name) {
          case "???????? ??????????":
            if (element.id != defaultHabitsIds["salatDuha"]) {
              element.id = defaultHabitsIds["salatDuha"];
              element.save();
            }
            break;
          case "???????? ??????????":
            if (element.id != defaultHabitsIds["salatWitr"]) {
              element.id = defaultHabitsIds["salatWitr"];
              element.save();
            }
            break;
          default:
        }
      });
    }
    //backward compatibility to fix defaultHabitIds for version 1.0.0
    portOldStatsToDatabase();
  }

  void mockData() {
    DateTime startDate = DateTime(2023, 1, 1);
    DateTime endDate = DateTime.now();
    Boxes.getHabits().values.forEach((element) {
      int value;

      element.records = mockGenerator.generateRandomDates(
          startDate, endDate, element.maxValue);
      element.creationDate = startDate;
      element.save();
    });
  }

  late bool animate = true;

  @override
  void initState() {
    super.initState();
    //this is because I need context in showAppSharePromot and it needs to be called after initstate is done
    Future.delayed(Duration.zero, () {
      mmmain();
    });

    Future.delayed(Duration(milliseconds: 200)).then((value) => setState(() {
          animate = !animate;
        }));
  }

  void shareAppPrompt() {
    SharedPreferences.getInstance().then((prefs) async {
      //every five opens it will ask for sharing app and if pressed later will try after 5 opens then it wont open after that
      if ((prefs.getInt('app_open_count') ?? 0) % 3 == 0 &&
          (prefs.getInt('app_open_count_later') ?? 0) <
              2) if (await AlertWidget.showMessage(
          "???????? ???? ?????????? ?????????? ???????????? ?????????????? ???????? ???????????????? ?????? ???????????????? ???????????? ???????????????? ???????? ???????? ???? ?????? ??????????????",
          "???????? ????????",
          false,
          context,
          "??????????",
          "??????????")) {
        await Share.share(
            '?????????? ?????????? ?????????????? ?????????? ?????????? ?????????? ?????????????? https://islamichabits.page.link/download',
            subject: '?????????? ?????????? ?????????? ????????????');
        prefs.setInt('app_open_count_later', 2);
      } else {
        //?????????? was press
        int laterWillShare = (prefs.getInt('app_open_count_later') ?? 0) + 1;
        prefs.setInt('app_open_count_later', laterWillShare);
      }
    });
  }

  void mmmain() async {
    shareAppPrompt();
    print("main");
    print(Boxes.getHabits().values);
    //if (mock) await Boxes.getHabits().clear();

    initializeDefaultHabits();
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
    var combinedMaps = combineMaps(habits);
    print(combinedMaps);
    var datesListSorted = combinedMaps.keys.toList();
    datesListSorted.sort((a, b) => a.compareTo(b));
    print(datesListSorted);
  }

  late bool isDarkMode;
  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("?????????? ????????????"),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.delete),
            //   onPressed: () {
            //     var habits = Boxes.getHabits().values.toList();
            //     habits.forEach((element) async {
            //       element.records = {};
            //       await element.save();
            //       setState(() {});
            //     });
            //     //setState(() {});
            //   },
            //   tooltip: '?????????? ??????????',
            // ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(
                    '?????????? ?????????? ?????????????? ?????????? ?????????? ?????????? ?????????????? https://islamichabits.page.link/download',
                    subject: '?????????? ?????????? ?????????? ????????????');
              },
              tooltip: '???????????? ??????????????',
            ),
            IconButton(
              icon: Icon(isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined),
              onPressed: () {
                MyApp.of(context)!.changeTheme();
              },
              tooltip: '?????????? ??????????',
            ),

            // IconButton(
            //   icon: const Icon(
            //     Icons.add,
            //   ),
            //   onPressed: () {
            //     showDialog(
            //         context: context,
            //         builder: (context) => TransactionDialog(
            //               onClickedDone: addNewHabit,
            //             ));
            //   },
            //   tooltip: '?????????? ???????? ??????????',
            // ),
            IconButton(
              icon: const Icon(
                Icons.add_box,
                //color: Color.fromARGB(255, 210, 178, 126),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HabitAddPage();
                }));
              },
              tooltip: '?????????? ???????? ??????????',
            ),
          ],
        ),

        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast),
          child: ValueListenableBuilder<Box<HabitRecord>>(
            valueListenable: Boxes.getHabits().listenable(),
            builder: (context, box, _) {
              final habits = box.values.toList().cast<HabitRecord>();

              //var listOfMaps = habits.map((e) => e.records).toList();

              var combinedMaps = combineMaps(habits);
              heatMapDatasets = {
                ...combinedMaps,
                DateTime(2020, 2, 1):
                    100, // 100 means all habits are done that date (all days are now % using combine funciton)
              };
              // TODO: DateTime(2020, 2, 1): 6 this is an adhoc sulition for the max value of the grid,
              //when adding new habit all colors of max value will be disrubted
              var datesListSorted = combinedMaps.keys.toList();
              datesListSorted.sort((a, b) => a.compareTo(b));
              DateTime start = DateTime.now();
              DateTime last = DateTime.now();
              if (datesListSorted.isNotEmpty) {
                start = datesListSorted.first;
                //last = datesListSorted.last;
              }
              return Column(
                children: [
                  buildStatusCard(start, last),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 20, top: 16, bottom: 8),
                      child: Text(
                        "??????????????",
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              //: Color.fromARGB(255, 217, 208, 193),
                              : fontColorLight,
                        ),
                      ),
                    ),
                  ),
                  GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.only(
                        right: 20, top: 8, bottom: 20, left: 20), //all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: habits.map((e) {
                      return HabitButtonAnimated(
                          key: UniqueKey(),
                          habit: e,
                          onClickedDone: habitCheckIn,
                          isDarkMode:
                              Theme.of(context).brightness == Brightness.dark,
                          onTap: habitButtonTap,
                          color: e.isDefaultHabit!
                              ? defaultHabitColor
                              : personalHabitColor);
                    }).toList(),
                  ),
                ],
              );
            },
          ),
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
    Color sabah = Color.fromARGB(255, 123, 167, 216);
    Color masa = Color.fromARGB(255, 180, 111, 113);
    Color defaultColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]!.withOpacity(0.25)
        : Color.fromARGB(255, 217, 208, 193).withOpacity(0.25);
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? null
          : Color.fromARGB(255, 247, 240, 226),
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
                  "???????? ????????????",
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        //: Color.fromARGB(255, 217, 208, 193),
                        : fontColorLight,
                  ),
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
              defaultColor: defaultColor,
              textColor: Theme.of(context).textTheme.labelSmall!.color,
              // startDate: DateTime(2022, 12, 1),
              // endDate: DateTime(2022, 12, 31),
              colorMode: ColorMode.opacity,
              datasets: heatMapDatasets,
              colorsets: {
                //1: Colors.yellow[600]!,
                1: animate ? defaultColor : Color(0xFF73CABA),
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
    final habit = HabitRecord(
        isDefaultHabit: false,
        id: UniqueKey().toString(),
        name: name,
        creationDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
    Boxes.getHabits().add(habit);
  }

  void habitCheckIn({required HabitRecord habit, int? value}) {
    var today = DateTime.now();
    habit.records![DateTime(today.year, today.month, today.day)] =
        value ?? habit.maxValue;

    habit.save();
  }

  void habitButtonTap({required HabitRecord habit}) {
    if (habit.id == defaultHabitsIds["morningAthkarId"]) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AthkarPage(
          habit: habit,
          athkarType: AthkarType.morning,
        );
      }));
    } else if (habit.id == defaultHabitsIds["eveningAthkarId"]) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AthkarPage(
          habit: habit,
          athkarType: AthkarType.evening,
        );
      }));
    } else if (habit.id == defaultHabitsIds["sleepingAthkarId"]) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AthkarPage(
          habit: habit,
          athkarType: AthkarType.sleeping,
        );
      }));
    } else {
      // showDialog(
      //     useSafeArea: false,
      //     context: context,
      //     builder: (context) => HabitStatsPagePopUp(
      //           habit: widget.habit,
      //         ));

      // showGeneralDialog(
      //     context: context,
      //     barrierDismissible: true,
      //     barrierLabel:
      //         MaterialLocalizations.of(context).modalBarrierDismissLabel,
      //     barrierColor: Colors.black45,
      //     transitionDuration: const Duration(milliseconds: 400),
      //     pageBuilder: (BuildContext buildContext, Animation animation,
      //             Animation secondaryAnimation) =>
      //         HabitStatsPagePopUp(
      //           habit: widget.habit,
      //         ));
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HabitStatsPage(
          habit: habit,
        );
      }));
    }
  }
}
