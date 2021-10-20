import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/main_screen/main_widget.dart';
//import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:myevpanet/api/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:myevpanet/webview_screens/order_widget.dart';

class LoginWidget2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginWidgetState2();
}

class LoginWidgetState2 extends State with SingleTickerProviderStateMixin {
  
  bool keyboardIsActive = false; //определяет состояние клавиатуры

  @override
  void initState() {
    super.initState();
    currentGuidIndex = 0;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  //final String assetName = 'assets/images/evpanet_auth_logo.svg';
  final String assetName = 'assets/images/splash_logo.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff11273c), Color(0xff3c5d7c)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height
            ),
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _buildLogoTop(),
                  _buildPhoneField(),
                  _buildUIDField(),
                  _buildSubmitButton(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: LinearProgressIndicator(
                        value: currentGuidIndex /
                            (guids.isNotEmpty ? guids.length : 1),
                        backgroundColor: Color(0xff3c5d7c),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 15.0),
                              child: Divider(
                                color: Color(0xffd3edff),
                                height: 50,
                              )),
                        ),
                        Text(
                          "или",
                          style: const TextStyle(
                              color: Color(0xffd3edff),
                              fontSize: 15),
                        ),
                        Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(
                                  left: 15.0, right: 10.0),
                              child: Divider(
                                color: Color(0xffd3edff),
                                height: 50,
                              )),
                        ),
                      ]
                    ),
                  ),
                  _buildConnectRequestButton(),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }

  void authButtonPressed() async {
    //SystemChannels.textInput.invokeMethod('TextInput.hide');
    var _phoneNumber = phone.getUnmaskedText();
    var _userID = 0;
    if (uid.getUnmaskedText() != '') {
      _userID = int.parse(uid.getUnmaskedText());
    }

    if (_phoneNumber.length == 11 && _userID > 0) {
      //номер телефона достаточной длины и ИД тоже корректный можно идти дальше
      var phone = int.parse(_phoneNumber);
      var id = _userID;
      if (verbose >= 1) print('Entered phone number is: $phone');
      if (verbose >= 1) print('Entered ID is: $id');

      //requesting auth from server
      Map<String, String> result =
          await RestAPI().authorizeUserPOST('+' + phone.toString(), id, devKey);

      //обработка ответа сервера
      bool _checks = true;
      if (result['answer'] == 'isFull') {
        var _body = json.decode(result['body']);
        if (verbose >= 1) print(_body);
        if (!_body['error']) {
          //ошибок нет. в ответе лежат гуиды
          if (registrationMode == 'new') {
            guids = _body['message']['guids'];
          } else {
            //здесь надо к списку гуидов добавить еще гуиды без повторений
            for (var addGuid in _body['message']['guids']) {
              if (!guids.contains(addGuid)) guids.add(addGuid);
            }
            registrationMode = 'new';
          }
        } else {
          //в ответе есть ошибка и ее значение выводим
          _checks = false;
          if (verbose >= 1) print('Got Error: ${_body['message']}');
          Fluttertoast.showToast(
              msg: "Абонент(ов) с такими данными не найдено",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        //ответ был не получен из-за ошибки сети
        _checks = false;
        if (verbose >= 1) print('network error :(');
      }
      if (_checks) {
        if (verbose >= 1) print('Got good GUID(s)');
        //fbHelper.saveDeviceToken(result);
        //сохранение списка гуидов в файл
        if (verbose >= 1) print(guids);
        final _guidsfile = await FileStorage('guidlist.dat').localFile;
        _guidsfile.writeAsString(jsonEncode(guids),
            mode: FileMode.write, encoding: utf8);
        currentGuidIndex = 0;
        //запрашиваем сервер данные всех пользователей и сохраняем (обновляем) файлы
        for (var guid in guids) {
          var usersRequest = await RestAPI().userDataGet(guid, devKey);
          if (verbose >= 1) print('$guid: $usersRequest');
          currentGuidIndex++;
          setState(() {});
        }
        currentGuidIndex = 0;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => MainScreenWidget()));
      }
    } else {
      Fluttertoast.showToast(
          msg: "Введены некорректные данные",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Widget _buildLogoTop() {
    return Center(
      child: keyboardIsActive ? Container() : Container(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
          right: 8,
          left: 8,
        ),
        child: Image.asset(
          assetName,
          color: Color(0xffd3edff),
        )
      )
    );
  }

  var phone = new MaskTextInputFormatter(
      mask: '+# (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
  var uid = new MaskTextInputFormatter(
      mask: '#####', filter: {"#": RegExp(r'[0-9]')});

  Widget _buildPhoneField() {
    return TextField(
      //controller: textEditingController,
      inputFormatters: [phone],
      keyboardType: TextInputType.phone,
      style: const TextStyle(color: Color(0xffd3edff), fontSize: 18.0),
      textCapitalization: TextCapitalization.characters,
      onTap: () {keyboardIsActive = true; setState(() {});},
      onChanged: (s) {keyboardIsActive = true; setState(() {});},
      onEditingComplete: () {keyboardIsActive = false; FocusScope.of(context).unfocus(); setState(() {});},
      decoration: const InputDecoration(
        labelText: 'Номер телефона',
        labelStyle: const TextStyle(
          color: Color(0xffd3edff),
          letterSpacing: 1,
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffd3edff))),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffd3edff)))),
    );
  }

  Widget _buildUIDField() {
    return TextField(
      inputFormatters: [uid],
      keyboardType: TextInputType.number,
      onTap: () {keyboardIsActive = true; setState(() {});},
      onChanged: (s) {keyboardIsActive = true; setState(() {});},
      onEditingComplete: () {keyboardIsActive = false; FocusScope.of(context).unfocus(); setState(() {});},
      style: const TextStyle(
        color: Color(0xffd3edff),
      ),
      decoration: const InputDecoration(
          labelText: 'Ваш ИД (ID)',
          labelStyle: TextStyle(
            color: Color(0xffd3edff),
            letterSpacing: 1,
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffd3edff))),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffd3edff)))),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 8,
        right: 8,
        left: 8,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Color(0x858eaac2),
            elevation: 0.0,
            shape: const RoundedRectangleBorder(
                side: BorderSide(color: Color(0xff95abbf)))),
        onPressed: devKey != null ? authButtonPressed : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                registrationMode == 'add' ? 'Добавить ' : 'Войти в кабинет ',
                //getAuthButtonPressed(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  String getAuthButtonPressed() {
    if (devKey == null) return 'Нет доступа к интернету ';
    switch (registrationMode) {
      case 'new':
        return 'Войти в кабинет ';
        break;
      case 'add':
        return 'Добавить ';
        break;
      default:
        return 'Войти в кабинет ';
    }
  }

  
  Widget _buildConnectRequestButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 8,
        right: 8,
        left: 8,
      ),
      child: ElevatedButton(
        //elevation: 0.0,
        style: ElevatedButton.styleFrom(
            primary: Color(0x858eaac2),
            elevation: 0.0,
            shape: const RoundedRectangleBorder(
                side: BorderSide(color: Color(0xff95abbf)))),
        onPressed: devKey != null
            ? () {
                // Тут колбасим открытие новой страницы с возможностью оставить заявку на подключение (Используем новый API).
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => OrderView()));
              }
            : null,
        //color: Color(0x408eaac2),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.person_add,
                color: Colors.white,
              ),
              Text(
                devKey != null ? ' Новое подключение' : 'Нет доступа к интернету',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
