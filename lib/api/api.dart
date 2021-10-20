import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/helpers/data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void dprintL(dynamic source) {
  String dt = DateTime.now().toLocal().toString();
  print('[$dt]| $source');
}

void dprintD(dynamic source, int verb) {
  String dt = DateTime.now().toLocal().toString();
  if (verb >= 1) print('[$dt]| $source');
}

class FileStorage {
  String filename;

  FileStorage(String name) {
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

class Pushes {
  Pushes() {
    loadSavedPushes().then((value) {
      pushes = value;
      allSeen = isAllSeen();
    });
  }

  List<OneNotification> pushes = [];
  SharedPreferences sharedPreferences;
  bool allSeen;
  bool isAllSeen() {
    dprintL('check if all ${pushes.length} pushes seen');
    if (pushes.length == 0) return true;
    return (pushes.every((push) => push.seen));
  }

  Future<List<OneNotification>> loadSavedPushes() async {
    dprintL('Loading saved pushes');
    sharedPreferences = await SharedPreferences.getInstance();
    List<String> _pushesList = sharedPreferences.getStringList('pushes') ?? [];
    dprintL('${_pushesList.length} pushes loaded');
    //print(_pushesList);
    //print('------------|');
    pushes.clear();
    _pushesList.forEach((_push) {
      var _tmp = json.decode(_push);
      OneNotification push = OneNotification();
      push.id = _tmp['id'];
      push.title = _tmp['title'].toString();
      push.date = _tmp['date'].toString();
      push.body = _tmp['body'].toString();
      push.seen = _tmp['seen'] ?? false;
      pushes.add(push);
      //print('added\n${push.body}');
    });
    return pushes;
  }

  //получение сообщений
  Future<void> getNewUnreadPushesFromServer(String token, guid, int id) async {
    Response response;
    //Map<String, String> answer = {'answer': 'isEmpty', 'body': ''};
    Map<String, String> headers = {'token': token};
    String url = 'https://evpanet.com/api/apk/message/$guid';
    dprintL('get messages...[$url]');
    dprintL('with headers...[$headers]');
    try {
      response = await get(Uri.parse(url), headers: headers);
      dprintL(response.statusCode);
      dprintL(response.body);
      if (response.statusCode == 201 || response.statusCode == 401) {
        String jsonAnswer = response.body;
        var decodedAnswer = json.decode(jsonAnswer);
        bool errorFlag = decodedAnswer['error'];
        var messages = decodedAnswer['message'];
        if (!errorFlag) {
          if (messages.runtimeType.toString() == 'String')
            dprintL('got no messages');
          else {
            messages.forEach((message) {
              OneNotification push = OneNotification();
              push.body = message['text'];
              push.id = id;
              pushes.add(push);
            });
            savePushes();
          }
        } else
          dprintL('got error: $messages');
      } else
        dprintL('statusCode not 201: ${response.statusCode}');
      //answer = {'answer': 'isFull', 'body': response.body};
    } on SocketException catch (error) {
      dprintL(error.message);
    }
  }

  int parsePushForId(String source) {
    dprintL('parsing $source for id');
    if (source != 'null') {
      int _indexOpen = source.indexOf('(');
      int _indexClose = source.indexOf(')');
      String _toParse = source.substring(_indexOpen + 1, _indexClose);
      int answer = int.parse(_toParse);
      dprintL(answer);
      return answer;
    } else {
      dprintL(0);
      return 0;
    }
  }

  Future<void> savePushes() async {
    dprintL('save all ${pushes.length} pushes.');
    List<String> _list = [];
    sharedPreferences = await SharedPreferences.getInstance();
    pushes.forEach((push) {
      Map<String, dynamic> _tmp = {};
      _tmp['id'] = push.id;
      _tmp['title'] = push.title;
      _tmp['body'] = push.body;
      _tmp['date'] = push.date;
      _tmp['seen'] = push.seen;
      _list.add(json.encode(_tmp));
    });
    await sharedPreferences.setStringList('pushes', _list);
    dprintL('saved $_list pushes');
  }
}

class Network {
  bool isError = false;
  String error = '';
  Response response;
  Future<Response> getData(String url) async {
    if (verbose == 1) print('Calling uri: $url');
    // 4
    try {
      return await get(Uri.parse(url));
    } on SocketException catch (e) {
      Fluttertoast.showToast(
          msg: "Нет подключения к сети",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      this.isError = true;
      this.error = e.toString();
    } on HandshakeException catch (e) {
      Fluttertoast.showToast(
          msg: "Нет подключения к сети",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      this.isError = true;
      this.error = e.toString();
    }
    return response;
  }
}

class RestAPI {
  Future<Response> getData(String url) async {
    Network network = Network();
    return await network.getData(url);
  }

  Future<String> remontAddPOST(
      String comment, String guid, String token) async {
    Response _response;
    String _answer = '';
    Map<String, String> _headers = {'token': '$token'};
    Map _body = {'message': '$comment', 'guid': '$guid'};
    String _url = 'https://evpanet.com/api/apk/support/request';
    if (verbose >= 1)
      print(
          'Requesting by POST: url = $_url; headers = $_headers; body = $_body');
    try {
      _response = await post(Uri.parse(_url), headers: _headers, body: _body);
      if (_response.statusCode >= 200 && _response.statusCode <= 401)
        _answer = json.decode(_response.body)['message'];
    } on SocketException catch (error) {
      if (verbose >= 1) print(error.message);
      return _answer;
    } on HandshakeException catch (error) {
      if (verbose >= 1) print(error.message);
      return _answer;
    } on NoSuchMethodError catch (error) {
      if (verbose >= 1) print(error.toString());
      return _answer;
    }
    if (verbose >= 1) {
      print('Response statusCode: ${_response.statusCode}');
      print('Response reasonPhrase: ${_response.reasonPhrase}');
      if (_response.statusCode == 201 && _response.reasonPhrase == 'Created')
        print('Response body: $_answer');
    }
    return _answer;
  }

  //изменение тарифа
  Future<String> tarifChangePATCH(
      String tarifId, String guid, String token) async {
    Response _response;
    String _answer = 'isEmpty';
    Map<String, String> _headers = {'token': '$token'};
    Map _body = {'tarif': tarifId, 'guid': guid};
    String _url = 'https://evpanet.com/api/apk/user/tarif';
    if (verbose >= 1)
      print(
          'Changing tarif by PATCH: url = $_url; headers = $_headers; body = $_body');
    try {
      _response = await patch(Uri.parse(_url), headers: _headers, body: _body);
      _response.statusCode == 200
          ? _answer =
              json.decode(_response.body)['message']['tarif_id'].toString()
          : _answer = 'isError';
    } on SocketException catch (error) {
      if (verbose >= 1) print(error.message);
      return 'isException';
    } on HandshakeException catch (error) {
      if (verbose >= 1) print(error.message);
      return 'isException';
    } on NoSuchMethodError catch (error) {
      if (verbose >= 1) print(error.toString());
      return _answer;
    }
    if (verbose >= 1)
      print('Response statusCode: ${_response.statusCode}; body: $_answer');
    return _answer;
  }

  //добавление дней к пакету
  Future<String> addDaysPUT(int daysToAdd, String guid, String token) async {
    Response _response;
    String _answer = 'isEmpty';
    Map<String, String> _headers = {'token': '$token'};
    Map _body = {'days': daysToAdd.toString(), 'guid': guid};
    String _url = 'https://evpanet.com/api/apk/user/days/';
    if (verbose >= 1)
      print(
          'Adding days by PUT: url = $_url; headers = $_headers; body = $_body');
    try {
      _response = await put(Uri.parse(_url), headers: _headers, body: _body);
      _response.statusCode == 201
          ? _answer = _response.body
          : _answer = 'isError';
    } on SocketException catch (error) {
      if (verbose >= 1) print(error.message);
      return 'isException';
    } on HandshakeException catch (error) {
      if (verbose >= 1) print(error.message);
      return 'isException';
    } on NoSuchMethodError catch (error) {
      if (verbose >= 1) print(error.toString());
      return _answer;
    }
    if (verbose >= 1)
      print('Response statusCode: ${_response.statusCode}; body: $_answer');
    return _answer;
  }

  //смена переключателей автоактивации или род. контроля
  Future<String> switchChangePUT(
      String switchType, String guid, String token) async {
    Response _response;
    String _answer = 'isEmpty';
    Map<String, String> _headers = {'token': '$token'};
    Map _body = {'guid': guid};
    String _url = switchType == 'activation'
        ? 'https://evpanet.com/api/apk/user/auto_activation/'
        : 'https://evpanet.com/api/apk/user/parent_control/';
    if (verbose >= 1)
      print(
          'Changing auto_activation flag by PUT: url = $_url; headers = $_headers; body = $_body');
    try {
      _response = await put(Uri.parse(_url), headers: _headers, body: _body);
      _response.statusCode == 201
          ? _answer = json.decode(_response.body)['message']['value'].toString()
          : _answer = 'isError';
    } on SocketException catch (error) {
      if (verbose >= 1) print(error.message);
      return 'isException';
    } on HandshakeException catch (error) {
      if (verbose >= 1) print(error.message);
      return 'isException';
    } on NoSuchMethodError catch (error) {
      if (verbose >= 1) print(error.toString());
      return _answer;
    }
    if (verbose >= 1)
      print('Response statusCode: ${_response.statusCode}; body: $_answer');
    return _answer;
  }

  //авторизация
  Future<Map<String, String>> authorizeUserPOST(
      String number, int uid, String token) async {
    Response _response;
    Map<String, String> _answer = {'answer': 'isEmpty', 'body': ''};
    Map<String, String> _headers = {'token': '$token'};
    Map _body = {'number': '$number', 'uid': '$uid'};
    String _url = 'https://evpanet.com/api/apk/login/user';
    if (verbose >= 1)
      print(
          'Requesting by POST: url = $_url; headers = $_headers; body = $_body');
    try {
      _response = await post(Uri.parse(_url), headers: _headers, body: _body);
      if (_response.statusCode == 201 || _response.statusCode == 401)
        _answer = {'answer': 'isFull', 'body': _response.body};
    } on SocketException catch (error) {
      if (verbose >= 1) print(error.message);
      return _answer;
    } on HandshakeException catch (error) {
      if (verbose >= 1) print(error.message);
      return _answer;
    } on NoSuchMethodError catch (error) {
      if (verbose >= 1) print(error.toString());
      return _answer;
    }
    if (verbose >= 1) {
      print('Response statusCode: ${_response.statusCode}');
      print('Response reasonPhrase: ${_response.reasonPhrase}');
      if (_response.statusCode == 201 && _response.reasonPhrase == 'Created')
        print(
            'Response body: ${json.decode(_response.body)['message']['guids']}');
    }
    return _answer;
  }

  //получение данных абонента
  Future<String> userDataGet(String guid, String token) async {
    Response response;
    Map<String, String> answer = {'answer': 'isEmpty', 'body': ''};
    Map<String, String> headers = {'token': '$token'};
    String url = 'https://evpanet.com/api/apk/user/info/$guid';
    if (verbose >= 1)
      print('Requesting by GET: url = $url; headers = $headers');
    try {
      response = await get(Uri.parse(url), headers: headers);//.timeout(Duration(seconds: 5), onTimeout: () {answer = {'answer': 'isTimeout', 'body': ''}; return response;});
      if (response.statusCode == 201 || response.statusCode == 401)
        answer = {'answer': 'isFull', 'body': response.body};
    } on SocketException catch (error) {
      if (verbose >= 1) print(error.message);
      return 'SocketException';
    } on HandshakeException catch (error) {
      if (verbose >= 1) print(error.message);
      return 'HandshakeException';
    } on NoSuchMethodError catch (error) {
      if (verbose >= 1) print(error.toString());
      return 'NoSuchMethodException';
    }
    if (verbose >= 1) {
      print('Response statusCode: ${response.statusCode}');
      print('Response reasonPhrase: ${response.reasonPhrase}');
      if (response.statusCode == 201 && response.reasonPhrase == 'Created')
        print('Response body: ${json.decode(response.body)['message']}');
    }
    if (answer['answer'] == 'isFull') {
      //получили какой-то ответ, который можно декодировать
      var decoded = json.decode(answer['body']);
      if (!decoded['error']) {
        print(
            'ответ был хороший, записываем в глобальную переменную и сохраняем в файл');
        users[currentGuidIndex] = decoded['message']['userinfo'];
        userInfo = users[currentGuidIndex];
        if (verbose >= 2)
          userInfo.forEach((k, v) {
            print('$k, $v');
          });
        final File _file = await FileStorage('$guid.dat').localFile;
        _file.writeAsString(response.body);
        return 'Ok';
      } else
        return 'NotOk';
    } else
      return answer['answer'];
  }
}

class UserInfo {
  Future<bool> readFromFile() async {
    if (verbose >= 1)
      print('Check existing of file ${guids[currentGuidIndex]}.dat');
    final File _file =
        await FileStorage('${guids[currentGuidIndex]}.dat').localFile;
    if (_file.existsSync()) {
      if (verbose >= 1) print('file is exists. Start reading.');
      var res = _file.readAsStringSync(encoding: utf8);
      if (verbose >= 1) print('Show what readed:\n$res');
      if (verbose >= 1) print('Start json parsing');
      var parsed = json.decode(res);
      users[currentGuidIndex] = parsed['message']['userinfo'];
      userInfo = users[currentGuidIndex];
      if (verbose >= 2)
        userInfo.forEach((k, v) {
          print('$k, $v');
        });
      return true;
    } else {
      if (verbose >= 1) print('file is not exists!');
      return false;
    }
  }

  Future<void> getUserData() async {
    bool result;
    if (verbose >= 1) print('First try read from file');
    result = await readFromFile();
    if (verbose >= 1) print('result of file reading? $result');
    if (!result) {
      if (verbose >= 1) print('Second try get from server');
      String res = await RestAPI().userDataGet(guids[currentGuidIndex], devKey);
      if (verbose >= 1) print(res);
    }
    return null;
  }
}

//все вспомогательные классы с их методами здесь

/*
* Описание принципов работы нового API.
*
* Основной адрес нового API: https://evpanet.com/api/apk/
* ***************************************************************
* Авторизация:
*   URL: https://evpanet.com/api/apk/login/user
*   Method: POST
*   Header:
*     - key = token
*     - value = токен от гугла
*   Body:
*     - number = номер телефона в формате +7....
*     - uid = ID абонента
*   Response:
*     - формат: JSON
*     - данные: массив GUID
* ***************************************************************
* Получение данных абонента:
*   URL: https://evpanet.com/api/apk/user/info/<GUID>
*   Method: GET
*   Header:
*     - key = token
*     - value = токен от гугла
*   Response:
*     - формат: JSON
*     - данные: данные об абоненте, и доступные тарифные планы
* ***************************************************************
* Изменение флагов автоактивации и родительского контроля:
*   URLS:
*     - https://evpanet.com/api/apk/user/parent_control/  для родительского контроля
*     - https://evpanet.com/api/apk/user/auto_activation/ для автоактивации
*   Method: PUT
*   Header:
*     - key = token
*     - value = токен от гугла
*   Body:
*     - формат = JSON {"guid":"<GUID>"}
*   Response:
*     - формат: JSON
*     - данные: текущее состояние флага (1 или 0)
*
* ***************************************************************
* Добавление ремонта или коментария к ремонту
*   URL: https://evpanet.com/api/apk/support/request
*   Method: POST
*   Header:
*     - key = token
*     - value = токен от гугла
*   Body:
*     - message = сообщение от абонента
*     - guid
*   Response:
*     - формат: JSON
*     - ответ: есть ли ошибка и текст, или сообщения или ошибки
**
* ***************************************************************
* Изменение пакета или активация нового
*   URL: https://evpanet.com/api/apk/user/tarif
*   Method: PATCH
*   Header:
*     - key = token
*     - value = токен от гугла
*   Body:
*     - формат = JSON {"tarif":"<tarifid>","guid":"<GUID>"}
*   Response:
*     - формат: JSON
*     - данные:
*         "packet_secs",
*         "tarif_id",
*         "tarif_sum",
*         "tarif_name"
* ***************************************************************
* Добавление дней
*   URL: https://evpanet.com/api/apk/user/days/
*   Method: PUT
*   Header:
*     - key = token
*     - value = токен от гугла
*   Body:
*     - формат = JSON {"guid":"<GUID>","days":<DAYS>}
*   Response:
*     - формат: JSON
*     - данные:
*         "days": <days>,
*         "packet_secs": <packet_secs>,
*         "extra_account": <extra_account>
*
* ***************************************************************
* */
