import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/api/api.dart';
import 'package:myevpanet/main_screen/setups.dart';

class RadioGroup extends StatefulWidget {
  @override
  RadioGroupWidget createState() => RadioGroupWidget();
}
//userInfo = users[currentGuidIndex];

String initialTarif = '';
var _tarifs = userInfo["allowed_tarifs"];
class RadioGroupWidget extends State {
  String id = '';
  @override
  void initState() {
    _tarifs = userInfo["allowed_tarifs"];
    //print(userInfo['id']);
    //print(userInfo['allowed_tarifs']);
    for (var item in _tarifs) {
      if (verbose >= 1) print(item);
      if (item['sum'].toString() == userInfo['tarif_sum'].toString()) {
        id = item['id'].toString();
        initialTarif = id;
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
      if (!answerOfTarifChange.startsWith('is')) id = answerOfTarifChange;
      setState(() {});
      await RestAPI().userDataGet(guids[currentGuidIndex], devKey);
      Navigator.pop(context);
      //SetupGroupWidget().setState(() { });
    }
  }

  List<Widget> _list() {
    List<Widget> tList = [];
    bool _availableTarifChoice = false;
    for (var item in _tarifs) {
      //print(userInfo['extra_account'].runtimeType);
      //print(userInfo['extra_account']);
      //print(userInfo['tarif_sum'].runtimeType);
      //print(userInfo['tarif_sum']);
      //print(item['sum'].runtimeType);
      //print(item['sum']);
      double userBalance = double.parse(userInfo['extra_account']);
      int userTarifSum = userInfo['tarif_sum'].runtimeType.toString() == 'int' ? userInfo['tarif_sum'] : int.parse(userInfo['tarif_sum']);
      int tarifSum = item['sum'].runtimeType.toString() == 'int' ? item['sum'] : int.parse(item['sum']);
      String tarifId = item['id'].toString();
      String tarifName = item['name'].toString();
      bool canChange = userBalance >= tarifSum;
      tList.add(
        RadioListTile(
          activeColor: Colors.green,
          dense: true,
          title: Text('$tarifName ($tarifSum руб.)'),
          subtitle: tarifSum == userTarifSum ? Text("(текущий тариф)") : null,
          value: tarifId,
          groupValue: id,
          onChanged: canChange ? (val) => myDialog(context, val) : null,
          selected: tarifSum == userTarifSum ? true : false,
        )
      );
      if (canChange) _availableTarifChoice = true;
    }
    if (!_availableTarifChoice) tList.add(Text('На балансе недостаточно средств для активации тарифного плана.'));
    if (userInfo['auto_activation'] == 1) tList.add(Text('Чтобы изменить тариф нужно сначала отключить автоактивацию.'));
    return tList;
  }

  /*Future<void> onTarifButtonPressed() async{
    print('Tarif changing from $initialTarif to $id');
    String _url = 'https://app.evpanet.com/?set=new_tarif';
    _url += '&tid=$id';
    _url += '&guid=${guids[currentGuidIndex]}';
    _url += '&devid=$devKey';
    print('Sending url: $_url');
    dynamic answer = await RestAPI().getData(_url);
    print('$answer');
  }*/

  Widget build(BuildContext context) {
    return
      //Толян тут украшай как желаешь....
      Column(
        children: _list(),
      );
  }
}
