import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/application_theme_pers.dart';

Future<void> showChangeSavedLayoutName({required TextEditingController controlerNameLayout, required context, required VoidCallback confirmFunction}) async{
  await showDialog(context: context, builder: (context){
    return _ChangeLayoutNameDialog(
      controlerNameLayout: controlerNameLayout,
      confirmFunction: confirmFunction,
    );
  },);
}

class _ChangeLayoutNameDialog extends StatelessWidget{
  final TextEditingController controlerNameLayout;
  final VoidCallback confirmFunction;
  const _ChangeLayoutNameDialog({required this.controlerNameLayout, required this.confirmFunction});

  @override
  Widget build(context) {
    final theme = Provider.of<AppThemePers>(context);

    return AlertDialog(
          backgroundColor: theme.bkgColor,
          contentPadding: const  EdgeInsets.all(0),
          title: Text('Novo nome:', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, color: theme.fontColor),),
          titlePadding: const EdgeInsets.only(top: 6, bottom: 6),
          content:Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 500,
                color: Colors.white10,
                child: TextField(
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    controller: controlerNameLayout),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    confirmFunction();
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
