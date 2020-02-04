import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          _createDrawerItem(icon: Icons.contacts, text: 'Contacts',),
          _createDrawerItem(icon: Icons.event, text: 'Events',),
          _createDrawerItem(icon: Icons.note, text: 'Notes',),
          Divider(),
          _createDrawerItem(icon: Icons.collections_bookmark, text: 'Steps'),
          _createDrawerItem(icon: Icons.face, text: 'Authors'),
          _createDrawerItem(
              icon: Icons.account_box, text: 'Flutter Documentation'),
          _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),
          Divider(),
          _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
      //    _createUserListItem(),
        ],
      ),
    );
  }

  Widget _createHeader(context) {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
/*            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('path/to/header_background.png'))*/
        ),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Flutter Step-by-Step",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
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

//  Widget _createUserListItem() {
//
//
//    return new ListView.builder(
//      // ignore: missing_return
//      itemBuilder:  (BuildContext context, int index) {
//          new Text('${users.values.toList()[index].name}');
//        }
////      itemCount: users.length,
////      itemBuilder: (BuildContext context, int index) {
////        String key = users.keys.elementAt(index);
////        return new Column(
////          children: <Widget>[
////            new ListTile(
////              title: new Text("$key"),
////              //subtitle: new Text("${users[key]}"),
////            ),
////            new Divider(
////              height: 2.0,
////            ),
////          ],
////        );
////      },
//
//
//      );
//    }


  }

