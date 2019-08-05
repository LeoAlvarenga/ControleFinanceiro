import 'package:controle_financeiro/helpers/operacao_helper.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  OperacaoHelper helper = OperacaoHelper();

  List<Operacao> operacoes = List();

  String _valorTotal = "0";

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  //configurações do BottomNavigator
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Crédito',
      style: optionStyle,
    ),
    Text(
      'Index 2: Débito',
      style: optionStyle,
    ),
    Text(
      'Index 3: Saque',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Controle Financeiro"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Total Gasto: R\$" + _valorTotal /*+ totalGasto()*/,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            color: Colors.deepPurple,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return _movimentacao(context, index);
                },
                itemCount: operacoes.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
        onPressed: () {
          createDialog(context);
          _getAllContacts();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            title: Text('Crédito'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_atm),
            title: Text('Débito'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            title: Text('Saque'),
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.deepPurpleAccent[100],
        onTap: _onItemTapped,
      ),
    );
  }

  createDialog(BuildContext context) {
    String selectedType;
    var _formKey = GlobalKey<FormState>();
    var dropValue = "teste";
    var _tipos = <String>['Crédito', 'Débito', 'Saque'];

    final _valorController = TextEditingController();
    final _observacaoController = TextEditingController();

    Operacao _novaOperacao = Operacao();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(
                'Novo Movimento',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              ),
              content: Form(
                key: _formKey,
                autovalidate: true,
                child: ListView(
                  padding: EdgeInsets.all(10.0),
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                          child: Icon(Icons.scatter_plot),
                        ),
                        DropdownButton(
                          value: selectedType,
                          items: _tipos
                              .map((value) => DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  ))
                              .toList(),
                          onChanged: (selected) {
                            print(selected);
                            setState(() {
                              selectedType = selected;
                              _novaOperacao.tipo = selected;
                            });
                          },
                          hint: Text("Selecione o Tipo"),
                        ),
                      ],
                    ),
                    TextField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.monetization_on),
                          labelText: 'Valor'),
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: _valorController,
                      onChanged: (text) {
                        setState(() {
                          _novaOperacao.valor = text;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.report), labelText: 'Observação'),
                      controller: _observacaoController,
                      onChanged: (text) {
                        _novaOperacao.observacao = text;
                      },
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 30),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          onPressed: () async {
                            await helper.saveOperacao(_novaOperacao);
                            print("Operacao salva");
                            _getAllContacts();
                            Navigator.pop(context);
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Colors.deepPurple,
                                  Colors.deepPurpleAccent,
                                  Colors.deepPurple,
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(18.0),
                            child: const Text('Salvar',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        OutlineButton(
                            child: new Text("Button text"),
                            onPressed: () async {
                              await helper.saveOperacao(_novaOperacao);
                              print("Operacao salva");
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)))
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  Widget _movimentacao(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[Icon(selecionaIcone(operacoes[index].tipo))],
              ),
              Column(
                children: <Widget>[
                  Text(operacoes[index].tipo,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                  Text("R\$" + operacoes[index].valor,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 15.0,
                      )),
                  Text(
                    formatDate(DateTime.now(),
                        [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]).toString(),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed:() async { 
                        await helper.deleteOperacao(operacoes[index].id);
                        print("Deletado operação id:" + operacoes[index].id.toString());
                        _getAllContacts();
                        },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  IconData selecionaIcone(String tipo) {
    switch (tipo) {
      case "Crédito":
        return Icons.payment;
        break;
      case "Débito":
        return Icons.local_atm;
        break;
      case "Saque":
        return Icons.account_balance_wallet;
        break;
      default:
        return null;
        break;
    }
  }

  void _getAllContacts() {
    helper.getAllOperacoes().then((list) {
      setState(() {
        operacoes = list;
        atualizaValor();
      });
    });
  }

  // String totalGasto() {
  //   double _total = 0;
  //   for (int i = 0; i < operacoes.length; i++) {
  //     print(operacoes[i].valor);
  //     _total += double.parse(operacoes[i].valor);
  //   }
  //   print(_total);
  //   return _total.toString();
  // }

  atualizaValor() {
    double _total = 0;
    for (int i = 0; i < operacoes.length; i++) {
      print(operacoes[i].valor);
     _total += double.parse(operacoes[i].valor);

     setState(() {
      _valorTotal = _total.toString();
     });
     }
  }
}
