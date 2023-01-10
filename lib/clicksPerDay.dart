import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class ClicksPerDay {
  late Map<String, Map<String, int>> clicksOfDays = {};
  late SharedPreferences _prefs;

  Map<DateTime, int> morningClicksOfDays = {};
  Map<DateTime, int> afternoonClicksOfDays = {};
  Map morningStats = {'daysCount': 0, 'consistency': 0, 'streak': 0};
  Map eveningStats = {'daysCount': 0, 'consistency': 0, 'streak': 0};
  ClicksPerDay();

  calculateStats(Map<DateTime, int> list, var mp) {
    List<DateTime> sorted = list.keys.toList();
    sorted.sort((a, b) => b.compareTo(a)); //sorted in reverse order
    DateTime first = sorted.last;
    DateTime last = sorted.first;
    DateTime now = DateTime.now();
    int numDays = now.difference(first).inDays + 1;
    int streak = 1;

    if (now.difference(last).inDays > 1) {
      //there is a difference between today and last date in list more than one so streak is broken
      streak = 0;
    } else {
      for (int i = 1; i < sorted.length; i++) {
        // Calculate the difference between the current and previous key
        int difference = sorted[i].difference(sorted[i - 1]).inDays;

        // If the difference is 1, increment the streak and update the streak end date
        if (difference == -1) {
          streak++;
        } else {
          // Reset the streak if the difference is greater than 1
          break;
        }
      }
    }
    mp['daysCount'] = sorted.length;
    mp['consistency'] = (sorted.length / numDays * 100).ceil();

    mp['streak'] = streak;
  }

  //make values from 1 to 13 for the heat map
  Map<DateTime, int> normalizeMap(Map<DateTime, int> map) {
    // Find the maximum value in the map
    int maxVal = map.values.reduce(max);

    // Create a new map to store the normalized values
    Map<DateTime, int> normalizedMap = {};

    // Iterate over the map and compute the percentage of each value to the max value
    map.forEach((key, value) {
      int normalizedValue = (value / maxVal * 13).round();
      normalizedValue = normalizedValue < 1 ? 1 : normalizedValue;
      normalizedMap[key] = normalizedValue;
    });

    return normalizedMap;
  }

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
    if (afternoonClicksOfDays.isNotEmpty) {
      afternoonClicksOfDays = normalizeMap(afternoonClicksOfDays);
      calculateStats(afternoonClicksOfDays, eveningStats);
    }
    if (morningClicksOfDays.isNotEmpty) {
      morningClicksOfDays = normalizeMap(morningClicksOfDays);
      calculateStats(morningClicksOfDays, morningStats);
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
      var date = DateTime(2023, 1, i);
      var value = Random().nextInt(301) + 1; // Random integer from 100 to 400
      morningClicksOfDays[date] = value;
    }
    for (int i = 1; i <= 31; i++) {
      var date = DateTime(2023, 1, i);
      var value = Random().nextInt(301) + 1; // Random integer from 100 to 400
      afternoonClicksOfDays[date] = value;
    }
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
    if (afternoonClicksOfDays.isNotEmpty) {
      afternoonClicksOfDays = normalizeMap(afternoonClicksOfDays);
      calculateStats(afternoonClicksOfDays, eveningStats);
    }
    if (morningClicksOfDays.isNotEmpty) {
      morningClicksOfDays = normalizeMap(morningClicksOfDays);
      calculateStats(morningClicksOfDays, morningStats);
    }
    eveningStats['daysCount'] = 68;
    eveningStats['consistency'] = 65;

    eveningStats['streak'] = 4;
    morningStats['daysCount'] = 68;
    morningStats['consistency'] = 65;

    morningStats['streak'] = 6;
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
    if (clicksOfDays.isNotEmpty) splitClicksOfDays();
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
