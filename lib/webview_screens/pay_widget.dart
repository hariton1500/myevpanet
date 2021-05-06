import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/api/api.dart';

class PayView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _url =
        'https://my.evpanet.com/?login=${users[currentGuidIndex]['login']}&password=${users[currentGuidIndex]['clear_pass']}';
    dprintD(_url, verbose);
    return Scaffold(
      body: WebviewScaffold(
          withJavascript: true,
          //headers: {},
          appBar: AppBar(
            title: Text('Пополнение баланса'),
          ),
          url: _url),
    );
  }
}
