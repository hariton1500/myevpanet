import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myevpanet/main.dart';
import 'dart:async';
import 'dart:io';
import 'package:myevpanet/api/api.dart';
import 'package:myevpanet/main_screen/main_widget.dart';
import 'package:myevpanet/login_screen/login_widget.dart';

class SplashWidget extends StatefulWidget {
  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {

  @override
  initState() {
    print('SplashScreen initState');
    super.initState();
    Future<int> goto = whereToGo();
    Timer(Duration(seconds: 5), (){goGo(goto);});
  }
  Future<void> goGo(Future<int> index) async {
    if (await index == 1) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MainScreenWidget()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginWidget()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                              child: Image.asset("assets/images/splash_logo.png"),
                          )
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SpinKitThreeBounce(
                      color: Colors.white,
                      size: 50.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Загрузка...",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  int getRandom() {
    Random rnd = new Random();
    int c7 = rnd.nextInt(10);
    int c6 = rnd.nextInt(10);
    int c5 = rnd.nextInt(10);
    int c4 = rnd.nextInt(10);
    int c3 = rnd.nextInt(10);
    int c2 = rnd.nextInt(10);
    int c1 = rnd.nextInt(9) + 1;
    int content = c1 * 1000000 + c2 * 100000 + c3 * 10000 + c4 * 1000;
    content += c5 * 100 + c6 * 10 + c7;
    return content;
  }

  Future<int> whereToGo() async {
    final file = await FileStorage('key.dat').localFile;
    if (file.existsSync()) {
      print('Key file is exists');
      devKey = file.readAsStringSync(encoding: utf8);
      if (devKey.toString().length == 7) {
        print('Device key is: $devKey');
        //guidlist.dat file check
        final _guidsfile = await FileStorage('guidlist.dat').localFile;
        if (_guidsfile.existsSync()) {
          print('GUIDs file exists');
          var _readResult = _guidsfile.readAsStringSync(encoding: utf8);
          final parsed = json.decode(_readResult);
          print(parsed);
          guids = parsed;
          print('List of GUIDS readed. Updating UserInfo from Server');
          currentGuidIndex = 0;
          for (var guid in guids) {
            print('Updating from Server for guid $guid');
            var result = await UserInfo().getUserInfoFromServer();
            if (result) {
              print('Ok');
            } else {
              print('Not ok!');
              print('Trying to read from file instead');
              await UserInfo().readFromFile();
            }
            currentGuidIndex++;
          }
          currentGuidIndex = 0;
          return 1;//Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MainScreenWidget()));
        } else {
          print('GUIDS file not exists. Got to Login Screen');
          return 0;//Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginWidget()));
        }
      } else {
        print('Key File has wrong key. Creating new one...');
        file.writeAsStringSync(getRandom().toString(), mode: FileMode.write, encoding: utf8);
        print('New Key File created and saved');
        print('Go to Login Screen');
        return 0;//Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginWidget()));
      }
    } else {
      print('Key file is not exists');
      devKey = getRandom().toString();
      print('New Key is: $devKey');
      file.writeAsStringSync(devKey, mode: FileMode.write, encoding: utf8);
      print('Key File created and saved');
      print('Go to Login Screen');
      return 0;//Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginWidget()));
    }
  }
}