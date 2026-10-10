import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/application_theme_pers.dart';
import 'package:image_layout/persistence/layout_persistence.dart';
import 'package:image_layout/utils/utils.dart';
import 'package:image_layout/screens/sub_screen/confirm_decision_alert.dart';
import 'package:image_layout/screens/sub_screen/change_saved_layout_name.dart';
import 'package:image_layout/screens/sub_screen/error_alert.dart';
import 'package:image_layout/screens/create_new_layout.dart';


class ManageLayouts extends StatefulWidget {
  const ManageLayouts({super.key});

  @override
  State<ManageLayouts> createState() => _ManageLayoutsState();
}

class _ManageLayoutsState extends State<ManageLayouts> {

  LayoutPersistence? persistence;

  ///gerenciamento da listview
  List<String> items = [];
  List<String> selectedItems = [];
  //itens da listview
  List<Uint8List> tumbnails = [];
  List dimensions = [];
  List amtImagens = [];

  ///gerenciamento da pagina
  TextEditingController nomeLayoutControler = TextEditingController();
  String title = 'Layouts salvos';
  bool empty = false;
  bool load = true;


  void exibirTelaErro(String textoErro){
    showDialog(context: context, builder: (context){
      return ErrorAlertDialogBox(
        text: textoErro,
      );
    },);
  }
  

  @override
  void initState(){
    persistence = LayoutPersistence();
    super.initState();
    startPage();
  }


  Future<void> startPage() async{
    await persistence!.loadKeys();
    List alturaLargura;
    List cordenadas;
    Uint8List retGetThumb;

    inserirTumbnails()async{
      for(int i=0; i< persistence!.keys.length; i++){
        persistence!.name = persistence!.keys[i];
        items.add(persistence!.name!);
        alturaLargura = await persistence!.getDocumentSize();
        dimensions.add([alturaLargura[1], alturaLargura[0]]);
        cordenadas = await persistence!.getCoordinatesImg();
        amtImagens.add(cordenadas.length);
        retGetThumb = await persistence!.getThumbnailLayout();
        tumbnails.add(retGetThumb);
      }
    }

    await Future.delayed(const Duration(milliseconds: 500)); //tempo para troca de paginas
    await inserirTumbnails();
    if(items.isEmpty){
      empty = true;
    }
    load = false;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<AppThemePers>(context);
    final Size telaTamanho = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: tema.bkgColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: tema.buttonColor,
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: deleteSelected,
        backgroundColor: tema.buttonColor,
        foregroundColor: tema.iconsColor,
        child: const Icon(Icons.delete),
      ),
      body: Stack(children: [
          Visibility(
              visible: load,
              child: Container(
                color: Colors.black54,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: telaTamanho.height*0.1)),
                    Center(child: SizedBox(
                      width: telaTamanho.width*0.7,
                      child: Image.asset('assets/images/loading_anm.gif'),
                    )),
                    Text("Um instante...", style: TextStyle(color: tema.iconsColor, fontSize: telaTamanho.width*0.07)),
                  ],
                ),
              )
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedItems.contains(item);
                return CheckboxListTile(
                  side: BorderSide(color: tema.lightButtonIconsColor),
                  contentPadding: const EdgeInsets.all(0),
                  secondary: IconButton(
                    onPressed: (){
                      changeName(index);
                    },
                    icon: Icon(Icons.edit, color: tema.fontColor,),
                  ),
                  title: Container(
                    color: isSelected? const Color.fromRGBO(0, 0, 200, 200) : tema.bkgColor,
                    margin: EdgeInsets.only(bottom: telaTamanho.height*0.05),
                    alignment: Alignment.center,
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected? Colors.blue : tema.bkgColor,  // Define a cor da borda
                            width: 4,          // Define a largura da borda
                          ),
                        ),
                        height: telaTamanho.height*0.3,
                        child: Image.memory(tumbnails[index], fit: BoxFit.contain),
                      ),
                      Text(
                        '${persistence!.keys[index]}',
                        style: TextStyle(fontSize: 20.0, color: tema.fontColor),
                      ),
                      Text("${dimensions[index][0]} x ${dimensions[index][1]} px \n"
                          "~${(pxToCm(300, dimensions[index][0])).toStringAsFixed(2)} x ${(pxToCm(300, dimensions[index][1])).toStringAsFixed(2)} cm (300ppi)",
                        style: TextStyle(fontSize: 17, color: tema.fontColor),
                        textAlign: TextAlign.center,
                      ),
                      Text("Suporte para até ${amtImagens[index]} imagen(s)", style: TextStyle(color: tema.fontColor),),
                    ],),
                  ),
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        selectedItems.add(item);
                      } else {
                        selectedItems.remove(item);
                      }
                      if(selectedItems.length > 1){
                        title = '${selectedItems.length} itens selecionados';
                      }else if(selectedItems.length == 1){
                        title = '1 item selecionado';
                      }else{
                        title = 'Layouts salvos';
                      }

                    });
                  },
                );
              },
            ),
          ),
        Visibility(
          visible: empty,
          child: Container(
            padding:  EdgeInsets.all(telaTamanho.height*0.06),
              child: Column(
                children: [
                  Text("Não há layouts salvos aqui por enquanto.", style: TextStyle(color: tema.fontColor, fontSize: telaTamanho.width*0.1),),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const CreateNewLayoutPage())
                    ),
                    child: Text("Criar um layout?", style: TextStyle(color: tema.iconsColor, fontSize: telaTamanho.width*0.09, decoration: TextDecoration.underline))
                  )
                ],
              )
          ),
        ),
      ],),
    );
  }


  Future<void> changeName(int index) async{
    bool mudou = false;
    if(selectedItems.isEmpty){
      await showChangeSavedLayoutName(
          controlerNameLayout: nomeLayoutControler,
          context: context,
          confirmFunction: ()async{
            if(nomeLayoutControler.text.trim() != '' && nomeLayoutControler.text.trim() != items[index]){
              load = true;
              mudou = await persistence!.changeKeyName(chave: items[index], newKeyName: nomeLayoutControler.text.trim());
              if(mudou){
                items = [];
                selectedItems = [];
                tumbnails = [];
                nomeLayoutControler.text = '';
                startPage();
              }else{
                exibirTelaErro("Não foi possível alterar o nome do layout pelo especificado, pois já existem outros atributos com esse nome, ou foi inserido um nome inválido.");
                nomeLayoutControler.text = '';
              }
            }
          }
      );

    }
  }


  Future<void> deleteSelected()async{
    bool deveDeletar = false;
    if(selectedItems.isNotEmpty){
      String texto;
      if(selectedItems.length > 1){
        texto = 'Deseja realmente deletar os layouts selecionados?\nEssa ação será irreversível.\n\n';
      }else{
        texto = 'Deseja realmente deletar o layout selecionado?\nEssa ação será irreversível.\n\n';
      }

      await showDialog(context: context, barrierDismissible: true ,builder: (context){
        return ConfirmDecisionDialog(
          text: texto,
          subtext: "Deseja proseguir e deletar?",
          confirmFunction: (){
            Navigator.of(context).pop();
            deveDeletar = true;
          },
        );
      },);

      if(deveDeletar){
        for(int i=0; i<selectedItems.length; i++){
          await persistence!.deleteByKey(selectedItems[i]);
        }
        items = [];
        selectedItems = [];
        tumbnails = [];

        title = 'Layouts salvos';
        deveDeletar = false;
        startPage();
      }
    }
  }

}