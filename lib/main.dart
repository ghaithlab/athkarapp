import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'athkar.dart';
import 'athkarListView.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Athkar> athkars = [];
  final List<Athkar> _removedItems = [];
  ThemeData _themeData = ThemeData();
  double _fontSize = 0;
  bool _isMorning = true; // Set the initial value to true
  late SharedPreferences _prefs;
//testing
//testing 2
  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    // If the current time is between 6:00 AM and 12:00 PM, set _isMorning to true
    if (now.hour >= 6 && now.hour < 12) {
      _isMorning = true;
    }
    // If the current time is between 12:00 PM and 6:00 AM, set _isMorning to false
    else if (now.hour >= 12 || now.hour < 6) {
      _isMorning = false;
    }
    buildAthkarList();
    _themeData = ThemeData.dark();
    _fontSize = 20;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        // Retrieve the stored theme and font size data from the shared preferences, if available
        _themeData = _prefs.getBool('isDarkTheme') ?? true
            ? ThemeData.dark()
            : ThemeData.light();
        _fontSize = _prefs.getDouble('fontSize') ?? 20;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _themeData, // Set the theme to a dark color scheme
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              _isMorning ? '** الصباح' : '** المساء',
              textAlign: TextAlign.center,
            ),
            actions: [
              // Add the refresh button to the app bar
              Switch(
                value: _isMorning,
                onChanged: (value) {
                  setState(() {
                    _isMorning = value;
                    buildAthkarList();
                  });
                },
                // tooltip: 'تبديل بين اذكار الصباح واذكار المساء',
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    buildAthkarList();
                  });
                },
                tooltip: 'اعادة الاذكار',
              ),
              IconButton(
                icon: const Icon(Icons.brightness_6),
                onPressed: () {
                  setState(() {
                    if (_themeData == ThemeData.dark()) {
                      _themeData = ThemeData.light();
                    } else {
                      _themeData = ThemeData.dark();
                    }
                    _prefs.setBool(
                        'isDarkTheme', _themeData == ThemeData.dark());
                    //buildAthkarList();
                  });
                },
                tooltip: 'تبديل السمة',
              ),
              // Add the font size increase button to the app bar

              TextButton(
                  onPressed: () {
                    setState(() {
                      _fontSize++;
                      _prefs.setDouble('fontSize', _fontSize);
                    });
                  },
                  child: const Text(
                    "ض",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _fontSize--;
                      _prefs.setDouble('fontSize', _fontSize);
                    });
                  },
                  child: const Text(
                    "ض",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  )),
            ],
          ),
          body: AthkarList(
            athkars: athkars,
            fontSize: _fontSize,
            removedItems: _removedItems,
          ),
        ),
      ),
    );
  }

  void buildAthkarList() {
    athkars.clear();
    _removedItems.clear();
    List paragraphs = _isMorning ? paragraphsMorning : paragraphsEvening;
    for (int i = 0; i < paragraphs.length; i++) {
      String p = "${paragraphs[i]['paragraph']}";
      int count = paragraphs[i]['Counter'];
      athkars.add(Athkar(paragraph: p, counter: count));
    }
  }
}



              // Add the font size decrease button to the app bar
              //   IconButton(
              //     icon: const Icon(Icons.add),
              //     onPressed: () {
              //       setState(() {
              //         _fontSize++;
              //       });
              //     },
              //     tooltip: 'زيادة حجم الخط',
              //   ),
              //   IconButton(
              //     icon: const Icon(Icons.remove),
              //     onPressed: () {
              //       setState(() {
              //         _fontSize--;
              //       });
              //     },
              //     tooltip: 'تقليل حجم الخط',
              //   ),