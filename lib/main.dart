import 'package:flutter/material.dart';
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
      home: const MyHomePage(
        title: 'Cadastro',
      ),
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
              '''
            Saudações usúario,
            Esse é um pequeno APP criado para 
            o meu curso Talento Tech. 😁
            ''',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incluirAstro(context);
        },
        child: const Icon(Icons.public_outlined),
      ),
    );
  }

  void _incluirAstro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaAstros(),
      ),
    );
  }
}
