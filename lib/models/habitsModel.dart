import 'package:hive/hive.dart';

part 'habitsModel.g.dart';

@HiveType(typeId: 0)
class HabitRecord extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  // @HiveField(2)
  // late int value;

  // @HiveField(3)
  // late DateTime date;

  @HiveField(8)
  late Map<DateTime, int>? records;

  @HiveField(9)
  late DateTime? creationDate;

  HabitRecord(
      {required this.id,
      required this.name,
      this.isBasicHabit = false,
      this.isDefaultHabit = true,
      required this.creationDate}) {
    records = {};
  }

  @HiveField(6)
  late bool? isDefaultHabit;

  @HiveField(7)
  late bool?
      isBasicHabit; //basic means only Done or not, it doesnt have a value like number of pages in reading habit

  bool hasToday() {
    DateTime today = DateTime.now();

    return (records!.containsKey(DateTime(today.year, today.month, today.day)));
  }

  int calculateStreak() {
    var list = records!.keys.toList();
    if (list.isEmpty) return 0;
    // list = [
    //   DateTime(2023, 1, 7),
    //   DateTime(2023, 1, 8),
    //   DateTime(2023, 1, 7),
    //   //DateTime(2023, 2, 1),
    //   DateTime(2023, 2, 2),
    // ];
    list.sort((a, b) => b.compareTo(a));
    DateTime first = list.last;
    DateTime last = list.first;
    DateTime now = DateTime.now();

    int streak = 1;

    if (now.difference(last).inDays > 1) {
      //there is a difference between today and last date in list more than one so streak is broken
      streak = 0;
    } else {
      for (int i = 1; i < list.length; i++) {
        // Calculate the difference between the current and previous key
        int difference = list[i].difference(list[i - 1]).inDays;

        // If the difference is 1, increment the streak and update the streak end date
        if (difference == -1) {
          streak++;
        } else {
          // Reset the streak if the difference is greater than 1
          break;
        }
      }
    }
    return streak;
  }

  int calculateDaysCount() {
    return records!.length;
  }

  int calculateConsistency() {
    List<DateTime> sorted = records!.keys.toList();
    if (sorted.isNotEmpty) {
      sorted.sort((a, b) => b.compareTo(a)); //sorted in reverse order
      DateTime first = sorted.last;
      DateTime last = sorted.first;
      DateTime now = DateTime.now();
      int numDays = now.difference(first).inDays + 1;
      return (sorted.length / numDays * 100).ceil();
    }
    return 0;
  }
}

// class Habit {
//   List<HabitRecord> list;
//   String? name;
//   String? id;
//   int? count;
//   List<DateTime>? dates;

//   Habit({required List<HabitRecord> this.list}) {
//     if (list.isNotEmpty) {
//       name = list[0].name;
//       id = list[0].id;
//       count = list.length;
//       dates = list.map((e) => e.date).toList();
//     }
//   }
//   void CheckToday({int? value}) {
//     HabitRecord today = HabitRecord(
//       name: name!,
//       id: id!,
//       date: DateTime.now(),
//       value: value ?? 0,
//     );
//     today.save();
//     //TODO: save into hive.
//   }

// }
// class HiveDB {
//   static final HiveDB _singleton = HiveDB._internal();
//   static Box<Habit> _habitsBox;

//   factory HiveDB() {
//     return _singleton;
//   }

//   HiveDB._internal() {
//     // Open the Hive database and get the box for the Habit objects
//     Hive.openBox('habits', compactor: HiveCompactor()).then((box) {
//       _habitsBox = box;
//     });
//   }

//   Future<void> addHabit(Habit habit) async {
//     // Add the Habit object to the box
//     await _habitsBox.add(habit);
//   }

//   Future<List<Habit>> getHabits() async {
//     // Get a list of all the Habit objects in the box
//     return _habitsBox.values.toList();
//   }

//   Future<void> updateHabit(Habit habit) async {
//     // Update the Habit object in the box
//     await _habitsBox.put(habit.hashCode, habit);
//   }

//   Future<void> deleteHabit(Habit habit) async {
//     // Delete the Habit object from the box
//     await _habitsBox.delete(habit.hashCode);
//   }
// }
