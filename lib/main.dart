import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planetario/controles/controle_astros.dart';
import 'package:planetario/modelos/astros.dart';
import 'package:planetario/telas/tela_astros.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planetário',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Meu Planetário',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ControleAstros controla a leitura e escrita de dados sobre os astros
  final ControleAstros _controleAstros = ControleAstros();
  List<Astro> _astros = [];

  @override
  void initState() {
    super.initState();
    _lerAstros();
  }

  // Lê os dados dos astros e atualiza a lista de astros
  Future<void> _lerAstros() async {
    final resultado = await _controleAstros.lerAstros();
    setState(() {
      _astros = resultado;
      if (kDebugMode) {
        // Exibir os dados lidos no console para controle
        print('Dados lidos: $_astros');
      }
    });
  }

  // Navega para a tela de inclusão de astros e recarrega a lista após a inserção
  void _incluirAstro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaAstros(),
      ),
    ).then((value) {
      _lerAstros(); // Recarregar a lista de astros após inserir um novo astro
      if (kDebugMode) {
        // Exibir mensagem no console após a inserção de um novo astro
        print('Novo astro incluído e lista recarregada.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        // Exibir o número de astros no console
        itemCount: _astros.length,
        itemBuilder: (context, index) {
          final astro = _astros[index];
          // Exibir informações sobre cada astro no console
          if (kDebugMode) {
            print(
              'Exibindo astro: ${astro.nome}${astro.distancia} Km\nCircunferência: ${astro.tamanho} Km\nApelido: ${astro.apelido
            );
          }
          return ListTile(
            title: Text(astro.nome),
            subtitle: Text(
              'Distância: ${astro.distancia} Km\nCircunferência: ${astro.tamanho} Km\nApelido: ${astro.apelido}',
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incluirAstro(context);
        },
        child: const Icon(Icons.public_outlined),
      ),
    );
  }
}
