import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'athkar.dart';
// import 'athkarListView.dart';
import 'athkar/athkarPage.dart';

void main() => runApp(MyApp());

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
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        // Set the theme to a dark color scheme
        debugShowCheckedModeBanner: false,
        home: AthkarPage());
  }
}
