import 'package:flutter/material.dart';
import 'package:myevpanet/main_screen/radio.dart';

Widget blueZone_1(Map userInfo) {
  return
    Container(
      color: Colors.blue,
      height: 230.0,
      child: Padding(
        padding: EdgeInsets.only(
          top: 10.0,
          right: 20.0,
          left: 20.0,
          bottom: 20.0
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(
                    top: 10.0
                ),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.only(
                              right: 30.0
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "Текущий тарифный план",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  top: 5.0
                                ),
                                child: Text(
                                  userInfo["tarif_name"] + " (" + userInfo["tarif_sum"].toString() + " р.)",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                          child: Container(),
                      ),
                    //Text('ID: ${userInfo['id'].toString()}'),
                    //Text('Тарифный план: ' + userInfo["tarif_name"] + " (" + userInfo["tarif_sum"]?.toString() + "р.)" ),
                    ],
                  )
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                    flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(
                        //top: 20.0
                        ),
                          child: SizedBox(
                        /*height: 165,
                          width: 165,*/
                            child: Stack(
                              children: <Widget>[
                                SizedBox(
                                  child: CircularProgressIndicator(
                                value: 1,
                                valueColor: new AlwaysStoppedAnimation(Colors.white),
                                strokeWidth: 7.0,
                              ),
                              height: 100.0,
                              width: 100.0,
                            ),
                              SizedBox(
                                child: CircularProgressIndicator(
                                value: secToDate(userInfo['packet_secs'])/30,
                                //value: 0.875,
                                valueColor: new AlwaysStoppedAnimation(Colors.lightBlueAccent),
                                strokeWidth: 5.0,
                              ),
                              height: 100.0,
                              width: 100.0,
                            ),
                              SizedBox(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "Осталось",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Stack(
                                        children: <Widget>[
                                          // Stroked text as border.
                                          Text(
                                            "${secToDate(userInfo['packet_secs']).truncate()}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                foreground: Paint()
                                                  ..style = PaintingStyle.stroke
                                                  ..color = Colors.white70
                                                  ..strokeWidth = 1
                                            ),
                                          ),
                                          Text(
                                            "${secToDate(userInfo['packet_secs']).truncate()}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: Colors.lightGreenAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "дней",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                              height: 100.0,
                              width: 100.0,
                            )
                          ],
                        ),
                      ),
                    ),),
                    Expanded(
                      flex: 2,
                      child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 6.0,
                              right: 4.0
                          ),
                          child: Text("На Вашем счету: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          userInfo["extra_account"].toString() + " р.",
                          style: TextStyle(
                            color: double.parse(userInfo["extra_account"]) < 0 ? Colors.pink : Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ),
                    //Text("${ 1 - secToDate(userInfo['packet_secs']/30)}"),
                  ],
                ),

              ),
            ),
          ],
        ),
      ),
    );
}
Widget blueZone_2(Map userInfo) {
  return
    Container(
      child: Column(
        children: <Widget>[
          double.parse(userInfo["debt"]) > 0
              ?
          Container (
              decoration: new BoxDecoration (
                  color: Colors.red
              ),
              child: new ListTile(
                title: Text(
                  "За вами числится задолженость " + userInfo["debt"]?.toString() + " р.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                //subtitle: Text(userInfo["tarif_name"] + " (" + userInfo["tarif_sum"]?.toString() + "р.)" ),
              )
          )
              :
          Container(),
        ],
      )
    );
}

Widget blueZoneT(Map userInfo) {
  /*allowed_tarifs, [{id: C0BBF38B06F025C1AC3AAB01E5C2B5A1, name: Интернет 25 Мбит, sum: 350, speed: 25600, speed2: 25600, enable: 1}, {id: CBF84BB4A6540716BC9111FE6B8DA88E, name: Интернет 50 Мбит, sum: 450, speed: 51200, speed2: 51200, enable: 1}, {id: 173466D4E27465492586BB71D48A7416, name: Интернет 100 Мбит, sum: 550, speed: 102400, speed2: 102400, enable: 1}, {id: 130C6C7E3E14BE113C0101925CD363E5, name: Интернет 24 часа 25 Мбит, sum: 50, speed: 25600, speed2: 25600, enable: 1}, {id: C906EBF11687DFB84BA7B40122E66A0A, name: Интернет 48 часов 25 Мбит, sum: 70, speed: 25600, speed2: 25600, enable: 1}]*/
  //print(_tarifs[1]['id']);
  return RadioGroup();
}

Widget blueZoneS(Map userInfo) {


  return
    Text('здесь нужна форма с настройками');
}

Widget blueZoneM() {
  return
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
              maxLines: 4,
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
    );
}

void sendMessagePressed() {

}

double secToDate(secsLeft) {
  return secsLeft / 60 / 60 / 24;
}


class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    this.label,
    this.padding,
    this.groupValue,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool groupValue;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue)
          onChanged(value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio<bool>(
              groupValue: groupValue,
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}