import 'dart:typed_data';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:image_layout/persistence/layout_persistence.dart';
import 'package:image_layout/screens/photo_editor.dart';
import 'package:image_layout/utils/utils.dart';
import 'package:image_layout/application_theme_pers.dart';


class ChooseSavedLayouts extends StatefulWidget {
  const ChooseSavedLayouts({super.key});

  @override
  State<ChooseSavedLayouts> createState() => _ChooseSavedLayoutsState();
}

class _ChooseSavedLayoutsState extends State<ChooseSavedLayouts> {

  ///controle da pagina
  int _selectItem = -1; // índice do item selecionado
  bool load = true;
  LayoutPersistence? persistence;
  bool empty = false;

  ///elementos visuais
  List<Uint8List> tumbnails = [];
  List dimensions = [];
  List supportedImagesNumberList = [];

  @override
  void initState(){
    super.initState();
    persistence = LayoutPersistence();
    initialize();
  }

  void initialize() async{
    await persistence!.loadKeys();
    Uint8List retGetThumb;
    List shape;
    List coordinates;

    insertThumbnails()async{
      for(int i=0; i< persistence!.keys.length; i++){
        persistence!.name = persistence!.keys[i];
        shape = await persistence!.getDocumentSize();
        dimensions.add([shape[1], shape[0]]);
        coordinates = await persistence!.getCoordinatesImg();
        supportedImagesNumberList.add(coordinates.length);
        retGetThumb = await persistence!.getThumbnailLayout();
        tumbnails.add(retGetThumb);
      }
    }

    await Future.delayed(const Duration(milliseconds: 500)); //tempo para troca de paginas
    await insertThumbnails();
    
    load = false;
    
    if(tumbnails.isEmpty){
      empty = true;
    }

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<AppThemePers>(context);
    final Size screenSize = MediaQuery.of(context).size;

    void confirmarEscolha() async{
      if (_selectItem != -1) {
        persistence!.name = persistence!.keys[_selectItem];
        List coordinates = await persistence!.getCoordinatesImg();
        irParaEditor(coordinates);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: tema.buttonColor,
              title: const Text('Erro', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
              content: Text('Selecione um layout antes de continuar.', style: TextStyle(color: tema.fontColor)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK', style: TextStyle(color: tema.fontColor)),
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      backgroundColor: tema.bkgColor,
      appBar: AppBar(
        backgroundColor: tema.buttonColor,
        foregroundColor: Colors.white,
        title: const Text('Seus Layouts'),
      ),
      body: Stack(children: [
        Visibility(
            visible: load,
            child: Container(
              color: Colors.black54,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: screenSize.height*0.1)),
                  Center(child: SizedBox(
                    width: screenSize.width*0.7,
                    child: Image.asset('assets/images/loading_anm.gif'),
                  )),
                  Text("Um instante...", style: TextStyle(color: tema.iconsColor, fontSize: screenSize.width*0.07)),
                ],
              ),
            )
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(child: GridView.count(
                  crossAxisCount: 1,
                  children: List.generate(persistence!.getAmtSavedLayouts(), (index) {
                    final isSelecionado = _selectItem == index;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectItem = index;
                        });
                      },
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelecionado ? Colors.blue : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          child: Column(children: [
                            SizedBox(
                              height: screenSize.height*0.3,
                              child: Image.memory(tumbnails[index], fit: BoxFit.contain),
                            ),
                          ],)
                        ),
                        Text(
                          '${persistence!.keys[index]}',
                          style: TextStyle(fontSize: 20.0, color: tema.fontColor),
                        ),
                        const Padding(padding: EdgeInsets.all(3)),
                        Text("${dimensions[index][0]} x ${dimensions[index][1]} px \n"
                            "~${(pxToCm(300, dimensions[index][0])).toStringAsFixed(2)} x ${(pxToCm(300, dimensions[index][1])).toStringAsFixed(2)} cm (300ppi)",
                            style: TextStyle(fontSize: screenSize.width*0.02, color: tema.fontColor),
                            textAlign: TextAlign.center,
                        ),
                        Text("Suporte para até ${supportedImagesNumberList[index]} imagens", style: TextStyle(color: tema.fontColor),),
                    ],),
                    );
                  }),
                ),),
              ],
            ),
          ),
        Visibility(
          visible: empty,
          child: Container(
              padding:  EdgeInsets.all(screenSize.height*0.06),
              child: Column(
                children: [
                  Text("Não há layouts salvos aqui por enquanto.", style: TextStyle(color: tema.fontColor, fontSize: screenSize.width*0.1),),
                  TextButton(
                      child: Text("Criar um layout?", style: TextStyle(color: tema.iconsColor, fontSize: screenSize.width*0.09, decoration: TextDecoration.underline)),
                      onPressed: () => Navigator.pushNamed(context, '/criarNovoLayout')
                  )
                ],
              )
          ),
        ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: confirmarEscolha,
        backgroundColor: tema.buttonColor,
        foregroundColor: tema.iconsColor,
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  void irParaEditor(List posicoes){
    ImageEditorPageArgs argumentos = ImageEditorPageArgs(dimensions[_selectItem][0], dimensions[_selectItem][1], posicoes);
    Navigator.pushNamed(context, "/editorImagens", arguments: argumentos);
  }

}
