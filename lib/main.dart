import 'package:flex/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flex/app_preferences.dart';

void main() async {
  runApp(const MainApp());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppPreferences.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AnnotatedRegion(
            value: const SystemUiOverlayStyle(
              systemNavigationBarColor: Color(0xff303030),
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarDividerColor: Color(0xff303030),
            ),
            child: HomeScreen(),
          );
        } else {
          return Container(color: Colors.grey[850]);
        }
      },
    );
  }
}
