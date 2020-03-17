import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:myevpanet/helpers/DesignHelper.dart';
import 'package:myevpanet/webview_screens/pay_widget.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myevpanet/api/api.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/main_screen/radio.dart';
import 'package:url_launcher/url_launcher.dart';

class SetupGroup extends StatefulWidget {
  @override
  SetupGroupWidget createState() => SetupGroupWidget();
}
Map initialTarif;
class SetupGroupWidget extends State {
  bool autoState = users[currentGuidIndex]['auto_activation'] == 1 ? true : false;
  bool parentState = users[currentGuidIndex]['flag_parent_control'] == 1 ? true : false;
  String text = '';
  double _currentDays = 1;
  String daysText = 'день';
  //String text = '';
  String phoneToCall = '+79780489664';

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
      statusBarIconBrightness: Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness: Brightness.light, //navigation bar icons' color
    ));
  }

  void onSetupAutoChange(value) async{
    String answer = await RestAPI().switchChangePUT('activation', guids[currentGuidIndex], devKey);
    setState(
      () {
        if (answer == 'isEmpty' || answer == 'Exception') {
          autoState = !value;
        } else {
          autoState = value;
          users[currentGuidIndex]['auto_activation'] = autoState ? 1 : 0;
          userInfo = users[currentGuidIndex];
        }
      }
    );
  }
  void onSetupParentChange(bool value) async{
    String answer = await RestAPI().switchChangePUT('parent', guids[currentGuidIndex], devKey);
    setState(
      () {
        if (answer == 'isEmpty' || answer == 'Exception') {
          parentState = !value;
        } else {
          parentState = value;
          users[currentGuidIndex]['flag_parent_control'] = parentState ? 1 : 0;
          userInfo = users[currentGuidIndex];
        }
      }
    );
  }

  // это можно вынести в отдельный файл
  /*
  * Вызов модального окна с сообщением в ремонты
  * */
  void _showModalSupport() async{
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Color(0xff2c4860),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(left: 0.0,right: 0.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 18.0,
                    ),
                    margin: EdgeInsets.only(top: 13.0,right: 8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 0.0,
                            offset: Offset(0.0, 0.0),
                          ),
                        ]
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom: 20.0
                          ),
                          alignment: Alignment.topCenter,
                          child: Center(
                            child: Text(
                              'Отправка сообщения в службу технической поддержки',
                              style: TextStyle(
                                  fontSize: ResponsiveFlutter.of(context).fontSize(2),
                                  color: Color.fromRGBO(72, 95, 113, 1.0),
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                          ),
                          child: TextField(
                            onChanged: (_text) {
                              text = _text;
                            },
                            autofocus: true,
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              //hintText: "Напишите нам",
                              labelText: "Ваше сообщение",
                              labelStyle: TextStyle(
                                color: Color(0xff374b5d),
                                letterSpacing: 1,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Color(0xff374b5d),
                                  style: BorderStyle.solid,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Colors.amber,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.only(top: 15.0,bottom:15.0),
                            decoration: BoxDecoration(
                              color: Color(0xff374b5d),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(6.0),
                                  bottomRight: Radius.circular(6.0)),
                            ),
                            child:  Text(
                              "Отправить сообщение",
                              style: TextStyle(color: Colors.white,fontSize: 20.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap:(){
                            _sendMessagePressed();
                          },
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  void _sendMessagePressed() async{
    String answer = await RestAPI().remontAddPOST(text, guids[currentGuidIndex], devKey);
    print(answer);
    Navigator.pop(context);
  }
/*
 *  Вызов модального окна для совершения звонка
 * */
  void _showModalCallSupport() async{
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Color(0xff2c4860),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(left: 0.0,right: 0.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 18.0,
                    ),
                    margin: EdgeInsets.only(top: 13.0,right: 8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 0.0,
                            offset: Offset(0.0, 0.0),
                          ),
                        ]
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(
                                16.0
                            ),
                            child: Column(
                              children: <Widget>[
                                Text("Пожалуйста выберите один из номеров технической поддержки."),
                                DropdownButton<String>(
                                    value: phoneToCall,
                                    autofocus: true,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        phoneToCall = newValue;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem(
                                          value: '+79780489664',
                                          child: Text('+7 (978) 048-96-64')
                                      ),
                                      DropdownMenuItem(
                                          value: '+79780755900',
                                          child: Text('+7 (978) 075-59-00')
                                      ),
                                    ]
                                ),
                              ],
                            )
                        ),
                        SizedBox(height: 24.0),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.only(top: 15.0,bottom:15.0),
                            decoration: BoxDecoration(
                              color: Color(0xff374b5d),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(6.0),
                                  bottomRight: Radius.circular(6.0)),
                            ),
                            child:  Text(
                              "Совершить звонок",
                              style: TextStyle(color: Colors.white,fontSize: 20.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () async{
                            if (await canLaunch('tel://$phoneToCall')) launch('tel://$phoneToCall');
                          },
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );

  }

  /*
  * Вызов модального окна для отправки СМС
  * */

  void _showModalSMSSupport() async{
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Color(0xff2c4860),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(left: 0.0,right: 0.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 18.0,
                    ),
                    margin: EdgeInsets.only(top: 13.0,right: 8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 0.0,
                            offset: Offset(0.0, 0.0),
                          ),
                        ]
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(
                                16.0
                            ),
                            child: Column(
                              children: <Widget>[
                                Text("Пожалуйста выберите один из номеров технической поддержки."),
                                DropdownButton<String>(
                                    value: phoneToCall,
                                    autofocus: true,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        phoneToCall = newValue;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem(
                                          value: '+79780489664',
                                          child: Text('+7 (978) 048-96-64')
                                      ),
                                      DropdownMenuItem(
                                          value: '+79780755900',
                                          child: Text('+7 (978) 075-59-00')
                                      ),
                                    ]
                                ),
                              ],
                            )
                        ),
                        SizedBox(height: 24.0),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.only(top: 15.0,bottom:15.0),
                            decoration: BoxDecoration(
                              color: Color(0xff374b5d),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(6.0),
                                  bottomRight: Radius.circular(6.0)),
                            ),
                            child:  Text(
                              "Отправить СМС",
                              style: TextStyle(color: Colors.white,fontSize: 20.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () async{
                            if (await canLaunch('sms://$phoneToCall')) launch('sms://$phoneToCall');
                          },
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );

  }

  void onAddDaysButtonPressed() async {
    String answer = await RestAPI().addDaysPUT(_currentDays.round(), guids[currentGuidIndex], devKey);
    if (!answer.startsWith('is')) {
      var decode = json.decode(answer);
      print(decode);
      //users[currentGuidIndex]['extra_account'] = decode['extra_account'];
      //users[currentGuidIndex]['packet_secs'] = decode['packet_secs'];
      //userInfo = users[currentGuidIndex];
      setState(() {});
    }
  }

  final double appBarHeight = 66.0;

  List<Widget> _list1() {
    List<Widget> tList = [];
    tList.add(
      SwitchListTile(
        activeColor: Color(0xff3e6282),
        dense: true,
        value: autoState,
        title: Text('Автоактивация пакета'),
        onChanged: (bool state) {onSetupAutoChange(state);},
      )
    );
    tList.add(
      SwitchListTile(
        activeColor: Color(0xff3e6282),
        dense: true,
        value: parentState,
        title: Text('Родительский контроль'),
        onChanged: (bool state) {onSetupParentChange(state);},
      )
    );
    return tList;
  }

  List<Widget> _list() {
    List<Widget> tList = [];
    tList.add(
        RadioGroup()
    );
    return tList;
  }

  @override
  Widget build(BuildContext context) {

    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return Container(
      child: Scaffold(
        body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                title: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Настройки',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                                padding: EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  right: 10.0
                                ),
                                child: Icon(
                                  MaterialCommunityIcons.phone,
                                  color: Colors.white,
                                  size: 24.0,
                                )
                            ),
                            onTap: () {
                              //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SupportScreen()));
                              _showModalCallSupport();
                            },
                          ),
                          GestureDetector(
                            child: Container(
                                padding: EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  right: 10.0
                                ),
                                child: Icon(
                                  MaterialCommunityIcons.email,
                                  color: Colors.white,
                                  size: 24.0,
                                )
                            ),
                            onTap: () {
                              //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SupportScreen()));
                              _showModalSMSSupport();
                            },
                          ),
                          GestureDetector(
                            child: Container(
                                padding: EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                ),
                                child: Icon(
                                  MaterialCommunityIcons.face_agent,
                                  color: Colors.white,
                                  size: 24.0,
                                )
                            ),
                            onTap: () {
                              //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SupportScreen()));
                              _showModalSupport();
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
                pinned: true,
                expandedHeight: 330,
                flexibleSpace:
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [
                              0.2,
                              0.7,
                            ],
                            colors: [Color.fromRGBO(68, 98, 124, 1), Color.fromRGBO(15, 34, 51, 1)]
                        )
                    ),
                    child: FlexibleSpaceBar(
                      background: Container(
                        padding: new EdgeInsets.only(top: statusBarHeight + appBarHeight),
                        height: ResponsiveFlutter.of(context).verticalScale(330),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 7.0,
                                            right: 4.0
                                        ),
                                        child: Center(
                                          child: Text("Доступный баланс",
                                            style: TextStyle(
                                              color: Color.fromRGBO(144, 198, 124, 1),
                                              fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(
                                                  right: 5.0
                                              ),
                                              child: CircleButton(
                                                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PayView())), // Харитон, тут надо тапнуть на новый скрин пополнения баланса
                                                  iconData: MaterialCommunityIcons.wallet_plus_outline
                                              ),
                                            ),
                                           Text(
                                             NumberFormat('#,##0.00##', 'ru_RU').format(double.parse(userInfo["extra_account"])) + " р.",
                                             //userInfo["extra_account"],
                                             style: TextStyle(
                                               color: double.parse(userInfo["extra_account"]) < 0 ? Color.fromRGBO(255, 81, 105, 1) : Color.fromRGBO(217, 234, 244, 1),
                                               fontSize: ResponsiveFlutter.of(context).fontSize(3.7),
                                               fontWeight: FontWeight.bold,
                                               shadows: [
                                                 Shadow(
                                                   blurRadius: 1.0,
                                                   color: Colors.black,
                                                   offset: Offset(1.0, 1.0),
                                                 ),
                                               ],
                                             ),
                                           ),
                                         ],
                                        )
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.0,
                                            right: 4.0
                                        ),
                                        child: Center(
                                          child: Text(
                                            userInfo["tarif_name"] + " (" + userInfo["tarif_sum"].toString() + " р.)",
                                            style: TextStyle(
                                              color: Color(0xff82a0d7),
                                              fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                )
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: EdgeInsets.all(30.0),
                                    child: Card(
                                      elevation: 3.0,
                                      child: Container(
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            //border: Border.all(width: 1.0, color: Color.fromRGBO(52, 79, 100, 1.0)),
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                stops: [
                                                  0.2,
                                                  0.7,
                                                ],
                                                colors: [
                                                  Color.fromRGBO(52, 82, 108, 1.0),
                                                  Color.fromRGBO(28, 49, 70, 1.0)
                                                ]
                                            )
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  //textScaleFactor1.toString(),
                                                  '${userInfo['name']}'.toUpperCase(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: ResponsiveFlutter.of(context).fontSize(1.8),
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(166, 187, 204, 1),
                                                    shadows: [
                                                      Shadow(
                                                        blurRadius: 1.0,
                                                        color: Colors.black,
                                                        offset: Offset(1.0, 1.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )

                                            ),
                                            Expanded(
                                              flex: 1,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                              padding: EdgeInsets.all(5.0),
                                                              child: Text(
                                                                'ID: ' + userInfo['id'].toString(),
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
                                                                  shadows: [
                                                                    Shadow(
                                                                      blurRadius: 1.0,
                                                                      color: Colors.black,
                                                                      offset: Offset(1.0, 1.0),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.all(5.0),
                                                              child: Text(
                                                                'Логин: ' + userInfo['login'].toString(),
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
                                                                  shadows: [
                                                                    Shadow(
                                                                      blurRadius: 1.0,
                                                                      color: Colors.black,
                                                                      offset: Offset(1.0, 1.0),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                    ),

                                                  ],
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [
                                  0.2,
                                  0.7,
                                ],
                                colors: [Color.fromRGBO(68, 98, 124, 1), Color.fromRGBO(15, 34, 51, 1)]
                            )
                        ),
                      ),
                    ),
                  )
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      padding: EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 16.0,
                        bottom: 10.0
                      ),
                        child: Column(
                          children: _list1(),
                      ),
                    ),
                    Divider(
                      indent: 20.0,
                      endIndent: 20.0,
                      color: Color(0xff3e6282),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 16.0,
                          left: 16.0,
                          right: 16.0,
                      ),
                      child: Text(
                        'Доступные тарифные планы',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                            color: Color.fromRGBO(72, 95, 113, 1.0),
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 10.0,
                          right: 16.0,
                          left: 16.0
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: 16.0
                        ),
                        child: Column(
                          children: _list(),
                        ),
                      ),
                    ),
                    Divider(
                      indent: 20.0,
                      endIndent: 20.0,
                      color: Color(0xff3e6282),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 10.0,
                          right: 16.0,
                          left: 16.0
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: 16.0
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Добавление дней к текущему пакету',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: ResponsiveFlutter.of(context).fontSize(2.0),
                                color: Color.fromRGBO(72, 95, 113, 1.0),
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text('Стоимость одного дня - ${users[currentGuidIndex]['days_price']} руб.'),
                            Slider(
                              value: _currentDays.roundToDouble(),
                              onChanged: (double days) => setState(() {
                                _currentDays = days;
                                if ((days % 10).round() == 0) daysText = 'дней';
                                if ((days % 10).round() == 1) daysText = 'день';
                                if ((days % 10).round() >= 2) daysText = 'дня';
                                if ((days % 10).round() >= 5) daysText = 'дней';
                                if (days.round() >= 11 && days.round() <= 14) daysText = 'дней';
                              }),
                              min: 1,
                              max: users[currentGuidIndex]['max_days'] >= 1 ? users[currentGuidIndex]['max_days'].toDouble() : 1,
                              divisions: users[currentGuidIndex]['max_days'] > 0 ? users[currentGuidIndex]['max_days'] - 1 : null,
                              label: _currentDays.round().toString(),
                            ),
                            users[currentGuidIndex]['max_days'] > 0 ?
                            RaisedButton(
                              onPressed: onAddDaysButtonPressed,
                              elevation: 15,
                              child: Text('Добавить ${_currentDays.round()} $daysText'),
                            ) :
                            Text('Недостаточно средств для добавления дней'),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ),
        ],
      ),
     ),
   );
  }
}
