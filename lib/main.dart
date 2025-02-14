import 'package:flutter/material.dart';
import 'package:planetario/controles/controle_astros.dart';
import 'package:planetario/modelos/astros.dart';
import 'package:planetario/telas/tela_astros.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controleAstros = ControleAstros();
  await controleAstros
      .deletarBancoDeDados(); // Adicione isso temporariamente para recriar o banco
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
  final ControleAstros _controleAstros = ControleAstros();
  List<Astro> _astros = [];

  @override
  void initState() {
    super.initState();
    _lerAstros();
  }

  Future<void> _lerAstros() async {
    final resultado = await _controleAstros.lerAstros();
    setState(() {
      _astros = resultado;
      print('Dados lidos: $_astros');
    });
  }

  void _incluirAstro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaAstros(),
      ),
    ).then((value) {
      _lerAstros(); // Recarregar a lista de astros após inserir um novo astro
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
        itemCount: _astros.length,
        itemBuilder: (context, index) {
          final astro = _astros[index];
          return ListTile(
            title: Text(astro.nome),
            subtitle: Text(
                'Distância: ${astro.distancia} km\nCircunferência: ${astro.tamanho} km'),
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
