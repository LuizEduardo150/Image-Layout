import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/utils/enumarator_qualidade_foto_e_unidade_medida.dart';
import 'package:image_layout/tema_cores.dart';


class MenuAddEspacamento extends StatelessWidget{
  final TextEditingController controlerEspacamentoHorizontal;
  final TextEditingController controlerEspacamentoVertical;
  final VoidCallback funcaoConfirmar;
  final UnidadeDeMedida unidadeMedida;
  const MenuAddEspacamento({super.key, required this.controlerEspacamentoHorizontal,
    required this.controlerEspacamentoVertical, required this.funcaoConfirmar,
    required this.unidadeMedida
  });

  @override
  Widget build(BuildContext context){
    final tema = Provider.of<TemaAplicacao>(context);

    return ListView(
      shrinkWrap: true,
      children: [
      AlertDialog(
        insetPadding: const EdgeInsets.all(0),
          backgroundColor: tema.corDefundo,
        title: Text("Espaçamento entre imagens", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color: tema.corDaFonte),),
        titlePadding: const EdgeInsets.all(5),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(padding: EdgeInsets.all(5)),

              Row(children: [
                const Padding(padding: EdgeInsets.all(5)),
                Text("Espaçamento\nHorizontal", style: TextStyle(color: tema.corDaFonte),),
                const Padding(padding: EdgeInsets.all(5)),
                SizedBox(width: 100, height: 50, child: TextField(style: TextStyle(color: tema.corDaFonte), decoration: const InputDecoration(border: OutlineInputBorder()), controller: controlerEspacamentoHorizontal, keyboardType: TextInputType.number),),
                Text(unidadeMedida.toStringReduzido(), style: TextStyle(color: tema.corFonteSecundaria),),
              ],),

              const Padding(padding: EdgeInsets.all(5)),

              Row(children: [
                const Padding(padding: EdgeInsets.all(5)),
                Text("Espaçamento\nVertical", style: TextStyle(color: tema.corDaFonte),),
                const Padding(padding: EdgeInsets.all(5)),
                SizedBox(width: 100, height: 50, child: TextField(style: TextStyle(color: tema.corDaFonte), decoration: const InputDecoration(border: OutlineInputBorder()), controller: controlerEspacamentoVertical, keyboardType: TextInputType.number),),
                Text(unidadeMedida.toStringReduzido(), style: TextStyle(color: tema.corFonteSecundaria),),
              ],),

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
                    ),
                  ],),
              )
            ],)
      )
    ],);
  }
}