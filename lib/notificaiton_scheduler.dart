import 'dart:convert';
import 'dart:io';

import 'package:athkarapp/DateStorageJson.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PrayerTimeNotificationScheduler {
  Future init() async {
    String lat = "";
    String long = "";
    Position p = await getCurrentLocation();
    lat = '${p.latitude}';
    long = '${p.longitude}';
    await getPrayertimes(lat, long);
    // _showMessage(p.dates);

    print(dates);
  }

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

  List<tz.TZDateTime> dates = [];
  Future<void> getPrayertimes(String latitude, String longitude) async {
    String url =
        'https://api.aladhan.com/v1/calendar?latitude=$latitude&longitude=$longitude&month=${DateTime.now().month}&year=${DateTime.now().year}';

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
        var dd = DateFormat('dd-MM-yyyy').parse(date);
        if (dd.isAfter(DateTime.now()) &&
            dd.isBefore(DateTime.now().add(Duration(days: 2)))) {
          //var timeFajr = DateFormat.Hm().parse(fajrTime);
          // tz.TZDateTime tzFajr = tz.TZDateTime.utc(
          //   dd.year,
          //   dd.month,
          //   dd.day,
          //   timeFajr.hour,
          //   timeFajr.minute,
          // ).add(
          //   Duration(minutes: 30),
          // );

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
          tz.TZDateTime tzFajr = tz.TZDateTime.from(
            fajrNotificationDateTime,
            tz.local,
          );

// Schedule a notification for the Fajr time
          dates.add(tzFajr);

// Get the Asr time for the day
          String s = day['timings']['Asr'];

          s = s.substring(
              0,
              s.indexOf(
                  " ")); //the string format is 05:12 (+x) we want to remove the (+x)Parse the Asr time into a DateTime object
          DateTime asrDateTime =
              DateFormat('dd-MM-yyyy HH:mm').parse('$date $s');

// Add 30 minutes to the Asr time to get the notification time
          DateTime asrNotificationDateTime =
              asrDateTime.add(Duration(minutes: 30));

          tz.TZDateTime tzAsr = tz.TZDateTime.from(
            asrNotificationDateTime,
            tz.local,
          );

          dates.add(tzAsr);
        }
      }
      print(dates);
    }
  }

  void scheduleNotifications() async {
    NotificationsApi.init();

    int scheduledNotifications =
        await NotificationsApi.listScheduledNotifications();
    // await NotificationsApi.clear();
    // scheduledNotifications =
    //     await NotificationsApi.listScheduledNotifications();
    // var dd = DateTime.now();

    // await NotificationsApi.schedule(
    //   title: "title",
    //   body: "from",
    //   payload: "payload",
    //   time: tz.TZDateTime.now(tz.local).add(const Duration(seconds: 20)),
    // );
    //NotificationsApi.clear();
    //var dd = DateTime.now().add(Duration(seconds: 20));
    // DateTime dd = DateFormat('dd-MM-yyyy HH:mm')
    //     .parse('14-1-2023 11:55')
    //     .add(Duration(seconds: 20));
    // await NotificationsApi.schedule(
    //   id: 15,
    //   title: "تذكير بالأذكار",
    //   body: "from test",
    //   payload: "payload",
    //   time: tz.TZDateTime.from(dd, tz.local).add(Duration(seconds: 20)),
    // );
    // await NotificationsApi.schedule(
    //   id: 16,
    //   title: "تذكير بالأذكار",
    //   body: "from test",
    //   payload: "payload",
    //   time: tz.TZDateTime.from(dd, tz.local).add(Duration(seconds: 30)),
    // );
    // await NotificationsApi.schedule(
    //   id: 17,
    //   title: "تذكير بالأذكار",
    //   body: "from test",
    //   payload: "payload",
    //   time: tz.TZDateTime.from(dd, tz.local).add(Duration(seconds: 40)),
    // );
    // await NotificationsApi.schedule(
    //   title: "title",
    //   body: "utc",
    //   payload: "payload",
    //   time: tz.TZDateTime.utc(
    //           dd.year, dd.month, dd.day, dd.hour, dd.minute, dd.second)
    //       .add(const Duration(seconds: 25)),
    // );
//if (scheduledNotifications == 0)
    if (scheduledNotifications == 0) {
      await init();
      bool x = await NotificationsApi.isAndroidPermissionGranted();
      if (x) {
        // NotificationsApi.showNotification(
        //     title: "title", body: "body", payload: "payload");
        // await NotificationsApi.schedule(
        //   id: 1,
        //   title: "title",
        //   body: "body",
        //   payload: "payload",
        //   time: DateTime.now(),
        // );
        for (int i = 0; i < dates.length; i++)
          await NotificationsApi.schedule(
            id: i,
            title: "تذكير بالأذكار",
            body:
                "(الَّذِينَ آمَنُواْ وَتَطْمَئِنُّ قُلُوبُهُم بِذِكْرِ اللَّهِ أَلاَ بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ)",
            payload: "payload",
            time: dates[i],
          );
      } else if (await NotificationsApi.requestPermissions()) {
        for (int i = 0; i < dates.length; i++)
          await NotificationsApi.schedule(
            id: i,
            title: "تذكير بالأذكار",
            body:
                "(الَّذِينَ آمَنُواْ وَتَطْمَئِنُّ قُلُوبُهُم بِذِكْرِ اللَّهِ أَلاَ بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ)",
            payload: "payload",
            time: dates[i],
          );
        // NotificationsApi.showNotification(
        //     title: "title", body: "body", payload: "payload");
        // await NotificationsApi.schedule(
        //   title: "title",
        //   body: "body",
        //   payload: "payload",
        //   time: tz.TZDateTime.now(tz.local).add(const Duration(seconds: 20)),
        // );

      }
      print(dates);
    }
  }
}

class NotificationsApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static Future clear() async {
    await _notifications.cancelAll();
  }

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
    tz.initializeTimeZones();
  }

  static Future showNotification(
          {int id = 0, String? title, String? body, String? payload}) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);

  static Future schedule({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required tz.TZDateTime time,
  }) async {
    _notifications.zonedSchedule(
        id, title, body, time, await _notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
    // _notifications.show(id, title, body, await _notificationDetails(),
    //     payload: payload);
  }

  static Future<int> listScheduledNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await _notifications.pendingNotificationRequests();

    return pendingNotificationRequests.length;
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          //channelDescription: 'chennel description',
          importance: Importance.max,
          priority: Priority.max),
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
