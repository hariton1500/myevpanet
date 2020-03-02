import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/api/api.dart';

class RadioGroup extends StatefulWidget {
  @override
  RadioGroupWidget createState() => RadioGroupWidget();
}
var _tarifs = userInfo["allowed_tarifs"];
Map initialTarif = {};
class RadioGroupWidget extends State {
  String id = '';
  @override
  void initState() {
    for (var item in _tarifs) {
      if (verbose >= 1) print(item);
      if (item['sum'] == userInfo['tarif_sum']) {
        id = item['id'];
        initialTarif = item;
      }
    }
    super.initState();
  }
  Future<void> myDialog(BuildContext context, dynamic value) async{
    var dialog = CupertinoAlertDialog (
      title: Text('Изменение тарифа...'),
      content: Text('Согласны?'),
      actions: [
        CupertinoDialogAction(
          child: Text('Нет'),
          onPressed: () {Navigator.pop(context, false);},
        ),
        CupertinoDialogAction(
          child: Text('Да'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
    bool _answer = await showDialog<bool>(
      context: context,
      builder: (_) => dialog,
      barrierDismissible: false,
    );
    if (verbose >= 1) print('Dialog result is: $_answer');
    if (_answer) {
      String answerOfTarifChange = await RestAPI().tarifChangePATCH(value, guids[currentGuidIndex], devKey);
      setState(() {
        if (!answerOfTarifChange.startsWith('is')) id = answerOfTarifChange;//value.toString();
      });
    }
  }

  List<Widget> _list() {
    List<Widget> tList = [];
    bool _availableTarifChoice = false;
    for (var item in _tarifs) {
      bool canChange = double.parse(userInfo['extra_account']) >= double.parse(item['sum']);
      tList.add(
        RadioListTile(
          activeColor: Colors.green,
          dense: true,
          title: Text('${item['name']} (${item['sum']} руб.)'),
          subtitle: item['sum'] == userInfo['tarif_sum'] ? Text("(текущий тариф)") : null,
          value: item['id'],
          groupValue: id,
          onChanged: canChange ? (val) => myDialog(context, val) : null,
          selected: item['sum'] == userInfo['tarif_sum'] ? true : false,
        )
      );
      if (canChange) _availableTarifChoice = true;
    }
    if (!_availableTarifChoice) tList.add(Text('На балансе недостаточно средств для активации тарифного плана.'));
    if (userInfo['auto_activation'] == 1) tList.add(Text('Чтобы изменить тариф нужно сначала отключить автоактивацию.'));
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
