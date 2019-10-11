import 'package:controle_financeiro/helpers/operacao_helper.dart';
import 'package:date_format/date_format.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  OperacaoHelper helper = OperacaoHelper();

  List<Operacao> movimentacoes = List();

  Operacao _operacaoRemoved = Operacao();

  String _valorTotal = "0";

  String _valorLimite = "500";

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _getOperacoes(_selectedIndex);

    print(movimentacoes);
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
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.more_vert, color: Colors.white,),
          //   onPressed: () {
          PopupMenuButton<AppBarActions>(
            itemBuilder: (context) => <PopupMenuEntry<AppBarActions>>[
              PopupMenuItem(
                value: AppBarActions.apagaTudo,
                child: Text("Apagar Tudo"),
              ),
              PopupMenuItem(
                value: AppBarActions.configuracoes,
                child: Text("Configurações"),
              )
            ],
            onSelected: _appBarActions,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Total Gasto:",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "R\$" + _valorTotal,
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
            ),
            color: alertaDeCorTotalGasto(double.parse(_valorTotal)),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return _movimentacao(context, index);
                },
                itemCount: movimentacoes.length,
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
                settingModalBottomSheet(context, "Crédito");
              }),
          SpeedDialChild(
              child: Icon(Icons.local_atm),
              backgroundColor: Colors.deepPurple,
              label: 'Débito',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                settingModalBottomSheet(context, "Débito");
              }),
          SpeedDialChild(
              child: Icon(Icons.account_balance_wallet),
              backgroundColor: Colors.deepPurple,
              label: 'Saque',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                settingModalBottomSheet(context, "Saque");
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

  settingModalBottomSheet(context, String tipo) {
    var _formKey = GlobalKey<FormState>();

    final _valorController = TextEditingController();
    final _observacaoController = TextEditingController();

    Operacao _novaOperacao = Operacao();

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (BuildContext bc) {
          return Container(
            width: 200,
            child: Form(
              key: _formKey,
              autovalidate: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15,15,15,MediaQuery.of(context).viewInsets.bottom),
                child: Wrap(
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
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
                        } else if (double.tryParse(value) == null) {
                          return '"$value" não é válido, use apenas números e "."';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.info_outline,
                            color: Colors.deepPurple,
                          ),
                          labelText: 'Observação',
                          hoverColor: Colors.deepPurple),
                      controller: _observacaoController,
                      cursorColor: Colors.deepPurple,
                    ),
                    DateTimePickerFormField(
                      inputType: InputType.date,
                      format: DateFormat("dd-MM-yyyy"),
                      initialDate: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      editable: false,
                      decoration: InputDecoration(
                        hoverColor: Colors.deepPurple,
                        icon: Icon(Icons.date_range, color: Colors.deepPurple),
                        hasFloatingPlaceholder: false,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "selecione uma Data";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (dt) {
                        setState(() {
                          _novaOperacao.data =
                              formatDate(dt, [dd, "/", mm, "/", yyyy]);
                        });
                        print(_novaOperacao.data);
                      },
                    ),
                    const SizedBox(height: 30),
                    MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _novaOperacao.valor = _valorController.text;
                          _novaOperacao.observacao = _observacaoController.text;
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
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      color: Colors.deepPurple,
                      splashColor: Colors.deepPurpleAccent,
                      elevation: 6,
                      highlightElevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidate: false,
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
                          } else if (double.tryParse(value) == null) {
                            return '"$value" não é válido, use apenas números e "."';
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.info_outline,
                              color: Colors.deepPurple,
                            ),
                            labelText: 'Observação',
                            hoverColor: Colors.deepPurple),
                        controller: _observacaoController,
                        cursorColor: Colors.deepPurple,
                      ),
                      DateTimePickerFormField(
                        inputType: InputType.date,
                        format: DateFormat("dd-MM-yyyy"),
                        initialDate: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day),
                        editable: false,
                        decoration: InputDecoration(
                          hoverColor: Colors.deepPurple,
                          icon:
                              Icon(Icons.date_range, color: Colors.deepPurple),
                          hasFloatingPlaceholder: false,
                        ),
                        validator: (value) {
                          if (value == null) {
                            return "selecione uma Data";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (dt) {
                          setState(() {
                            _novaOperacao.data =
                                formatDate(dt, [dd, "/", mm, "/", yyyy]);
                          });
                          print(_novaOperacao.data);
                        },
                      ),
                      const SizedBox(height: 30),
                      MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _novaOperacao.valor = _valorController.text;
                            _novaOperacao.observacao =
                                _observacaoController.text;
                            _novaOperacao.tipo = tipo;
                            var _operacaoSalva = await helper.saveOperacao(_novaOperacao);
                            print("Operacao salva");
                            print(_operacaoSalva);
                            _getOperacoes(_selectedIndex);
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Salvar",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        color: Colors.deepPurple,
                        splashColor: Colors.deepPurpleAccent,
                        elevation: 6,
                        highlightElevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ],
                  ),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        selecionaIcone(movimentacoes[index].tipo),
                        size: 40,
                        color: Colors.deepPurple,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Tipo:",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        movimentacoes[index].tipo,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Data:",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        movimentacoes[index].data,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "valor:",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "R\$ " + movimentacoes[index].valor,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          observacaoDialog(movimentacoes[index].observacao);
        },
      ),
    );
  }

  observacaoDialog(String observacao) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Observação da Operação"),
            content: Row(
              children: <Widget>[
                Icon(
                  Icons.info_outline,
                  size: 55,
                  color: Colors.deepPurple,
                ),
                Flexible(
                    child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    observacao,
                    style: TextStyle(fontSize: 20),
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                  child: Icon(
                    Icons.check,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  _appBarActions(AppBarActions selecionado) {
    switch (selecionado) {
      case AppBarActions.apagaTudo:
        print("apagatudo selecionado");
        return apagaDialog();
        break;
      case AppBarActions.configuracoes:
        print("configurações selecionado");
        return configuracoesDialog();
        break;
      default:
        return null;
        break;
    }
  }

  configuracoesDialog() {
    final _valorController = TextEditingController();
    _valorController.text = _valorLimite;
    final _formKey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Configurações"),
            content: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Valor Limite:",
                  labelStyle: TextStyle(color: Colors.deepPurple, fontSize: 20),
                ),
                //initialValue: _valorLimite,
                controller: _valorController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Digite um valor";
                  } else if (double.tryParse(value) == Null) {
                    return "Valor Inválido, utilize apenas números e '.'";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.save),
                color: Colors.deepPurple,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      _valorLimite = _valorController.text;
                    });
                    print(_valorLimite);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        });
  }

  apagaOperacao(int index) async {
    _operacaoRemoved = movimentacoes[index];
    await helper.deleteOperacao(movimentacoes[index].id);
    print("Deletado operação id:" + movimentacoes[index].id.toString());
    _getOperacoes(_selectedIndex);
  }

  apagaDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Apagar Tudo?"),
            content: Row(
              children: <Widget>[
                Icon(
                  Icons.delete_forever,
                  size: 60,
                  color: Colors.red,
                ),
                Flexible(
                  child: Text("Estes dados serão apagados permanentemente"),
                ),
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text("Cancelar",
                    style: TextStyle(color: Colors.blueAccent)),
                onPressed: () => Navigator.pop(context),
              ),
              MaterialButton(
                  child: Text("Apagar", style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    apagaTudo();
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  apagaTudo() {
    for (int i = 0; i < movimentacoes.length; i++) {
      apagaOperacao(i);
    }
    print("Todas  operações apagadas");
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
        movimentacoes = list;
        atualizaValor();
        print(movimentacoes);
      });
    });
  }

  void _getSelectedOperacoes(String tipoSelecionado) {
    helper.getSelectedOperacoes(tipoSelecionado).then((list) {
      setState(() {
        movimentacoes = list;
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
    for (int i = 0; i < movimentacoes.length; i++) {
      print(movimentacoes[i].valor);
      _total += double.parse(movimentacoes[i].valor);
    }
    if (movimentacoes.length == 0) _total = 0;
    setState(() {
      _valorTotal = _total.toStringAsPrecision(5);
    });
  }

  alertaDeCorTotalGasto(double valor) {
    if (valor <= double.parse(_valorLimite)) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}

enum AppBarActions { apagaTudo, configuracoes }
