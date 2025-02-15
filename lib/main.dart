import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planetario/controles/controle_astros.dart';
import 'package:planetario/modelos/astros.dart';
import 'package:planetario/telas/tela_astros.dart';

void main() {
  runApp(
    const MyApp(),
  );
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
      if (kDebugMode) {
        print(
          'Dados lidos: $_astros',
        );
      }
    });
  }

  void _incluirAstro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaAstros(
          onData: () {},
        ),
      ),
    ).then((value) {
      _lerAstros();
      if (kDebugMode) {
        print(
          'Novo astro incluído e lista recarregada.',
        );
      }
    });
  }

  void _excluirAstro(int id) async {
    await _controleAstros.excluirAstro(id);
    _lerAstros();
  }

  void _confirmarExclusao(BuildContext context, Astro astro) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Confirmação de exclusão')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.warning_outlined,
                size: 48,
                color: Colors.red,
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Você tem certeza que deseja excluir o astro ${astro.nome}?',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () {
                _excluirAstro(int.parse(astro.id!));
                Navigator.of(context).pop();
                if (kDebugMode) {
                  print('Astro excluído: ${astro.id}');
                }
              },
            ),
          ],
        );
      },
    );
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
          if (kDebugMode) {
            print(
              'Exibindo astro: ${astro.nome}\nDistância: ${astro.distancia} Km\nCircunferência: ${astro.tamanho} Km\nEstrela Mãe: ${astro.estrela}\nApelido: ${astro.apelido}',
            );
          }
          return ListTile(
            title: Text(astro.nome),
            subtitle: Text(
              'Distância: ${astro.distancia} Km\nCircunferência: ${astro.tamanho} Km\nEstrela Mãe: ${astro.estrela}\nApelido: ${astro.apelido}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmarExclusao(context, astro),
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
