import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/api/api.dart';
import 'package:myevpanet/main_screen/setups.dart';
import 'package:myevpanet/widgets/drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MainScreenWidget extends StatefulWidget {
  
  MainScreenWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {

  List<Widget> idListPoints() {
    List<Widget> _list = [];
    for (var item in users.keys) {
      _list.add(
        Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == item
                  ? Color.fromRGBO(0, 0, 0, 0.9)
                  : Color.fromRGBO(0, 0, 0, 0.4)
          ),
        )
      );
    }
    return _list;
  }

  List<Widget> idList() {
    List<Widget> _list = [];
    for (var item in users.keys) {
        _list.add(
          Column(
            children: <Widget>[
              ListTile(
                  title: Text('${users[item]['name']}'),
                  subtitle: Text('${users[item]['login']} (${users[item]['id']})'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      '${users[item]['name'].substring(0,1)}',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SetupGroup()));
                  }
              ),
            ],
          ),
        );
    }
    return _list;
  }


  @override
  void initState() {
    if (verbose >= 1) print('MainScreen initState()');
    if (verbose >= 1) print('Start getData');
    getData();
    super.initState();
    fbHelper.configure(this.context);
    if (verbose >= 1) print('End getData');
  }
  void getData() async {
    await UserInfo().getUserData();
    setState(() {});
    if (verbose >= 5) print('Main Screen: Show UserInfo:\n$userInfo');
  }

  ///////////////////////////////////
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  int _selectedIndex = 0;
  String _title = 'Информация';
  int _current = 0;

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
          children: [
            CarouselSlider(
              items: idList(),
              autoPlay: false,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index) {
                setState(() {
                  currentGuidIndex = index;
                  userInfo = users[currentGuidIndex];
                  _current = index;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: idListPoints()
            ),
          ]
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


