import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myevpanet/login_screen/order_screen.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/main_screen/main_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myevpanet/api/api.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginWidgetState();
}

class LoginWidgetState extends State with SingleTickerProviderStateMixin{
  final String assetName = 'assets/images/evpanet_auth_logo.svg';
  bool isLoading = false;
  Widget _buildLogoTop(){
    return Padding(
        padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 16
        ),
        child: SvgPicture.asset(assetName, color: Colors.blue,)
    );
  }

  var phone = new MaskTextInputFormatter(mask: '+# (###) ###-##-##', filter: { "#": RegExp(r'[0-9]') });
  var uid = new MaskTextInputFormatter(mask: '#####', filter: { "#": RegExp(r'[0-9]') });

  Widget _buildEmailField() {
    return Padding(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
        ),
        child: TextField(
          //controller: textEditingController,
          inputFormatters: [phone],
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Номер телефона'
          ),
        )
    );
  }

  Widget _buildPasswordField() {
    return Padding(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
        ),
        child: TextField(
          inputFormatters: [uid],
          //controller: uid,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ваш ИД (ID)'
          ),
        )
    );
  }

  Widget _buildSubmitButton() {
    return
      RaisedButton(
        onPressed: devKey != null ? authButtonPressed : null,
        color: Theme.of(context).primaryColorDark,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                devKey != null ? 'Войти в личный кабинет' : 'Нет доступа к интернету',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Авторизация"),
      ),
      body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Container(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 24.0,
                                        right: 24.0
                                    ),

                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        _buildLogoTop(),
                                        _buildEmailField(),
                                        _buildPasswordField(),
                                        new Padding(padding: EdgeInsets.all(16.0),
                                          child: _buildSubmitButton(),
                                        ),
                                      ],
                                    )
                                )
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                isLoading ? SpinKitThreeBounce(
                                  size: 51.0,
                                  color: Colors.blue,
                                  controller: AnimationController(vsync: this, duration: const Duration(seconds: 3)),
                                ) :
                                Text(
                                  "",
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: devKey != null ? () {
          // Тут колбасим открытие новой страницы с возможностью оставить заявку на подключение (Используем новый API).
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MakeOrder()));
        } : null,
        label: Text('Оставить заявку'),
        icon: Icon(Icons.person_add),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }

  void authButtonPressed() async {
    var _phoneNumber = phone.getUnmaskedText();
    var _userID = 0;
    if (uid.getUnmaskedText() != '') {
      _userID = int.parse(uid.getUnmaskedText());
    }

    if (_phoneNumber.length == 11 && _userID > 0) {
      //номер телефона достаточной длины и ИД тоже корректный можно идти дальше
      var phone = int.parse(_phoneNumber);
      var id = _userID;
      if (verbose >=1) print('Entered phone number is: $phone');
      if (verbose >=1) print('Entered ID is: $id');

      //requesting auth from server
      Map<String, String> result = await RestAPI().authorizeUserPOST('+' + phone.toString(), id, devKey);

      //обработка ответа сервера
      bool _checks = true;
      if (result['answer'] == 'isFull') {
        var _body = json.decode(result['body']);
        if (verbose >=1) print(_body);
        if (!_body['error']) {
          //ошибок нет. в ответе лежат гуиды
          guids = _body['message']['guids'];
        } else {
          //в ответе есть ошибка и ее значение выводим
          _checks = false;
          if (verbose >= 1) print('Got Error: ${_body['message']}');
          Fluttertoast.showToast(
            msg: "Абонент(ов) с такими данными не найдено",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          );
        }
      } else {
        //ответ был не получен из-за ошибки сети
        _checks = false;
        if (verbose >=1) print('network error :(');
      }
      if (_checks) {
        setState(() => isLoading = true);
        if (verbose >=1) print('Got good GUID(s)');
        //fbHelper.saveDeviceToken(result);
        //save guids to file
        if (verbose >=1) print(guids);
        final _guidsfile = await FileStorage('guidlist.dat').localFile;
        _guidsfile.writeAsString(result.toString(), mode: FileMode.write, encoding: utf8);
        currentGuidIndex = 0;
        for (var guid in guids) {
          var usersRequest = await RestAPI().userDataGet(guid, devKey);
          if (verbose >=1) print('$guid: $usersRequest');
          currentGuidIndex++;
        }
        currentGuidIndex = 0;
        setState(() => isLoading = false);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MainScreenWidget()));
      }
    } else {
      Fluttertoast.showToast(
        msg: "Введены некорректные данные",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }
}

