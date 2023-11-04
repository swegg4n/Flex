import 'package:flutter/material.dart';
import 'package:flex/theme.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: Scaffold(
        appBar: AppBar(),
        body: Container(
          margin: const EdgeInsets.only(left: 7, right: 7, top: 15, bottom: 100),
          child: Placeholder(),
        ),
      ),
    );
  }
}
