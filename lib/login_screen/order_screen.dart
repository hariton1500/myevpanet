import 'package:flutter/material.dart';

class MakeOrder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MakeOrderState();
  }
  
class MakeOrderState extends State{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заявка на подключение к сети EvpaNet')
      ),
      body: _form(),
    );
  }

  Widget _form() {
    return Text('Тута будет форма на подачу заявки на подключение блин! Толян, какие поля? Что делать с адресами? Давай инструкцию!');
  }
}