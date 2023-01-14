import 'dart:convert';
import 'dart:io';

class DateStorage {
  static Future<void> saveDates(List<DateTime> dates) async {
    try {
      // Create a new file if it doesn't exist
      // otherwise clear the content
      File file = File('dates.json');
      if (!(await file.exists())) {
        file = await file.create();
      } else {
        await file.writeAsString("");
      }

      // Convert the list of dates to a JSON string
      String jsonString = jsonEncode(dates);

      // Write the JSON string to the file
      await file.writeAsString(jsonString);
    } catch (e) {
      print('An error occurred while saving the dates: $e');
    }
  }

  static Future<List<DateTime>> readDates() async {
    try {
      // Read the contents of the file
      String jsonString = await File('dates.json').readAsString();

      // Convert the JSON string to a list of dates
      List<DateTime> dates = List<DateTime>.from(jsonDecode(jsonString));

      return dates;
    } catch (e) {
      print('An error occurred while reading the dates: $e');
      return <DateTime>[];
    }
  }
}
