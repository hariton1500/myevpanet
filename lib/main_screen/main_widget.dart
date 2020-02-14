import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/api/api.dart';
import 'package:myevpanet/main_screen/blue_part.dart';
import 'package:myevpanet/main_screen/white_part.dart';
import 'package:myevpanet/widgets/drawer.dart';

class MainScreenWidget extends StatefulWidget {
  
  MainScreenWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {

  @override
  void initState() {
    if (verbose == 1) print('MainScreen initState()');
    if (verbose == 1) print('Start getData');
    getData();
    super.initState();
    fbHelper.configure(this.context);
    if (verbose == 1) print('End getData');
  }
  void getData() async {
    await UserInfo().getUserData();
    setState(() {});
    if (verbose == 5) print('Main Screen: Show UserInfo:\n$userInfo');
  }

  int _selectedIndex = 0;
  String _title = 'Информация';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('$_title'),
          //elevation: 2.0,
          actions: <Widget>[
            //Padding(
              //child: Icon(Icons.search),
              //padding: const EdgeInsets.only(right: 10.0),
            //)
          ],
        ),

        body: Column(
          children: <Widget>[
            _selectedIndex == 0 ? blueZone_1(userInfo) : _selectedIndex == 1 ? blueZoneT(userInfo) : _selectedIndex == 2 ? blueZoneS(userInfo) : /*SupportScreen(),*/blueZoneM(),
            _selectedIndex == 0 ? blueZone_2(userInfo) : Container(),
            _selectedIndex == 0 ? whiteZone(userInfo, context) : Container()
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(FontAwesome.info_circle),
              title: Text('Информация'),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesome.ruble),
              title: Text('Тарифы'),
            ),
            BottomNavigationBarItem(
              icon: Icon(MaterialCommunityIcons.cogs),
              title: Text('Настройки'),
            ),
            BottomNavigationBarItem(
              icon: Icon(MaterialCommunityIcons.face_agent),
              title: Text('Техподдержка'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0: _title = 'Информация';
        break;
        case 1: _title = 'Тарифы';
        break;
        case 2: _title = 'Настройки';
        break;
        case 3: _title = 'Техподдержка';
        break;
      }
    });
  }
}


