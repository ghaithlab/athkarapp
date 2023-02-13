import 'dart:io';
import 'dart:ui';

import 'package:athkarapp/Widgets/alertWidget.dart';
import 'package:athkarapp/habitStatsPage.dart';
import 'package:athkarapp/main.dart';
import 'package:athkarapp/models/habitsModel.dart';
import 'package:athkarapp/notificaiton_scheduler.dart';
import 'package:athkarapp/statsPage.dart';
import 'package:flutter/services.dart';

//import '../selectableButton.dart';
import 'athkar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'athkarListView.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AthkarPage extends StatefulWidget {
  final HabitRecord habit;
  final bool isMorningAthkar;
  AthkarPage({super.key, required this.habit, required this.isMorningAthkar});
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

  Future getPrayerTimes() async {
    //var scheduleNotif;

    var scheduleNotif = _prefs.getBool('scheduleNotif');
    print("scheduleNotif settings is $scheduleNotif");
    if (Platform.isAndroid || Platform.isIOS) {
      //TODO: Remove when adding scheduing in IOS
      if (scheduleNotif == null) {
        // first time app open
        if (await AlertWidget.showMessage(
            "يحتاج التطبيق إلى معرفة الموقع لحساب أوقات الصلاة ليقوم بإظهار إشعارات تذكير بالأذكار بأوقاتها المستحبة وهي بين صلاة الفجر وطلوع الشمس لأذكار الصباح و بين صلاة العصر وغروب الشمس لأذكار المساء، هل تريد جدولة الإشعارات؟",
            "إذن استخدام الموقع",
            false,
            context,
            "استخدام الموقع",
            "تخطي")) {
          //ok button clicked
          PrayerTimeNotificationScheduler p = PrayerTimeNotificationScheduler();
          try {
            await p.scheduleNotifications();
            setState(() {
              _prefs.setBool('scheduleNotif', true);
            });
          } catch (e) {
            setState(() {
              _prefs.setBool('scheduleNotif', false);
            });
            AlertWidget.showMessage(
                e.toString(), "خطأ", true, context, "إغلاق", "");
          }
        } else {
          //no button clicked
          _prefs.setBool('scheduleNotif', false);
        }
      } else if (scheduleNotif == true) {
        PrayerTimeNotificationScheduler p = PrayerTimeNotificationScheduler();
        //lets not notify if it failed since it will try again later in another open
        await p.scheduleNotifications().onError((error, stackTrace) {
          // _showMessage(error.toString(), "خطأ", true);
        });
      }
    }
  }

  Future getPrayerTimesByButton() async {
    //var scheduleNotif;

    //var scheduleNotif = _prefs.getBool('scheduleNotif');
    if (Platform.isAndroid || Platform.isIOS) {
      //TODO: Remove when adding scheduing in IOS

      // first time app open
      if (await AlertWidget.showMessage(
          "يحتاج التطبيق إلى معرفة الموقع لحساب أوقات الصلاة ليقوم بإظهار إشعارات تذكير بالأذكار بأوقاتها المستحبة وهي بين صلاة الفجر وطلوع الشمس لأذكار الصباح و بين صلاة العصر وغروب الشمس لأذكار المساء، هل تريد جدولة الإشعارات؟",
          "إذن استخدام الموقع",
          false,
          context,
          "استخدام الموقع",
          "تخطي")) {
        //ok button clicked
        PrayerTimeNotificationScheduler p = PrayerTimeNotificationScheduler();
        // p.scheduleNotifications().onError((error, stackTrace) =>
        //     AlertWidget.showMessage(
        //         error.toString(), "خطأ", true, context, "إغلاق", ""));
        // _prefs.setBool('scheduleNotif', true);
        try {
          await p.scheduleNotifications();

          _prefs.setBool('scheduleNotif', true);
        } catch (e) {
          _prefs.setBool('scheduleNotif', false);

          AlertWidget.showMessage(
              e.toString(), "خطأ", true, context, "إغلاق", "");
        }
      } else {
        //no button clicked

        _prefs.setBool('scheduleNotif', false);
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    // If the current time is between 6:00 AM and 12:00 PM, set _isMorning to true
    // if (now.hour >= 6 && now.hour < 12) {
    //   _isMorning = true;
    // }
    // // If the current time is between 12:00 PM and 6:00 AM, set _isMorning to false
    // else if (now.hour >= 12 || now.hour < 6) {
    //   _isMorning = false;
    // }
    _isMorning = widget.isMorningAthkar;
    buildAthkarList();
    _fontSize = 20;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        _fontSize = _prefs.getDouble('fontSize') ?? 20;
        getPrayerTimes();
      });
    });
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      //padding: EdgeInsets.all(0),
      //enabled: false,
      value: position,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              iconData,
            ),
            SizedBox(
              width: 12,
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isMorning ? "أذكار الصباح" : "أذكار المساء",
            // textAlign: TextAlign.center,
            //  style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(right: 8),
                //   child: TextButton(
                //     style: ButtonStyle(
                //       textStyle: MaterialStateProperty.all(const TextStyle(
                //           fontSize: 20, fontWeight: FontWeight.w800)),

                //       // foregroundColor:
                //       //     MaterialStateProperty.all(Colors.white),
                //     ),
                //     onPressed: (() {
                //       setState(() {
                //         _isMorning = !_isMorning;
                //         buildAthkarList();
                //       });
                //     }),
                //     child: Text(
                //       _isMorning ? 'أذكار الصباح' : "أذكار المساء",
                //       style: TextStyle(fontSize: 18),
                //     ),
                //   ),
                // ),
                Row(
                  children: [
                    // Add the refresh button to the app bar
                    // IconButton(
                    //   icon: const Icon(Icons.refresh),
                    //   onPressed: () {
                    //     setState(() {
                    //       buildAthkarList();
                    //       //TODO: to remove
                    //       //_prefs.clear();
                    //     });
                    //   },
                    //   tooltip: 'اعادة الاذكار',
                    // ),
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
                          return HabitStatsPage(habit: widget.habit);
                        }));
                      },
                      tooltip: 'تبديل السمة',
                    ),
                    // IconButton(
                    //   icon: const Icon(Icons.stacked_line_chart),
                    //   onPressed: () {
                    //     Navigator.push(context,
                    //         MaterialPageRoute(builder: (context) {
                    //       return StatsPage();
                    //     }));
                    //   },
                    //   tooltip: 'تبديل السمة',
                    // ),

                    // IconButton(
                    //   icon: const Icon(Icons.brightness_6),
                    //   onPressed: () async {
                    //     await NotificationsApi.schedule(
                    //       title: "title",
                    //       body: "from",
                    //       payload: "payload",
                    //       time: tz.TZDateTime.now(tz.local)
                    //           .add(const Duration(seconds: 5)),
                    //     );
                    //   },
                    //   tooltip: 'تبديل السمة',
                    // ),
                    // Add the font size increase button to the app bar

                    // TextButton(
                    //     onPressed: () {
                    //       setState(() {
                    //         _fontSize++;
                    //         _prefs.setDouble('fontSize', _fontSize);
                    //       });
                    //     },
                    //     child: const Text(
                    //       "ض",
                    //       style: TextStyle(
                    //         //color: Colors.white,
                    //         fontWeight: FontWeight.w800,
                    //         fontSize: 24,
                    //       ),
                    //     )),
                    // TextButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       _fontSize--;
                    //       _prefs.setDouble('fontSize', _fontSize);
                    //     });
                    //   },
                    //   child: const Text(
                    //     "ض",
                    //     style: TextStyle(
                    //       //color: Colors.white,
                    //       fontWeight: FontWeight.w800,
                    //       fontSize: 16,
                    //     ),
                    //   ),
                    // ),
                    PopupMenuButton(
                      //padding: EdgeInsets.all(0),
                      offset: const Offset(0, 12),
                      position: PopupMenuPosition.under,
                      onSelected: (value) {
                        //_onMenuItemSelected(value as int);
                        switch (value) {
                          case 0:
                            {
                              setState(() {
                                buildAthkarList();
                              });
                            }
                            break;
                          case 1:
                            MyApp.of(context)!.changeTheme();
                            break;
                          case 2:
                            getPrayerTimesByButton();
                            break;
                          case 3:
                            _prefs.setBool('scheduleNotif', false);
                            break;

                          default:
                        }
                      },
                      // IconButton(
                      //   icon: const Icon(Icons.brightness_6),
                      //   onPressed: () {
                      //     MyApp.of(context)!.changeTheme();
                      //   },
                      //   tooltip: 'تبديل السمة',
                      // ),
                      itemBuilder: (ctx) => [
                        _buildPopupMenuItem('إبدأ من جديد', Icons.refresh, 0),
                        // _buildPopupMenuItem(
                        //     'تبديل السمة', Icons.brightness_6, 1),
                        getNotifcationButton(),
                        //_buildPopupMenuItem('Exit', Icons.exit_to_app, 3),

                        PopupItem(
                            onTapHandler: () {},
                            dismissOnTap: false,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: decreaseFont,
                                    child: const Text("ض",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        )),
                                    // icon: Icon(Icons.favorite),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: setDafeultFontsize,
                                    child: const Text(
                                      "100%",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                    // icon: Icon(Icons.favorite),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: increaseFont,
                                    child: const Text(
                                      "ض",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 24,
                                      ),
                                    ),
                                    // icon: Icon(Icons.favorite),
                                  ),
                                ),
                              ],
                            )),
                        // PopupItem(
                        //   dismissOnTap: false,
                        //   onTapHandler: decreaseFont,
                        //   child: Container(
                        //     width: double.infinity,
                        //     child: ElevatedButton.icon(
                        //       // style: ButtonStyle(backgroundColor: Colors.black),
                        //       onPressed: () {
                        //         print("You pressed Icon Elevated Button");
                        //       },
                        //       icon: Icon(
                        //           Icons.save), //icon data for elevated button
                        //       label: Text("Elevated"), //label text
                        //     ),
                        //   ),
                        // )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
        body: AthkarList(
          athkars: athkars,
          fontSize: _fontSize,
          removedItems: _removedItems,
          isMorning: _isMorning,
          habit: widget.habit,
        ),
      ),
    );
  }

  PopupMenuItem<dynamic> getNotifcationButton() {
    bool? schedule = _prefs.getBool('scheduleNotif');
    if (schedule == false) {
      return _buildPopupMenuItem('تفعيل الاشعارات', Icons.notifications, 2);
    } else
      return _buildPopupMenuItem('تعطيل الاشعارات', Icons.notifications_off, 3);
  }

  void decreaseFont() {
    setState(() {
      _fontSize--;
      _prefs.setDouble('fontSize', _fontSize);
    });
  }

  void increaseFont() {
    setState(() {
      _fontSize++;
      _prefs.setDouble('fontSize', _fontSize);
    });
  }

  void setDafeultFontsize() {
    setState(() {
      _fontSize = 20;
      _prefs.setDouble('fontSize', _fontSize);
    });
  }

  void buildAthkarList() {
    athkars.clear();
    _removedItems.clear();
    List paragraphs = _isMorning ? paragraphsMorning : paragraphsEvening;
    for (int i = 0; i < paragraphs.length; i++) {
      String p = "${paragraphs[i]['paragraph']}";
      int count = paragraphs[i]['Counter'];
      athkars.add(Athkar(paragraph: p, counter: count, thikirCount: count));
    }
  }
}

class PopupItem extends PopupMenuItem {
  final Function() onTapHandler;
  final bool dismissOnTap;
  const PopupItem(
      {required Widget child,
      required this.onTapHandler,
      required this.dismissOnTap})
      : super(child: child, padding: const EdgeInsets.all(0));

  @override
  _PopupItemState createState() => _PopupItemState();
}

class _PopupItemState extends PopupMenuItemState {
  @override
  void handleTap() {
    var parent =
        widget as PopupItem; // IDK how to not do this, just learning now
    parent.onTapHandler();
    if (parent.dismissOnTap) Navigator.pop(context, widget.value);
  }
}
