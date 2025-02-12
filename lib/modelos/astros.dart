// Criação da classe Astros, responsável por armazenar os dados referentes aos astros
class Astros {
  String? id; // Identificador opcional
  String nome; // Nome do astro
  double tamanho; // Tamanho ou circunferência do astro
  double distancia; // Distância do astro em relação à sua estrela
  String? apelido; // Apelido: Nome alternativo para o astro

  // Construtor de classe Astros
  Astros({
    this.id,
    required this.nome,
    required this.tamanho,
    required this.distancia,
    this.apelido,
  });

  // Construtor vazio
  Astros.vazio()
      : nome = '',
        tamanho = 0.0,
        distancia = 0.0,
        apelido = '';

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
