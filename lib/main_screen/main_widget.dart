import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
              height: 230.0,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10.0
                        ),
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      right: 30.0
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "Текущий тарифный план",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: 5.0
                                        ),
                                        child: Text(
                                          userInfo["tarif_name"] + " (" + userInfo["tarif_sum"]?.toString() + " р.)",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20.0
                                  ),
                                  child: SizedBox(
/*                                  height: 165,
                                  width: 165,*/
                                    child: Stack(
                                      children: <Widget>[
                                        SizedBox(
                                          child: CircularProgressIndicator(
                                            value: 1,
                                            valueColor: new AlwaysStoppedAnimation(Colors.lightBlueAccent),
                                            strokeWidth: 65.0,
                                          ),
                                          height: 65.0,
                                          width: 65.0,
                                        ),
                                        SizedBox(
                                          child: CircularProgressIndicator(
                                            value: 0.2,
                                            valueColor: new AlwaysStoppedAnimation(Colors.white70),
                                            strokeWidth: 65.0,
                                          ),
                                          height: 65.0,
                                          width: 65.0,
                                        ),
                                        SizedBox(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                    "Осталось",
                                                    style: TextStyle(
                                                      color: Colors.indigo,
                                                    ),
                                                  ),
                                                  Stack(
                                                    children: <Widget>[
                                                      // Stroked text as border.
                                                      Text(
                                                        "25",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 25,
                                                            foreground: Paint()
                                                              ..style = PaintingStyle.stroke
                                                              ..color = Colors.white70
                                                              ..strokeWidth = 2
                                                        ),
                                                      ),
                                                      Text(
                                                        "25",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 25,
                                                          color: Colors.pink,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "дней",
                                                    style: TextStyle(
                                                      color: Colors.indigo,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                          height: 120.0,
                                          width: 120.0,
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                              ),


//                          Text('ID: ${userInfo['id'].toString()}'),
//                          Text('Тарифный план: ' + userInfo["tarif_name"] + " (" + userInfo["tarif_sum"]?.toString() + "р.)" ),
                            ],
                          )
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 6.0,
                                right: 4.0
                              ),
                              child: Text("На Вашем счету: ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),

                            ),
                          Text(
                              userInfo["extra_account"]?.toString() + " р.",
                              style: TextStyle(
                                color: double.parse(userInfo["extra_account"]) < 0 ? Colors.pink : Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                          ),

                        ],
                        ),
                      ),
                    ),
                  ],
                ),

              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  double.parse(userInfo["debt"]) > 0
                      ?
                  Container (
                      decoration: new BoxDecoration (
                          color: Colors.red
                      ),
                      child: new ListTile(
                        title: Text(
                          "За вами числится задолженость " + userInfo["debt"]?.toString() + " р.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        //subtitle: Text(userInfo["tarif_name"] + " (" + userInfo["tarif_sum"]?.toString() + "р.)" ),
                      )
                  )
                      :
                  "",
                ],
              )

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

  double SecToDate(secsLeft) {
    return secsLeft / 60 / 60 / 24;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}


