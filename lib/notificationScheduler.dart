import 'dart:html';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PrayerTimeNotificationScheduler {
  // Initialize the FlutterLocalNotificationsPlugin object
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Future<void> scheduleNotification(
  //     DateTime notificationDateTime, String title, String message) async {
  //   // Create a notification for the specified time
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'channel_id', 'channel_name', 'channel_description');
  //   ;

  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.schedule(
  //       0, title, message, notificationDateTime, platformChannelSpecifics);
  // }

  Future<void> scheduleNotificationsForMonth() async {
    // Set up the notification plugin

    // var initializationSettingsAndroid =
    //     AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS = IOSInitializationSettings();
    // var initializationSettings = InitializationSettings(
    //     initializationSettingsAndroid, initializationSettingsIOS);
    // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // PermissionStatus permission =
    //     await Permissions().request(Permissions);

// Check if the permission was granted
    if (permission == PermissionStatus.granted) {
      // If the permission was granted, schedule the notifications
      PrayerTimeNotificationScheduler scheduler =
          PrayerTimeNotificationScheduler();
      await scheduler.scheduleNotificationsForMonth();
    }

    // Get the current position of the device
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Get the latitude and longitude from the position
    double latitude = position.latitude;
    double longitude = position.longitude;

    // Construct the API URL with the latitude and longitude
    String url =
        'https://api.aladhan.com/v1/calendar?latitude=$latitude&longitude=$longitude&month=1&year=2023';

    // Make the HTTP GET request to the API
    var response = await http.get(Uri.parse(url));

    // Check the status code of the response
    if (response.statusCode == 200) {
      // If the call to the API was successful, parse the JSON response
      var data = json.decode(response.body);

      // Get the list of days from the JSON data
      List days = data['data'];
      // Iterate through the list of days
      for (var day in days) {
        // Get the Fajr time for the day
        String fajrTime = day['timings']['Fajr'];
        // Parse the Fajr time into a DateTime object
        DateTime fajrDateTime = DateTime.parse(fajrTime);
        // Add 30 minutes to the Fajr time to get the notification time
        DateTime fajrNotificationDateTime =
            fajrDateTime.add(Duration(minutes: 30));
// Schedule a notification for the Fajr time

        // await scheduleNotification(fajrNotificationDateTime,
        //     'Prayer Time Reminder', 'It is time for your Fajr prayer');

// Get the Asr time for the day
        String asrTime = day['timings']['Asr'];
// Parse the Asr time into a DateTime object
        DateTime asrDateTime = DateTime.parse(asrTime);
// Add 30 minutes to the Asr time to get the notification time
        DateTime asrNotificationDateTime =
            asrDateTime.add(Duration(minutes: 30));
// Schedule a notification for the Asr time

        // await scheduleNotification(asrNotificationDateTime,
        //     'Prayer Time Reminder', 'It is time for your Asr prayer');
      }
    } else {
      // If the call to the API was unsuccessful, throw an error
      throw Exception('Failed to load data');
    }
  }
}
