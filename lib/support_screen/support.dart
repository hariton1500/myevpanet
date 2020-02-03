import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    /*Center(
                      child: Text('Сообщение в службу поддержки:')
                    ),*/
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
    );
  }
  void sendMessagePressed() {

  }
}
