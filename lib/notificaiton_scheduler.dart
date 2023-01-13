import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PrayerTimeNotificationScheduler {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('location service is disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permissions are parmenently denied, we cannont request permissions");
    }
    return await Geolocator.getCurrentPosition();
  }

  List<DateTime> dates = [];
  Future<void> getPrayertimes(String latitude, String longitude) async {
    // Construct the API URL with the latitude and longitude
    String url =
        'https://api.aladhan.com/v1/calendar?latitude=$latitude&longitude=$longitude&month=${DateTime.now().month}&year=2023';

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
        String date = day['date']['gregorian']['date'];
        String fajrTime = day['timings']['Fajr'];

        fajrTime = fajrTime.substring(
            0,
            fajrTime.indexOf(
                " ")); //the string format is 05:12 (+x) we want to remove the (+x)
        // Parse the Fajr time into a DateTime object
        DateTime fajrDateTime =
            DateFormat('dd-MM-yyyy HH:mm').parse('$date $fajrTime');
        // Add 30 minutes to the Fajr time to get the notification time
        DateTime fajrNotificationDateTime =
            fajrDateTime.add(Duration(minutes: 30));
// Schedule a notification for the Fajr time
        dates.add(fajrNotificationDateTime);
        // await scheduleNotification(fajrNotificationDateTime,
        //     'Prayer Time Reminder', 'It is time for your Fajr prayer');

// Get the Asr time for the day
        String asrTime = day['timings']['Asr'];
        asrTime = asrTime.substring(
            0,
            asrTime.indexOf(
                " ")); //the string format is 05:12 (+x) we want to remove the (+x)
// Parse the Asr time into a DateTime object
        DateTime asrDateTime =
            DateFormat('dd-MM-yyyy HH:mm').parse('$date $asrTime');
// Add 30 minutes to the Asr time to get the notification time
        DateTime asrNotificationDateTime =
            asrDateTime.add(Duration(minutes: 30));
        dates.add(asrNotificationDateTime);
      }
    }
  }

  void scheduleNotifications() async {}
}

class NotificationsApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static void init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');

    // final IOSInitializationSettings initializationSettingsIOS =
    //     const IOSInitializationSettings(
    //         requestAlertPermission: true,
    //         requestBadgePermission: true,
    //         requestSoundPermission: true,
    //         onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    // final MacOSInitializationSettings initializationSettingsMacOS =
    //     const MacOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      //  iOS: initializationSettingsIOS,
      //  macOS: initializationSettingsMacOS,
    );

    await _notifications.initialize(initializationSettings);
  }

  static Future showNotification(
          {int id = 0, String? title, String? body, String? payload}) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        //channelDescription: 'chennel description',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future<bool> isAndroidPermissionGranted() async {
    bool granted = false;
    if (Platform.isAndroid) {
      granted = await _notifications
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      // setState(() {
      //   _notificationsEnabled = granted;
      // });
    }
    return granted;
  }

  static Future<bool> requestPermissions() async {
    bool? granted = false;
    if (Platform.isIOS || Platform.isMacOS) {
      // await _notifications
      //     .resolvePlatformSpecificImplementation<
      //         IOSFlutterLocalNotificationsPlugin>()
      //     ?.requestPermissions(
      //       alert: true,
      //       badge: true,
      //       sound: true,
      //     );
      // await _notifications
      //     .resolvePlatformSpecificImplementation<
      //         MacOSFlutterLocalNotificationsPlugin>()
      //     ?.requestPermissions(
      //       alert: true,
      //       badge: true,
      //       sound: true,
      //     );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      granted = await androidImplementation?.requestPermission();

      // setState(() {
      //   _notificationsEnabled = granted ?? false;
      // });
    }
    return granted ?? false;
  }
}
