import 'package:flutter/material.dart';

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
      body: Text("Push List")
    );
  }
}