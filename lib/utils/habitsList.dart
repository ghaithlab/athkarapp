import 'package:athkarapp/models/habitsModel.dart';
import 'package:flutter/foundation.dart';

Map defaultHabitsIds = {
  "morningAthkarId": "###1",
  "eveningAthkarId": "###2",
  "salatDuha": "###3",
  "salatWitr": "###4",
  "tahajud": "###5",
  "sleepingAthkarId": "###6",
  "kiyamlayl": "###7",
};

class HabitRecordGenerator {
  static List<HabitRecord> getIslamicHabits() {
    var today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return [
      HabitRecord(
        id: defaultHabitsIds["sleepingAthkarId"],
        name: "أذكار النوم",
        isBasicHabit: false,
        isDefaultHabit: true,
        creationDate: today,
        maxValue: 183, ////////////////////////////TODO IMPORTANT
      ),
      HabitRecord(
        id: defaultHabitsIds["morningAthkarId"],
        name: "أذكار الصباح",
        isBasicHabit: false,
        isDefaultHabit: true,
        creationDate: today,
        maxValue: 183,
      ),
      HabitRecord(
        id: defaultHabitsIds["eveningAthkarId"],
        name: "أذكار المساء",
        isBasicHabit: false,
        isDefaultHabit: true,
        creationDate: today,
        maxValue: 184,
      ),
      HabitRecord(
        id: defaultHabitsIds["salatDuha"],
        name: "صلاة الضحى",
        isBasicHabit: true,
        isDefaultHabit: true,
        creationDate: today,
      ),
      HabitRecord(
        id: defaultHabitsIds["salatWitr"],
        name: "صلاة الوتر",
        isBasicHabit: true,
        isDefaultHabit: true,
        creationDate: today,
      ),
      HabitRecord(
        id: defaultHabitsIds["tahajud"],
        name: "صلاة التهجد",
        isBasicHabit: true,
        isDefaultHabit: true,
        creationDate: today,
      ),
      HabitRecord(
        id: defaultHabitsIds["kiyamlayl"],
        name: "صلاة قيام الليل",
        isBasicHabit: true,
        isDefaultHabit: true,
        creationDate: today,
      ),
    ];
  }

  static List<HabitRecord> getPersonalHabits() {
    var today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return [
      HabitRecord(
        id: UniqueKey().toString(),
        name: "قراءة ورد قرآن",
        isBasicHabit: true,
        isDefaultHabit: false,
        creationDate: today,
      ),
      HabitRecord(
        id: UniqueKey().toString(),
        name: "قراءة يومية",
        isBasicHabit: true,
        isDefaultHabit: false,
        creationDate: today,
      ),
      HabitRecord(
        id: UniqueKey().toString(),
        name: "تمارين رياضية",
        isBasicHabit: true,
        isDefaultHabit: false,
        creationDate: today,
      ),
    ];
  }
}
