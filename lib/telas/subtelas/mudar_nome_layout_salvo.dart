import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/tema_cores.dart';

Future<void> exibirTelaMudarNomeLayoutSalvo({required TextEditingController controlerNomeLayout, required context, required VoidCallback funcaoConfirmar}) async{
  await showDialog(context: context, builder: (context){
    return _NomeLayout(
      controlerNomeLayout: controlerNomeLayout,
      funcaoConfirmar: funcaoConfirmar,
    );
  },);
}

class _NomeLayout extends StatelessWidget{
  final TextEditingController controlerNomeLayout;
  final VoidCallback funcaoConfirmar;
  const _NomeLayout({required this.controlerNomeLayout, required this.funcaoConfirmar});

  @override
  Widget build(context) {
    final tema = Provider.of<TemaAplicacao>(context);

    return AlertDialog(
          backgroundColor: tema.corDefundo,
          contentPadding: const  EdgeInsets.all(0),
          title: Text('Novo nome:', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, color: tema.corDaFonte),),
          titlePadding: const EdgeInsets.only(top: 6, bottom: 6),
          content:Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 500,
                color: Colors.white10,
                child: TextField(
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    controller: controlerNomeLayout),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    funcaoConfirmar();
                    Navigator.of(context).pop();
                  },
                    style: ElevatedButton.styleFrom(
                      //padding: const EdgeInsets.all(0),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0, // Removendo a sombra
                    ),
                    child: const Icon(Icons.check),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  ElevatedButton( ///cancelar
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0, // Removendo a sombra
                    ),
                    child: const Icon(Icons.cancel_outlined, size: 30,),
                  ),
                ],),

            ],)
      );
  }
}
