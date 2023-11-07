import 'package:flex/app_preferences.dart';
import 'package:flutter/material.dart';

class TotalFlexTime extends StatefulWidget {
  const TotalFlexTime({super.key});

  @override
  State<TotalFlexTime> createState() => _TotalFlexTimeState();
}

class _TotalFlexTimeState extends State<TotalFlexTime> {
  @override
  Widget build(BuildContext context) {
    int totalFlexTime = AppPreferences.getTotalFlexTime();
    bool negative = totalFlexTime < 0;
    bool positive = totalFlexTime > 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      decoration: BoxDecoration(
        border: Border.all(
            color: negative
                ? Colors.red[400]!
                : positive
                    ? Colors.green[400]!
                    : Colors.grey[600]!,
            width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Total flex:', style: TextStyle(fontSize: 18, color: Colors.grey[200])),
          Text(
            ' ${negative ? "-" : positive ? "+" : ""}${totalFlexTime.abs() >= 60 ? "${totalFlexTime.abs() ~/ 60}h " : ""}${totalFlexTime.abs() % 60} min',
            style: TextStyle(fontSize: 18, color: Colors.grey[200]),
          )
        ],
      ),
    );
  }
}
