import 'package:athkarapp/Widgets/numberCounter.dart';
import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({
    Key? key,
    required this.mp,
  }) : super(key: key);

  final Map mp;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                NumberCounter(
                  startValue: 0,
                  endValue: mp['daysCount'],
                  txtStyle: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontSize: 24),
                ),
                // Text("${mp['daysCount']}",
                //     style: Theme.of(context)
                //         .textTheme
                //         .labelLarge!
                //         .copyWith(fontSize: 24)),
                Text("الأيام",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 16))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                // Text("${mp['consistency']}%",
                //     style: Theme.of(context)
                //         .textTheme
                //         .labelLarge!
                //         .copyWith(fontSize: 24)),
                Row(
                  children: [
                    Text("%",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 24)),
                    NumberCounter(
                        startValue: 0,
                        endValue: mp['consistency'],
                        txtStyle: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 24)),
                  ],
                ),
                Text("الثبات",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 16))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    NumberCounter(
                        startValue: 0,
                        endValue: mp['streak'],
                        txtStyle: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 24)),
                    // Text("${mp['streak']}",
                    //     style: Theme.of(context)
                    //         .textTheme
                    //         .labelLarge!
                    //         .copyWith(fontSize: 24)),
                    SizedBox(
                      width: 3,
                    ),
                    Text("يوم",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 12))
                  ],
                ),
                Text("المداومة",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 16))
              ],
            ),
          )
        ],
      ),
    );
  }
}
