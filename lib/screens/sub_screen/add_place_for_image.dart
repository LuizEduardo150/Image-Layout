import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/utils/enum_app_values.dart';
import 'package:image_layout/utils/utils.dart';
import 'package:image_layout/application_theme_pers.dart';

class AddImageSpaceMenu extends StatelessWidget{
  final TextEditingController controlerHeight;
  final TextEditingController controlerWidth;
  final int restX;
  final int restY;
  final int recommendedHeight;
  final UnitOfMeasurement unitOfMeasurement;
  final Quality docQuality;
  final VoidCallback confirmFunction;

  const AddImageSpaceMenu({super.key, required this.recommendedHeight,
    required this.restX, required this.restY, required this.controlerHeight,
    required this.controlerWidth, required this.confirmFunction,
    required this.unitOfMeasurement, required this.docQuality
  });

  @override
  Widget build(context){
    final tema = Provider.of<AppThemePers>(context);
    return ListView(children: [
      AlertDialog(
        backgroundColor: tema.bkgColor,
        title: Text("Adicionar campo para imagem", style: TextStyle(fontSize: 20, color: tema.fontColor), textAlign: TextAlign.center),
        titlePadding: const EdgeInsets.all(5),
        insetPadding: const EdgeInsets.all(0),
        alignment: Alignment.center,
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(padding: EdgeInsets.all(4)),
              Row(children: [
                const Padding(padding: EdgeInsets.all(3)),
                Text("Largura restante\nna linha atual ", style: TextStyle(fontSize: 18, color: tema.secondFontColor)),
                const Padding(padding: EdgeInsets.all(4)),
                Text(":", style: TextStyle(color: tema.secondFontColor),),
                const Padding(padding: EdgeInsets.all(4)),
                Text(getRestoX().toStringAsFixed(2), style: TextStyle(fontSize: 18, color: tema.secondFontColor)),
              ],),

              const Padding(padding: EdgeInsets.all(4)),

              Row(children: [
                const Padding(padding: EdgeInsets.all(3)),
                Text("Altura restante\nno documento ", style: TextStyle(fontSize: 18, color: tema.secondFontColor)),
                const Padding(padding: EdgeInsets.all(9)),
                Text(":", style: TextStyle(color: tema.secondFontColor)),
                const Padding(padding: EdgeInsets.all(7)),
                Text(getrestY().toStringAsFixed(2), style: TextStyle(fontSize: 18, color: tema.secondFontColor)),
              ],),

              const Padding(padding: EdgeInsets.all(4)),

              Row(children: [
                const Padding(padding: EdgeInsets.all(3)),
                Text("Altura atual\nrecomendada", style: TextStyle(fontSize: 18, color: tema.secondFontColor)),
                const Padding(padding: EdgeInsets.all(13)),
                Text(":", style: TextStyle(color: tema.secondFontColor)),
                const Padding(padding: EdgeInsets.all(9)),
                Text(getrecommendedHeight().toStringAsFixed(2), style: TextStyle(fontSize: 18, color: tema.secondFontColor)),
              ],),

              const Padding(padding: EdgeInsets.all(15)),

              Row(children: [
                const Padding(padding: EdgeInsets.all(10)),
                Text("Largura: ", style: TextStyle(fontSize: 30, color: tema.fontColor)),
                SizedBox(width: 100, height: 40,
                  child: TextField(
                    style: TextStyle(color: tema.fontColor),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    controller: controlerWidth, keyboardType: TextInputType.number
                  )
                ),
                Text(unitOfMeasurement.toStringReduced(), style: TextStyle(color: tema.secondFontColor),),
              ],),

              const Padding(padding: EdgeInsets.all(4)),

              Row(children: [
                const Padding(padding: EdgeInsets.all(22)),
                Text("Altura: ", style: TextStyle(fontSize: 30, color: tema.fontColor)),
                SizedBox(width: 100, height: 40,
                  child: TextField(
                    style: TextStyle(color: tema.fontColor),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    controller: controlerHeight, keyboardType: TextInputType.number
                  )
                ),
                Text(unitOfMeasurement.toStringReduced(), style: TextStyle(color: tema.secondFontColor),),
              ],),

              const Padding(padding: EdgeInsets.all(4)),

              Container( //espaço para os botoes
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: confirmFunction,
                      style: ElevatedButton.styleFrom(
                        //padding: const EdgeInsets.all(0),
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
                    ),
                  ],),
              )
            ],
          ),
      )
    ],);
  }

  num getRestoX(){
    if(unitOfMeasurement == UnitOfMeasurement.centimeters){
      return pxToCm(docQuality.getValorPPI(), restX);
    }
    else{
      return restX;
    }
  }

  num getrestY(){
    if(unitOfMeasurement == UnitOfMeasurement.centimeters){
      return pxToCm(docQuality.getValorPPI(), restY);
    }
    else{
      return restY;
    }
  }

  num getrecommendedHeight(){
    if(unitOfMeasurement == UnitOfMeasurement.centimeters){
      return pxToCm(docQuality.getValorPPI(), recommendedHeight);
    }
    else{
      return recommendedHeight;
    }
  }

}