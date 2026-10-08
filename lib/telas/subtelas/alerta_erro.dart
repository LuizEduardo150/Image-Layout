import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:image_layout/tema_cores.dart';

class AlertaErroDialogBox extends StatelessWidget{
  final String texto;
  const AlertaErroDialogBox({super.key, required this.texto});

  @override
  Widget build(BuildContext context){

    final tema = Provider.of<TemaAplicacao>(context);
    final Size telaTamanho = MediaQuery.of(context).size;

    return AlertDialog(
      scrollable: true,
      backgroundColor: tema.corBotoes,
      
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cancel, color: Colors.red, size: 50),
          Text('     ERRO!', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red))
        ],
      ),
      titlePadding: const EdgeInsets.all(10),
      
      content: Text(
        texto,
        style: TextStyle(fontSize: telaTamanho.height*0.04, color: tema.corDaFonte),
        textAlign: TextAlign.left,
        softWrap: true,
      ),
        
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: tema.corBotoes,
              foregroundColor: tema.corIconeBototesClaro
            ),
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text("sair", style: TextStyle(fontSize: 30))
            
          )
      ],
    );
  }
}
