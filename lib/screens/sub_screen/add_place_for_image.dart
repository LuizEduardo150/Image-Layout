import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/utils/enum_app_values.dart';
import 'package:image_layout/utils/utils.dart';
import 'package:image_layout/application_theme_pers.dart';

class MenuAddEspacoDeImagem extends StatelessWidget{
  final TextEditingController controlerAltura;
  final TextEditingController controlerLargura;
  final int restoX;
  final int restoY;
  final int alturaRecomendada;
  final UnidadeDeMedida unidadeMedida;
  final Qualidade qualidadeDoc;
  final VoidCallback funcaoConfirmar;

  const MenuAddEspacoDeImagem({super.key, required this.alturaRecomendada,
    required this.restoX, required this.restoY, required this.controlerAltura,
    required this.controlerLargura, required this.funcaoConfirmar,
    required this.unidadeMedida, required this.qualidadeDoc
  });

  @override
  Widget build(context){
    final tema = Provider.of<TemaAplicacao>(context);
    return ListView(children: [
      AlertDialog(
        backgroundColor: tema.corDefundo,
        title: Text("Adicionar campo para imagem", style: TextStyle(fontSize: 20, color: tema.corDaFonte), textAlign: TextAlign.center),
        titlePadding: const EdgeInsets.all(5),
        insetPadding: const EdgeInsets.all(0),
        alignment: Alignment.center,
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(padding: EdgeInsets.all(4)),
              Row(children: [
                const Padding(padding: EdgeInsets.all(3)),
                Text("Largura restante\nna linha atual ", style: TextStyle(fontSize: 18, color: tema.corFonteSecundaria)),
                const Padding(padding: EdgeInsets.all(4)),
                Text(":", style: TextStyle(color: tema.corFonteSecundaria),),
                const Padding(padding: EdgeInsets.all(4)),
                Text(getRestoX().toStringAsFixed(2), style: TextStyle(fontSize: 18, color: tema.corFonteSecundaria)),
              ],),

              const Padding(padding: EdgeInsets.all(4)),

              Row(children: [
                const Padding(padding: EdgeInsets.all(3)),
                Text("Altura restante\nno documento ", style: TextStyle(fontSize: 18, color: tema.corFonteSecundaria)),
                const Padding(padding: EdgeInsets.all(9)),
                Text(":", style: TextStyle(color: tema.corFonteSecundaria)),
                const Padding(padding: EdgeInsets.all(7)),
                Text(getRestoY().toStringAsFixed(2), style: TextStyle(fontSize: 18, color: tema.corFonteSecundaria)),
              ],),

              const Padding(padding: EdgeInsets.all(4)),

              Row(children: [
                const Padding(padding: EdgeInsets.all(3)),
                Text("Altura atual\nrecomendada", style: TextStyle(fontSize: 18, color: tema.corFonteSecundaria)),
                const Padding(padding: EdgeInsets.all(13)),
                Text(":", style: TextStyle(color: tema.corFonteSecundaria)),
                const Padding(padding: EdgeInsets.all(9)),
                Text(getAlturaRecomendada().toStringAsFixed(2), style: TextStyle(fontSize: 18, color: tema.corFonteSecundaria)),
              ],),

              const Padding(padding: EdgeInsets.all(15)),

              Row(children: [
                const Padding(padding: EdgeInsets.all(10)),
                Text("Largura: ", style: TextStyle(fontSize: 30, color: tema.corDaFonte)),
                SizedBox(width: 100, height: 40,
                  child: TextField(style: TextStyle(color: tema.corDaFonte), decoration: const InputDecoration(border: OutlineInputBorder()), controller: controlerLargura, keyboardType: TextInputType.number),
                ),
                Text(unidadeMedida.toStringReduzido(), style: TextStyle(color: tema.corFonteSecundaria),),
              ],),

              const Padding(padding: EdgeInsets.all(4)),

              Row(children: [
                const Padding(padding: EdgeInsets.all(22)),
                Text("Altura: ", style: TextStyle(fontSize: 30, color: tema.corDaFonte)),
                SizedBox(width: 100, height: 40,
                  child: TextField(style: TextStyle(color: tema.corDaFonte), decoration: const InputDecoration(border: OutlineInputBorder()), controller: controlerAltura, keyboardType: TextInputType.number),
                ),
                Text(unidadeMedida.toStringReduzido(), style: TextStyle(color: tema.corFonteSecundaria),),
              ],),

              const Padding(padding: EdgeInsets.all(4)),

              Container( //espaço para os botoes
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: funcaoConfirmar,
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
    if(unidadeMedida == UnidadeDeMedida.centimetros){
      return pxToCm(qualidadeDoc.getValorPPI(), restoX);
    }
    else{
      return restoX;
    }
  }

  num getRestoY(){
    if(unidadeMedida == UnidadeDeMedida.centimetros){
      return pxToCm(qualidadeDoc.getValorPPI(), restoY);
    }
    else{
      return restoY;
    }
  }

  num getAlturaRecomendada(){
    if(unidadeMedida == UnidadeDeMedida.centimetros){
      return pxToCm(qualidadeDoc.getValorPPI(), alturaRecomendada);
    }else{
      return alturaRecomendada;
    }
  }

}