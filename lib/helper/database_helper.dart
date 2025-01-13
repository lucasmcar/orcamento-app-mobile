import 'package:sqflite/sqflite.dart';
import 'package:orcamento_app/models/pdf.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('orcamento.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;
    //final path = join(dbPath, filePath);


    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE if not exists empresa_db (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        endereco TEXT,
        cidade TEXT,
        telefone TEXT,
        email TEXT,
        cnpj TEXT,
        imagem_path TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE if not exists servidor_db  (
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         url TEXT,
         rota_cliente TEXT,
         rota_veiculos TEXT,
         rota_servicos TEXT
      )
    ''');

    await db.execute('''
    CREATE TABLE if not exists pdf_path_db (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        path TEXT,
        createdAT TEXT
      )
    ''');
  }

  Future insertPdf(Map<String, dynamic> pdf) async{
    final db = await instance.database;
    return await db.insert('pdf_path_db', pdf);
  }

  Future<List<Map<String, Object?>>?> getPdfs() async {
    final db = await instance.database;
    final result = await db.query('pdf_path_db');
    print(result);
    return result.isNotEmpty ? result : null;
  }

  Future<void> removePdf(int id) async {
    final db = await instance.database;
    await db.delete('pdf_path_db', where: 'id = ?', whereArgs: [id]);
  }

  // Servidor
  Future insertServidor(Map<String, dynamic> servidor) async{
    final db = await instance.database;
    return await db.insert('servidor_db', servidor);
  }

  Future<Map<String, dynamic>?> getServidor() async {
    final db = await instance.database;
    final result = await db.query('servidor_db', limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> editServidor(Map<String, dynamic> servidor) async {
    final db = await instance.database;
    return await db.update('servidor_db', servidor, where: 'id = ?', whereArgs: [servidor['id']]);
  }

  //Empresa
  Future<int> insertEmpresa(Map<String, dynamic> empresa) async {
    final db = await instance.database;
    return await db.insert('empresa_db', empresa);
  }

  Future<int> editEmpresa(Map<String, dynamic> empresa) async {
    final db = await instance.database;
    return await db.update('empresa_db', empresa, where: 'id = ?', whereArgs: [empresa['id']]);
  }

  Future<Map<String, dynamic>?> getEmpresa() async {
    final db = await instance.database;
    final result = await db.query('empresa_db', limit: 1);
    return result.isNotEmpty ? result.first : null;
  }


  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
