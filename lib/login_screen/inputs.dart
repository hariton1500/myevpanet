import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myevpanet/main.dart';

class Inputs extends StatefulWidget {
  @override
  _InputsState createState() => _InputsState();
}

class _InputsState extends State<Inputs> {
  //String editPhone;
  MaskTextInputFormatter phone = MaskTextInputFormatter(
      mask: '+# (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
  //int editID;
  MaskTextInputFormatter id =
      MaskTextInputFormatter(mask: '#####', filter: {"#": RegExp(r'[0-9]')});
  String textRepresentationOfMode = 'Вход   ';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
              child: Column(
            children: [
              TextFormField(
                //onChanged: (textPhone) => editPhone = textPhone,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Color(0xffd3edff), fontSize: 18.0),
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                    labelText: 'Номер телефона',
                    labelStyle: TextStyle(
                      color: Color(0xffd3edff),
                      letterSpacing: 1,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffd3edff))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffd3edff)))),
                inputFormatters: [phone],
              ),
              TextFormField(
                //onChanged: (textID) => editID = int.parse(textID),
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Color(0xffd3edff), fontSize: 18.0),
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                    labelText: 'Ваш ИД (ID)',
                    labelStyle: TextStyle(
                      color: Color(0xffd3edff),
                      letterSpacing: 1,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffd3edff))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffd3edff)))),
                inputFormatters: [id],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xff95abbf))),
                      elevation: 0.0,
                      primary: Color(0x858eaac2)),
                  //shape: RoundedRectangleBorder(side: BorderSide(color: Color(0xff95abbf))),
                  //elevation: 0.0,
                  //color: Color(0x858eaac2),
                  onPressed: authorizationButtonPressed,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textRepresentationOfMode,
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  void authorizationButtonPressed() {
    //print('$editPhone:$editID');
    print('${phone.getUnmaskedText()}:${id.getUnmaskedText()}');
  }
}

class ProgressIndicatorWidget extends StatefulWidget {
  @override
  _ProgressIndicatorWidgetState createState() =>
      _ProgressIndicatorWidgetState();
}

class _ProgressIndicatorWidgetState extends State<ProgressIndicatorWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: LinearProgressIndicator(
          value: currentGuidIndex / (guids.isNotEmpty ? guids.length : 1),
          backgroundColor: Color(0xff3c5d7c),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
    );
  }
}
