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
    _atualizarAstros();
  }

  Future<void> _atualizarAstros() async {
    final resultado = await _controleAstros.lerAstros();
    setState(() {
      _astros = resultado;
      // Debug print
      if (kDebugMode) {
        print('Dados lidos: $_astros');
      }
    });
  }

  void _incluirAstro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaAstros(
          astros: Astro.vazio(),
          onData: () {},
        ),
      ),
    ).then((value) {
      _atualizarAstros();
      // Debug print
      if (kDebugMode) {
        print('Novo astro incluído e lista recarregada.');
      }
    });
  }

  void _excluirAstro(int id) async {
    await _controleAstros.excluirAstro(id);
    _atualizarAstros();
    // Debug print
    if (kDebugMode) {
      print('Item excluído com sucesso');
    }
  }

  void _alterarAstros(BuildContext context, Astro astro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaAstros(
          astros: astro,
          onData: () {
            _atualizarAstros();
          },
        ),
      ),
    ).then((value) {
      _atualizarAstros();
      // Debug print
      if (kDebugMode) {
        print('Novo astro incluído e lista recarregada.');
      }
    });
  }

  void _confirmarExclusao(BuildContext context, Astro astro) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.warning_outlined,
                size: 48,
                color: Colors.black,
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
                // Debug print
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
          // Debug print
          if (kDebugMode) {
            print('Exibindo astro: ${astro.nome}\n'
                'Circunferência: ${astro.tamanho} Km\n'
                'Distância: ${astro.distancia} Km\n'
                'Estrela Mãe: ${astro.estrela}\n'
                'Apelido: ${astro.apelido}');
          }
          return ListTile(
              title: Text(astro.nome),
              subtitle: Text(
                'Circunferência: ${astro.tamanho} Km\n'
                'Distância: ${astro.distancia} Km\n'
                'Estrela Mãe: ${astro.estrela}\n'
                'Apelido: ${astro.apelido}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _alterarAstros(context, astro),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _confirmarExclusao(context, astro),
                  ),
                ],
              ));
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
