import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import 'package:image_layout/application_theme_pers.dart';

class SubTelaConfirmacao extends StatelessWidget{
  final String texto;
  final String subtexto;
  final VoidCallback funcaoConfirmar;
  const SubTelaConfirmacao({super.key, required this.subtexto, required this.texto ,required this.funcaoConfirmar});

  @override
  Widget build(context){
    final tema = Provider.of<TemaAplicacao>(context);
    final Size telaTamanho = MediaQuery.of(context).size;

    return AlertDialog(
      scrollable: true,
      backgroundColor: tema.corBotoes,
      contentPadding: const EdgeInsets.all(5),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, color: Colors.amber, size: telaTamanho.height*0.05,),
          const Text("  Atenção", style: TextStyle(fontSize: 30, color: Colors.amber), textAlign: TextAlign.center),
        ],
      ),
      titlePadding: const EdgeInsets.all(10),
      
      content: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: tema.corDefundo),
        padding: EdgeInsets.only(left: telaTamanho.width*0.03, right: telaTamanho.width*0.03),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding: EdgeInsets.all(4)),
            Text(texto,
              softWrap: true,
              style: TextStyle(fontSize: 20, color: tema.corDaFonte),
              textAlign: TextAlign.justify,
            ),
            const Padding(padding: EdgeInsets.all(4)),
            Text(subtexto,
              softWrap: true,
              style: TextStyle(fontSize: 20, color: tema.corDaFonte),
            ),
            const Padding(padding: EdgeInsets.all(4)),
          ],
        )
      ),

        actions: [Row(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [

              ElevatedButton(onPressed: funcaoConfirmar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    backgroundColor: tema.corBotoes,
                    elevation: 0, // Removendo a sombra
                  ),
                  child: Text("SIM", style: TextStyle(fontSize: 18, color: tema.corDosIcones)),
                ),

                const Padding(padding: EdgeInsets.only(right: 25)),
                
                ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    backgroundColor: tema.corBotoes,
                    elevation: 0, // Removendo a sombra
                  ),
                  child: Text("NÃO", style: TextStyle(fontSize: 18, color: tema.corIconeBototesClaro)),
                ),
            ]
        )],
        
    );
  }
}