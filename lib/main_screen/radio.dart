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
  }

  List<Widget> _list() {
    List<Widget> tList = [];
    bool _availableTarifChoice = false;
    for (var item in _tarifs) {
      tList.add(
        RadioListTile(
          activeColor: Colors.green,
          dense: true,
          title: Text('${item['name']} (${item['sum']} руб.)'),
          subtitle: item['sum'] == userInfo['tarif_sum'] ? Text("(текущий тариф)") : null,
          value: item['id'],
          groupValue: id,
          onChanged: double.tryParse(userInfo['extra_account']) >= item['sum'] ? (val) => onRadioChange(val) : null,
          selected: item['sum'] == userInfo['tarif_sum'] ? true : false,
        )
      );
      if (double.tryParse(userInfo['extra_account']) >= item['sum']) _availableTarifChoice = true;
    }
    tList.add(
      _availableTarifChoice ?
        RaisedButton(
          onPressed: userInfo['auto_activation'] == 0 ? onTarifButtonPressed : null,
          child: Text('Изменить тариф'),)
        :
        Text('На балансе недостаточно средств для активации тарифного плана.')
    );
    if (userInfo['auto_activation'] == 1) {
      tList.add(Text('Чтобы изменить тариф нужно сначала отключить автоактивацию.'));
    }
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
