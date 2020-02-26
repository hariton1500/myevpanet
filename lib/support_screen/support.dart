import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:myevpanet/helpers/DesignHelper.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
//import 'package:flutter/semantics.dart';
//import 'package:myevpanet/main.dart';

class SupportScreen extends StatefulWidget {

  SupportScreen({Key key, this.title}) : super(key: key);
  final String title;

   @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {

  @override
  void initState() {
    super.initState();
  }

  _launchURL(url) async {
    //const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    final double appBarHeight = 66.0;

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
                          'Оставить сообщение',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0
                          ),
                        ),
                      ),
                      ),
                    ],
                  ),
                ),
                pinned: true,
                expandedHeight: 170,
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
                      padding: new EdgeInsets.only(top: appBarHeight + 10.0),
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
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'Ф.И.О.: ' + userInfo['name'].toString(),
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
                                'Ваш ID: ' + userInfo['id'].toString(),
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
                    ),
                  ),
                )
            ),
            new SliverList(
                delegate: new SliverChildListDelegate([
                  Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: TextField(
                                autofocus: true,
                                maxLines: 4,
                                //inputFormatters: [phone],
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
                            Center(
                                child: RaisedButton(
                                    onPressed: sendMessagePressed,
                                    child: Text('Отправить в службу поддержки')
                                )
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 20.0
                              ),
                                child: Column(
                                  children: <Widget>[
                                    Text("Вы так же можете связаться со службой поддержки одним из следующих способов:"),
                                    RaisedButton.icon(
                                        elevation: 2.0,
                                        onPressed: _launchURL("tel://+79787173865"),
                                        icon: null,
                                        label: Text("+79787173865")
                                    ),
                                  ],
                                )
                            ),
                          ]
                      ),
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );

/*    return Scaffold(
      appBar: AppBar(
        title: Text('Сообщение в службу поддержки', style: TextStyle(fontSize: 14)),
      ),
      body: ListView(
        children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    *//*Center(
                      child: Text('Сообщение в службу поддержки:')
                    ),*//*
                    Center(
                      child: TextField(
                        maxLines: 10,
                        //inputFormatters: [phone],
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Введите текст сообщения'
                        ),
                      ),
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: sendMessagePressed,
                        child: Text('Отправить в службу поддержки')
                      )
                    )
                  ]
                )
              ),
        ]
      )
    );*/
  }
  void sendMessagePressed() {

  }
}
