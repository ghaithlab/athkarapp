import "package:athkarapp/habitAddDialogue.dart";
import "package:athkarapp/habitButton.dart";
import "package:athkarapp/models/boxes.dart";
import "package:athkarapp/models/habitsModel.dart";
import "package:athkarapp/utils/colorPalet.dart";
import "package:athkarapp/utils/habitsList.dart";
import "package:flutter/material.dart";
import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";

class HabitAddPage extends StatefulWidget {
  const HabitAddPage({super.key});

  @override
  State<HabitAddPage> createState() => _HabitAddPageState();
}

class _HabitAddPageState extends State<HabitAddPage> {
  Future<void> addHabit(HabitRecord habit) async {
    Box box = Boxes.getHabits();
    await box.add(habit);
  }

  dynamic longPressButton({required HabitRecord habit, int? value}) {
    addHabit(habit);
    Navigator.pop(this.context);
  }

  void tapButton({required HabitRecord habit}) {
    addHabit(habit);
    Navigator.pop(this.context);
  }

  void addCustomHabitDialog() {
    showDialog(
        context: context,
        builder: (context) => TransactionDialog(
              onClickedDone: addNewHabit,
            ));
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
    Navigator.pop(this.context);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إضافة عادة جديدة"),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.done),
            //   onPressed: () {
            //     showDialog(
            //         context: context,
            //         builder: (context) => TransactionDialog(
            //               onClickedDone: addNewHabit,
            //             ));
            //   },
            //   tooltip: 'إضافة عادة جديدة',
            // ),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast),
          child: ValueListenableBuilder<Box<HabitRecord>>(
            valueListenable: Boxes.getHabits().listenable(),
            builder: (context, box, _) {
              final habits = box.values.toList().cast<HabitRecord>();
              //var habitsNotAdded = HabitRecordGenerator.getHabits().where((e) {}})

              List<HabitRecord> habitsNotAdded =
                  HabitRecordGenerator.getIslamicHabits()
                      .where((element) =>
                          !habits.any((obj) => obj.id == element.id))
                      .toList();

              return Column(
                children: [
                  if (habitsNotAdded.isNotEmpty)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 20, top: 16, bottom: 8),
                        child: Text(
                          "السنن المؤكدة",
                          style: TextStyle(
                            fontSize: 24,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    //: Color.fromARGB(255, 217, 208, 193),
                                    : fontColorLight,
                          ),
                        ),
                      ),
                    ),
                  if (habitsNotAdded.isNotEmpty)
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.only(
                          right: 20, top: 8, bottom: 20, left: 20), //all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: habitsNotAdded.map((e) {
                        return HabitButtonAnimated(
                          key: UniqueKey(),
                          habit: e,
                          color: defaultHabitColor,
                          onClickedDone: longPressButton,
                          onTap: tapButton,
                          isDarkMode:
                              Theme.of(context).brightness == Brightness.dark,
                        );
                      }).toList(),
                    ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 20, top: 16, bottom: 8),
                      child: Text(
                        "عادات شخصية",
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
                    children: HabitRecordGenerator.getPersonalHabits().map((e) {
                      return HabitButtonAnimated(
                        key: UniqueKey(),
                        habit: e,
                        color: personalHabitColor,
                        onClickedDone: longPressButton,
                        onTap: tapButton,
                        isDarkMode:
                            Theme.of(context).brightness == Brightness.dark,
                      );
                    }).toList(),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.infinity,
                    child: HabitButtonAnimated(
                      key: UniqueKey(),
                      habit: HabitRecord(
                        id: UniqueKey().toString(),
                        name: "أخرى",
                        isBasicHabit: true,
                        isDefaultHabit: false,
                        creationDate: null,
                      ),
                      color: customHabitColor,
                      onClickedDone: (
                          {required HabitRecord habit, int? value}) {
                        addCustomHabitDialog();
                      },
                      onTap: ({required HabitRecord habit}) {
                        addCustomHabitDialog();
                      },
                      isDarkMode:
                          Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
