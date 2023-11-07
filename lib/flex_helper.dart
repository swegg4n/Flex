import 'package:flex/input_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlexSerializer {
  static String serialize(TimeOfDay startTime, int lunchTime, TimeOfDay endTime) {
    DateTime now = DateTime.now();
    DateTime startDateTime = DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute, 0, 0, 0);

    String startDateTimeSerialized = DateFormat('yyyy-MM-dd HH:mm:ss').format(startDateTime);
    int jobTime = startTime.minutesDiff(endTime);

    String serialized = '$startDateTimeSerialized;$jobTime;$lunchTime';
    return serialized;
  }

  static (DateTime, int, int) deserialize(String flexString) {
    List<String> values = flexString.split(';');

    DateTime startDateTime = DateTime.parse(values[0]);

    int jobTime = int.parse(values[1]);
    int lunchTime = int.parse(values[2]);

    return (startDateTime, jobTime, lunchTime);
  }
}
