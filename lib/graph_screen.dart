import 'package:flex/app_preferences.dart';
import 'package:flex/flex_helper.dart';
import 'package:flex/total_flex_time.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const int minTime = 360;
const int maxTime = 1200;
const TimeOfDay lunchStart = TimeOfDay(hour: 12, minute: 30);

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 65, bottom: 15),
      child: LayoutBuilder(builder: (context, constraints) {
        DateTime minDateTime = DateTime(2000, 1, 1, minTime ~/ 60, minTime % 60);
        DateTime maxDateTime = DateTime(2000, 1, 1, maxTime ~/ 60, maxTime % 60);
        DateTime centerTime = DateTime(2000, 1, 1, (maxDateTime.hour - minDateTime.hour) ~/ 2 + minDateTime.hour,
            (maxDateTime.minute - minDateTime.minute) ~/ 2 + minDateTime.minute);

        List<Box> boxes = [];
        int numBoxes = AppPreferences.keepFlexRotation;

        int idx = (AppPreferences.getFlexIndex() + 1) % numBoxes;

        List<String> savedFlexTimes = AppPreferences.getFlexTimes();
        debugPrint(savedFlexTimes.toString());
        for (var i = 0; i < numBoxes; i++, idx = (idx + 1) % numBoxes) {
          DateTime startDateTime;
          int jobTime;
          int lunchTime;

          if (savedFlexTimes[idx] != '') {
            (startDateTime, jobTime, lunchTime) = FlexSerializer.deserialize(savedFlexTimes[idx]);

            Box box = Box(startDateTime: startDateTime, jobTime: jobTime, lunchTime: lunchTime, screenWidth: constraints.maxWidth);
            boxes.add(box);
          }
        }

        return Column(
          children: [
            const TotalFlexTime(),
            const Padding(padding: EdgeInsets.only(bottom: 25)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat("HH:mm").format(minDateTime), style: TextStyle(fontSize: 16, color: Colors.grey[400])),
                Text(DateFormat("HH:mm").format(centerTime), style: TextStyle(fontSize: 16, color: Colors.grey[400])),
                Text(DateFormat("HH:mm").format(maxDateTime), style: TextStyle(fontSize: 16, color: Colors.grey[400])),
              ],
            ),
            Stack(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Divider(thickness: 1, height: 15, color: Colors.grey[600]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('|', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                  Text('|', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                  Text('|', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                ],
              ),
            ]),
            const Padding(padding: EdgeInsets.only(bottom: 3)),
            ...boxes,
          ],
        );
      }),
    );
  }
}

class Box extends StatelessWidget {
  final DateTime startDateTime;
  final int jobTime;
  final int lunchTime;
  final double screenWidth;

  const Box({super.key, required this.startDateTime, required this.jobTime, required this.lunchTime, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    int timeFromStart = startDateTime.hour * 60 + startDateTime.minute - minTime;

    double timeFromStartScreenSpace = timeSpaceToScreenSpace(timeFromStart, screenWidth);
    timeFromStartScreenSpace *= 1440 / (maxTime - minTime);

    double jobTimeScreenSpace = timeSpaceToScreenSpace(jobTime, screenWidth);
    jobTimeScreenSpace *= 1440 / (maxTime - minTime);

    if (timeFromStartScreenSpace < 0) jobTimeScreenSpace += timeFromStartScreenSpace;
    if (timeFromStartScreenSpace >= screenWidth) jobTimeScreenSpace = 0;

    timeFromStartScreenSpace = clampDouble(timeFromStartScreenSpace, 0, screenWidth);
    jobTimeScreenSpace = clampDouble(jobTimeScreenSpace, 0, screenWidth - timeFromStartScreenSpace);

    int lunchFromStart = lunchStart.hour * 60 + lunchStart.minute - minTime;
    double lunchFromStartScreenSpace = timeSpaceToScreenSpace(lunchFromStart, screenWidth);
    lunchFromStartScreenSpace *= 1440 / (maxTime - minTime);

    double lunchTimeScreenSpace = timeSpaceToScreenSpace(lunchTime, screenWidth);
    lunchTimeScreenSpace *= 1440 / (maxTime - minTime);

    Color boxColor;
    if (jobTime - lunchTime > 8 * 60) {
      boxColor = Colors.green[400]!;
    } else if (jobTime - lunchTime < 8 * 60) {
      boxColor = Colors.red[400]!;
    } else {
      boxColor = Colors.grey[600]!;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Stack(children: [
        Row(
          children: [
            Padding(padding: EdgeInsets.only(left: timeFromStartScreenSpace)),
            Container(
              width: jobTimeScreenSpace,
              height: 20,
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(padding: EdgeInsets.only(left: lunchFromStartScreenSpace)),
            Container(
              width: lunchTimeScreenSpace,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[850],
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: boxColor,
                    width: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

double timeSpaceToScreenSpace(int minutes, double screenWidth) {
  double xMin = 0;
  double xMax = 1440;
  double a = 0;
  double b = screenWidth;

  return a + (minutes - xMin) * (b - a) / (xMax - xMin);
}
