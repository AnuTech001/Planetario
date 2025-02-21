import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planetario/controles/controle_astros.dart';
import 'package:planetario/modelos/astros.dart';
import 'package:planetario/telas/tela_astros.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

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
        textTheme: GoogleFonts.orbitronTextTheme(),
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Astro> _astros = [];
  // ignore: unused_field
  late Future<void> _futureAstros;

  @override
  void initState() {
    super.initState();
    _futureAstros = _atualizarAstros();
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Color(0xff00FF00),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.warning_outlined,
                size: 48,
                color: Color(0xffFF0000),
              ),
              SizedBox(height: 16),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Você tem certeza que deseja excluir o astro ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: astro.nome,
                        style: TextStyle(
                          color: Color(0xff00FF00),
                        ),
                      ),
                      TextSpan(
                        text: '?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center, // Alinhamento central do texto
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black, // Mover para fora do Column
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cancel,
                        color: Color(0xff00FF00),
                      ),
                      SizedBox(width: 8), // Espaçamento entre ícone e texto
                      Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Color(0xff00FF00),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4), // Espaçamento entre os botões
                TextButton(
                  onPressed: () {
                    _excluirAstro(int.parse(astro.id!));
                    Navigator.of(context).pop();
                    // Debug print
                    if (kDebugMode) {
                      print('Astro excluído: ${astro.id}');
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delete_forever_outlined,
                        color: Color(0xffFF0000),
                      ),
                      SizedBox(width: 4), // Espaçamento entre ícone e texto
                      Text(
                        'Excluir',
                        style: TextStyle(
                          color: Color(0xffFF0000),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _playMusic() async {
    if (kDebugMode) {
      print('Tentando tocar música...');
    }
    try {
      await _audioPlayer.setSource(AssetSource('audio/musica.mp3'));
      _audioPlayer.setReleaseMode(ReleaseMode.loop); // Configurar para repetir
      await _audioPlayer.resume();
      if (kDebugMode) {
        print('Música tocando...');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao carregar o arquivo de música: $e');
      }
    }
  }

  void _pauseMusic() async {
    await _audioPlayer.pause();
    if (kDebugMode) {
      print('Música pausada');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: Color(0xff00FF00),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              height: 2.0,
              color: Color(0xff00FF00),
            )
          ],
        ),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _futureAstros, // Usar o Future inicializado no initState
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os dados'));
          } else {
            return ListView.builder(
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
                  title: Text(
                    astro.nome,
                    style: TextStyle(
                      color: Color(0xff00FF00),
                    ),
                  ),
                  subtitle: Text(
                    'Circunferência: ${astro.tamanho} Km\n'
                    'Distância: ${astro.distancia} Km\n'
                    'Estrela Mãe: ${astro.estrela}\n'
                    'Apelido: ${astro.apelido}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Color(0xff0000FF),
                        ),
                        onPressed: () => _alterarAstros(context, astro),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Color(0xffFF0000),
                        ),
                        onPressed: () => _confirmarExclusao(context, astro),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 40.0, // Defina a largura desejada
            height: 40.0, // Defina a altura desejada
            child: FloatingActionButton(
              onPressed: _playMusic,
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Color(0xff00FF00),
                  width:
                      2.0, // Altere este valor para ajustar a largura da borda
                ),
              ),
              child: const Icon(
                Icons.music_note,
                color: Color(0xff0000FF),
                size: 30.0, // Altere este valor para ajustar o tamanho do ícone
              ),
            ),
          ),
          SizedBox(height: 8.0),
          SizedBox(
            width: 40.0, // Defina a largura desejada
            height: 40.0, // Defina a altura desejada
            child: FloatingActionButton(
              onPressed: _pauseMusic,
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Color(0xff00FF00),
                  width:
                      2.0, // Altere este valor para ajustar a largura da borda
                ),
              ),
              child: const Icon(
                Icons.pause,
                color: Color(0xffFF0000),
                size: 30.0, // Altere este valor para ajustar o tamanho do ícone
              ),
            ),
          ),
          SizedBox(height: 8.0),
          SizedBox(
            width: 40.0, // Defina a largura desejada
            height: 40.0, // Defina a altura desejada
            child: FloatingActionButton(
              onPressed: () {
                _incluirAstro(context);
              },
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Color(0xff00FF00),
                  width:
                      2.0, // Altere este valor para ajustar a largura da borda
                ),
              ),
              child: const Icon(
                Icons.public_outlined,
                color: Color(0xff00FF00),
                size: 30.0, // Altere este valor para ajustar o tamanho do ícone
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
