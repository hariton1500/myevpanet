//все вспомогательные классы с их методами здесь

/*
* Описание принципов работы нового API.
*
* Основной адрес нового API: https://evpanet.com/api/apk/
*
* Авторизация:
*   URL: https://evpanet.com/api/apk/login/user
*   Method: POST
*   Body:
*     - number = номер телефона в формате +7....
*     - uid = ID абонента
*   Header:
*     - key = token
*     - value = токен от гугла
*
*   Response:
*     - формат: JSON
*     - данные: массив GUID
*
* Получение данных абонента:
*   URL: https://evpanet.com/api/apk/user/info/<GUID>
*   Method: GET
*   Header:
*     - key = token
*     - value = токен от гугла
*
*   Response:
*     - формат: JSON
*     - данные: данные об абоненте, и доступные тарифные планы
*
* Изменение флагов автоактивации и родительского контроля:
*   URLS:
*     - https://evpanet.com/api/apk/user/parent_control/  для родительского контроля
*     - https://evpanet.com/api/apk/user/auto_activation/ для автоактивации
*   Method: PUT
*   Body:
*     - формат = JSON {"guid":"<GUID>"}
*   Header:
*     - key = token
*     - value = токен от гугла
*
*   Response:
*     - формат: JSON
*     - данные: текущее состояние флага (1 или 0)
*
* */


import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myevpanet/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class FileStorage {
  String filename;

  FileStorage(String name){
    this.filename = name;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final path = await _localPath;
    return new File('$path/$filename');
  }

  Future<String> readFromFile() async {
    try {
      final file = await localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return 'ERROR';
    }
  }

  Future<File> writeToFile(String content) async {
    final file = await localFile;

    // Write the file

    return file.writeAsString('$content', mode: FileMode.write);
  }

}

class Network {
  Future getData(String url) async {
    if (verbose == 1) print('Calling uri: $url');
    // 4
    try {
      Response response = await get(url);
      if (response.statusCode == 200) {
        // 6
        return response.body;
      } else {
        if (verbose == 1) print(response.statusCode);
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Нет подключения к сети",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      return e.toString();
    } on HandshakeException catch (e) {
      Fluttertoast.showToast(
        msg: "Нет подключения к сети",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      return e.toString();
    }
      // 5
  }

  Future postData(String url, int number, int uid, int devid) async {
    var _body = {'number': '+79780481885', 'uid': '20', 'devid': '234234'};
    if (verbose == 1) print('Calling uri: $url body: $_body');
    // 4
    Response response = await post(url, body: _body);
    // 5
    if (response.statusCode == 200) {
      // 6
      return response.body;
    } else {
      if (verbose == 1) print('Error. Status is: ${response.statusCode}');
    }
  }

}

class RestAPI {
  Future<dynamic> getData(String url) async {
    Network network = Network();
    var gData = await network.getData(url);
    return gData;
  }

  Future<dynamic> postData(String url, int number, int uid, int devid) async {
    Network network = Network();
    var gData = await network.postData(url, number, uid, devid);
    return gData;
  }

}
class UserInfo {
  void f(k, v) {
    if (verbose == 1) print('$k, $v');
  }
  Future<bool> readFromFile() async {
    if (verbose == 1) print('Check existing of file ${guids[currentGuidIndex]}.dat');
    final File _file = await FileStorage('${guids[currentGuidIndex]}.dat').localFile;
    if (_file.existsSync()) {
      if (verbose == 1) print('file is exists. Start reading.');
      var res = _file.readAsStringSync(encoding: utf8);
      if (verbose == 1) print('Show what readed:\n$res');
      if (verbose == 1) print('Start json parsing');
      var parsed = json.decode(res);
      //print('Type of parsing result variable is: ${parsed.runtimeType}');
      if (parsed.runtimeType.toString().contains('List')) {
        userInfo = parsed[0];
        users[currentGuidIndex] = userInfo;
        userInfo.forEach(f);
        return true;
      } else {
        return false;
      }
    } else {
      if (verbose == 1) print('file is not exists!');
      return false;
    }
  }

  Future<bool> getUserInfoFromServer() async {
    if (verbose == 1) print('Start request from Server.');
    String _url = 'https://app.evpanet.com/?get=userinfo';
    _url += '&guid=${guids[currentGuidIndex]}&devid=$devKey';
    if (verbose == 1) print('Requesting uri: $_url');
    var result = await RestAPI().getData(_url);
    if (verbose == 1) print('Got from server: $result');
    if (verbose == 1) print('Checking if Answer is String and >38 symbols and no Exceptions meet');
    bool _checked = true;
    if (result.toString().contains('Exception')) {
      _checked = false;
    }
    if (!result.runtimeType.toString().contains('String')) {
      _checked = false;
    }
    if (result.toString().length <= 38) {
      _checked = false;
    }
    if (_checked) {
      if (verbose == 1) print('Yes. Start parsing.');
      var parsed = json.decode(result);
      if (verbose == 1) print('Parsing result is: $parsed');
      if (verbose == 1) print('Type os result variable is: ${parsed.runtimeType}');
      if (parsed.runtimeType.toString().contains('List')) {
        userInfo = parsed[0];
        users[currentGuidIndex] = userInfo;
        userInfo.forEach(f);
        if (verbose == 1) print('Type is List. Saving to file');
        final File _file = await FileStorage('${guids[currentGuidIndex]}.dat').localFile;
        _file.writeAsString(result);
        for (var item in parsed) {
          if (verbose == 1) print('$item\n${item.runtimeType}');
        }
      }
      return true;
    } else {
      return false;
    }
  }

  Future<Void> getUserData() async {
    bool result;
    result = await readFromFile();
    if (!result) {
      result = await getUserInfoFromServer();
    }
    return null;
  }
}