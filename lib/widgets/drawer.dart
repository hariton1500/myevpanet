import 'package:flutter/material.dart';

import 'package:myevpanet/main.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          //shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: idList()
          ),
    );
  }

  Widget _createHeader(context) {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .primaryColor,
/*            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('path/to/header_background.png'))*/
        ),
        child: Stack(
            children: <Widget>[
              Positioned(
                  bottom: 12.0,
                  left: 16.0,
                  child: Text("Flutter Step-by-Step",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500
                      )
                  )
              ),
            ]
        )
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }


  List<Widget> idList() {
    List<Widget> list = [];
    for (var item in users.keys) {
      list.add(
        Row(
          children: <Widget>[
            Text('${users[item]['id']}'),
            Text('${users[item]['name']}')
          ],
        )
      );
    }
    return list;
  } 

}