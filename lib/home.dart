import 'package:flex/theme.dart';
import 'package:flutter/material.dart';
import 'package:flex/settings_screen.dart';
import 'package:flex/input_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'graph_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  int selectedIndex = 1;

  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final screens = [
    SettingsScreen(),
    InputScreen(),
    GraphScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      darkTheme: appTheme,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: screens[widget.selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: widget.selectedIndex,
          onTap: (int idx) {
            setState(() {
              widget.selectedIndex = idx;
            });
          },
          items: const [
            BottomNavigationBarItem(
              activeIcon: Icon(
                FontAwesomeIcons.gear,
                color: Color(0xffeeeeee),
              ),
              icon: Icon(
                FontAwesomeIcons.gear,
                color: Color(0xff757575),
              ),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                FontAwesomeIcons.stopwatch,
                color: Color(0xffeeeeee),
              ),
              icon: Icon(
                FontAwesomeIcons.stopwatch,
                color: Color(0xff757575),
              ),
              label: 'Input',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                FontAwesomeIcons.chartBar,
                color: Color(0xffeeeeee),
              ),
              icon: Icon(
                FontAwesomeIcons.chartBar,
                color: Color(0xff757575),
              ),
              label: 'Graph',
            ),
          ],
        ),
      ),
    );
  }
}
