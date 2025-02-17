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
      print(
          "Inicializando o banco de dados em: $caminho"); // Print de depuração
    }
    return await openDatabase(
      caminho,
      version: 2,
      onCreate: _criarBD,
      onUpgrade: _atualizarBD,
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
        estrela TEXT,
        apelido TEXT
      );
    ''';
    await bd.execute(sql);
    if (kDebugMode) {
      print("Tabela astros criada com sucesso."); // Print de depuração
    }
  }

  // Função de migração para atualizar a tabela existente
  Future<void> _atualizarBD(
      Database bd, int antigaVersao, int novaVersao) async {
    if (antigaVersao < 2) {
      await bd.execute('ALTER TABLE astros ADD COLUMN estrela TEXT;');
      if (kDebugMode) {
        print('Tabela astros atualizada com sucesso.'); // Print de depuração
      }
    }
  }

  // Deletar o banco de dados
  Future<void> deletarBancoDeDados() async {
    final caminhoBD = await getDatabasesPath();
    final caminho = join(caminhoBD, 'astros.db');
    await deleteDatabase(caminho);
    if (kDebugMode) {
      print("Banco de dados deletado."); // Print de depuração
    }
  }

  // Ler os dados dos astros
  Future<List<Astro>> lerAstros() async {
    final db = await bd;
    if (kDebugMode) {
      print("Lendo dados da tabela astros."); // Print de depuração
    }
    final resultado = await db.query('astros');
    return resultado.map((map) => Astro.fromMap(map)).toList();
  }

  // Inserir um novo astro na tabela
  Future<int> inserirAstro(Astro astro) async {
    final db = await bd;
    if (kDebugMode) {
      print("Inserindo dados na tabela astros."); // Print de depuração
    }
    // Remover o id do mapa ao inserir, pois será gerado automaticamente
    final Map<String, dynamic> astroMap = astro.toMap();
    astroMap.remove('id');
    if (kDebugMode) {
      print("Dados do astro a ser inserido: $astroMap"); // Print de depuração
    }
    return await db.insert(
      'astros',
      astroMap,
    );
  }

  // Excluir astro da tabela
  Future<int> excluirAstro(int id) async {
    final db = await bd;
    if (kDebugMode) {
      print("Excluindo astro com id: $id"); // Print de depuração
    }
    return await db.delete('astros', where: 'id = ?', whereArgs: [id]);
  }

  // Alterar um astro existente na tabela
  Future<int> alterarAstro(Astro astro) async {
    final db = await bd;
    if (kDebugMode) {
      print(
          "Alterando dados do astro com id: ${astro.id}"); // Print de depuração
    }
    if (kDebugMode) {
      print(
          "Dados atualizados do astro: ${astro.toMap()}"); // Print de depuração
    }
    return await db.update(
      'astros',
      astro.toMap(),
      where: 'id = ?',
      whereArgs: [astro.id],
    );
  }
}
