import 'dart:math';
import 'dart:ui';
import 'package:myevpanet/helpers/DesignHelper.dart';
import 'package:myevpanet/main_screen/abonent2.dart';
import 'package:myevpanet/push_screen/pushList.dart';
import 'package:myevpanet/widgets/drawer.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/api/api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myevpanet/main_screen/setup/setups2.dart';

class MainScreenWidget extends StatefulWidget {
  //final Pushes _pushes = Pushes();
  MainScreenWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget>
    with TickerProviderStateMixin {
  String text = '';
  String phoneToCall = '+79780489664';
  DateFormat dateFormat;
  //Pushes pushes;
  bool isAllPushesSeen = true;
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    dprintL('MainScreen initState()');
    dprintL('Start getData');
    getData();
    Pushes pushes = Pushes();
    //pushes.loadSavedPushes().then((value) {
    isAllPushesSeen = pushes.isAllSeen();
    setState(() {});
    //});
    guids.forEach((guid) {
      pushes
          .getNewUnreadPushesFromServer(
              devKey, guid, int.parse(users[currentGuidIndex]['id']))
          .then((value) {
        isAllPushesSeen = pushes.isAllSeen();
        setState(() {});
      });
    });
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..repeat();
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          //isAllPushesSeen = pushes.isAllSeen();
        });
      });
    if (verbose >= 1) print('End getData');
    Intl.defaultLocale = 'ru_RU';
    initializeDateFormatting();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
      statusBarIconBrightness: Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness:
          Brightness.dark, //navigation bar icons' color
    ));
  }

  void getData() async {
    await UserInfo().getUserData();
    setState(() {});
    if (verbose >= 5) print('Main Screen: Show UserInfo:\n$userInfo');
  }

  int _current = 0;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    //contrller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(245, 246, 248, 1.0),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0), // here the desired height
          child: AppBar(
            iconTheme:
                new IconThemeData(color: Color.fromRGBO(72, 95, 113, 1.0)),
            titleSpacing: 0.0,
            brightness: Brightness.light,
            backgroundColor: Color.fromRGBO(245, 246, 248, 1.0),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Информация",
                  style: TextStyle(
                      color: Color.fromRGBO(72, 95, 113, 1.0), fontSize: 24.0),
                ),
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: TextStyle(
                      color: Color.fromRGBO(146, 152, 166, 1.0),
                      fontSize: 14.0),
                )
              ],
            ), // Your widgets here
            elevation: 0.0,
            actions: <Widget>[
              GestureDetector(
                child: Container(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
                    child: Icon(
                      MaterialCommunityIcons.phone,
                      color: Color.fromRGBO(72, 95, 113, 1.0),
                      size: 24.0,
                    )),
                onTap: () {
                  _showModalCallSupport();
                },
              ),
              GestureDetector(
                child: Container(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 16.0),
                    child: Icon(
                      MaterialCommunityIcons.face_agent,
                      color: Color.fromRGBO(72, 95, 113, 1.0),
                      size: 24.0,
                    )),
                onTap: () {
                  _showModalSupport();
                },
              ),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 10.0, right: 16.0, left: 16.0),
                  child: isAllPushesSeen
                      ? Icon(Icons.notifications_none_outlined, size: 24.0)
                      : Transform(
                          alignment: FractionalOffset.center,
                          transform: Matrix4.identity()
                            //..setEntry(3, 2, 0.002)
                            ..rotateY(pi * animation.value),
                          //animation: animation,
                          child: Icon(Icons.notifications_active, size: 24.0),
                        ),
                ),
                onTap: () async {
                  //await pushes.loadSavedPushes();
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => PushScreen()));
                  Pushes pushes = Pushes();
                  //await pushes.loadSavedPushes();
                  setState(() {
                    isAllPushesSeen = pushes.isAllSeen();
                  });
                },
              ),
            ],
          ),
        ),
        body: Column(children: [
          // каруселька
          Container(
            child: CarouselSlider(
              items: idList(),
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                height: MediaQuery.of(context).size.width / 1.8,
                //aspectRatio: 16 / 12,
                viewportFraction: 0.8,
                onPageChanged: (index, reason) {
                  currentGuidIndex = index;
                  userInfo = users[currentGuidIndex];
                  _current = index;
                  setState(() {});
                }
              ),
            ),
          ),
          // навигационные точечки
          Container(
            //padding: EdgeInsets.all(5.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: idListPoints()),
          ),
          // секция с картами деталей учетной записи
          Expanded(
            child: ListView(
              physics: ScrollPhysics(parent: BouncingScrollPhysics()),
              padding: EdgeInsets.only(top: 0.0, left: 30.0, right: 30.0),
              children: <Widget>[
                // виджет отображения долга
                Container(
                    child: Column(
                  children: <Widget>[
                    double.parse(users[currentGuidIndex]["debt"]) > 0
                        ? Card(
                            color: Colors.red,
                            child: new ListTile(
                              title: Text(
                                "За Вашей учётной записью числится задолженость ${users[currentGuidIndex]["debt"].toString()} р.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                        : Container(),
                  ],
                )),
                // текст - Детали учетной записи
                Container(
                  padding: EdgeInsets.only(left: 40.0, top: 10.0, bottom: 10.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Детали учётной записи',
                    style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(2.7),
                        color: Color.fromRGBO(72, 95, 113, 1.0),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Card(
                      child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.album, size: 40),
                          title: Text('Тарифный план'),
                          subtitle: Text(
                              '${users[currentGuidIndex]["tarif_name"]} (${users[currentGuidIndex]["tarif_sum"].toString()} р.)'),
                        ),
                      ],
                    ),
                  )),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Card(
                      child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.album, size: 40),
                          title: Text('IP адрес абонента'),
                          subtitle: Text(users[currentGuidIndex]["real_ip"]),
                        ),
                      ],
                    ),
                  )),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Card(
                      child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.album, size: 40),
                          title: Text('Адрес подключения'),
                          subtitle: Text(users[currentGuidIndex]["street"] +
                              ", д. " +
                              users[currentGuidIndex]["house"] +
                              ", кв. " +
                              users[currentGuidIndex]["flat"]),
                        ),
                      ],
                    ),
                  )),
                ),
              ],
            ),
          )
        ]));
  }

  // генерируем точки
  List<Widget> idListPoints() {
    List<Widget> _list = [];
    for (var item = 0; item < guids.length; item++ /*users.keys*/) {
      _list.add(Container(
        width: 8.0,
        height: 8.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _current == item
                ? Color.fromRGBO(116, 162, 177, 1.0)
                : Color.fromRGBO(198, 209, 216, 1.0)),
      ));
    }
    return _list;
  }

  // список тёмных плашек
  List<Widget> idList() {
    List<Widget> _list = [];
    for (var item = 0; item < guids.length; item++ /*users.keys*/) {
      var now = DateTime.now().toUtc();
      var packet = DateTime.parse(users[item]["packet_end_utc"]).toUtc();
      var daysRemain = packet.difference(now).inDays;

      var packetEndColor = Colors.white;

      if (daysRemain > 0 && daysRemain < 1) {
        packetEndColor = Colors.amber;
      } else if (daysRemain <= 0) {
        packetEndColor = Colors.red;
      }

      _list.add(GestureDetector(
          onTap: () async {
            //print('!!!!!!!!! current index is: $currentGuidIndex');
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SetupGroup()));
            setState(() {});
          },
          child: Abonent2(item, daysRemain, packetEndColor, users[item]['id'], double.parse(users[item]["extra_account"]), users[item]['name'], userInfo["packet_end"])
      ));
    }
    return _list;
  }

  // Вызов модального окна с сообщением в ремонты
  _showModalSupport() async {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Color(0xff2c4860),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: SupportMessageModal());
        });
  }

  //  Вызов модального окна для совершения звонка
  _showModalCallSupport() async {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Color(0xff2c4860),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Dialog(
              backgroundColor: Colors.transparent, child: CallWindowModal());
        });
  }
}
