import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Controle Financeiro"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          child: ListView.builder(
            itemBuilder: (context, index){
              return _movimentacao(context, index);
              },
          ),
        ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.add),
          onPressed: (){},
        ),
    );
  }

  Widget _movimentacao(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Text("Valor"),
              Text("Tipo do pagamento"),
              Text(DateTime.now().toString()),
            ],
          ),
        ),
      ),
    );
  }
}