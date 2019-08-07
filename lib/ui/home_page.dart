import 'package:controle_financeiro/helpers/operacao_helper.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  OperacaoHelper helper = OperacaoHelper();

  List<Operacao> operacoes = List();

  Operacao _operacaoRemoved = Operacao();

  String _valorTotal = "0";

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _getOperacoes(_selectedIndex);

    print(operacoes);
  }

  //configurações do BottomNavigator
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
      _getOperacoes(_selectedIndex);
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
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        children: [
          SpeedDialChild(
              child: Icon(Icons.payment),
              backgroundColor: Colors.deepPurple,
              label: 'Crédito',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                createDialog(context, "Crédito");
              }),
          SpeedDialChild(
              child: Icon(Icons.local_atm),
              backgroundColor: Colors.deepPurple,
              label: 'Débito',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                createDialog(context, "Débito");
              }),
          SpeedDialChild(
              child: Icon(Icons.account_balance_wallet),
              backgroundColor: Colors.deepPurple,
              label: 'Saque',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                createDialog(context, "Saque");
              }),
        ],
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

  createDialog(BuildContext context, String tipo) {
    var _formKey = GlobalKey<FormState>();

    final _valorController = TextEditingController();
    final _observacaoController = TextEditingController();

    Operacao _novaOperacao = Operacao();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(
                'Adcionar $tipo',
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
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.monetization_on,
                              color: Colors.deepPurple),
                          labelText: 'Valor'),
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: _valorController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Preenchimento Obrigatório!";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.report,
                            color: Colors.deepPurple,
                          ),
                          labelText: 'Observação',
                          hoverColor: Colors.deepPurple),
                      controller: _observacaoController,
                      cursorColor: Colors.deepPurple,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Preenchimento Obrigatório!";
                        } else {
                          return null;
                        }
                      },
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 30),
                        MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _novaOperacao.valor = _valorController.text;
                              _novaOperacao.observacao =
                                  _observacaoController.text;
                              _novaOperacao.tipo = tipo;
                              await helper.saveOperacao(_novaOperacao);
                              print("Operacao salva");
                              _getOperacoes(_selectedIndex);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Salvar",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          color: Colors.deepPurple,
                          splashColor: Colors.deepPurpleAccent,
                          elevation: 6,
                          highlightElevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  Widget _movimentacao(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(0.8, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        apagaOperacao(index);

        final snack = SnackBar(
          content: Text("Operação Removida!"),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: () {
              helper.saveOperacao(_operacaoRemoved);
              _getOperacoes(_selectedIndex);
            },
          ),
          duration: Duration(seconds: 2),
        );

        Scaffold.of(context).showSnackBar(snack);
      },
      child: GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(selecionaIcone(operacoes[index].tipo))
                  ],
                ),
                SizedBox(
                  width: 55.0,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      operacoes[index].tipo,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    Text("R\$" + operacoes[index].valor,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15.0,
                        )),
                    Text(
                      formatDate(DateTime.now(), [
                        dd,
                        '/',
                        mm,
                        '/',
                        yyyy,
                        ' ',
                        HH,
                        ':',
                        nn
                      ]).toString(),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(
                  width: 50.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  apagaOperacao(int index) async {
    _operacaoRemoved = operacoes[index];
    await helper.deleteOperacao(operacoes[index].id);
    print("Deletado operação id:" + operacoes[index].id.toString());
    _getOperacoes(_selectedIndex);
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

  void _getOperacoes(int tipo) {
    switch (tipo) {
      case 0:
        _getAllOperacoes();
        helper.deleteOperacao(7);
        break;
      case 1:
        _getSelectedOperacoes("Crédito");
        break;
      case 2:
        _getSelectedOperacoes("Débito");
        break;
      case 3:
        _getSelectedOperacoes("Saque");
        break;
      default:
        tipo = 0;
        break;
    }
  }

  void _getAllOperacoes() {
    helper.getAllOperacoes().then((list) {
      setState(() {
        operacoes = list;
        atualizaValor();
        print(operacoes);
      });
    });
  }

  void _getSelectedOperacoes(String tipoSelecionado) {
    helper.getSelectedOperacoes(tipoSelecionado).then((list) {
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
    }
    if (operacoes.length == 0) _total = 0;
    setState(() {
      _valorTotal = _total.toString();
    });
  }
}
