import 'package:flutter/foundation.dart';

class Astro {
  String? id; // Identificador opcional
  String nome; // Nome do astro
  double tamanho; // Tamanho ou circunferência do astro
  double distancia; // Distância do astro em relação à sua estrela
  String? estrela; // Nome da estrela mãe
  String? apelido; // Apelido: Nome alternativo para o astro

  // Construtor da classe Astro
  Astro({
    this.id,
    required this.nome,
    required this.tamanho,
    required this.distancia,
    this.estrela,
    this.apelido,
  }) {
    if (kDebugMode) {
      print('Astro criado: $nome, $tamanho, $distancia, $estrela, $apelido');
    }
  }

  // Construtor vazio
  Astro.vazio()
      : nome = '',
        tamanho = 0.0,
        distancia = 0.0,
        estrela = '',
        apelido = '' {
    if (kDebugMode) {
      print('Astro vazio criado');
    }
  }

  // Criação de um objeto Astro a partir de um mapa de dados
  factory Astro.fromMap(Map<String, dynamic> map) {
    var astro = Astro(
      id: map['id']?.toString(), // Converte o ID para String
      nome: map['nome'],
      tamanho: map['tamanho'],
      distancia: map['distancia'],
      estrela: map['estrela'],
      apelido: map['apelido'],
    );
    if (kDebugMode) {
      print('Astro criado a partir de mapa: ${astro.toMap()}');
    }
    return astro;
  }

  // Conversão do objeto Astro para um mapa de dados
  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'nome': nome,
      'tamanho': tamanho,
      'distancia': distancia,
      'estrela': estrela,
      'apelido': apelido,
    };
    if (kDebugMode) {
      print('Convertendo Astro para mapa: $map');
    }
    return map;
  }
}
