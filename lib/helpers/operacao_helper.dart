import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String operacoesTable = "operacoesTable";
final String idColumn ="idColumn";
final String tipoColumn = "tipoColumn";
final String valorColumn = "valorColumn";
final String observacaoColumn = "observacaoColumn";
final String dataColumn = "dataColumn";

class OperacaoHelper {

  static final OperacaoHelper _instance = OperacaoHelper.internal();

  factory OperacaoHelper() => _instance;

  OperacaoHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    }else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "operacoes.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion)async{
      await db.execute(
        "CREATE TABLE $operacoesTable($idColumn INTEGER PRIMARY KEY, $tipoColumn TEXT, $valorColumn TEXT,"
        " $observacaoColumn TEXT, $dataColumn TEXT)"
      );
    });
  }

  Future<Operacao> saveOperacao(Operacao operacao) async {
    Database dbOperacao = await db;
    operacao.id = await dbOperacao.insert(operacoesTable, operacao.toMap());
    return operacao;
  }

  Future<Operacao> getOperacao(int id) async {
    Database dbOperacao = await db;
    List<Map> maps = await dbOperacao.query(operacoesTable,
      columns: [idColumn, tipoColumn, valorColumn, observacaoColumn, dataColumn],
      where: "$idColumn = ?", whereArgs: [id]);
    if(maps.length> 0){
      return Operacao.fromMap(maps.first);
    } else{
      return null;
    }
  }

  Future<int>deleteOperacao(int id) async {
    Database dbOperacao = await db;
    return await dbOperacao.delete(operacoesTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateOperacao(Operacao operacao) async {
    Database dbOperacao = await db;
    return await dbOperacao.update(operacoesTable, 
      operacao.toMap(), 
      where: "$idColumn= ?", whereArgs: [operacao.id]);
  }

  Future<List> getAllOperacoes() async {
    Database dbOperacao = await db;
    List listMap = await dbOperacao.rawQuery("SELECT * FROM $operacoesTable");
    List<Operacao> listOperacao = List();
    for(Map m in listMap){
      listOperacao.add(Operacao.fromMap(m));
    }
    return listOperacao;
  }

  Future<List> getSelectedOperacoes(String tipoSelecionado) async {
    Database dbOperacao = await db;
    List listMap = await dbOperacao.query(operacoesTable, where: "$tipoColumn = ?", whereArgs: [tipoSelecionado]);
    List<Operacao> listOperacao = List();
    for(Map m in listMap){
      listOperacao.add(Operacao.fromMap(m));
    }
    return listOperacao;
  }

  Future<int> getNumber() async {
    Database dbOperacao = await db;
    return Sqflite.firstIntValue(await dbOperacao.rawQuery("SELECT COUNT(*) FROM $operacoesTable"));
  }

  Future close() async {
    Database dbOperacao = await db;
    dbOperacao.close();
  }
 
}

class Operacao {

  int id;
  String tipo;
  String valor;
  String observacao;
  String data;

  Operacao();

  Operacao.fromMap(Map map){
    id = map[idColumn];
    tipo = map[tipoColumn];
    valor = map[valorColumn];
    observacao = map[observacaoColumn];
    data = map[dataColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      tipoColumn: tipo,
      valorColumn: valor,
      observacaoColumn: observacao,
      dataColumn: data
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Operacao(id: $id, tipo: $tipo, valor: $valor, observacao: $observacao, data: $data)";
  }

  
}