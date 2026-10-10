import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/application_theme_pers.dart';

class SaveLayoutDialog extends StatelessWidget{
  final TextEditingController controlerNomeLayout;
  final String title;
  final VoidCallback confirmFunction1; //salvar e ir pro editor de foto
  final VoidCallback confirmFunction2; //salvar e continuar no editor de layouts
  const SaveLayoutDialog({super.key, required this.title, required this.controlerNomeLayout, required this.confirmFunction1, required this.confirmFunction2});

  @override
  Widget build(context) {
    final theme = Provider.of<AppThemePers>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return ListView(children: [
      AlertDialog(
        backgroundColor: theme.bkgColor,
        contentPadding: const  EdgeInsets.all(0),
        title: Text(title, textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, color: theme.fontColor, fontWeight: FontWeight.bold)),
        titlePadding: EdgeInsets.only(top: screenSize.height*0.03),
        content:Column(
            children: [
              Container(width: screenSize.height*0.5,
                color: Colors.white10,
                child: TextField(
                  style: TextStyle(color: theme.fontColor, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    controller: controlerNomeLayout
                ),
              ),
              Column(children: [
                Padding(padding: EdgeInsets.only(top: screenSize.height*0.04)),
                ElevatedButton(
                    onPressed: confirmFunction1,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.buttonColor,
                      foregroundColor: theme.fontColor,
                      elevation: 0, // Removendo a sombra
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    child: const Text("Salvar e ir para inserção\nde imagens",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                ),

                Padding(padding: EdgeInsets.only(top: screenSize.height*0.04)),

                ElevatedButton(
                    onPressed: confirmFunction2,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.buttonColor,
                      foregroundColor: theme.fontColor,
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

                Padding(padding: EdgeInsets.only(top: screenSize.height*0.06)),

                ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: theme.buttonColor,
                      foregroundColor: Colors.red,
                      elevation: 0, // Removendo a sombra
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))

                    ),
                    child: const Text("Cancelar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                ),
                Padding(padding: EdgeInsets.only(top: screenSize.height*0.02))

              ],),

            ],)
      )
    ],);
  }
}