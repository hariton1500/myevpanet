
import 'package:flutter/material.dart';
import 'package:myevpanet/main.dart';

class RadioGroup extends StatefulWidget {
  @override
  RadioGroupWidget createState() => RadioGroupWidget();
}
var _tarifs = userInfo["allowed_tarifs"];
class RadioGroupWidget extends State {
  String id;
  @override
  void initState() {
    for (var item in _tarifs) {
      if (item['sum'] == userInfo['tarif_sum']) id = item['id'];
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
    for (var item in _tarifs) {
      tList.add(
        RadioListTile(
          title: Text('${item['name']} (${item['sum']} руб.)'),
          value: item['id'],
          groupValue: id,
          onChanged: (val) => onRadioChange(val),
          selected: item['sum'] == userInfo['tarif_sum'] ? true : false,
        )
      );
    }
    return tList;
  }

  Widget build(BuildContext context) {
    return
      //Толян тут украшай как желаешь....
      Column(
        children: _list(),
      );
  }
}
