import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/tema_cores.dart';


class ConfiguracoesTema extends StatefulWidget {
  const ConfiguracoesTema({super.key});

  @override
  State<ConfiguracoesTema> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<ConfiguracoesTema> {

  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<TemaAplicacao>(context);
    final Size telaTamanho = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: tema.corDefundo,
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0.0,
        backgroundColor: tema.corBotoes,
        title: const Text('Defina o tema:'),
      ),
      body: ListView(children: [
        ListTile(
          title: Text('Claro (Img Layout)', style: TextStyle(color: tema.corDaFonte)),
          leading: tema.temaAtual == 'claro'? Icon(Icons.radio_button_checked, color: tema.corIconeBototesClaro) : Icon(Icons.radio_button_off, color: tema.corIconeBototesClaro),
          onTap: (){
            setState(() {
              tema.setTemaClaro();
            });
          },
        ),
        ListTile(
          title: Text('Escuro (Img Layout)', style: TextStyle(color: tema.corDaFonte)),
          leading: tema.temaAtual == 'escuro'? Icon(Icons.radio_button_checked, color: tema.corIconeBototesClaro) : Icon(Icons.radio_button_off, color: tema.corIconeBototesClaro),
          onTap: (){
            setState(() {
              tema.setTemaEscuro();
            });
          },
        ),
        ListTile(
          title: Text('Claro (padrão)', style: TextStyle(color: tema.corDaFonte)),
          leading: tema.temaAtual == 'claropadrao'? Icon(Icons.radio_button_checked, color: tema.corIconeBototesClaro) : Icon(Icons.radio_button_off, color: tema.corIconeBototesClaro),
          onTap: (){
            setState(() {
              tema.setTemaClaroPadrao();
            });
          },
        ),
        ListTile(
          title: Text('Escuro (padrão)', style: TextStyle(color: tema.corDaFonte)),
          leading: tema.temaAtual == 'escuropadrao'? Icon(Icons.radio_button_checked, color: tema.corIconeBototesClaro) : Icon(Icons.radio_button_off, color: tema.corIconeBototesClaro),
          onTap: (){
            setState(() {
              tema.setTemaEscuroPadrao();
            });
          },
        ),

        Padding(padding: EdgeInsets.all(telaTamanho.height*0.03)),

        Text("Exemplo de visual da aplicação:", style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.width*0.05),),

        Padding(padding: EdgeInsets.all(telaTamanho.height*0.01)),

        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                color: tema.corBotoes,
                borderRadius: BorderRadius.circular(40)
            ),
            child: Center(child: Text("Um Botão", style: TextStyle(color: tema.corDosIcones, fontSize: telaTamanho.width*0.1),)),
          ),
        ),

        Padding(padding: EdgeInsets.all(telaTamanho.height*0.01)),

        Column(children: [
              Container(
                height: telaTamanho.height*0.06,
                color: tema.corBotoes,
                child: Row(children: [
                  Text('  <-  Uma página', style: TextStyle(color: Colors.white, fontSize: telaTamanho.width*0.04),),
                ],)
              ),
        ],),

        Padding(padding: EdgeInsets.all(telaTamanho.height*0.01)),

        Container(
            height: telaTamanho.height*0.07,
            color: tema.corBotoes,
            child: Row(children: [
              const Icon(Icons.home, color: Colors.white),
              Padding(padding: EdgeInsets.only(left: telaTamanho.width*0.1)),
              const Icon(Icons.add_box_rounded, color: Colors.white),
              Padding(padding: EdgeInsets.only(left: telaTamanho.width*0.1)),
              const Icon(Icons.square_outlined, color: Colors.white),
              Padding(padding: EdgeInsets.only(left: telaTamanho.width*0.1)),
              const Icon(Icons.square_outlined, color: Colors.white),
            ],)
        ),


      ],),
    );
  }
}
