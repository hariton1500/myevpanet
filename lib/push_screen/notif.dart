import 'package:flutter/material.dart';
//import 'package:myevpanet/api/api.dart';
import 'package:myevpanet/helpers/data.dart';
import 'package:myevpanet/push_screen/pushList.dart';

class OneNotif extends StatelessWidget {
  OneNotif(this.notif);
  final OneNotification notif;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff32506a),
        title: Text(notif.title),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Navigator.pop(context, true);
              })
        ],
      ),
      body: Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: CustomListItemTwo(
            thumbnail: Container(
              decoration: const BoxDecoration(
                  color: Color(0xff42617e), shape: BoxShape.circle),
              alignment: Alignment(0.0, 0.0),
              child: Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 32.0,
              ),
            ),
            title: "ID: " + notif.id.toString(),
            subtitle: notif.body,
            author: notif.title,
            publishDate: notif.date
                .toString()
                .substring(0, notif.date.toString().length - 7),
            isFullSubtitle: true,
          )),
    );
  }
}
