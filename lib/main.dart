import 'package:flutter/material.dart';
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
      // Título do aplicativo
      title: 'Planetário',
      debugShowCheckedModeBanner: false,
      // Define o tema do aplicativo usando Material Design 3
      theme: ThemeData(
        useMaterial3: true,
      ),
      // Define a página inicial do aplicativo
      home: const TelaAstros(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Astros _astros = Astros(
    id: '',
    nome: 'Terra',
    tamanho: 12742.0,
    distancia: 149600000.0,
    apelido: 'O Planeta Azul',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Dados do planeta:',
            ),
            Text(
              'Nome: ${_astros.nome}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'Tamanho: ${_astros.tamanho} km',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'Distância: ${_astros.distancia} km',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'Apelido: ${_astros.apelido}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
