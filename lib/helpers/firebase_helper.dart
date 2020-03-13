import 'dart:io';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myevpanet/api/api.dart';

class FirebaseHelper{


  //final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  FirebaseHelper(){
    _init();
  }

  void _init(){
    if(Platform.isIOS){
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    //configure();
  }

  void configure(BuildContext context) {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // final snackbar = SnackBar(
        //   content: Text(message['notification']['title']),
        //   action: SnackBarAction(
        //     label: 'Go',
        //     onPressed: () => null,
        //   ),
        // );

        // Scaffold.of(context).showSnackBar(snackbar);
        //сохраняем полученную пушку в файл
        savePushToFile(message);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                //color: Colors.amber,
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        savePushToFile(message);
        // optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        savePushToFile(message);
        // optional
      },
    );
  }

  Future<String> getAppToken() async{
    return await _fcm.getToken();
  }

  Future<void> savePushToFile(Map<String, dynamic> message) async{
    final _file = await FileStorage('pushes.dat').localFile;
    _file.writeAsString('${message.toString()}', mode: FileMode.append);
  }
  /*Future saveDeviceToken(String json) async{
    //String uid = 'jeff1e7t';
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    // Save it to Firestore
    if (fcmToken != null) {
      print('fcmToken:');
      print(fcmToken);
      var tokens = _db
          .collection('users')
      //.document(uid)
      //.collection('tokens')
          .document(fcmToken);
      //print('tokens.get():');
      //print(await tokens.get());
      await tokens.setData({
        'token': fcmToken,
        //'createdAt': FieldValue.serverTimestamp(), // optional
        'guids': json // optional
      });
    }
  }*/

}