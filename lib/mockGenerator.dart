import 'dart:math';
import 'package:intl/intl.dart';

class mockGenerator {
  static Map<DateTime, int> generateRandomDates(
      DateTime startDate, DateTime endDate, int value) {
    int x;
    Random random = Random();

    // Calculate the difference in days between the start and end date
    int differenceInDays = endDate.difference(startDate).inDays;

    // Generate a random number of dates that is proportional to the difference in days
    int numberOfDates = (random.nextDouble() * differenceInDays).floor() + 1;

    Map<DateTime, int> dates = {};

    // Generate the requested number of dates
    for (int i = 0; i < differenceInDays; i++) {
      // Generate a random number of days between the start and end date
      // int randomNumberOfDays =
      //     random.nextInt((differenceInDays / 2 + 1).toInt()) +
      //         (differenceInDays / 2).toInt();

      // Add the random number of days to the start date to get a new date
      DateTime newDate = startDate.add(Duration(days: i));

      // Check if the new date is already in the set of dates
      if (!dates.keys.contains(newDate)) {
        if (value == 1) {
          x = random.nextInt(2);
        } else {
          x = random.nextInt(value + 1);
        }
        // Add the new date to the set of dates
        if (x != 0) dates[newDate] = x;
      }
    }

    // Convert the set to a sorted list of dates
    // List<DateTime> sortedDates = dates.toList();
    // sortedDates.sort((a, b) => a.compareTo(b));

    return dates;
  }
}
