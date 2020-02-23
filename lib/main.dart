import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ppp_conference/screens/root.dart';

void main() => runApp(PPPConference());

class PPPConference extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          canvasColor: Colors.grey[300],
          primaryColor: Color(0xFF017DC3),
          accentColor: Color(0xFF017DC3),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.transparent
          ),
          textTheme: TextTheme(
              title: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[600]),
              display1: TextStyle(fontSize: 28, fontWeight: FontWeight.w400))),
      title: 'PPP Conference App 2020',
      home: RootScreen(
        title: 'Schedule',
      ),
    );
  }
}
