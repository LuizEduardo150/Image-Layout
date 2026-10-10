import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';  //para usar o unit8list para visualização

import "package:image_layout/editors_tools/layout_editor_src_tools.dart";
import "package:image_layout/screens/photo_editor.dart";
import 'package:image_layout/utils/utils.dart';
import 'package:image_layout/utils/enum_app_values.dart';
import "package:image_layout/screens/sub_screen/add_place_for_image.dart";
import "package:image_layout/screens/sub_screen/alerta_erro.dart";
import "package:image_layout/screens/sub_screen/add_space_btwn_images.dart";
import "package:image_layout/screens/sub_screen/confirm_decision_alert.dart";
import "package:image_layout/screens/layout_editor_manual.dart";
import "package:image_layout/screens/sub_screen/save_layout.dart";
import 'package:image_layout/application_theme_pers.dart';


class LayoutEditorPageArgs{
  final int height;
  final int width;
  final int border;
  final Quality quality;
  final UnitOfMeasurement unit;

  LayoutEditorPageArgs(this.height, this.width, this.border, this.quality, this.unit);
}


class LayoutEditorPage extends StatefulWidget {
  
  const LayoutEditorPage({super.key});
  
  @override
  State<LayoutEditorPage> createState() => _LayoutEditorPageState();
}

///Desenvolvimento tela editor de layouts --------------------------------------
class _LayoutEditorPageState extends State<LayoutEditorPage>{
  LayoutEditorPageArgs? argumentos;
  final _controlerAltura = TextEditingController();
  final _controlerLargura = TextEditingController();
  final _controlerEsphorizontal = TextEditingController();
  final _controlerEspVertical = TextEditingController();
  final _controlerNomeLayout = TextEditingController();
  bool load = true;
  bool subtelaAtivada = false;
  LayoutMaker? _documento;
  Uint8List? imagemView;
  String infoDoc = "";

  void setInfoDoc(){
    infoDoc = "> Dimenções do Documento: \n  ${_documento!.getHeight()} x ${_documento!.getWidth()} px"
        "\n  ~${(pxToCm(_documento!.getDocumentQuality().getValorPPI(), _documento!.getHeight())).toStringAsFixed(2)} x "
        "${(pxToCm(_documento!.getDocumentQuality().getValorPPI(), _documento!.getWidth())).toStringAsFixed(2)} cm"
        "\n> Unidade de medida sendo usada: \n  ${_documento!.getunitOfMeasurementDocument().toStringExpanded()}"
        "\n> PPI definido: \n  ${_documento!.getDocumentQuality().getValorPPI()}";
  }

  void exibirTelaErro(String textoErro){
    showDialog(
      context: context,
      builder: (context) {
        return ErrorAlertDialogBox(
          text: textoErro,
        );
    });
  }

  void carregar() async{
    
    await Future.delayed(const Duration(milliseconds: 500)); //tempo para troca de tela
    
    _documento = LayoutMaker(argumentos!.unit, argumentos!.height, argumentos!.width, argumentos!.border, argumentos!.quality);
    
    setState(() {});
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      load = false;
      setState(() {});
    });
    
    imagemView = _documento!.getImagemView();
    setInfoDoc();
  }

  @override
  void didChangeDependencies() {
    
    super.didChangeDependencies();

    if (argumentos == null){
      argumentos = ModalRoute.of(super.context)!.settings.arguments as LayoutEditorPageArgs;
      carregar();
    }
    
  }
  

  @override
  Widget build(BuildContext context){
    final tema = Provider.of<AppThemePers>(context);
    final Size telaTamanho = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Editor Layout", style: TextStyle(fontSize: telaTamanho.width*0.04),),
        elevation: 0,
        backgroundColor: tema.buttonColor,
        foregroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.help),
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpEditorLayout()));
              }
          ),
          IconButton(onPressed: goToHome, icon: const Icon(Icons.home)),
          IconButton(
              onPressed: telaPularParaEditor,
              icon: const Icon(Icons.arrow_forward_ios_sharp)
          ),
        ],
      ),
      
      drawer: Drawer(
        backgroundColor: tema.buttonColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Configurações do editor", style: TextStyle(color: tema.fontColor, fontSize: 20, fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.all(telaTamanho.height*0.04)),
            Container(padding: EdgeInsets.only(left: telaTamanho.width*0.03), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.square_foot_outlined, color: tema.fontColor, size: 27),
                  const Padding(padding: EdgeInsets.only(left: 6)),
                  Text("Mudar a unidade de medida", style: TextStyle(color: tema.fontColor, fontWeight: FontWeight.bold),)
                ],),
                Container(padding: EdgeInsets.only(left: telaTamanho.width*0.05), child: Column(children: [
                  ListTile(
                    title: Text('Centímetros', style: TextStyle(color: tema.fontColor)),
                    leading: _documento?.getunitOfMeasurementDocument() == UnitOfMeasurement.centimeters? Icon(Icons.radio_button_checked, color: tema.lightButtonIconsColor) : Icon(Icons.radio_button_off, color: tema.lightButtonIconsColor),
                    onTap: (){
                      setState(() {
                        _documento!.setUnitOfMeasurement(UnitOfMeasurement.centimeters);
                        setInfoDoc();
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Pixels', style: TextStyle(color: tema.fontColor)),
                    leading: _documento?.getunitOfMeasurementDocument() == UnitOfMeasurement.pixels? Icon(Icons.radio_button_checked, color: tema.lightButtonIconsColor) : Icon(Icons.radio_button_off, color: tema.lightButtonIconsColor),
                    onTap: (){
                      setState(() {
                        _documento!.setUnitOfMeasurement(UnitOfMeasurement.pixels);
                        setInfoDoc();
                      });
                    },
                  ),
                ],),),
                Padding(padding: EdgeInsets.only(top: telaTamanho.height*0.1)),
                Row(children: [
                  Icon(Icons.info_outline, color: tema.fontColor),
                  const Padding(padding: EdgeInsets.only(left: 6)),
                  Text("Informações do documento", style: TextStyle(color: tema.fontColor, fontWeight: FontWeight.bold),)
                ],),
                Padding(padding: EdgeInsets.only(top: telaTamanho.height*0.02)),
                Text(infoDoc, style: TextStyle(color: tema.fontColor)),
              ],
            ),),

          ],
        ),
      ),

      backgroundColor: tema.bkgColor,

      body: Stack(children: [ //imagen sendo gerada e animação de load
        PopScope(
          canPop: false,
          child: const Text(""),
          onPopInvoked: (bool didPop){if(didPop){return;} goToHome();},
        ),
        layoutView(),
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
      ],),

      bottomNavigationBar: BottomAppBar( //Botoes de funcoes do editor
        padding: const EdgeInsets.all(0),
        color: tema.buttonColor,
        elevation: 0,
        height: telaTamanho.height*0.07,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton( ///adicionar um espacco de imagem
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.add_box_sharp, size: 30),
              color: Colors.white,
              onPressed: _adicionarAreaParaFoto, //tela deve ser fechada para concluir por isso wait
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.space_dashboard_sharp, color: Colors.white, size: 28),
              onPressed: _defEspacamentosHV,
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.arrow_downward, color: Colors.white),
              onPressed: _pularLinha,
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.undo, color: Colors.white),
              onPressed: _desfazerAcao,
            ),
            IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: _limparTodoDocumento,
                icon: const Icon(Icons.delete_forever, color: Colors.white, size: 27,)
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.save, color: Colors.white, size: 27,),
              onPressed: menuSalvar,
            ),
          ],
        ),
      ),
    );
  }//build fim

  Widget layoutView(){
    if(load && !subtelaAtivada){
      return const Text('');
    }else{
      return ListView( //Exibindo em tela o Layout sendo criado
        shrinkWrap: true,
        padding: const EdgeInsets.all(2),
        children: [Image.memory(imagemView!)],
      );
    }
  }

  Future<void> _adicionarAreaParaFoto() async{
    subtelaAtivada = true;
    int? altura;
    int? largura;
    await showDialog(context: context, builder: (BuildContext context){
      return AddImageSpaceMenu(
        docQuality: _documento!.getDocumentQuality(),
        unitOfMeasurement: _documento!.getunitOfMeasurementDocument(),
        recommendedHeight: _documento!.getCurrLineRecommendedHeight(),
        restX: _documento!.getRemainingX(),
        restY: _documento!.getRemainingY(),
        controlerHeight: _controlerAltura,
        controlerWidth: _controlerLargura,
        confirmFunction: ()async{

          if(_documento!.getunitOfMeasurementDocument() == UnitOfMeasurement.centimeters){//exige convercao para pixels
            altura = cmToPx(_documento!.getDocumentQuality().getValorPPI(), _controlerAltura.text);
            largura = cmToPx(_documento!.getDocumentQuality().getValorPPI(), _controlerLargura.text);
          }
          else{ //ja está em pixels (editor trabalha em pixels)
            altura = stringParseInt(_controlerAltura.text);
            largura = stringParseInt(_controlerLargura.text);
          }

          if(altura != null && largura != null && altura != 0 && largura != 0){
            if(_documento!.getCurrentLineHeight() != 0 && (altura! > _documento!.getCurrLineRecommendedHeight() && altura! <= _documento!.getHeight())){
              ///caso o usuario informe uma altura maior que na linha, ele deve ter certeza que quer isso
              ///essa confirmacao se da ao fato de adicionar espacos inutilizaveis com esse comportamento
              await showDialog(context: context, barrierDismissible: true ,builder: (context){
                return ConfirmDecisionDialog(
                  text: "Adicionar um espaço de imagem com altura maior que a altura recomendada da linha atual, gera espaços inutilizados na hora da troca de linha.",
                  subtext: "Deseja prosseguir mesmo assim?",
                  confirmFunction: ()async{
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    load = true;
                    setState(() {
                      Future<String> ret = _documento!.createSpaceToImage(altura!, largura!);
                      ret.then((value){
                        if(value != 'ok'){
                          load = false;
                          _controlerLargura.clear();
                          _controlerAltura.clear();
                          exibirTelaErro(value);
                        }
                      });
                    });

                  },
                );
              },);

            }
            else{ //mesmo tamanho de altura ou valores menores, não precisa de confirmação
              Navigator.of(context).pop();
              load = true;
              setState(() {
                Future<String> ret = _documento!.createSpaceToImage(altura!, largura!);
                ret.then((value){
                  if(value != 'ok'){ //retorno de erro é instantaneo
                    _controlerLargura.clear();
                    _controlerAltura.clear();
                    exibirTelaErro(value);
                  }
                });
              });
            }
          }
        },
      );
    },);

    if(load){
      await Future.delayed(const Duration(milliseconds: 200)); //tempo até a tela fechar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        imagemView = _documento!.getImagemView();
        setState(() {
          load = false;
        });
      });
    }
    subtelaAtivada = false;
  }

  void _defEspacamentosHV() async{
    subtelaAtivada = true;
    await showDialog(context: context, builder: (context){
      return AddspaceBtwnImagesMenu(
        unitOfMeasurement: _documento!.getunitOfMeasurementDocument(),
        controlerHorizontalSpacing: _controlerEsphorizontal,
        controlerVerticalSpacing: _controlerEspVertical,
        funcaoConfirmar: (){
          if(stringIsNumeric(_controlerEsphorizontal.text) == false && stringIsNumeric(_controlerEspVertical.text) == false) {
            exibirTelaErro('Formato de entrada desconhecido em ambos os campos, insira apenas números inteiros');
          }
          else if(stringIsNumeric(_controlerEsphorizontal.text) == false || stringIsNumeric(_controlerEspVertical.text) == false) {
            if(stringIsNumeric(_controlerEsphorizontal.text) == false){
              exibirTelaErro('Formato de entrada desconhecido no campo de espaçamento horizontal. Nenhuma alteração feita.');
            }
            if(stringIsNumeric(_controlerEspVertical.text) == false){
              exibirTelaErro('Formato de entrada desconhecido no campo de espaçamento vertical. Nenhuma alteração feita.');
            }
          }else{ //caso for inserido apenas valores inteiros... prosseguir...
            String retx, rety;

            if(_documento!.getunitOfMeasurementDocument() == UnitOfMeasurement.centimeters){ //exige parse para int
              rety = _documento!.setVerticalSpace(cmToPx(_documento!.getDocumentQuality().getValorPPI(), _controlerEspVertical.text)!);
              retx = _documento!.setHorizontalSpace(cmToPx(_documento!.getDocumentQuality().getValorPPI(), _controlerEsphorizontal.text)!);
            }
            else{ //ja esta em px n precisa de parse para o editor de layout
              retx = _documento!.setHorizontalSpace(stringParseInt(_controlerEsphorizontal.text)!);
              rety = _documento!.setVerticalSpace(stringParseInt(_controlerEspVertical.text)!);
            }

            if(retx != 'ok' && rety != 'ok'){//usuario inseriu numero absurdo em ambos os campos
              exibirTelaErro(retx);

            }else if(retx != 'ok' || rety != 'ok'){ //usuario inseriu numero absourdo em algum dos campos
              if(retx != 'ok'){//esp. horizontal invalido
                retx += '. Apenas esp. vertical foi alterado.';
                exibirTelaErro(retx);
                _controlerEsphorizontal.text = '${_documento!.getEspacamentoHorizontal()}';
              }
              else if(rety != 'ok'){
                rety += '. Apenas esp. horizontal foi alterado.';
                exibirTelaErro(rety);
                _controlerEspVertical.text = '${_documento!.getEspacamentoVertical()}';
              }
            }else{ //condição válida para todos os campos
              Navigator.of(context).pop();
            }
          }
        },
      );
    },);
    subtelaAtivada = false;
  }

  void _desfazerAcao()async{
    if(_documento!.getQTDespacosParaFotos() != 0){
      await showDialog(context: context, barrierDismissible: true ,builder: (context){
        return ConfirmDecisionDialog(
          text: "Deseja realmente desfazer uma ação feita no documento?\nEssa ação será irreversível.",
          subtext: "",
          confirmFunction: (){
            Navigator.of(context).pop();
            load = true;
            setState((){
              setState(() { //status de load na tela
                subtelaAtivada = true;
                load= true;
              });
              setState(() {
                _documento!.undoAction();
                imagemView = _documento!.getImagemView();
                load = false;
                subtelaAtivada = false;
              });
            });
          },
        );
      },);
    }
  }

  void _limparTodoDocumento() async{
    if(_documento!.getQTDespacosParaFotos() != 0){
      await showDialog(context: context, barrierDismissible: true ,builder: (context){
        return ConfirmDecisionDialog(
          text: "Deseja realmente deletar todas alterações feitas no documento?\nEssa ação é irreversível.",
          subtext: "Deseja realmente prosseguir com a escolha?",
          confirmFunction: (){
            Navigator.of(context).pop();
            load = true;
            setState(() {
              _documento!.clearAll();
              _documento!.setBkgColor('white');
            });
          },
        );
      },);
      if(load){
        await Future.delayed(const Duration(milliseconds: 200)); //tempo para a tela fechar
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            imagemView = _documento!.getImagemView();
            load = false;
          });
        });
      }
    }
  }

  void _pularLinha(){
    if(_documento!.getQTDespacosParaFotos() != 0){
      showDialog(context: context, barrierDismissible: true ,builder: (context){
        return ConfirmDecisionDialog(
          text: "\nSe você trocar de linha, não poderá adicionar mais espaços para foto futuramente na linha que foi pulada.",
          subtext: "\nDeseja pular de linha mesmo assim?",
          confirmFunction: (){
            _documento!.jumpLine();
            Navigator.of(context).pop();
          },
        );
      },);
    }
    else {
      exibirTelaErro('Documento vazio!\nPara pular de linha, o documento deve conter ao menos um espaço para imagem.');
    }
  }

  ///Tela para salvar layout
  Future<void> menuSalvar() async{
    Future<bool> verificarSalvar()async{
      bool salvou = false;
      if(_controlerNomeLayout.text.trim().isEmpty){
        exibirTelaErro("Você deve preencher o campo de nome do layout com um nome objetivo, pois ajudará na hora de identificar o layout desejado para futuras edições de imagens.");
        return false;
      }else{
        salvou = await _documento!.saveConfigurationLayoutSHPREF(_controlerNomeLayout.text.trim());

        if(!salvou){
          exibirTelaErro("Esse nome de layout já existe, insira outro nome para o layout atual.");
          return false;
        }else{
          return true;
        }
      }
    }

    if(_documento!.getQTDespacosParaFotos() > 0){
      await showDialog(context: context, builder: (context){ ///tela principal
        fecharTela(){
          Navigator.of(context).pop();
        }
        bool salvou = false;
        return SaveLayoutDialog(
          title: "Digite um nome para o Layout\n",
          controlerNomeLayout: _controlerNomeLayout,
          
          confirmFunction2: () async{//salvar e permanecer no editor de layouts
            salvou = await verificarSalvar();
            if(salvou){
              fecharTela();
            }
          },
          
          confirmFunction1: () async{ //salvar e ir para editor de foto
            salvou = await verificarSalvar();
            if(salvou){
              fecharTela();
              irParaEditorDeFotos();
            }
          }

        );
      },);
    }

    else{
      exibirTelaErro("documento vazio, impossível salvar conteúdo.");
    }
  }

  void goToHome() async{
    void sairEditor(){
      Navigator.of(context).popUntil(ModalRoute.withName('/'));
    }

    Future<bool> exibirTelaConfirmacaoVoltarParaHome() async{
      bool ret = false;
      await showDialog(context: context, builder: (context){
        return ConfirmDecisionDialog(
            text: "Deseja realmente voltar para home? Certifique-se que o layout foi salvo, caso tenha interesse em utilizá-lo mais tarde.",
            subtext: "Deseja voltar para a página inicial mesmo assim?",
            confirmFunction: (){
              Navigator.of(context).pop();
              ret = true;
            }
        );
      },);
      return ret;
    }

    if(_documento!.getPositionsToImages().isEmpty){
      sairEditor();
    }
    else{
      bool sair = false;
      sair = await exibirTelaConfirmacaoVoltarParaHome();
      if(sair){
        sairEditor();
      }
    }
  }

  void irParaEditorDeFotos(){
    var args = ImageEditorPageArgs(_documento!.getHeight(), _documento!.getWidth(), _documento!.getPositionsToImages());
    Navigator.pushNamedAndRemoveUntil(context, "/editorImagens", arguments: args, ModalRoute.withName("/"));
  }

  void telaPularParaEditor(){
    if(_documento!.getQTDespacosParaFotos() > 0){
      showDialog(context: context, barrierDismissible: true ,builder: (context){
        return ConfirmDecisionDialog(
          text: "\t\tDeseja realmente ir para a pagina de inserção de fotos? Caso a configuração de layout atual não foi salva, essa configuração será perdida.\n"
              "\t\tCaso já tenha salvo, ignore esse aviso. Caso contrário, retorne ao editor e clique no botão de salvar",
          subtext: "\nDeseja ir pra tela de inserção?",
          confirmFunction: (){
            Navigator.of(context).pop();
            irParaEditorDeFotos();
          },
        );
      },);
    }
  }

}//statefullwidget class fim
