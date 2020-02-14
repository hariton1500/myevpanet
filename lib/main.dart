
import 'package:flutter/material.dart';
import 'package:myevpanet/helpers/firebase_helper.dart';
//import 'package:myevpanet/api/api.dart';
import 'package:myevpanet/splash_screen/splash_widget.dart';
//тест репозитория
int verbose = 0;
List guids;
String devKey;
int currentGuidIndex = 0;
Map userInfo;
var users = Map();
FirebaseHelper fbHelper;
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
        ),
      debugShowCheckedModeBanner: false,
        home: SplashWidget(),
    );
  }
}
