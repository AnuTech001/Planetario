import 'package:flutter/foundation.dart';
import 'package:planetario/modelos/astros.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Classe de controle do programa
class ControleAstros {
  static Database? _bd;

  // Getter para o banco de dados
  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _initBD('astros.db');
    return _bd!;
  }

  // Inicializa o banco de dados
  Future<Database> _initBD(String localArquivo) async {
    final caminhoBD = await getDatabasesPath();
    final caminho = join(caminhoBD, localArquivo);
    if (kDebugMode) {
      print("Inicializando o banco de dados em: $caminho");
    }
    return await openDatabase(
      caminho,
      version: 1,
      onCreate: _criarBD,
    );
  }

  // Criação da tabela de astros no banco de dados
  Future<void> _criarBD(Database bd, int versao) async {
    const sql = '''
      CREATE TABLE astros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tamanho REAL NOT NULL,
        distancia REAL NOT NULL,
        apelido TEXT
      );
    ''';
    await bd.execute(sql);
    if (kDebugMode) {
      print("Tabela astros criada com sucesso.");
    }
  }

  // Deletar o banco de dados
  Future<void> deletarBancoDeDados() async {
    final caminhoBD = await getDatabasesPath();
    final caminho = join(caminhoBD, 'astros.db');
    await deleteDatabase(caminho);
    if (kDebugMode) {
      print("Banco de dados deletado.");
    }
  }

  // Ler os dados dos astros
  Future<List<Astro>> lerAstros() async {
    final db = await bd;
    if (kDebugMode) {
      print("Lendo dados da tabela astros.");
    }
    final resultado = await db.query('astros');
    return resultado.map((map) => Astro.fromMap(map)).toList();
  }

  // Inserir um novo astro na tabela
  Future<int> inserirAstro(Astro astro) async {
    final db = await bd;
    if (kDebugMode) {
      print("Inserindo dados na tabela astros.");
    }
    return await db.insert(
      'astros',
      astro.toMap(),
    );
  }
}
