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
      required this.creationDate,
      this.maxValue = 1}) {
    records = {};
  }

  @HiveField(6)
  late bool? isDefaultHabit;

  @HiveField(7)
  late bool?
      isBasicHabit; //basic means only Done or not, it doesnt have a value like number of pages in reading habit

  @HiveField(10, defaultValue: 1)
  int maxValue;
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


// Updating a class
// If an existing class needs to be changed – for example, you'd like the class to have a new field – but you'd still like to read objects written with the old adapter, don't worry! It is straightforward to update generated adapters without breaking any of your existing code. Just remember the following rules:

// Don't change the field numbers for any existing fields.
// If you add new fields, any objects written by the "old" adapter can still be read by the new adapter. These fields are just ignored. Similarly, objects written by your new code can be read by your old code: the new field is ignored when parsing.
// Fields can be renamed and even changed from public to private or vice versa as long as the field number stays the same.
// Fields can be removed, as long as the field number is not used again in your updated class.
// Changing the type of a field is not supported. You should create a new one instead.
// You have to provide defaultValue for new non-nullable fields after enabling null safety.