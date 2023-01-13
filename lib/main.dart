import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'athkar/athkarPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'notificaiton_scheduler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

const fontColorLight = Color(0xFF897465);

class MyApp extends StatefulWidget {
  MyApp({super.key});
  //ThemeData _themeData = ThemeData.dark();

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  late SharedPreferences _prefs;

  // void _showMessage(List<Object> lst) {
  //   //clicksPerDay.fillMorningEveningDummyData();
  //   String x = "";
  //   for (var day in lst) {
  //     x += "${day},   ";
  //   }
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         content: const Text('This is a message'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text(x),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void getPrayerTimes() async {
    String lat = "";
    String long = "";
    NotificationsApi.init();
    bool x = await NotificationsApi.isAndroidPermissionGranted();
    if (x)
      NotificationsApi.showNotification(
          title: "title", body: "body", payload: "payload");
    else if (await NotificationsApi.requestPermissions()) {
      NotificationsApi.showNotification(
          title: "title", body: "body", payload: "payload");
    }

    // PrayerTimeNotificationScheduler p = PrayerTimeNotificationScheduler();
    // p.getCurrentLocation().then((value) {
    //   lat = '${value.latitude}';
    //   long = '${value.longitude}';
    //   p.getPrayertimes(lat, long).then((value) {
    //     // _showMessage(p.dates);

    //     print(p.dates);
    //   });
    // });
  }

  @override
  void initState() {
    super.initState();

    getPrayerTimes();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        // Retrieve the stored theme and font size data from the shared preferences, if available
        _themeMode = _prefs.getBool('isDarkTheme') ?? true
            ? ThemeMode.dark
            : ThemeMode.light;
      });
    });
  }

  void changeTheme() {
    setState(() {
      _prefs.setBool('isDarkTheme', (_themeMode == ThemeMode.light));
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        themeMode: _themeMode,
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: Color(0xFFFEF8EE),
          cardColor: Color.fromARGB(255, 247, 240, 226),
          textTheme: ThemeData.light().textTheme.copyWith(
                labelLarge: TextStyle(fontSize: 20, color: fontColorLight),
                labelSmall: TextStyle(color: Color(0xFF897465)),
              ),
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                color: fontColorLight,
                fontSize: 18,
                fontWeight: FontWeight.w800),
            elevation: 1,
            backgroundColor: Color.fromARGB(255, 247, 240, 226),
            iconTheme: IconThemeData(color: fontColorLight),
            actionsIconTheme: IconThemeData(
                color: fontColorLight), // Color.fromARGB(222, 24, 85, 28)
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.all(Color.fromARGB(23, 85, 85, 85)),
              foregroundColor: MaterialStatePropertyAll(fontColorLight),
            ),
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          textTheme: ThemeData.dark().textTheme.copyWith(
                labelLarge: TextStyle(fontSize: 20, color: Colors.white),
                labelSmall: TextStyle(color: Colors.white),
              ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              //textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 20)),
              overlayColor:
                  MaterialStateProperty.all(Color.fromARGB(25, 238, 238, 238)),
              foregroundColor: MaterialStatePropertyAll(Colors.white),
            ),
          ),
        ),
        // Set the theme to a dark color scheme
        debugShowCheckedModeBanner: false,
        home: AthkarPage());
  }
}
