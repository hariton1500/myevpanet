import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/main_screen/main_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:scoped_model/scoped_model.dart';
//import 'package:myevpanet/scoped_models/main_model.dart';
import 'package:myevpanet/api/api.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginWidgetState();
}

class LoginWidgetState extends State with SingleTickerProviderStateMixin{
  final String assetName = 'images/evpanet_auth_logo.svg';
  bool isLoading = false;
  Widget _buildLogoTop(){
    return Padding(
        padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 32,
            bottom: 16
        ),
        child: SvgPicture.asset(assetName)
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
        color: Theme.of(context).accentColor,
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
    //var _model = ScopedModel.of<MainModel>(context);
    return
      Scaffold(
        body:
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _buildLogoTop(),
                  _buildEmailField(),
                  _buildPasswordField(),
                  isLoading ? SpinKitCubeGrid(
                    size: 51.0,
                    color: Colors.blue,
                    controller: AnimationController(vsync: this, duration: const Duration(seconds: 1)),
                    ) : Text(''),
                  new Padding(padding: EdgeInsets.all(16.0),
                    child: _buildSubmitButton(),
                  ),
                ],
              )
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
        guids = json.decode(result);
        //save guids to file
        print(guids);
        final _guidsfile = await FileStorage('guidlist.dat').localFile;
        _guidsfile.writeAsString(result.toString(), mode: FileMode.write, encoding: utf8);
        currentGuidIndex = 0;
        for (var guid in guids) {
          var usersRequest = await UserInfo().getUserInfoFromServer();
          print('$usersRequest');
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
    }
  }
}

