import 'package:flutter/material.dart';
import "package:permission_handler/permission_handler.dart";
import 'package:provider/provider.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'dart:typed_data';

import 'package:image_layout/utils/enum_app_values.dart';
import 'package:image_layout/editors_tools/photo_editor_src_tools.dart';
import "package:image_layout/screens/photo_editor_manual.dart";
import "package:image_layout/screens/sub_screen/alerta_erro.dart";
import 'package:image_layout/screens/sub_screen/confirm_decision_alert.dart';
import 'package:image_layout/application_theme_pers.dart';


class ImageEditorPageArgs{
  final int documentHeight;
  final int documentWidth;
  final List photoPositionsList;

  ImageEditorPageArgs(this.documentHeight, this.documentWidth, this.photoPositionsList);
}


class ImageEditorPage extends StatefulWidget {

  const ImageEditorPage({super.key});

  @override
  State<ImageEditorPage> createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage> {

  ImageEditorPageArgs? args;
  ImagensLayoutEditor? _document;
  Uint8List? imageView;
  Color _addButtonsColor = Colors.white;
  late String name; // TODO: ver se precisa
  String selectColorTittle = 'Selecione a cor';
  Color selectedColor = Colors.white;
  bool load = true;


  void loadPage() async{
    
    await Future.delayed(const Duration(milliseconds: 500));
    _document = ImagensLayoutEditor(
        height: args!.documentHeight,
        width: args!.documentWidth,
        amtPhotos: args!.photoPositionsList.length
    );
    
    await _document!.drawLayoutByPositions(args!.photoPositionsList);
    
    setState(() {});
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        load = false;
      });
    });
    
    imageView = _document!.getImageView();
  }

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();

    if (args == null){
      args = ModalRoute.of(super.context)!.settings.arguments as ImageEditorPageArgs;
      loadPage();
    }
  
  }


  void requestPermission() async{
    var status = await Permission.storage.status;
    if (!status.isGranted){
      await Permission.storage.request();
    }
    var status1 = await Permission.manageExternalStorage.status;
    if (!status1.isGranted){
      await Permission.manageExternalStorage.request();
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppThemePers>(context);
    final Size screenSize = MediaQuery.of(context).size;

    void salvarDocumento() async{
      bool res = await _document!.saveImage('ImgLayout${DateTime.now().toString()}');
      if(res){
        showDialog(builder: (context) => AlertDialog(
              backgroundColor: theme.bkgColor,
              title: Text("Imagem salva na geleria do seu celular", style: TextStyle(color: theme.fontColor)),
              actions: [
                Center(child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: theme.lightButtonIconsColor,
                        backgroundColor: theme.buttonColor,
                        elevation: 0
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: const Text("Ok", style: TextStyle(fontWeight: FontWeight.bold))
                ),)
              ],
            ),
            context: context
        );
      }
      else{
        _showErrorScreen("Erro inesperado ao tentar salvar a imagem na galeria.\nTente novamente mais tarde.", context);
      }
    }

    return Scaffold(
      backgroundColor: theme.bkgColor,
      appBar: AppBar(
        title: Text("Inserir Imagens", style: TextStyle(fontSize: screenSize.width*0.05)),
        elevation: 0.0,
        backgroundColor: theme.buttonColor,
        foregroundColor: Colors.white,
        actions: <Widget>[
          IconButton( //pagina de ajuda
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpEditorFotos()));
            },
            icon: const Icon(Icons.help)
          ),

          IconButton(//voltar para a home
              onPressed: ()async{
                if(_document!.getIndex() > 0){
                  bool ret = await _exibirTelaConfirmacaoVoltarParaHome(context);
                  if(ret){
                    _goBackHome();
                  }
                }
                else{
                  _goBackHome();
                }
              },
            icon: const Icon(Icons.home)
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: theme.buttonColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Configurações da\nferramenta de inserção",
              style: TextStyle(color: theme.fontColor, fontWeight: FontWeight.bold, fontSize: screenSize.height*0.03),
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.only(top: screenSize.height*0.03)),
            Row(children: [
              IconButton(onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: theme.buttonColor,
                      title: Text('Proporção do recorte', style: TextStyle(color: theme.fontColor)),
                      content: Text('A proporção do recorte define o comportamento da ferramenta de recorte de imagem ao inserir uma nova imagem no layout. A proporção livre, permite você recortar a imagem da forma que quiser, mas poderá perder a qualidade da imagem. A proporção travada, garante que o formato de recorte da imagem obedeça às proporções da imagem ao inseri-la no espaço do layout.'
                      '\n\nEm outras palavras, o recorte livre pode gerar o efeito de “esticar sua imagem”, caso seja feito um recorte incondizente com o espaço onde a imagem deve ser inserida.',
                        style: TextStyle(color: theme.fontColor),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Fechar', style: TextStyle(color: theme.lightButtonIconsColor),),
                        ),
                      ],
                    );
                  },
                );
                }, icon: Icon(Icons.info_outline, color: theme.secondFontColor,)),
              Text("  Proporção do recorte:", style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.05)),
            ],),

            Container(
                padding: EdgeInsets.only(left: screenSize.width*0.15),
                child: Column(children: [
                  Row(children: [
                    IconButton(
                        onPressed: (){
                          setState(() {
                            _document!.lockProportionCroper();
                          });
                        },
                        icon: _document == null? const Icon(Icons.access_alarm) :
                          Icon(_document!.getProportionLock()? Icons.radio_button_checked: Icons.radio_button_off, color: theme.lightButtonIconsColor)
                    ),
                    Text('Travada', style: TextStyle(color: theme.fontColor)),
                  ],),
                  Row(children: [
                    IconButton(
                        onPressed: (){
                          setState(() {
                            _document!.unlockProportionCroper();
                          });
                        },
                        icon: _document == null? const Icon(Icons.access_alarm) :
                          Icon(!_document!.getProportionLock()? Icons.radio_button_checked: Icons.radio_button_off, color: theme.lightButtonIconsColor)
                    ),
                    Text('Livre', style: TextStyle(color: theme.fontColor)),
                  ],),
                ],)
            ),

            Padding(padding: EdgeInsets.all(screenSize.height*0.01)),

            Row(children: [
              IconButton(onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: theme.buttonColor,
                      title: Text('Qualidade das imagens', style: TextStyle(color: theme.fontColor)),
                      content: Text("Aqui você define o comportamento do editor ao abrir uma imagem da sua galeria. No momento em que vai ser adicionado uma nova imagem, você pode preferir que a imagem seja aberta em sua máxima qualidade ou em qualidade reduzida. \nEssa opção pode ser útil caso seu aparelho não tenha bom desempenho ou caso seja antigo,a  medida que quanto maior a qualidade de imagem, mais o aplicativo irá demorar para abrir a imagem, recortá-la e inseri-la em seu layout.",

                        style: TextStyle(color: theme.fontColor),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Fechar', style: TextStyle(color: theme.lightButtonIconsColor),),
                        ),
                      ],
                    );
                  },
                );
                }, icon: Icon(Icons.info_outline, color: theme.secondFontColor,)),
              Text("Qualidade das imagens:", style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.05)),
            ],),
            Container(
                padding: EdgeInsets.only(left: screenSize.width*0.15),
                child: Column(children: [
                  Row(children: [
                    IconButton(
                        onPressed: (){
                          setState(() {
                            _document!.setDocumentQuality(Quality.high);
                          });
                        },
                        icon: _document == null? const Icon(Icons.access_alarm) :
                          Icon(_document!.getGaleryImageQuality() == Quality.high ? Icons.radio_button_checked: Icons.radio_button_off, color: theme.lightButtonIconsColor)
                    ),
                    Text('Muito Alta', style: TextStyle(color: theme.fontColor)),
                  ],),
                  Row(children: [
                    IconButton(
                        onPressed: (){
                          setState(() {
                            _document!.setDocumentQuality(Quality.medium);
                          });
                        },
                        icon: _document == null? const Icon(Icons.access_alarm) :
                          Icon(_document!.getGaleryImageQuality() == Quality.medium ? Icons.radio_button_checked: Icons.radio_button_off, color: theme.lightButtonIconsColor)
                    ),
                    Text('Alta', style: TextStyle(color: theme.fontColor)),
                  ],),
                  Row(children: [
                    IconButton(
                        onPressed: (){
                          setState(() {
                            _document!.setDocumentQuality(Quality.low);
                          });
                        },
                        icon: _document == null? const Icon(Icons.access_alarm) :
                          Icon(_document!.getGaleryImageQuality() == Quality.low ? Icons.radio_button_checked: Icons.radio_button_off, color: theme.lightButtonIconsColor)
                    ),
                    Text('Média', style: TextStyle(color: theme.fontColor)),
                  ],),
                  Row(children: [
                    IconButton(
                        onPressed: (){
                          setState(() {
                            _document!.setDocumentQuality(Quality.verylow);
                          });
                        },
                        icon: _document == null? const Icon(Icons.access_alarm) :
                          Icon(_document!.getGaleryImageQuality() == Quality.verylow ? Icons.radio_button_checked: Icons.radio_button_off, color: theme.lightButtonIconsColor)
                    ),
                    Text('Baixa', style: TextStyle(color: theme.fontColor)),
                  ],),
                ],)
            ),
        ],),
      ),
      body: Stack(children: [
        PopScope(
          canPop: false,
          child: const Text(""),
          onPopInvoked: (bool didPop)async {
            if(didPop){return;}
            if(_document!.getIndex() > 0){
              bool ret = await _exibirTelaConfirmacaoVoltarParaHome(context);
              if(ret){
                _goBackHome();
              }
            }
            else{
              _goBackHome();
            }
          }
        ),

        documentImageView(),
        
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
                  Text("Um instante...", style: TextStyle(color: theme.iconsColor, fontSize: screenSize.width*0.07)),
                ],
              ),
            )
        ),
      ],),

      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(0),
        color: theme.buttonColor,
        elevation: 0,
        height: screenSize.height*0.07,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton( //ADD FOTO
              icon: const Icon(Icons.add_photo_alternate, size: 30),
              color: _addButtonsColor,
              onPressed: (){
                _addGaleryImage(theme);
              }
            ),
            IconButton(
                onPressed: ()=> changeBkgColor(theme), icon: const Icon(Icons.space_dashboard_outlined, color: Colors.white)
            ),
            IconButton(
                onPressed: () => _fillCurrentSpaceWithColor(theme),
                icon: Icon(Icons.format_color_fill_outlined, size: 28, color: _addButtonsColor)
            ),
            IconButton(
              icon: const Icon(Icons.undo, color: Colors.white),
              onPressed: _undoOneAction,
            ),
            IconButton(
                icon: const Icon(Icons.delete_forever_rounded, color: Colors.white),
                onPressed: _removeAllImages
            ),
            IconButton(
              icon: const Icon(Icons.save, color: Colors.white),
              onPressed: () => salvarDocumento()
            ),
          ],
        ),
      ),
    );

  }

  void changeBkgColor(AppThemePers theme)async{
    selectColorTittle = 'Mudar cor de fundo:';
    selectedColor = _document!.getBkgColor();
    Color color = await colorPicker(theme);

    if(color != Colors.transparent){
      await Future.delayed(const Duration(milliseconds: 150));
      setState(() {
        load = true;
      });
      selectedColor = color;
      _document!.setBkgColor(selectedColor);
      await _document!.changeBackgroundColor(args!.photoPositionsList, selectedColor);
      imageView = _document!.getImageView();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          load = false;
        });
      });
    }
  }

  Widget documentImageView(){
    if(load){
      return const Text('');
    }else{
      return ListView( //Exibicao do documento sendo criado
        shrinkWrap: true,
        padding: const EdgeInsets.all(4),
        children: [Image.memory(imageView!)]
      );
    }
  }

  Future<Color> colorPicker(AppThemePers theme) async{
    final Color newColor = await showColorPickerDialog( // TODO dando erro aqui
      context,
      selectedColor,
      title: Text(selectColorTittle,
          style: TextStyle(color: theme.fontColor)),
      backgroundColor: theme.bkgColor,
      spacing: 0,
      enableOpacity: false,
      showColorCode: false,
      colorCodeHasColor: true,
      pickersEnabled: <ColorPickerType, bool>{ //selecionar por roda de cores
        ColorPickerType.wheel: true,
        ColorPickerType.accent: false,
        ColorPickerType.primary: false,
      },
      actionButtons: const ColorPickerActionButtons(
        okButton: false,
        closeButton: false,
        dialogActionButtons: true,
      ),
    );

    if(selectedColor == newColor){
      return Colors.transparent;
    }else{
      return newColor;
    }

  }


  void _addGaleryImage(AppThemePers theme) async{
    if(_document!.canInsert()){
      setState(() {
        load = true;
      });
      bool ret = await _document!.addGaleryImage(args!.photoPositionsList[_document!.getIndex()], theme);

      if(ret == true){
        setState(() {
          imageView = _document!.getImageView();
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            load = false;
          });
        });
        //se acabaram os espacos, o botao deve ficar desabilitado
        if(!_document!.canInsert()){_addButtonsColor = Colors.white10;}
      }else{
        await Future.delayed(const Duration(milliseconds: 100)); //tempo para sair do menu do croper para o editor
        setState(() {
          load = false;
        });
      }
    }
  }

  void _fillCurrentSpaceWithColor(AppThemePers theme)async {
    if(_document!.canInsert()){
      await showDialog(context: context, builder: (context){

        addWithBkgColor()async{
          Navigator.of(context).pop();
          setState(() {
            load = true;
          });
          await Future.delayed(const Duration(milliseconds: 200)); //tempo para abrir loading
          setState(() {
            _document!.fillCurrentSpaceWithColor(args!.photoPositionsList[_document!.getIndex()], _document!.getBkgColor());
            imageView = _document!.getImageView();
            load = false;
          });
          if(!_document!.canInsert()){//acabaram os espacos, botao fica desabilitado
            _addButtonsColor = Colors.white10;
          }
        }

        addSelectingColor() async{
          Navigator.of(context).pop();
          selectColorTittle = 'Escolha uma cor:';
          selectedColor = Colors.transparent;
          Color cor = await colorPicker(theme);
          if(cor != Colors.transparent){
            setState(() {
              load = true;
            });
            await Future.delayed(const Duration(milliseconds: 200)); //tempo para fechar tela e abrir loading
            selectedColor = cor;
            setState(() {
              _document!.fillCurrentSpaceWithColor(args!.photoPositionsList[_document!.getIndex()], cor);
              imageView = _document!.getImageView();
              load = false;
            });
            if(!_document!.canInsert()){//acabaram os espacos, botao fica desabilitado
              _addButtonsColor = Colors.white10;
            }
          }
        }

        return AlertDialog(
          backgroundColor: theme.bkgColor,
          title: Text("Preencher espaço atual:", style: TextStyle(color: theme.fontColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(onPressed: addWithBkgColor,
                style: ElevatedButton.styleFrom(foregroundColor: theme.fontColor, backgroundColor: theme.buttonColor),
                child: const Text("Pintar com cor de fundo"),
              ),
              ElevatedButton(onPressed: addSelectingColor,
                style: ElevatedButton.styleFrom(foregroundColor: theme.fontColor, backgroundColor: theme.buttonColor),
                child: const Text("Pintar com outra cor"),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(foregroundColor: theme.fontColor, backgroundColor: theme.buttonColor), child: const Text("Cancelar"),
              ),
            ),
          ],
        );
      });
    }
  }

  void _removeAllImages(){
    if(_document!.getIndex() != 0){
      showDialog(context: context, barrierDismissible: true ,builder: (context){
        return ConfirmDecisionDialog(
          text: "Deseja realmente deletar todas as imagens inseridas?\nEssa ação é irreversível.",
          subtext: "Deseja realmente prosseguir com a escolha?",
          confirmFunction: ()async{
            Navigator.of(context).pop();
            if(_document!.canInsert() == false){
              _addButtonsColor = Colors.white;
            }
            setState(() {
              load = true;
            });
            await Future.delayed(const Duration(milliseconds: 200)); //tempo para abrir loading
            _document!.clearAll(args!.photoPositionsList);
            imageView = _document!.getImageView();
            setState(() {
              load = false;
            });

          },
        );
      },);
    }
  }


  void _undoOneAction()async{
    if(_document!.getIndex() != 0){ //ha alteracoes para serem desfeitas
      setState(() {
        load = true;
      });
      await Future.delayed(const Duration(milliseconds: 200)); //tempo para abrir loading
      if(_document!.canInsert()){//caso o indice for para proxima posicao
        _document!.undoOneAction(args!.photoPositionsList[_document!.getIndex()-1]);
        imageView = _document!.getImageView();
      }
      else {//indice ja aponta para ultima posicao pois tinha acabado o espaco
        _document!.undoOneAction(args!.photoPositionsList[_document!.getIndex()]);
        _addButtonsColor = Colors.white;
        imageView = _document!.getImageView();
      }
      if(_document!.canInsert() == false){ //tinha acabado o espaco, agora tem mais 1
        _addButtonsColor = Colors.white;
      }
      setState(() {
        load = false;
      });
    }
  }


  void _showErrorScreen(String textoErro, context){
    showDialog(context: context, builder: (context){
      return ErrorAlertDialogBox(
        text: textoErro,
      );
    },);
  }

  void _goBackHome(){
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  Future<bool> _exibirTelaConfirmacaoVoltarParaHome(context) async{
    bool ret = false;
    await showDialog(context: context, builder: (context){
      return ConfirmDecisionDialog(
        text: "Existem fotos inseridas no documento. Não será possível recuparar depois as modificações feita no documento.",
        subtext: "Deseja voltar para a página inicial mesmo assim?",
        confirmFunction: (){
          Navigator.of(context).pop();
          ret = true;
        }
      );
    },);
    return ret;
  }
}
