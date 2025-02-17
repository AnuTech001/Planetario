import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planetario/controles/controle_astros.dart';
import 'package:planetario/modelos/astros.dart';

class TelaAstros extends StatefulWidget {
  final Astro astros;
  final Function() onData;
  const TelaAstros({
    super.key,
    required this.astros,
    required this.onData,
  });

  @override
  State<TelaAstros> createState() => _TelaAstrosState();
}

class _TelaAstrosState extends State<TelaAstros> {
  // Chave global para o formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _estrelaController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();

  // Instância do controle de astros e do modelo de astro
  final ControleAstros _controleAstros = ControleAstros();
  late Astro _astros;

  @override
  void initState() {
    super.initState();
    _astros = widget.astros;
    _nomeController.text = _astros.nome;
    _tamanhoController.text = _astros.tamanho.toString();
    _distanciaController.text = _astros.distancia.toString();
    _estrelaController.text = _astros.estrela!;
    _apelidoController.text = _astros.apelido ?? '';
  }

  @override
  void dispose() {
    // Dispor dos controladores ao descartar o widget
    _nomeController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _estrelaController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  // Método para inserir um astro no banco de dados
  Future<void> _inserirAstro() async {
    _astros.nome = _nomeController.text;
    _astros.tamanho = double.parse(_tamanhoController.text);
    _astros.distancia = double.parse(_distanciaController.text);
    _astros.apelido = _apelidoController.text;
    _astros.estrela = _estrelaController.text;
    await _controleAstros.inserirAstro(_astros);
    if (kDebugMode) {
      // Log para verificação dos dados inseridos
      print('Astro inserido: ${_astros.toMap()}');
    }
  }

  // Método para submeter o formulário
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _inserirAstro().then((_) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dados cadastrados com sucesso!'),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(); // Navegar de volta para a tela principal
        widget.onData();
        if (kDebugMode) {
          // Log para verificar a navegação de volta
          print('Navegando de volta para a tela principal após cadastro.');
        }
      });
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
                // Campo de texto para estrela mãe
                TextFormField(
                  controller: _estrelaController,
                  decoration: InputDecoration(
                    labelText: 'Estrela Mãe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length <= 2) {
                      return 'Por favor, insira o nome da estrela\nCom três ou mais letras';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _astros.estrela = value!;
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
