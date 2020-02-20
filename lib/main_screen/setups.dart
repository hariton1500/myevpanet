import 'package:flutter/material.dart';
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
  }
  void onSetupAutoChange(value) async{
    String _url = 'https://app.evpanet.com/?set=auto_activation';
    _url += '&guid=${guids[currentGuidIndex]}';
    _url += '&devid=$devKey';
    print('Sending autoactivation [$value] to URL: $_url');
    dynamic answer = await RestAPI().getData(_url);
    print('$answer');
    setState(
      () {
        autoState = value;
      }
    );
  }
  void onSetupParentChange(value) async{
    String _url = 'https://app.evpanet.com/?set=parent_control';
    _url += '&guid=${guids[currentGuidIndex]}';
    _url += '&devid=$devKey';
    print('Sending parent control [$value] to URL: $_url');
    dynamic answer = await RestAPI().getData(_url);
    print('$answer');
    setState(
      () {
        parentState = value;
      }
    );
  }

  List<Widget> _list() {
    List<Widget> tList = [];
    //tList.add(Text('Текущий тариф: ${initialTarif['name']} (${initialTarif['sum']} руб.)'));
    //tList.add(Text('Сделайте выбор из доступных тарифов:'));
    tList.add(
      SwitchListTile(
        dense: true,
        value: autoState,
        title: Text('Автоактивация пакета'),
        onChanged: (bool state) {onSetupAutoChange(state);},
      )
    );
    tList.add(
      SwitchListTile(
        dense: true,
        value: parentState,
        title: Text('Родительский контроль'),
        onChanged: (bool state) {onSetupParentChange(state);},
      )
    );
    tList.add(
      Text('Тарифы')
    );
    tList.add(
      RadioGroup()
    );
    return tList;
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text('Настройки'),
        ),
        //Толян тут украшай как желаешь....
        body:

          Column(
            children: _list()
          )
      );
  }
}
