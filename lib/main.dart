import 'dart:developer';

import 'package:athkarapp/homeScreen.dart';
import 'package:athkarapp/models/habitsModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'athkar/athkarPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'notificaiton_scheduler.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:core';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(HabitRecordAdapter());
  await Hive.openBox<HabitRecord>('Habits');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

//const fontColorLight = Color(0xFF897465);
const fontColorLight = Color(0xFF964F36);

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

  @override
  void initState() {
    super.initState();

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
                labelLarge: const TextStyle(
                  fontSize: 20,
                  color: fontColorLight,
                  fontWeight: FontWeight.w700,
                ),
                // labelSmall: TextStyle(color: Color(0xFF897465)),
                labelSmall: const TextStyle(
                  color: fontColorLight,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: fontColorLight,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
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
          cardColor: Color(0xFF3A3A3A),
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
        home: HomeScreen());
  }
}
