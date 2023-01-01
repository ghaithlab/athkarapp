import 'package:athkarapp/clicksPerDay.dart';
import "package:flutter/material.dart";

import 'heatMapWidget/data/heatmap_color_mode.dart';
import 'heatMapWidget/heatmap.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  bool isOpacityMode = true;
  Map<DateTime, int> heatMapDatasets = {
    DateTime(2022, 5, 6): 3,
    DateTime(2022, 5, 7): 7,
    DateTime(2022, 6, 8): 10,
    DateTime(2022, 7, 9): 13,
    DateTime(2022, 12, 13): 6,
  };
  ClicksPerDay clicksPerDay = ClicksPerDay();
  @override
  void initState() {
    clicksPerDay = ClicksPerDay();
    super.initState();
    function();
  }

  void function() async {
    await clicksPerDay.init();
    setState(() {});
  }

  void printer() {
    clicksPerDay.splitClicksOfDays();
    print(clicksPerDay.morningClicksOfDays);
    print(clicksPerDay.afternoonClicksOfDays);
    print(heatMapDatasets);
  }

  void _showMessage() {
    //clicksPerDay.fillMorningEveningDummyData();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('This is a message'),
          actions: <Widget>[
            TextButton(
              child: Text(
                  "afternoon:${clicksPerDay.afternoonClicksOfDays} \n morning:${clicksPerDay.morningClicksOfDays}"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showSnackMessge(String str) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color.fromARGB(255, 45, 45, 45),
        duration: const Duration(milliseconds: 500),
        content: Text(
          str,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        )));
  }

  @override
  Widget build(BuildContext context) {
    //printer();
    //clicksPerDay.fillMorningEveningDummyData();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إحصاءات الأذكار"),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: () {
                _showMessage();
                setState(() {});
              },
              tooltip: 'تبديل السمة',
            ),
          ],
        ),
        body: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              margin: const EdgeInsets.all(20),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "أذكار الصباح",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 12),
                    HeatMap(
                      scrollable: true,
                      showText: false,
                      showColorTip: false,
                      defaultColor: Colors.grey[700],
                      // startDate: DateTime(2022, 12, 1),
                      // endDate: DateTime(2022, 12, 31),
                      colorMode:
                          isOpacityMode ? ColorMode.opacity : ColorMode.color,
                      datasets: clicksPerDay.morningClicksOfDays,
                      colorsets: {
                        1: Colors.red[400]!,
                        3: Colors.orange,
                        5: Colors.yellow,
                        7: Colors.green,
                        9: Colors.blue,
                        11: Colors.indigo,
                        13: Colors.purple,
                      },
                      onClick: (value) {
                        showSnackMessge(
                            "${value.year} - ${value.month} - ${value.day}");
                      },
                    ),
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              margin: const EdgeInsets.all(20),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "أذكار المساء",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 12),
                    HeatMap(
                      scrollable: true,
                      showText: false,
                      showColorTip: false,
                      defaultColor: Colors.grey[700],

                      // startDate: DateTime(2022, 12, 1),
                      // endDate: DateTime(2022, 12, 31),
                      colorMode:
                          isOpacityMode ? ColorMode.opacity : ColorMode.color,
                      datasets: clicksPerDay.afternoonClicksOfDays,
                      colorsets: {
                        1: Colors.yellow[600]!,
                        3: Colors.orange,
                        5: Colors.yellow,
                        7: Colors.green,
                        9: Colors.blue,
                        11: Colors.indigo,
                        13: Colors.purple,
                      },
                      onClick: (value) {
                        showSnackMessge(
                            "${value.year} - ${value.month} - ${value.day}");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
