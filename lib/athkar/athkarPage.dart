import 'package:athkarapp/main.dart';
import 'package:athkarapp/statsPage.dart';

//import '../selectableButton.dart';
import 'athkar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'athkarListView.dart';

class AthkarPage extends StatefulWidget {
  @override
  _AthkarPageState createState() => _AthkarPageState();
}

class _AthkarPageState extends State<AthkarPage> {
  List<Athkar> athkars = [];
  final List<Athkar> _removedItems = [];
  double _fontSize = 0;
  bool _isMorning = true; // Set the initial value to true
  late SharedPreferences _prefs;
  bool selected = false;
  String pressedText = "أذكار الصباح";
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
    _fontSize = 20;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        _fontSize = _prefs.getDouble('fontSize') ?? 20;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          // title: Text(
          //   _isMorning ? ' الصباح' : ' المساء',
          //   textAlign: TextAlign.center,
          // ),

          actions: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TextButton(
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                              const TextStyle(fontSize: 20)),
                          overlayColor:
                              MaterialStateProperty.all(Colors.grey[600]),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: (() {
                        setState(() {
                          _isMorning = !_isMorning;
                          buildAthkarList();
                        });
                      }),
                      child: Text(
                        _isMorning ? 'أذكار الصباح' : "أذكار المساء",
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      // Add the refresh button to the app bar

                      // Switch(
                      //   value: _isMorning,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _isMorning = value;
                      //       buildAthkarList();
                      //     });
                      //   },
                      //   // tooltip: 'تبديل بين اذكار الصباح واذكار المساء',
                      // ),
                      IconButton(
                        icon: const Icon(Icons.stacked_line_chart),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return StatsPage();
                          }));
                        },
                        tooltip: 'تبديل السمة',
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          setState(() {
                            buildAthkarList();
                            //TODO: to remove
                            //_prefs.clear();
                          });
                        },
                        tooltip: 'اعادة الاذكار',
                      ),
                      IconButton(
                        icon: const Icon(Icons.brightness_6),
                        onPressed: () {
                          MyApp.of(context)!.changeTheme();
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        body: AthkarList(
          athkars: athkars,
          fontSize: _fontSize,
          removedItems: _removedItems,
          isMorning: _isMorning,
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
