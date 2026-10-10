import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/utils/enum_app_values.dart';
import 'package:image_layout/application_theme_pers.dart';


class AddspaceBtwnImagesMenu extends StatelessWidget{
  final TextEditingController controlerHorizontalSpacing;
  final TextEditingController controlerVerticalSpacing;
  final VoidCallback funcaoConfirmar;
  final UnitOfMeasurement unitOfMeasurement;
  
  const AddspaceBtwnImagesMenu({super.key, required this.controlerHorizontalSpacing,
    required this.controlerVerticalSpacing, required this.funcaoConfirmar,
    required this.unitOfMeasurement
  });


  @override
  Widget build(BuildContext context){
    final theme = Provider.of<AppThemePers>(context);

    return ListView(
      shrinkWrap: true,
      children: [
      AlertDialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: theme.bkgColor,
        title: Text("Espaçamento entre imagens", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color: theme.fontColor),),
        titlePadding: const EdgeInsets.all(5),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding: EdgeInsets.all(5)),

            Row(children: [
              const Padding(padding: EdgeInsets.all(5)),
              Text("Espaçamento\nHorizontal", style: TextStyle(color: theme.fontColor),),
              const Padding(padding: EdgeInsets.all(5)),
              
              SizedBox(
                width: 100, height: 50, 
                child: TextField(
                  style: TextStyle(color: theme.fontColor),
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  controller: controlerHorizontalSpacing, keyboardType: TextInputType.number)
              ),
              Text(unitOfMeasurement.toStringReduced(), style: TextStyle(color: theme.secondFontColor),),
            ],),

            const Padding(padding: EdgeInsets.all(5)),

            Row(children: [
              const Padding(padding: EdgeInsets.all(5)),
              Text("Espaçamento\nVertical", style: TextStyle(color: theme.fontColor),),
              const Padding(padding: EdgeInsets.all(5)),
              
              SizedBox(
                width: 100, height: 50,
                child: TextField(
                  style: TextStyle(color: theme.fontColor),
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  controller: controlerVerticalSpacing, keyboardType: TextInputType.number)
              ),
              
              Text(unitOfMeasurement.toStringReduced(), style: TextStyle(color: theme.secondFontColor),),
            ]),

            const Padding(padding: EdgeInsets.all(5)),

            Container( //espaço para os botoes
              color: Colors.transparent,
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: funcaoConfirmar,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0, // Removendo a sombra
                    ),
                    child: const Icon(Icons.check),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  ElevatedButton(
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
                  )
                ]
              )
            )
          ]
        )
      )
    ]);
  }
}