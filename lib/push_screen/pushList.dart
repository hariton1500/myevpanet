import 'package:flutter/material.dart';
import '../main.dart';

class PushScreen extends StatefulWidget {

  PushScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PushScreenState createState() => _PushScreenState();
}

class _PushScreenState extends State<PushScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список сообщений')
      ),
      body: ListView(
        children: listRows()
      )
    );
  }

  List<Widget> listRows() {
    List<Widget> _list = [];
    for (var _push in pushes) {
      _list.add(
        Card(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.message),
                  Column(
                    children: <Widget>[
                      Text(_push['time']),
                      Text(_push['date'])
                    ],
                  ),
                ]
              ),
              Row(
                children: <Widget>[
                  Text(_push['message'])
                ],
              )
            ],
          )
        )
      );
    }
    return _list;
  }

}