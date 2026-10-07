import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:image_layout/tema_cores.dart';

class AlertaErroDialogBox extends StatelessWidget{
  final String texto;
  const AlertaErroDialogBox({super.key, required this.texto});

  @override
  Widget build(context){
    final tema = Provider.of<TemaAplicacao>(context);
    final Size telaTamanho = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: tema.corBotoes,
      contentPadding: const EdgeInsets.all(2),
      title: Column(children: [
        Icon(Icons.cancel, color: Colors.red, size: telaTamanho.height*0.05,),
        Text("ERRO!", style: TextStyle(fontSize: telaTamanho.height*0.05, color: Colors.red)),
      ],),
      titlePadding: const EdgeInsets.all(10),
      content: ListView(
        children: [
          Container(
            decoration: BoxDecoration(color: tema.corDefundo, borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.only(left: telaTamanho.width*0.03, right: telaTamanho.width*0.03),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  texto,
                  style: TextStyle(fontSize: telaTamanho.height*0.04, color: tema.corDaFonte),
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tema.corBotoes,
                    foregroundColor: tema.corIconeBototesClaro
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("sair", style: TextStyle(fontSize: telaTamanho.height*0.04))
                ),
            ],),),
        ],
      ),
    );
  }
}