import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:myevpanet/helpers/DesignHelper.dart';
import 'package:myevpanet/webview_screens/pay_widget.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import '../main.dart';

class Abonent2 extends StatelessWidget {
  final int item;
  final int daysRemain;
  final Color packetEndColor;
  final String id;
  final double balance;
  final String name;
  final String endDate;
  Abonent2(this.item, this.daysRemain, this.packetEndColor, this.id, this.balance, this.name, this.endDate);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 1.0, right: 1.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: const Color.fromRGBO(52, 79, 100, 1.0)
          ),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: const Color.fromRGBO(184, 202, 220, 1.0),
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: const Offset(1.0, 2.0)
            )
          ],
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.2,
              1.0,
            ],
            colors: [
              const Color.fromRGBO(68, 98, 124, 1),
              const Color.fromRGBO(10, 33, 51, 1)
            ]
          )
        ),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                //color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'ID: $id',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          const Shadow(
                            blurRadius: 1.0,
                            color: Colors.black,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text("Доступный баланс",
                          //textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: Color.fromRGBO(144, 198, 124, 1),
                            fontSize: 12.0,
                          ),
                        ),
                        Text(NumberFormat('#,##0.00##', 'ru_RU').format(balance) + " р.",
                          style: TextStyle(
                            color: balance < 0
                                ? const Color.fromRGBO(255, 81, 105, 1)
                                : Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              const Shadow(
                                blurRadius: 1.0,
                                color: Colors.black,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          )
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(width: 120, height: 30),
                          child: TextButton.icon(
                            onPressed: (){},
                            icon: const Icon(Icons.payment, size: 15),
                            label: const Text('Пополнить',
                              style: const TextStyle(
                                fontSize: 13
                              ),
                            )
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$name',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(166, 187, 204, 1),
                      shadows: [
                        const Shadow(
                          blurRadius: 1.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                //color: Colors.cyan,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const Text(
                          'Окончание действия пакета',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            shadows: [
                              const Shadow(
                                blurRadius: 1.0,
                                color: Colors.black,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '$endDate (${daysRemain.toString()} дн.)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: packetEndColor,
                            shadows: [
                              const Shadow(
                                blurRadius: 1.0,
                                color: Colors.black,
                                offset: const Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ),
                    const Icon(
                      MaterialCommunityIcons.cogs,
                      color: Colors.white,
                      size: 30.0
                    ),  
                  ],
                )
              )
            ],
          ),
        ),
      )
    );
  }
}


class Abonent extends StatelessWidget {
  final int item;
  final int daysRemain;
  final Color packetEndColor;
  Abonent(this.item, this.daysRemain, this.packetEndColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0, bottom: 0.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: Color.fromRGBO(52, 79, 100, 1.0)
          ),
          borderRadius: BorderRadius.circular(
              ResponsiveFlutter.of(context).moderateScale(8)
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(184, 202, 220, 1.0),
              blurRadius: 5.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
              offset: Offset(
                1.0, // Move to right 10  horizontally
                2.0, // Move to bottom 10 Vertically
              ),
            )
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.2,
              1.0,
            ],
            colors: [
              Color.fromRGBO(68, 98, 124, 1),
              Color.fromRGBO(10, 33, 51, 1)
            ]
          )
        ),
        child: Container(
          padding: EdgeInsets.all(
            ResponsiveFlutter.of(context).moderateScale(20)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //верхняя часть
              Expanded(
                flex: 3,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      // Левая сторона верхнего блока
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'ID: ' + users[item]['id'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveFlutter.of(context).fontSize(2.4),
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
                          ),
                          //кнопка пополнения баланса
                          /*
                          ElevatedButton.icon(
                            icon: Icon(Icons.payment, size: 5.0,),
                            style: ButtonStyle(elevation: MaterialStateProperty.all(5.0), alignment: Alignment.centerLeft, fixedSize: MaterialStateProperty.all<Size>(Size.fromHeight(10.0)), padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero)),
                            label: Text('Пополнить', style: TextStyle(fontSize: 5),),
                            onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PayView()));},
                          ),
                          */
                          CircleButton(
                            size: 35.0, //animationSize.value,
                            onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PayView()));},
                            iconData: MaterialCommunityIcons.wallet_plus_outline
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      // Правая сторона верхнего блока
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 3.0, right: 4.0),
                            child: Text(
                              "Доступный баланс",
                              style: TextStyle(
                                color: Color.fromRGBO(144, 198, 124, 1),
                                fontSize: ResponsiveFlutter.of(context)
                                    .fontSize(1.6),
                              ),
                            ),
                          ),
                          Text(
                            NumberFormat('#,##0.00##', 'ru_RU').format(double.parse(users[item]["extra_account"])) + " р.",
                            style: TextStyle(
                              color: double.parse(users[item]["extra_account"]) < 0
                                  ? Color.fromRGBO(255, 81, 105, 1)
                                  : Colors.white,
                              fontSize: ResponsiveFlutter.of(context).fontSize(3.2),
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
                      ),
                    )
                  ],
                ),
              ),
              //средняя часть
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 0.0),
                      child: Text(
                        '${users[item]['name']}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: ResponsiveFlutter.of(context).fontSize(3),
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
                  ],
                ),
              ),
              //нижняя часть
              Expanded(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Окончание действия пакета',
                            style: TextStyle(
                              fontSize: ResponsiveFlutter.of(context).fontSize(1.4),
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 1.0,
                                  color: Colors.black,
                                  offset: Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            userInfo["packet_end"] +
                                " (" +
                                daysRemain.toString() +
                                " дн.)",
                            style: TextStyle(
                              fontSize: ResponsiveFlutter.of(context)
                                  .fontSize(1.8),
                              fontWeight: FontWeight.bold,
                              color: packetEndColor,
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
                    Expanded(
                      flex: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Icon(
                              MaterialCommunityIcons.cogs,
                              color: Colors.white,
                              size: 40.0,
                            ),
                          )
                        ],
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}