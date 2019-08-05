import 'package:controle_financeiro/helpers/operacao_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Teste extends StatefulWidget {
  @override
  _TesteState createState() => _TesteState();
}

class _TesteState extends State<Teste> {

 
  OperacaoHelper helper = OperacaoHelper();

  List<Operacao> operacoes = List();

  @override
  initState(){

    _getAllContacts();

    print(operacoes);
    

  }

  void _getAllContacts() {
    helper.getAllOperacoes().then((list) {
      setState(() {
        operacoes = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}