import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myevpanet/api/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myevpanet/helpers/data.dart';

class FirebaseHelper {
  FirebaseMessaging _fcm = FirebaseMessaging();

  FirebaseHelper() {
    _init();
  }

  void _init() {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions();
    }
    configure();
  }

  void configure() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        dprintL("recieved push when app is active: ${message['data']}");
        //lastMessage = message;
        dprintL('loading saved pushes, add new, save all');
        Pushes _pushes = Pushes();
        await _pushes.loadSavedPushes();
        OneNotification _push = OneNotification();
        _push.id = Pushes()
            .parsePushForId(message['notification']['title'].toString());
        _push.title = message['notification']['title'].toString();
        _push.body = message['notification']['body'].toString();
        _push.date = DateTime.now().toLocal().toString();
        _push.seen = false;
        _pushes.pushes.add(_push);
        _pushes.savePushes();
        Fluttertoast.showToast(
            msg:
                '${message['notification']['title']} : ${message['notification']['body']}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      },
      onLaunch: (Map<String, dynamic> message) async {
        dprintL("onLaunch: $message");
        dprintL('TRYING');
        Pushes _pushes = Pushes();
        await _pushes.loadSavedPushes();
        OneNotification _push = OneNotification();
        _push.id = Pushes().parsePushForId(message['data']['title'].toString());
        _push.title = message['data']['title'].toString();
        _push.body = message['data']['message'].toString();
        _push.date = DateTime.now().toLocal().toString();
        _push.seen = false;
        if (_pushes.pushes.any((__push) => __push.date == _push.date)) {
          _pushes.pushes.add(_push);
          _pushes.savePushes();
        } else
          dprintL('found duplicate. push not saved.');
      },
      onResume: (Map<String, dynamic> message) async {
        dprintL("onResume: ${message['data']}");
        Pushes _pushes = Pushes();
        await _pushes.loadSavedPushes();
        OneNotification _push = OneNotification();
        _push.id = Pushes().parsePushForId(message['data']['title'].toString());
        _push.title = message['data']['title'].toString();
        _push.body = message['data']['message'].toString();
        _push.date = DateTime.now().toLocal().toString();
        _push.seen = false;
        _pushes.pushes.add(_push);
        _pushes.savePushes();
      },
    );
  }

  Future<String> getAppToken() async {
    return await _fcm.getToken();
  }
}
