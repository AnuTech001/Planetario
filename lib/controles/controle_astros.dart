import 'package:planetario/modelos/astros.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Classe de controle do programa
class ControleAstros {
  static Database? _bd;

  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _initBD('astros.db');
    return _bd!;
  }

  Future<Database> _initBD(String localArquivo) async {
    final caminhoBD = await getDatabasesPath();
    final caminho = join(caminhoBD, localArquivo);
    return await openDatabase(
      caminho,
      version: 1,
      onCreate: _criarBD,
    );
  }

  Future<void> _criarBD(Database bd, int versao) async {
    const sql = '''
      CREATE TABLE planetas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tamanho REAL NOT NULL,
        distancia REAL NOT NULL,
        apelido TEXT
      );
    ''';
    await bd.execute(sql);
  }

  Future<int> inserirAstro(Astros astro) async {
    final db = await bd;
    return await db.insert(
      'astros',
      astro.toMap(),
    );
  }
}
