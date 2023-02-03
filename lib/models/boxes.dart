import 'package:athkarapp/models/habitsModel.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<HabitRecord> getHabits() => Hive.box<HabitRecord>('Habits');
}
