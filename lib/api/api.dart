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
*
* */


import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
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
  bool isError = false;
  String error = '';
  Response response;
  Future<Response> getData(String url) async {
    if (verbose == 1) print('Calling uri: $url');
    // 4
    try {
      return await get(url);
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
      this.isError = true;
      this.error = e.toString();
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

  /*   URL: https://evpanet.com/api/apk/user/tarif
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
  */
  Future<String> tarifChangePATCH(String tarifId, String guid, String token) async{
    Response _response;
    String _answer = 'isEmpty';
    Map<String, String> _headers = {'token' : '$token'};
    Map _body = {'tarif' : tarifId, 'guid' : guid};
    String _url = 'https://evpanet.com/api/apk/user/tarif';
    if (verbose >= 1) print('Changing tarif by PATCH: url = $_url; headers = $_headers; body = $_body');
    try {
      _response = await patch(_url, headers: _headers, body: _body);
      _response.statusCode == 200 ?
        _answer = json.decode(_response.body)['message']['tarif_id'].toString()
        :
        _answer = 'isError';
    } on SocketException catch (error) {
      if (verbose >=1) print(error.message);
      return 'isException';
    } on HandshakeException catch (error) {
      if (verbose >=1) print(error.message);
      return 'isException';
    }
    if (verbose >= 1) print('Response statusCode: ${_response.statusCode}; body: $_answer');
    return _answer;
  }


  Future<String> switchChangePUT(String switchType, String guid, String token) async{
    Response _response;
    String _answer = 'isEmpty';
    Map<String, String> _headers = {'token' : '$token'};
    Map _body = {'guid' : guid};
    String _url = switchType == 'activation' ?
      'https://evpanet.com/api/apk/user/auto_activation/' :
      'https://evpanet.com/api/apk/user/parent_control/';
    if (verbose >= 1) print('Changing auto_actiovation flag by PUT: url = $_url; headers = $_headers; body = $_body');
    try {
      _response = await put(_url, headers: _headers, body: _body);
      _response.statusCode == 201 ?
        _answer = json.decode(_response.body)['message']['value'].toString()
        :
        _answer = 'isError';
    } on SocketException catch (error) {
      if (verbose >=1) print(error.message);
      return 'isException';
    } on HandshakeException catch (error) {
      if (verbose >=1) print(error.message);
      return 'isException';
    }
    if (verbose >= 1) print('Response statusCode: ${_response.statusCode}; body: $_answer');
    return _answer;
  }

  Future<Map<String, String>> authorizeUserPOST(String number, int uid, String token) async {
    Response _response;
    Map<String, String> _answer = {'answer' : 'isEmpty', 'body' : ''};
    Map<String, String> _headers = {'token' : '$token'};
    Map _body = {'number' : '$number', 'uid' : '$uid'};
    String _url = 'https://evpanet.com/api/apk/login/user';
    if (verbose >= 1) print('Requesting by POST: url = $_url; headers = $_headers; body = $_body');
    try {
      _response = await post(_url, headers: _headers, body: _body);
      if (_response.statusCode == 201 || _response.statusCode == 401) _answer = {'answer' : 'isFull', 'body' : _response.body};
    } on SocketException catch (error) {
      if (verbose >=1) print(error.message);
      return _answer;
    } on HandshakeException catch (error) {
      if (verbose >=1) print(error.message);
      return _answer;
    }
    if (verbose >= 1) {
      print('Response statusCode: ${_response.statusCode}');
      print('Response reasonPhrase: ${_response.reasonPhrase}');
      if (_response.statusCode == 201 && _response.reasonPhrase == 'Created') print('Response body: ${json.decode(_response.body)['message']['guids']}');
    }
    return _answer;
  }

  /* Получение данных абонента:
  *   URL: https://evpanet.com/api/apk/user/info/<GUID>
  *   Method: GET
  *   Header:
  *     - key = token
  *     - value = токен от гугла
  *
  *   Response:
  *     - формат: JSON
  *     - данные: данные об абоненте, и доступные тарифные планы
  */
  Future<String> userDataGet(String guid, String token) async {
    Response response;
    Map<String, String> answer = {'answer' : 'isEmpty', 'body' : ''};
    Map<String, String> headers = {'token' : '$token'};
    String url = 'https://evpanet.com/api/apk/user/info/$guid';
    if (verbose >= 1) print('Requesting by GET: url = $url; headers = $headers');
    try {
      response = await get(url, headers: headers).timeout(Duration(seconds: 5), onTimeout: (){
        answer = {'answer' : 'isTimeout', 'body' : ''};
        return response;
        });
      if (response.statusCode == 201 || response.statusCode == 401) answer = {'answer' : 'isFull', 'body' : response.body};
    } on SocketException catch (error) {
      if (verbose >=1) print(error.message);
      return 'SocketException';
    } on HandshakeException catch (error) {
      if (verbose >=1) print(error.message);
      return 'HandshakeException';
    }
    if (verbose >= 1) {
      print('Response statusCode: ${response.statusCode}');
      print('Response reasonPhrase: ${response.reasonPhrase}');
      if (response.statusCode == 201 && response.reasonPhrase == 'Created') print('Response body: ${json.decode(response.body)['message']}');
    }
    if (answer['answer'] == 'isFull') {
      //получили какой-то ответ, который можно декодировать
      var decoded = json.decode(answer['body']);
      if (!decoded['error']) {
        print('ответ был хороший, записываем в глобальную переменную и сохраняем в файл');
        users[currentGuidIndex] = decoded['message']['userinfo'];
        userInfo = users[currentGuidIndex];
        if (verbose >= 2) userInfo.forEach((k, v) {print('$k, $v');});
        final File _file = await FileStorage('$guid.dat').localFile;
        _file.writeAsString(response.body);
        return 'Ok';
      } else return 'NotOk';
    } else return answer['answer'];
  }
}

class UserInfo {
  int getRandom() {
    Random rnd = new Random();
    int c7 = rnd.nextInt(10);
    int c6 = rnd.nextInt(10);
    int c5 = rnd.nextInt(10);
    int c4 = rnd.nextInt(10);
    int c3 = rnd.nextInt(10);
    int c2 = rnd.nextInt(10);
    int c1 = rnd.nextInt(9) + 1;
    int content = c1 * 1000000 + c2 * 100000 + c3 * 10000 + c4 * 1000;
    content += c5 * 100 + c6 * 10 + c7;
    return content;
  }

  Future<bool> readFromFile() async {
    if (verbose >= 1) print('Check existing of file ${guids[currentGuidIndex]}.dat');
    final File _file = await FileStorage('${guids[currentGuidIndex]}.dat').localFile;
    if (_file.existsSync()) {
      if (verbose >= 1) print('file is exists. Start reading.');
      var res = _file.readAsStringSync(encoding: utf8);
      if (verbose >= 1) print('Show what readed:\n$res');
      if (verbose >= 1) print('Start json parsing');
      var parsed = json.decode(res);
      //print('Type of parsing result variable is: ${parsed.runtimeType}');
      //userInfo = parsed['message']['userinfo'];
      users[currentGuidIndex] = parsed['message']['userinfo'];
      userInfo = users[currentGuidIndex];
      if (verbose >= 2) userInfo.forEach((k, v) {print('$k, $v');});
      return true;
    } else {
      if (verbose >= 1) print('file is not exists!');
      return false;
    }
  }

  /*Future<bool> getUserInfoFromServer() async {
    if (verbose >= 1) print('Start request from Server.');
    String _url = 'https://app.evpanet.com/?get=userinfo';
    _url += '&guid=${guids[currentGuidIndex]}&devid=$devKey';
    if (verbose >= 1) print('Requesting uri: $_url');
    var result = await RestAPI().getData(_url);
    if (verbose >= 1) print('Got from server: $result');
    if (verbose >= 1) print('Checking if Answer is String and >38 symbols and no Exceptions meet');
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
      if (verbose >= 1) print('Yes. Start parsing.');
      var parsed = json.decode(result.body);
      if (verbose >= 1) print('Parsing result is: $parsed');
      if (verbose >= 1) print('Type os result variable is: ${parsed.runtimeType}');
      if (parsed.runtimeType.toString().contains('List')) {
        userInfo = parsed[0];
        users[currentGuidIndex] = userInfo;
        //userInfo.forEach(f);
        if (verbose >= 1) print('Type is List. Saving to file');
        final File _file = await FileStorage('${guids[currentGuidIndex]}.dat').localFile;
        _file.writeAsString(result.body);
        for (var item in parsed) {
          if (verbose >= 1) print('$item\n${item.runtimeType}');
        }
      }
      return true;
    } else {
      return false;
    }
  }*/

  Future<Void> getUserData() async {
    bool result;
    if (verbose >=1) print('First try read from file');
    result = await readFromFile();
    if (verbose >=1) print('result of file reading? $result');
    if (!result) {
      if (verbose >=1) print('Second try get from server');
      String res = await RestAPI().userDataGet(guids[currentGuidIndex], devKey);
      if (verbose >=1) print(res);
    }
    return null;
  }
}