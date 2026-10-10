import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/screens/theme_configuration.dart';
import 'package:image_layout/screens/create_new_layout.dart';
import 'package:image_layout/screens/choose_saved_layouts.dart';
import 'package:image_layout/screens/photo_editor.dart';
import 'package:image_layout/screens/layout_editor.dart';
import 'package:image_layout/screens/manage_layouts.dart';
import 'package:image_layout/screens/home.dart';
import 'package:image_layout/application_theme_pers.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){

    return ChangeNotifierProvider(
        create: (_) => AppThemePers(),
        child: MaterialApp(
          title: "Image Layout",
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/' : (context) => const Home(),
            '/criarNovoLayout': (context) => const CreateNewLayoutPage(),
            '/editarComlayoutsExistentes': (context) => const ChooseSavedLayouts(),
            '/gerenciarLayouts': (context) => const ManageLayouts(),
            '/configuracaoTheme': (context) => const ThemeConfiguration(),
            '/editorImagens': (context) => const ImageEditorPage(),
            '/editorLayouts': (context) => const LayoutEditorPage()
          }
        )
    );
  }

}
