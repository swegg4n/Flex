import 'package:flex/flex_helper.dart';
import 'package:flex/shared/date_time.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late SharedPreferences _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const int keepFlexRotation = 20;
  static const String _flexTimesKey = 'flexTimesKey';

  static List<String> getFlexTimes() {
    return _prefs.getStringList(_flexTimesKey) ?? List.filled(keepFlexRotation, '');
  }

  static Future appendFlexTime(String value) async {
    int idx = getFlexIndex();
    List<String> flexTimes = getFlexTimes();

    bool newDay = true;

    if (flexTimes[idx] == '' || value == '') {
      newDay = false;
    } else {
      DateTime storedDateTime = FlexSerializer.deserialize(flexTimes[idx]).$1;
      DateTime newDateTime = DateTime.parse(value.split(';')[0]);

      if (storedDateTime.isSameDate(newDateTime)) {
        newDay = false;
      }
    }

    if (newDay) {
      idx = (idx + 1) % keepFlexRotation;
      setFlexIndex(idx);
    }

    flexTimes[idx] = value;
    await _prefs.setStringList(_flexTimesKey, flexTimes);

    debugPrint('FLEX TIMES:');
    debugPrint(flexTimes.toString());
  }

  static const String _flexIndexKey = 'flexIndexKey';

  static int getFlexIndex() {
    return _prefs.getInt(_flexIndexKey) ?? 0;
  }

  static Future setFlexIndex(int value) async {
    await _prefs.setInt(_flexIndexKey, value);
  }

  static const String _lockedKey = 'lockeKey';

  static bool getLocked() {
    return _prefs.getBool(_lockedKey) ?? false;
  }

  static Future setLocked(bool value) async {
    await _prefs.setBool(_lockedKey, value);
  }

  static const String _lastDayLockedKey = 'lastDayLockedKey';

  static String getLastDayLocked() {
    return _prefs.getString(_lastDayLockedKey) ?? '';
  }

  static Future setLastDayLocked(String value) async {
    await _prefs.setString(_lastDayLockedKey, value);
  }

  static const String _totalFlexTimeKey = 'totalFlexTimeKey';

  static int getTotalFlexTime() {
    return _prefs.getInt(_totalFlexTimeKey) ?? 0;
  }

  static Future setTotalFlexTime(int value) async {
    _prefs.setInt(_totalFlexTimeKey, value);

    debugPrint('total flex time set to: $value');
  }

  static const String _inputStartTimeKey = 'inputStartTimeKey';

  static TimeOfDay getInputStartTime() {
    String value = _prefs.getString(_inputStartTimeKey) ?? '08:00';
    int hour = int.parse(value.split(':')[0]);
    int minute = int.parse(value.split(':')[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  static Future setInputStartTime(TimeOfDay value) async {
    _prefs.setString(_inputStartTimeKey, '${value.hour}:${value.minute}');
  }

  static const String _inputLunchTimeKey = 'inputLunchTimeKey';

  static int getInputLunchTime() {
    return _prefs.getInt(_inputLunchTimeKey) ?? 60;
  }

  static Future setInputLunchTime(int value) async {
    _prefs.setInt(_inputLunchTimeKey, value);
  }

  static const String _inputEndTimeKey = 'inputEndTimeKey';

  static TimeOfDay getInputEndTime() {
    String value = _prefs.getString(_inputEndTimeKey) ?? '17:00';
    int hour = int.parse(value.split(':')[0]);
    int minute = int.parse(value.split(':')[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  static Future setInputEndTime(TimeOfDay value) async {
    _prefs.setString(_inputEndTimeKey, '${value.hour}:${value.minute}');
  }

  static const String _todaysFexKey = 'todaysFlexKey';

  static int getTodaysFlex() {
    return _prefs.getInt(_todaysFexKey) ?? 0;
  }

  static Future setTodaysFlex(int value) async {
    _prefs.setInt(_todaysFexKey, value);
  }
}
