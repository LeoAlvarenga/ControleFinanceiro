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

  @override
  void initState(){
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
                  children: <Widget>[
                    Text(
                      "Total Gasto: xxxxx",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                      textAlign: TextAlign.center,
                    )
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
                    itemCount: 3,
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
                      fontSize: 25.0
                    ),
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
                                });
                              },
                              hint: Text("Selecione o Tipo"),
                            ),
                          ],
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.monetization_on),
                              labelText: 'Valor'),
                          keyboardType: TextInputType.numberWithOptions(),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.report), labelText: 'Observação'),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(height: 30),
                            RaisedButton(
                              onPressed: () {},
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
                    children: <Widget>[Icon(Icons.attach_money)],
                  ),
                  Column(
                    children: <Widget>[
                      Text("Tipo do pagamento",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold)),
                      Text("Valor",
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
                  )
                ],
              ),
            ),
          ),
        );
      }

    void _getAllContacts() {
      helper.getAllOperacoes().then((list){
        setState(() {
         operacoes = list; 
        });
      });
    }
    
      
}
