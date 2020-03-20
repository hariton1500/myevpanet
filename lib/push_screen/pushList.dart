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
    //print('Reading content of pushes.dat');
    for (var _push in pushes) {
      //print(_push);
      _list.add(
        Card(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.message),
                  Column(
                    children: <Widget>[
                      Text(_push['id'].toString()),
                      Text(_push['title']),
                      Text(DateTime.tryParse(_push['date']).toString()),
                      Text(_push['body']),
                    ],
                  ),
                ]
              ),
            ],
          )
        )
      );
    }
    return _list;
  }

}