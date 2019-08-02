import 'package:flutter/material.dart';

class Adicionar extends StatefulWidget {
  @override
  _AdicionarState createState() => _AdicionarState();
}

class _AdicionarState extends State<Adicionar> {
  final _formKey = GlobalKey<FormState>();

  List<String> _tipos = ["Crédito", 'Débito', 'Saque'];

  var dropdownValue = 'Tipo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Adicionar Movimento"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              
              TextField(
                decoration: InputDecoration(
                  labelText: "Valor:",
                ),
                keyboardType: TextInputType.number,
              )
            ],
          ),
        ),
      ),
    );
  }
}
