import 'package:athkarapp/athkar/athkarPage.dart';
import 'package:athkarapp/clicksPerDay.dart';
import 'package:athkarapp/habitStatsPage.dart';
import 'package:athkarapp/models/habitsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../statsPage.dart';
import 'athkar.dart';
import 'athkarListItem.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AthkarList extends StatefulWidget {
  HabitRecord habit;
  List<Athkar> athkars;
  double fontSize;
  List<Athkar> removedItems;
  AthkarType athkarType;
  AthkarList(
      {required this.athkars,
      required this.fontSize,
      required this.removedItems,
      required this.athkarType,
      required this.habit});
  @override
  _AthkarListState createState() => _AthkarListState();
}

class _AthkarListState extends State<AthkarList> {
  ClicksPerDay clicksPerDay = ClicksPerDay();
  @override
  void initState() {
    super.initState();
    clicksPerDay.init();
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  }

  // void printer() {
  //   clicksPerDay.splitClicksOfDays();
  //   print(clicksPerDay.morningClicksOfDays);
  //   print(clicksPerDay.afternoonClicksOfDays);
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var _type = FeedbackType.light;
        Vibrate.feedback(_type);
        // Check if the list is not empty
        if (widget.athkars.isNotEmpty) {
          setState(() {
            //clicksPerDay.saveClicksPerDay(1, widget.isMorning);

            if (widget.athkars[0].counter > 1) {
              widget.athkars[0].counter--;
            } else {
              saveThikirCount(widget.athkars[0].thikirCount);
              widget.removedItems.add(widget.athkars[0]);

              widget.athkars.removeAt(0);
              checkIfFinished(widget.removedItems.last);
            }
          });
        }
      },
      child: RefreshIndicator(
        onRefresh: _undoRemove,
        child: ListView.builder(
          physics:
              const AlwaysScrollableScrollPhysics(), // Make the list scrollable
          itemCount: widget.athkars.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(widget.athkars[index].paragraph),
              onDismissed: (direction) {
                // clicksPerDay.saveClicksPerDay(
                //     widget.athkars[index].counter, widget.isMorning);
                saveThikirCount(widget.athkars[index].thikirCount);
                setState(() {
                  widget.removedItems.add(widget.athkars[index]);

                  widget.athkars.removeAt(index);
                  checkIfFinished(widget.removedItems.last);
                });
              },
              child: AthkarListItem(
                text1: widget.athkars[index].paragraph,
                text2: "التكرار: ${widget.athkars[index].counter}",
                fontSize: widget.fontSize,
              ),
            );
          },
        ),
      ),
    );
  }

  void saveThikirCount(int count) {
    var today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    if (widget.habit.records!.containsKey(today)) {
      //not first thikir so accumulate count of thikir
      widget.habit.records![today] = count + widget.habit.records![today]!;
    } else {
      //first thikir in the day so the date is not in the map
      widget.habit.records![today] = count;
    }
    widget.habit.save();
  }

  Future<void> _undoRemove() async {
    if (widget.removedItems.isNotEmpty) {
      setState(() {
        widget.athkars.insert(0, widget.removedItems.removeLast());
      });
    }
    return;
  }

  void checkIfFinished(Athkar thekir) async {
    var _type = FeedbackType.warning;
    Vibrate.feedback(_type);
    //log firebase even that an item was removed
    await FirebaseAnalytics.instance.logEvent(
      name: "single_thikir_done",
      parameters: {
        "athkar": widget.athkarType.toString(),
        "full_text": thekir.paragraph,
      },
    );
    if (widget.athkars.isEmpty) {
      await FirebaseAnalytics.instance.logEvent(
        name: "Athkar_done",
        parameters: {
          "athkar": widget.athkarType.toString(),
        },
      );
      //Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        //return StatsPage();

        return HabitStatsPage(habit: widget.habit);
      }));
    }
  }
}
