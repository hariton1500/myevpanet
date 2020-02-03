
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
        home: SplashWidget(),
    );
  }
}
