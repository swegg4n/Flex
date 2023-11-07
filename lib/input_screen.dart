import 'package:flex/app_preferences.dart';
import 'package:flex/flex_helper.dart';
import 'package:flex/shared/button.dart';
import 'package:flex/shared/date_time.dart';
import 'package:flex/shared/time_picker.dart';
import 'package:flex/total_flex_time.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class InputScreen extends StatefulWidget {
  late TimeOfDay _startTime;
  late int _lunchTime;
  late TimeOfDay _endTime;
  late bool _flexLocked;
  late int _todaysFlex;

  InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  @override
  initState() {
    super.initState();

    String lastDayLocked = AppPreferences.getLastDayLocked();
    bool locked = AppPreferences.getLocked();

    widget._flexLocked = false;
    widget._todaysFlex = 0;

    if (lastDayLocked != '') {
      DateTime lastDateTimeLocked = DateTime.parse(lastDayLocked);

      if (lastDateTimeLocked.isSameDate(DateTime.now()) && locked) {
        widget._flexLocked = true;
        widget._todaysFlex = AppPreferences.getTodaysFlex();
      }
    }

    String lastFlex = AppPreferences.getFlexTimes()[AppPreferences.getFlexIndex()];
    if (widget._flexLocked && lastFlex != '') {
      DateTime dateTime;
      int jobTime;
      int lunchTime;

      (dateTime, jobTime, lunchTime) = FlexSerializer.deserialize(lastFlex);

      widget._startTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
      widget._lunchTime = lunchTime;
      widget._endTime = widget._startTime.add(minutes: jobTime);
    } else {
      widget._startTime = AppPreferences.getInputStartTime();
      widget._lunchTime = AppPreferences.getInputLunchTime();
      widget._endTime = AppPreferences.getInputEndTime();
    }
  }

  TimeOfDay get startTime {
    return widget._startTime;
  }

  set startTime(TimeOfDay value) {
    AppPreferences.setInputStartTime(value);
    setState(() {
      widget._startTime = value;
    });
  }

  int get lunchTime {
    return widget._lunchTime;
  }

  set lunchTime(int value) {
    AppPreferences.setInputLunchTime(value);
    setState(() {
      widget._lunchTime = value;
    });
  }

  TimeOfDay get endTime {
    return widget._endTime;
  }

  set endTime(TimeOfDay value) {
    AppPreferences.setInputEndTime(value);
    setState(() {
      widget._endTime = value;
    });
  }

  bool get flexLocked {
    return widget._flexLocked;
  }

  set flexLocked(bool value) {
    setState(() {
      widget._flexLocked = value;
    });
  }

  int get todaysFlex {
    return widget._todaysFlex;
  }

  set todaysFlex(int value) {
    setState(() {
      widget._todaysFlex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 65, bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TotalFlexTime(key: GlobalKey()),
          const Spacer(),
          Text(DateFormat("d MMMM, yyyy").format(DateTime.now()), style: TextStyle(fontSize: 16, color: Colors.grey[400])),
          const Spacer(flex: 2),
          InputGroup(
            label: 'Start time',
            mainText: '${startTime.hour.toString().padLeft(2, '0')} : ${startTime.minute.toString().padLeft(2, '0')}',
            onPressedMain: () async {
              TimeOfDay? selectedTime = await openTimePicker(
                context: context,
                initialTime: startTime,
              );

              if (selectedTime != null) {
                startTime = selectedTime;
                endTime = calculateEndTime(startTime, lunchTime);
              }
            },
            onPressedMinus: () {
              startTime = startTime.subtract(minutes: 15);
              endTime = calculateEndTime(startTime, lunchTime);
            },
            onPressedPlus: () {
              startTime = startTime.add(minutes: 15);
              endTime = calculateEndTime(startTime, lunchTime);
            },
            disabled: flexLocked,
          ),
          const Spacer(),
          InputGroup(
            label: 'Lunch      ',
            mainText: '$lunchTime min',
            onPressedMain: () async {
              TimeOfDay? selectedTime = await openTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: lunchTime ~/ 60, minute: lunchTime % 60),
                  initialEntryMode: TimePickerEntryMode.inputOnly);

              if (selectedTime != null) {
                lunchTime = selectedTime.hour * 60 + selectedTime.minute;
                endTime = calculateEndTime(startTime, lunchTime);
              }
            },
            onPressedMinus: () {
              if (lunchTime >= 15) {
                lunchTime -= 15;
                endTime = calculateEndTime(startTime, lunchTime);
              }
            },
            onPressedPlus: () {
              lunchTime += 15;
              endTime = calculateEndTime(startTime, lunchTime);
            },
            disabled: flexLocked,
          ),
          const Spacer(),
          InputGroup(
            label: 'End time  ',
            mainText: '${endTime.hour.toString().padLeft(2, '0')} : ${endTime.minute.toString().padLeft(2, '0')}',
            onPressedMain: () async {
              TimeOfDay? selectedTime = await openTimePicker(
                context: context,
                initialTime: endTime,
              );

              if (selectedTime != null) {
                endTime = selectedTime;
              }
            },
            onPressedMinus: () {
              endTime = endTime.subtract(minutes: 15);
            },
            onPressedPlus: () {
              endTime = endTime.add(minutes: 15);
            },
            disabled: flexLocked,
          ),
          const Spacer(flex: 2),
          Visibility(
            visible: flexLocked,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Today\'s flex:', style: TextStyle(fontSize: 18, color: Colors.grey[200])),
                const Padding(padding: EdgeInsets.only(right: 7)),
                Text(
                  '${todaysFlex > 0 ? "+" : todaysFlex < 0 ? "-" : ""}${todaysFlex.abs() >= 60 ? "${todaysFlex.abs() ~/ 60}h " : ""}${todaysFlex.abs() % 60} min.',
                  style: TextStyle(fontSize: 20, color: Colors.grey[200]),
                ),
                const Padding(padding: EdgeInsets.only(right: 5)),
                if (todaysFlex > 0) Icon(FontAwesomeIcons.caretUp, color: Colors.green[400]),
                if (todaysFlex < 0) Icon(FontAwesomeIcons.caretDown, color: Colors.red[400]),
              ],
            ),
          ),
          const Spacer(flex: 1),
          SizedBox(
            width: 190,
            child: ButtonIcon(
              icon: flexLocked ? FontAwesomeIcons.lock : FontAwesomeIcons.lockOpen,
              text: flexLocked ? 'unlock flex' : 'lock flex',
              paddingHorizontal: 0,
              paddingVertical: 16,
              iconSize: 20,
              fontSize: 20,
              onPressed: () {
                flexLocked = !flexLocked;
                AppPreferences.setLocked(flexLocked);

                if (flexLocked) {
                  todaysFlex = calculateTodaysFlex(startTime, lunchTime, endTime);

                  String serialized = FlexSerializer.serialize(startTime, lunchTime, endTime);
                  AppPreferences.appendFlexTime(serialized);
                  AppPreferences.setLastDayLocked(DateFormat("yyyy-MM-dd").format(DateTime.now()));

                  AppPreferences.setTotalFlexTime(AppPreferences.getTotalFlexTime() + todaysFlex);
                } else {
                  AppPreferences.setTotalFlexTime(AppPreferences.getTotalFlexTime() - todaysFlex);
                  todaysFlex = 0;

                  String serialized = '';
                  AppPreferences.appendFlexTime(serialized);
                  AppPreferences.setLastDayLocked('');
                }
                AppPreferences.setTodaysFlex(todaysFlex);
              },
              color: Colors.grey[800],
            ),
          ),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}

TimeOfDay calculateEndTime(TimeOfDay startTime, int lunchTime) {
  TimeOfDay time = TimeOfDay(hour: startTime.hour, minute: startTime.minute);
  return time.add(hours: 8, minutes: lunchTime);
}

int calculateTodaysFlex(TimeOfDay startTime, int lunchTime, TimeOfDay endTime) {
  int jobTime = startTime.minutesDiff(endTime) - lunchTime;
  // assume user should work 8 hours per day
  return jobTime - 8 * 60;
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add({int hours = 0, int minutes = 0}) {
    DateTime dateTime = DateTime(2000, 0, 0, hour, minute);
    dateTime = dateTime.add(Duration(hours: hours, minutes: minutes));
    return replacing(hour: dateTime.hour, minute: dateTime.minute);
  }

  TimeOfDay subtract({int hours = 0, int minutes = 0}) {
    DateTime dateTime = DateTime(2000, 0, 0, hour, minute);
    dateTime = dateTime.subtract(Duration(hours: hours, minutes: minutes));
    return replacing(hour: dateTime.hour, minute: dateTime.minute);
  }

  int minutesDiff(TimeOfDay other) {
    DateTime startTime = DateTime(2000, 0, 0, hour, minute);
    DateTime endTime = DateTime(2000, 0, 0, other.hour, other.minute);
    return startTime.difference(endTime).inMinutes.abs();
  }
}

class InputGroup extends StatelessWidget {
  final String label;
  final String mainText;
  final Function? onPressedMain;
  final Function? onPressedMinus;
  final Function? onPressedPlus;
  final bool disabled;

  const InputGroup({
    super.key,
    required this.label,
    required this.mainText,
    required this.onPressedMain,
    required this.onPressedMinus,
    required this.onPressedPlus,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Text(label, style: TextStyle(fontSize: 18, color: disabled ? Colors.grey[600] : Colors.grey[200])),
        const Spacer(flex: 4),
        SizedBox(
          width: 55,
          height: 40,
          child: ButtonIcon(
              icon: FontAwesomeIcons.minus,
              paddingHorizontal: 0,
              paddingVertical: 0,
              iconSize: 16,
              iconColor: disabled ? Colors.grey[600] : Colors.grey[200],
              color: Colors.grey[800],
              onPressed: disabled ? null : onPressedMinus),
        ),
        const Padding(padding: EdgeInsets.only(right: 5)),
        SizedBox(
          width: 110,
          height: 50,
          child: Button(
            text: mainText,
            fontSize: 20,
            paddingHorizontal: 5,
            paddingVertical: 7.5,
            color: Colors.grey[800],
            textColor: disabled ? Colors.grey[600] : Colors.grey[200],
            onPressed: disabled ? null : onPressedMain,
          ),
        ),
        const Padding(padding: EdgeInsets.only(right: 5)),
        SizedBox(
          width: 55,
          height: 40,
          child: ButtonIcon(
            icon: FontAwesomeIcons.plus,
            paddingHorizontal: 0,
            paddingVertical: 0,
            iconSize: 18,
            iconColor: disabled ? Colors.grey[600] : Colors.grey[200],
            color: Colors.grey[800],
            onPressed: disabled ? null : onPressedPlus,
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
