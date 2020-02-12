import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/api/api.dart';
import 'package:myevpanet/support_screen/support.dart';
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
    print('MainScreen initState()');
    print('Start getData');
    getData();
    super.initState();
    print('End getData');
  }
  void getData() async {
    await UserInfo().getUserData();
    setState(() {});
    print('Main Screen: Show UserInfo:\n$userInfo');
  }
  void turnLeft() {
    if (currentGuidIndex == 0) {
      currentGuidIndex = guids.length - 1;
    } else {
      currentGuidIndex--;
    }
    getData();
  }
  void turnRight() {
    if (currentGuidIndex + 1 == guids.length) {
      currentGuidIndex = 0;
    } else {
      currentGuidIndex++;
    }
    getData();
  }
  void supportButtonPressed() {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SupportScreen()));
  }
  void payButtonPressed() {

  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text("Информация"),
          elevation: 1.0,
          actions: <Widget>[
            //Padding(
              //child: Icon(Icons.search),
              //padding: const EdgeInsets.only(right: 10.0),
            //)
          ],
        ),

        body: Column(
          children: <Widget>[
            Container(
              color: Colors.blue,
              height: 250.0,
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Stack(
                              children: <Widget>[
                                SizedBox(
                                  child: CircularProgressIndicator(
                                    value: 1,
                                    valueColor: new AlwaysStoppedAnimation(Colors.lightBlueAccent),
                                    strokeWidth: 50.0,
                                  ),
                                  height: 50.0,
                                  width: 50.0,
                                ),
                                SizedBox(
                                  child: CircularProgressIndicator(
                                    value: 0.2,
                                    valueColor: new AlwaysStoppedAnimation(Colors.white70),
                                    strokeWidth: 50.0,
                                  ),
                                  height: 50.0,
                                  width: 50.0,
                                ),
                                SizedBox(
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text("25"),
                                        Text("дней"),
                                      ],
                                   ),
                                  height: 100.0,
                                  width: 100.0,
                                )
                              ],
                            ),
                          )
//                          Text('ID: ${userInfo['id'].toString()}'),
//                          Text('Тарифный план: ' + userInfo["tarif_name"] + " (" + userInfo["tarif_sum"]?.toString() + "р.)" ),
                        ],
                )
                    ),
                  ],
                ),

              ),
            ),
            Expanded(
                child: ListView(
                  children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        ListTile(
                          title: Text("ID"),
                          subtitle: Text(userInfo["id"]?.toString()),
                        ),
                        ListTile(
                          title: Text("Тарифный план"),
                          subtitle: Text(userInfo["tarif_name"] + " (" + userInfo["tarif_sum"]?.toString() + "р.)" ),
                        ),
                        ListTile(
                          title: Text("Ф.И.О."),
                          subtitle: Text(userInfo["name"]),
                        ),
                        ListTile(
                          title: Text('Адрес'),
                          subtitle: Text(userInfo["street"] + ", д. " + userInfo["house"] + ", кв. " + userInfo["flat"]),
                        ),
                        ListTile(
                          title: Text('Логин'),
                          subtitle: Text(userInfo["login"]),
                        ),
                        ListTile(
                          title: Text('IP адрес абонента'),
                          subtitle: Text(userInfo["real_ip"]),
                        ),
                      ]
                  ).toList(),
                )
            ),
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
    });
  }

}


