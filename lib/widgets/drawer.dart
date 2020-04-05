import 'package:flutter/material.dart';
import 'package:myevpanet/login_screen/login_widget.dart';
import 'package:myevpanet/main.dart';

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
    list.add(
      Column(
        children: <Widget>[
          FlatButton(
            onPressed: () {
              registrationMode = 'new';
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginWidget()));
            },
            child: Text('Повторная регистрация')
          ),
          Divider(),
          FlatButton(
            onPressed: () {
              registrationMode = 'add';
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginWidget()));
            },
            child: Text('Добавить ID')
          ),
        ],
      )
    );
    return list;
  } 
}