import 'package:flutter/material.dart';
import 'package:image_layout/telas/configuracoes_tema.dart';
import 'package:image_layout/telas/criar_novo_layout.dart';
import 'package:image_layout/telas/editar_com_layouts_existentes.dart';
import 'package:image_layout/telas/editor_imagens.dart';
import 'package:image_layout/telas/editor_layout.dart';
import 'package:image_layout/telas/gerenciar_layouts.dart';
import 'package:image_layout/telas/home.dart';
import 'package:image_layout/tema_cores.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
        create: (_) => TemaAplicacao(),
        child: MaterialApp(
          title: "Image Layout",
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/' : (context) => const Home(),
            '/criarNovoLayout': (context) => const CriarNovoLayoutPage(),
            '/editarComlayoutsExistentes': (context) => const NovoLayoutPredefinido(),
            '/gerenciarLayouts': (context) => const GerenciarLayouts(),
            '/configuracaoTema': (context) => const ConfiguracoesTema(),
            '/editorImagens': (context) => const EditorDeImagem(),
            '/editorLayouts': (context) => const EditorLayouts()
          }
        )
    );
  }
}
