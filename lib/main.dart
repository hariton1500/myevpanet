
import 'package:flutter/material.dart';
//import 'package:myevpanet/api/api.dart';
import 'package:myevpanet/splash_screen/splash_widget.dart';
//тест репозитория
List guids;
String devKey;
int currentGuidIndex = 0;
Map userInfo;
var users = Map();

void main() {
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData (
        primaryColorDark: Color(0xFF1976d2),
        primaryColor: Color(0xFF2196f3),
        accentColor: Color(0xFFff5722),
        primaryColorLight: Color(0xFFbbdefb),
        textTheme: TextTheme(
          body1: TextStyle(color: Color(0xFF212121)),
          title: TextStyle(color: Color(0xFF212121)),
          headline: TextStyle(color: Color(0xFF212121)),
          body2: TextStyle(color: Color(0xFF757575)),
          subtitle: TextStyle(color: Color(0xFF757575)),
          subhead: TextStyle(color: Color(0xFF000000)),
        ),
      ),
      debugShowCheckedModeBanner: false,
        home: SplashWidget(),
    );
  }
}
