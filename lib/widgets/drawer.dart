import 'package:flutter/material.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/main_screen/main_widget.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          //shrinkWrap: true,
          padding: EdgeInsets.zero,
          children:
            //DrawerHeader(child: Text('Список ваших учетных записей:')),
            idList(context)
        ),
    );
  }

  List<Widget> idList(context) {
    List<Widget> list = [];
    list.add(
      UserAccountsDrawerHeader(
        accountName: Text('${userInfo['name']}'),
        accountEmail: Text('${userInfo['login']}'),
        currentAccountPicture: CircleAvatar(
          backgroundColor:
          Theme.of(context).platform == TargetPlatform.iOS
              ? Colors.blue
              : Colors.white,
          child: Text(
            '${userInfo['name'].substring(0,1)}',
            style: TextStyle(fontSize: 40.0),
          ),
        ),
      ),
    );
    for (var item in users.keys) {
      if (users[item]['id'] != userInfo['id']) {
        list.add(
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
                      currentGuidIndex = item;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MainScreenWidget()));
                    }

                ),
                Divider(),
              ],
            ),
        );
      }
    }
    return list;
  } 
}