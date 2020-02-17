import 'package:flutter/material.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/api/api.dart';

class RadioGroup extends StatefulWidget {
  @override
  RadioGroupWidget createState() => RadioGroupWidget();
}
var _tarifs = userInfo["allowed_tarifs"];
Map initialTarif;
class RadioGroupWidget extends State {
  String id;
  @override
  void initState() {
    for (var item in _tarifs) {
      if (item['sum'] == userInfo['tarif_sum']) {
        id = item['id'];
        initialTarif = item;
      }
    }
    super.initState();
  }
  void onRadioChange(value) {
    print(value);
    setState(
      () {
        id = value.toString();
      }
    );
    //id = value.toString();
  }

  List<Widget> _list() {
    List<Widget> tList = [];
    bool _availableTarifChoice = false;
    tList.add(Text('Текущий тариф: ${initialTarif['name']} (${initialTarif['sum']} руб.)'));
    tList.add(Text('Сделайте выбор из доступных тарифов:'));
    for (var item in _tarifs) {
      if (double.tryParse(userInfo['extra_account']) >= item['sum']) {
        tList.add(
          RadioListTile(
            title: Text('${item['name']} (${item['sum']} руб.)'),
            value: item['id'],
            groupValue: id,
            onChanged: (val) => onRadioChange(val),
            selected: item['sum'] == userInfo['tarif_sum'] ? true : false,
          )
        );
        _availableTarifChoice = true;
      }
    }
    tList.add(
      _availableTarifChoice ?
        RaisedButton(
          onPressed: onTarifButtonPressed,
          child: Text('Изменить тариф'),)
        :
        Text('Доступных тарифов нет. На балансе недостаточно средств.')
    );
    return tList;
  }

  Future<void> onTarifButtonPressed() async{
    print('Tarif changing from ${initialTarif['id']} to $id');
    String _url = 'https://app.evpanet.com/?set=new_tarif';
    _url += '&tid=$id';
    _url += '&guid=${guids[currentGuidIndex]}';
    _url += '&devid=$devKey';
    print('Sending url: $_url');
    dynamic answer = await RestAPI().getData(_url);
    print('$answer');
  }

  Widget build(BuildContext context) {
    return
      //Толян тут украшай как желаешь....
      Column(
        children: _list(),
      );
  }
}
