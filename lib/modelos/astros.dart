// Criação da classe Astros, responsável por armazenar os dados referentes aos astros
class Astro {
  String? id; // Identificador opcional
  String nome; // Nome do astro
  double tamanho; // Tamanho ou circunferência do astro
  double distancia; // Distância do astro em relação à sua estrela
  String? apelido; // Apelido: Nome alternativo para o astro

  // Construtor da classe Astro
  Astro({
    this.id,
    required this.nome,
    required this.tamanho,
    required this.distancia,
    this.apelido,
  });

  // Construtor vazio
  Astro.vazio()
      : nome = '',
        tamanho = 0.0,
        distancia = 0.0,
        apelido = '';

  // Criação de um objeto Astro a partir de um mapa de dados
  factory Astro.fromMap(Map<String, dynamic> map) {
    return Astro(
      id: map['id']?.toString(), // Converte o ID para String
      nome: map['nome'],
      tamanho: map['tamanho'],
      distancia: map['distancia'],
      apelido: map['apelido'],
    );
  }

  // Conversão do objeto Astro para um mapa de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tamanho': tamanho,
      'distancia': distancia,
      'apelido': apelido,
    };
  }
}
