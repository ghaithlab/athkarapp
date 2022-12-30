import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class ClicksPerDay {
  late Map<String, Map<String, int>> clicksOfDays = {};
  late SharedPreferences _prefs;

  Map<DateTime, int> morningClicksOfDays = {};
  Map<DateTime, int> afternoonClicksOfDays = {};

  ClicksPerDay();

  void splitClicksOfDays() {
    morningClicksOfDays = {};
    afternoonClicksOfDays = {};
    for (var entry in clicksOfDays.entries) {
      String date = entry.key;
      Map<String, int> isMorningClicks = entry.value;
      if (isMorningClicks['true'] != null) {
        morningClicksOfDays[DateTime.parse(date)] = isMorningClicks['true']!;
      }
      if (isMorningClicks['false'] != null) {
        afternoonClicksOfDays[DateTime.parse(date)] = isMorningClicks['false']!;
      }
    }
  }

  void fillMorningEveningDummyData() {
    morningClicksOfDays = {
      DateTime(2022, 12, 29): 200,
    };

    afternoonClicksOfDays = {
      DateTime(2022, 12, 29): 200,
    };
    for (int i = 1; i <= 31; i++) {
      var date = DateTime(2022, 12, i);
      var value = Random().nextInt(301) + 1; // Random integer from 100 to 400
      morningClicksOfDays[date] = value;
    }
    for (int i = 1; i <= 31; i++) {
      var date = DateTime(2022, 12, i);
      var value = Random().nextInt(301) + 1; // Random integer from 100 to 400
      afternoonClicksOfDays[date] = value;
    }
    for (int i = 1; i <= 31; i++) {
      var date = DateTime(2022, 11, i);
      var value = Random().nextInt(301) + 1; // Random integer from 100 to 400
      morningClicksOfDays[date] = value;
    }
    for (int i = 1; i <= 31; i++) {
      var date = DateTime(2022, 11, i);
      var value = Random().nextInt(301) + 1; // Random integer from 100 to 400
      afternoonClicksOfDays[date] = value;
    }
    for (int i = 1; i <= 31; i++) {
      var date = DateTime(2022, 10, i);
      var value = Random().nextInt(301) + 1; // Random integer from 100 to 400
      morningClicksOfDays[date] = value;
    }
    for (int i = 1; i <= 31; i++) {
      var date = DateTime(2022, 10, i);
      var value = Random().nextInt(301) + 1; // Random integer from 100 to 400
      afternoonClicksOfDays[date] = value;
    }
    print(morningClicksOfDays);
    print(afternoonClicksOfDays);
  }

  // Method to read all shared preferences and build the clicksOfDays map
  Future<void> readClicksPerDay() async {
    clicksOfDays = {};
    //_prefs = await SharedPreferences.getInstance();
    _prefs.getKeys().forEach((key) {
      if (key.contains('#')) {
        // Split the key into date and isMorning
        List<String> parts = key.split('#');
        String date = parts[0];
        String isMorning = parts[1];
        // Initialize the inner map if it doesn't exist
        if (!clicksOfDays.containsKey(date)) {
          clicksOfDays[date] = {};
        }
        clicksOfDays[date]![isMorning] = _prefs.getInt(key)!;
      }
    });

    splitClicksOfDays();
  }

  // Method to initialize the SharedPreferences object and read the click counts
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await readClicksPerDay();
  }

  // Method to save the click counts to SharedPreferences
  Future<void> saveClicksPerDay(int clicks, bool isMorning) async {
    // Convert the isMorning bool to a string
    String isMorningString = isMorning ? 'true' : 'false';
    // Get the current date in the ISO 8601 date format (yyyy-MM-dd)
    //DateTime now = DateTime.now();
    DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    String dateString = now.toIso8601String();
    //String dateString = now.toIso8601String(dateOnly: true);
    // Initialize the inner map if it doesn't exist
    if (!clicksOfDays.containsKey(dateString)) {
      clicksOfDays[dateString] = {};
    }
    // Increment the click count or initialize it to the provided value
    if (clicksOfDays[dateString]!.containsKey(isMorningString)) {
      clicksOfDays[dateString]![isMorningString] =
          clicksOfDays[dateString]![isMorningString]! + clicks;
    } else {
      clicksOfDays[dateString]![isMorningString] = clicks;
    }
    // Save the click count to SharedPreferences
    _prefs.setInt('$dateString#$isMorningString',
        clicksOfDays[dateString]![isMorningString]!);
  }
}
