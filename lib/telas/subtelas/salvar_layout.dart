import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/tema_cores.dart';

class SalvarLayout extends StatelessWidget{
  final TextEditingController controlerNomeLayout;
  final String titulo;
  final VoidCallback funcaoConfirmar1; //salvar e ir pro editor de foto
  final VoidCallback funcaoConfirmar2; //salvar e continuar no editor de layouts
  const SalvarLayout({super.key, required this.titulo, required this.controlerNomeLayout, required this.funcaoConfirmar1, required this.funcaoConfirmar2});

  @override
  Widget build(context) {
    final tema = Provider.of<TemaAplicacao>(context);
    final Size telaTamanho = MediaQuery.of(context).size;

    return ListView(children: [
      AlertDialog(
        backgroundColor: tema.corDefundo,
        contentPadding: const  EdgeInsets.all(0),
        title: Text(titulo, textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, color: tema.corDaFonte, fontWeight: FontWeight.bold)),
        titlePadding: EdgeInsets.only(top: telaTamanho.height*0.03),
        content:Column(
            children: [
              Container(width: telaTamanho.height*0.5,
                color: Colors.white10,
                child: TextField(
                  style: TextStyle(color: tema.corDaFonte, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    controller: controlerNomeLayout
                ),
              ),
              Column(children: [
                Padding(padding: EdgeInsets.only(top: telaTamanho.height*0.04)),
                ElevatedButton(
                    onPressed: funcaoConfirmar1,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tema.corBotoes,
                      foregroundColor: tema.corDaFonte,
                      elevation: 0, // Removendo a sombra
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    child: const Text("Salvar e ir para inserção\nde imagens",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                ),

                Padding(padding: EdgeInsets.only(top: telaTamanho.height*0.04)),

                ElevatedButton(
                    onPressed: funcaoConfirmar2,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tema.corBotoes,
                      foregroundColor: tema.corDaFonte,
                      elevation: 0, // Removendo a sombra
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    child: const Text("  Salvar e continuar no   \neditor de layouts",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    )
                ),

                Padding(padding: EdgeInsets.only(top: telaTamanho.height*0.06)),

                ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: tema.corBotoes,
                      foregroundColor: Colors.red,
                      elevation: 0, // Removendo a sombra
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))

                    ),
                    child: const Text("Cancelar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                ),
                Padding(padding: EdgeInsets.only(top: telaTamanho.height*0.02))

              ],),

            ],)
      )
    ],);
  }
}