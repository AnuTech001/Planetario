import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Clase de controle do programa
class ControleAstros {
  static Database? _bd;

  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _initBD('astros.db');
    return _bd!;
  }
}
