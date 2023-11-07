import 'package:flex/app_preferences.dart';
import 'package:flex/shared/button.dart';
import 'package:flex/shared/time_picker.dart';
import 'package:flex/total_flex_time.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 65, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TotalFlexTime(key: GlobalKey()),
          const Spacer(),
          Button(
            text: 'override total flex',
            fontSize: 20,
            color: Colors.grey[800],
            paddingHorizontal: 15,
            paddingVertical: 18,
            onPressed: () async {
              int totalFlexTime = AppPreferences.getTotalFlexTime();

              int initialHour = totalFlexTime.abs() ~/ 60;
              int initialMinute = totalFlexTime.abs() % 60;
              if (totalFlexTime < 0) {
                initialHour += 12;
              }

              TimeOfDay? selectedTime = await openTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
                  initialEntryMode: TimePickerEntryMode.inputOnly,
                  use24HourFormat: false);

              if (selectedTime != null) {
                int selectedMinutes = selectedTime.hour * 60 + selectedTime.minute;

                // if "pm" was selected
                if (selectedMinutes > 12 * 60) {
                  selectedMinutes = -(selectedMinutes - 12 * 60);
                }

                setState(() {
                  AppPreferences.setTotalFlexTime(selectedMinutes);
                });
              }
            },
          ),
          const Spacer(flex: 2),
          Container(width: double.infinity),
        ],
      ),
    );
  }
}
