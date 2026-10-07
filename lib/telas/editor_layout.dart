import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';  //para usar o unit8list para visualização

import "package:image_layout/ferramentas_dos_editores/gerar_manipular_layouts.dart";
import "package:image_layout/telas/editor_imagens.dart";
import 'package:image_layout/utils/funcoes_cast.dart';
import 'package:image_layout/utils/enumarator_qualidade_foto_e_unidade_medida.dart';
import "package:image_layout/telas/subtelas/adicionar_espaco_imagem.dart";
import "package:image_layout/telas/subtelas/alerta_erro.dart";
import "package:image_layout/telas/subtelas/adicionar_espacamento.dart";
import "package:image_layout/telas/subtelas/alerta_confirmar_desicao.dart";
import "package:image_layout/telas/menu_editor_layout.dart";
import "package:image_layout/telas/subtelas/salvar_layout.dart";
import 'package:image_layout/tema_cores.dart';


BuildContext? contextG;

class EditorLayoutArgs{
  final int altura;
  final int largura;
  final int borda;
  final Qualidade qualidade;
  final UnidadeDeMedida unidade;

  EditorLayoutArgs(this.altura, this.largura, this.borda, this.qualidade, this.unidade);
}


class EditorLayouts extends StatefulWidget {
  EditorLayouts({super.key, required context}){
    contextG = context;
  }

  @override
  State<EditorLayouts> createState() => _EditorLayouts();
}

///Desenvolvimento tela editor de layouts --------------------------------------
class _EditorLayouts extends State<EditorLayouts>{
  final argumentos = ModalRoute.of(contextG!)!.settings.arguments as EditorLayoutArgs;
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
    infoDoc = "> Dimenções do Documento: \n  ${_documento!.getAltura()} x ${_documento!.getLargura()} px"
        "\n  ~${(pxToCm(_documento!.getQualidadeDocumento().getValorPPI(), _documento!.getAltura())).toStringAsFixed(2)} x "
        "${(pxToCm(_documento!.getQualidadeDocumento().getValorPPI(), _documento!.getLargura())).toStringAsFixed(2)} cm"
        "\n> Unidade de medida sendo usada: \n  ${_documento!.getUnidadeDeMedidaDocumento().toStringExpandido()}"
        "\n> PPI definido: \n  ${_documento!.getQualidadeDocumento().getValorPPI()}";
  }

  void exibirTelaErro(String textoErro){
    showDialog(context: context, builder: (context){
      return AlertaErroDialogBox(
        texto: textoErro,
      );
    },);
  }

  carregar() async{
    await Future.delayed(const Duration(milliseconds: 500)); //tempo para troca de tela
    _documento = LayoutMaker(argumentos.unidade, argumentos.altura, argumentos.largura, argumentos.borda, argumentos.qualidade);
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      load = false;
      setState(() {});
    });
    imagemView = _documento!.getImagemView();
    setInfoDoc();
  }

  @override
  void initState() {
    super.initState();
    carregar();
  }

  @override
  Widget build(BuildContext context){
    final tema = Provider.of<TemaAplicacao>(context);
    final Size telaTamanho = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Editor Layout", style: TextStyle(fontSize: telaTamanho.width*0.04),),
        elevation: 0,
        backgroundColor: tema.corBotoes,
        foregroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.help),
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpEditorLayout()));
              }
          ),
          IconButton(onPressed: voltarParaHome, icon: const Icon(Icons.home)),
          IconButton(
              onPressed: telaPularParaEditor,
              icon: const Icon(Icons.arrow_forward_ios_sharp)
          ),
        ],
      ),
      
      drawer: Drawer(
        backgroundColor: tema.corBotoes,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Configurações do editor", style: TextStyle(color: tema.corDaFonte, fontSize: 20, fontWeight: FontWeight.bold)),
            Padding(padding: EdgeInsets.all(telaTamanho.height*0.04)),
            Container(padding: EdgeInsets.only(left: telaTamanho.width*0.03), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.square_foot_outlined, color: tema.corDaFonte, size: 27),
                  const Padding(padding: EdgeInsets.only(left: 6)),
                  Text("Mudar a unidade de medida", style: TextStyle(color: tema.corDaFonte, fontWeight: FontWeight.bold),)
                ],),
                Container(padding: EdgeInsets.only(left: telaTamanho.width*0.05), child: Column(children: [
                  ListTile(
                    title: Text('Centímetros', style: TextStyle(color: tema.corDaFonte)),
                    leading: _documento?.getUnidadeDeMedidaDocumento() == UnidadeDeMedida.centimetros? Icon(Icons.radio_button_checked, color: tema.corIconeBototesClaro) : Icon(Icons.radio_button_off, color: tema.corIconeBototesClaro),
                    onTap: (){
                      setState(() {
                        _documento!.setUnidadeDeMedida(UnidadeDeMedida.centimetros);
                        setInfoDoc();
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Pixels', style: TextStyle(color: tema.corDaFonte)),
                    leading: _documento?.getUnidadeDeMedidaDocumento() == UnidadeDeMedida.pixels? Icon(Icons.radio_button_checked, color: tema.corIconeBototesClaro) : Icon(Icons.radio_button_off, color: tema.corIconeBototesClaro),
                    onTap: (){
                      setState(() {
                        _documento!.setUnidadeDeMedida(UnidadeDeMedida.pixels);
                        setInfoDoc();
                      });
                    },
                  ),
                ],),),
                Padding(padding: EdgeInsets.only(top: telaTamanho.height*0.1)),
                Row(children: [
                  Icon(Icons.info_outline, color: tema.corDaFonte),
                  const Padding(padding: EdgeInsets.only(left: 6)),
                  Text("Informações do documento", style: TextStyle(color: tema.corDaFonte, fontWeight: FontWeight.bold),)
                ],),
                Padding(padding: EdgeInsets.only(top: telaTamanho.height*0.02)),
                Text(infoDoc, style: TextStyle(color: tema.corDaFonte)),
              ],
            ),),

          ],
        ),
      ),

      backgroundColor: tema.corDefundo,

      body: Stack(children: [ //imagen sendo gerada e animação de load
        PopScope(
          canPop: false,
          child: const Text(""),
          onPopInvoked: (bool didPop){if(didPop){return;} voltarParaHome();},
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
                  Text("Um instante...", style: TextStyle(color: tema.corDosIcones, fontSize: telaTamanho.width*0.07)),
                ],
              ),
            )
        ),
      ],),

      bottomNavigationBar: BottomAppBar( //Botoes de funcoes do editor
        padding: const EdgeInsets.all(0),
        color: tema.corBotoes,
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

  _adicionarAreaParaFoto() async{
    subtelaAtivada = true;
    int? altura;
    int? largura;
    await showDialog(context: context, builder: (BuildContext context){
      return MenuAddEspacoDeImagem(
        qualidadeDoc: _documento!.getQualidadeDocumento(),
        unidadeMedida: _documento!.getUnidadeDeMedidaDocumento(),
        alturaRecomendada: _documento!.getAlturaRecomendadaLinhaAtual(),
        restoX: _documento!.getRestanteX(),
        restoY: _documento!.getRestanteY(),
        controlerAltura: _controlerAltura,
        controlerLargura: _controlerLargura,
        funcaoConfirmar: ()async{

          if(_documento!.getUnidadeDeMedidaDocumento() == UnidadeDeMedida.centimetros){//exige convercao para pixels
            altura = cmToPx(_documento!.getQualidadeDocumento().getValorPPI(), _controlerAltura.text);
            largura = cmToPx(_documento!.getQualidadeDocumento().getValorPPI(), _controlerLargura.text);
          }
          else{ //ja está em pixels (editor trabalha em pixels)
            altura = stringParseInt(_controlerAltura.text);
            largura = stringParseInt(_controlerLargura.text);
          }

          if(altura != null && largura != null && altura != 0 && largura != 0){
            if(_documento!.getAlturaLinhaAtual() != 0 && (altura! > _documento!.getAlturaRecomendadaLinhaAtual() && altura! <= _documento!.getAltura())){
              ///caso o usuario informe uma altura maior que na linha, ele deve ter certeza que quer isso
              ///essa confirmacao se da ao fato de adicionar espacos inutilizaveis com esse comportamento
              await showDialog(context: context, barrierDismissible: true ,builder: (context){
                return SubTelaConfirmacao(
                  texto: "Adicionar um espaço de imagem com altura maior que a altura recomendada da linha atual, gera espaços inutilizados na hora da troca de linha.",
                  subtexto: "Deseja prosseguir mesmo assim?",
                  funcaoConfirmar: ()async{
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    load = true;
                    setState(() {
                      Future<String> ret = _documento!.criarEspacoDeImagem(altura!, largura!);
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
                Future<String> ret = _documento!.criarEspacoDeImagem(altura!, largura!);
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
      return MenuAddEspacamento(
        unidadeMedida: _documento!.getUnidadeDeMedidaDocumento(),
        controlerEspacamentoHorizontal: _controlerEsphorizontal,
        controlerEspacamentoVertical: _controlerEspVertical,
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

            if(_documento!.getUnidadeDeMedidaDocumento() == UnidadeDeMedida.centimetros){ //exige parse para int
              rety = _documento!.setEspacamentoVertical(cmToPx(_documento!.getQualidadeDocumento().getValorPPI(), _controlerEspVertical.text)!);
              retx = _documento!.setEspacamentoHorizontal(cmToPx(_documento!.getQualidadeDocumento().getValorPPI(), _controlerEsphorizontal.text)!);
            }
            else{ //ja esta em px n precisa de parse para o editor de layout
              retx = _documento!.setEspacamentoHorizontal(stringParseInt(_controlerEsphorizontal.text)!);
              rety = _documento!.setEspacamentoVertical(stringParseInt(_controlerEspVertical.text)!);
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
        return SubTelaConfirmacao(
          texto: "Deseja realmente desfazer uma ação feita no documento?\nEssa ação será irreversível.",
          subtexto: "",
          funcaoConfirmar: (){
            Navigator.of(context).pop();
            load = true;
            setState((){
              setState(() { //status de load na tela
                subtelaAtivada = true;
                load= true;
              });
              setState(() {
                _documento!.desfazerUmaAcao();
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
        return SubTelaConfirmacao(
          texto: "Deseja realmente deletar todas alterações feitas no documento?\nEssa ação é irreversível.",
          subtexto: "Deseja realmente prosseguir com a escolha?",
          funcaoConfirmar: (){
            Navigator.of(context).pop();
            load = true;
            setState(() {
              _documento!.clearAll();
              _documento!.setCorDeFundo('white');
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
        return SubTelaConfirmacao(
          texto: "\nSe você trocar de linha, não poderá adicionar mais espaços para foto futuramente na linha que foi pulada.",
          subtexto: "\nDeseja pular de linha mesmo assim?",
          funcaoConfirmar: (){
            _documento!.pularLinha();
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
  menuSalvar() async{
    Future<bool> verificarSalvar()async{
      bool salvou = false;
      if(_controlerNomeLayout.text.trim().isEmpty){
        exibirTelaErro("Você deve preencher o campo de nome do layout com um nome objetivo, pois ajudará na hora de identificar o layout desejado para futuras edições de imagens.");
        return false;
      }else{
        salvou = await _documento!.salvarConfiguracaoLayoutSHPREF(_controlerNomeLayout.text.trim());

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
        return SalvarLayout(
          titulo: "Digite um nome para o Layout\n",
          controlerNomeLayout: _controlerNomeLayout,
          funcaoConfirmar2: ()async{//salvar e permanecer no editor de layouts
            salvou = await verificarSalvar();
            if(salvou){
              fecharTela();
            }
          },
          funcaoConfirmar1: ()async{ //salvar e ir para editor de foto
            salvou = await verificarSalvar();
            if(salvou){
              fecharTela();
              irParaEditorDeFotos();
            }
          },
        );
      },);
    }
    else{
      exibirTelaErro("documento vazio, impossível salvar conteúdo.");
    }
  }

  void voltarParaHome() async{
    void sairEditor(){
      Navigator.of(context).popUntil(ModalRoute.withName('/'));
    }

    Future<bool> exibirTelaConfirmacaoVoltarParaHome() async{
      bool ret = false;
      await showDialog(context: context, builder: (context){
        return SubTelaConfirmacao(
            texto: "Deseja realmente voltar para home? Certifique-se que o layout foi salvo, caso tenha interesse em utilizá-lo mais tarde.",
            subtexto: "Deseja voltar para a página inicial mesmo assim?",
            funcaoConfirmar: (){
              Navigator.of(context).pop();
              ret = true;
            }
        );
      },);
      return ret;
    }

    if(_documento!.getPosicoesParaImagens().isEmpty){
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
    var args = EditorImagemArgs(_documento!.getAltura(), _documento!.getLargura(), _documento!.getPosicoesParaImagens());
    Navigator.pushNamedAndRemoveUntil(context, "/editorImagens", arguments: args, ModalRoute.withName("/"));
  }

  void telaPularParaEditor(){
    if(_documento!.getQTDespacosParaFotos() > 0){
      showDialog(context: context, barrierDismissible: true ,builder: (context){
        return SubTelaConfirmacao(
          texto: "\t\tDeseja realmente ir para a pagina de inserção de fotos? Caso a configuração de layout atual não foi salva, essa configuração será perdida.\n"
              "\t\tCaso já tenha salvo, ignore esse aviso. Caso contrário, retorne ao editor e clique no botão de salvar",
          subtexto: "\nDeseja ir pra tela de inserção?",
          funcaoConfirmar: (){
            Navigator.of(context).pop();
            irParaEditorDeFotos();
          },
        );
      },);
    }
  }

}//statefullwidget class fim
