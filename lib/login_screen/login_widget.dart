import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        onPressed: authButtonPressed,
        color: Theme.of(context).primaryColorDark,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Войти в личный кабинет',
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
        onPressed: () {
          // Тут колбасим открытие новой страницы с возможностью оставить заявку на подключение (Используем новый API).
        },
        label: Text('Оставить заявку'),
        icon: Icon(Icons.person_add),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }


  void authButtonPressed() async {

    //var _model = ScopedModel.of<MainModel>(context);
    var _phoneNumber = phone.getUnmaskedText();
    var _userID = 0;
    if (uid.getUnmaskedText() != '') {
      _userID = int.parse(uid.getUnmaskedText());
    }

    print(_userID);
    print(_phoneNumber.length);

    if (_phoneNumber.length == 11 && _userID > 0) {
      //_model.updatePhone(int.parse(_phoneNumber));
      //_model.updateID(_userID);
      var phone = int.parse(_phoneNumber);
      var id = _userID;
      print('Entered phone number is: $phone');
      print('Entered ID is: $id');
      //requesting auth from server
      var _url = 'https://app.evpanet.com/';
      _url += '?reg&t=$phone&id=$id';
      _url += '&devid=$devKey';

      var result = await RestAPI().getData(_url);
      print(result);
      bool _checks = true;
      if (result.toString().contains('00000000-0000-0000-C000-000000000046')) {
        print('Auth failed. No such users.');
        Fluttertoast.showToast(
        msg: "Такой пользователь не найден",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
        );
        _checks = false;
      }
      print(result.toString().length);
      if (result.toString().length < 38) {
        print('Got bad answer. Do nothing');
        _checks = false;
      }
      if (result.toString().contains('Exception')) {
        print('Got Exception Error');
        _checks = false;
      }
      if (_checks) {
        setState(() => isLoading = true);
        print('Got good GUID(s)');
        //fbHelper.saveDeviceToken(result);
        guids = json.decode(result);
        //save guids to file
        print(guids);
        final _guidsfile = await FileStorage('guidlist.dat').localFile;
        _guidsfile.writeAsString(result.toString(), mode: FileMode.write, encoding: utf8);
        currentGuidIndex = 0;
        for (var guid in guids) {
          var usersRequest = await UserInfo().getUserInfoFromServer();
          print('$guid: $usersRequest');
          currentGuidIndex++;
        }
        currentGuidIndex = 0;
        setState(() => isLoading = false);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MainScreenWidget()));
      }
      //_url = 'https://evpanet.com/api/apk/login/user';
      //var newres = await RestAPI().postData(_url, _model.phone, _model.id, int.parse(_model.dev_key));
      //print(newres);
      //print('Go to Main Screen');
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MainScreenWidget()));
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

