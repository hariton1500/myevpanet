import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:myevpanet/helpers/DesignHelper.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myevpanet/api/api.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/main_screen/radio.dart';

class SetupGroup extends StatefulWidget {
  @override
  SetupGroupWidget createState() => SetupGroupWidget();
}
//var _tarifs = userInfo["allowed_tarifs"];
Map initialTarif;
class SetupGroupWidget extends State {
  bool autoState;
  bool parentState;
  @override
  void initState() {
    autoState = userInfo['auto_activation'] == 1 ? true : false;
    parentState = userInfo['flag_parent_control'] == 1 ? true : false;
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
          userInfo['auto_activation'] = autoState ? 1 : 0;
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
          userInfo['auto_activation'] = parentState ? 1 : 0;
        }
      }
    );
  }

  // это можно вынести в отдельный файл
  void showModalSupport() async{
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
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
                              autofocus: true,
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                //hintText: "Напишите нам",
                                labelText: "Ваше сообщение",
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
                                color: Theme.of(context).primaryColor,
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
                              Navigator.pop(context);
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
                      Container(child: Padding(
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
                      GestureDetector(
                        child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              MaterialCommunityIcons.face_agent,
                              color: Colors.white,
                              size: 32.0,
                            )
                        ),
                        onTap: () {
                          //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SupportScreen()));
                          showModalSupport();
                          },
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
                                                  onTap: () => print("Cool"), // Харитон, тут надо тапнуть на новый скрин пополнения баланса
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
               new SliverList(
                 delegate: new SliverChildListDelegate([
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
/*                   Container(color: Colors.indigo, height: 150.0),
                   Container(color: Colors.blue, height: 150.0),*/
                 ],)
               ),
        ],
      ),
     ),
   );
  }
}
