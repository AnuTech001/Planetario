import 'package:flutter/material.dart';
import 'package:planetario/controles/controle_astros.dart';
import 'package:planetario/modelos/astros.dart';

// Classe responsável pela criação da tela
class TelaAstros extends StatefulWidget {
  const TelaAstros({super.key});

  @override
  State<TelaAstros> createState() => _TelaAstrosState();
}

// Estado da classe TelaAstros
class _TelaAstrosState extends State<TelaAstros> {
  // Chave global do formulário para validação
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para capturar os dados do usuário
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();

  // Instância inicializada da classe de controle
  final ControleAstros _controleAstros = ControleAstros();
  // Instância inicializada da classe Astros para armazenar os dados
  final Astros _astros = Astros.vazio();

  @override
  void initState() {
    // Inicializa os controladores de texto, caso necessário
    super.initState();
  }

  @override
  void dispose() {
    // Libera os recursos dos controladores de texto
    _nomeController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  Future<void> _inserirAstro() async {
    _astros.nome = _nomeController.text;
    _astros.tamanho = double.parse(_tamanhoController.text);
    _astros.distancia = double.parse(_distanciaController.text);
    _astros.apelido = _apelidoController.text;
    await _controleAstros.inserirAstro(_astros);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _inserirAstro();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados cadastrados com sucesso!'),
        ),
      );
      Navigator.of(context).pop(); // Adicionado parênteses aqui
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastrar Astro'),
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo de texto para nome
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length <= 2) {
                      return 'Por favor, insira o nome do planeta\nCom três ou mais letras';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _astros.nome = value!;
                  },
                ),
                const SizedBox(height: 16),
                // Campo de texto para tamanho/circunferência
                TextFormField(
                  controller: _tamanhoController,
                  decoration: InputDecoration(
                    labelText: 'Circunferência (Km)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a circunferência do planeta';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, apenas números são aceitos';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _astros.tamanho = double.parse(value!);
                  },
                ),
                const SizedBox(height: 16),
                // Campo de texto para distância da estrela
                TextFormField(
                  controller: _distanciaController,
                  decoration: InputDecoration(
                    labelText: 'Distância de sua estrela (Km)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a distância do planeta\nem relação a sua estrela';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, apenas números são aceitos';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _astros.distancia = double.parse(value!);
                  },
                ),
                const SizedBox(height: 16),
                // Campo de texto para apelido
                TextFormField(
                  controller: _apelidoController,
                  onSaved: (value) {
                    _astros.apelido = value!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Apelido',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Botão para submeter o formulário
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Icon(
                    Icons.add_outlined,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: TelaAstros()));
}
