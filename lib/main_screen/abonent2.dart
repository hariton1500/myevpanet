import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:myevpanet/webview_screens/pay_widget.dart';

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
      width: MediaQuery.of(context).size.width,
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
            stops: [0.2, 1.0],
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      //crossAxisAlignment: CrossAxisAlignment.end,
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
                            onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PayView()));},
                            icon: const Icon(MaterialCommunityIcons.wallet_plus_outline, size: 15),
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
                      size: 35.0
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
