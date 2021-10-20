import 'package:flutter/material.dart';
import 'package:myevpanet/helpers/firebase_helper.dart';
import 'package:myevpanet/splash_screen/splash_widget.dart';

int verbose = 0;
List guids = [];
//List pushes = [];
List<String> sharedPushes = [];
String devKey;
int currentGuidIndex = 0;
Map userInfo;
//bool useNewApiVersion = true;
var users = Map();
//FirebaseHelper fbHelper;
int messageForId = 0;
Map<String, dynamic> lastMessage;
bool lastMessageIsSeen = false;
//GlobalKey refreshKey;
String registrationMode = 'new';
final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: 'Main Navigator');

void main() {
  runApp(App());
  FirebaseHelper fbHelper = FirebaseHelper();
  //print(fbHelper);
}

//
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColorDark: Color(0xFF1976d2),
        primaryColor: Color(0xFF2196f3),
        accentColor: Color(0xFFff5722),
        //colorScheme: ColorScheme(secondary: Color(0xFFff5722)),
        primaryColorLight: Color(0xFFbbdefb),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashWidget(),
    );
  }
}
