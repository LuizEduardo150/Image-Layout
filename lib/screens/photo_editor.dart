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


class EditorImagemArgs{
  final int alturaDocumento;
  final int larguraDocumento;
  final List listaComPosicoesParaFotos;

  EditorImagemArgs(this.alturaDocumento, this.larguraDocumento, this.listaComPosicoesParaFotos);
}


class EditorDeImagem extends StatefulWidget {

  const EditorDeImagem({super.key});

  @override
  State<EditorDeImagem> createState() => _EditorDeImagemState();
}

class _EditorDeImagemState extends State<EditorDeImagem> {

  EditorImagemArgs? argumentos;
  ImagensLayoutEditor? _documento;
  Uint8List? imagemView;
  Color _corBotoesAdd = Colors.white;
  late String nome;
  String tituloSeletorCor = 'Selecione a cor';
  Color corSelecionada = Colors.white;
  bool load = true;


  void carregar() async{
    
    await Future.delayed(const Duration(milliseconds: 500));
    _documento = ImagensLayoutEditor(
        altura: argumentos!.alturaDocumento,
        largura: argumentos!.larguraDocumento,
        qtdFotos: argumentos!.listaComPosicoesParaFotos.length
    );
    
    await _documento!.desenharLayoutPorPosicoes(argumentos!.listaComPosicoesParaFotos);
    
    setState(() {});
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        load = false;
      });
    });
    
    imagemView = _documento!.getImagemView();
  }

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();

    if (argumentos == null){
      argumentos = ModalRoute.of(super.context)!.settings.arguments as EditorImagemArgs;
      carregar();
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
    final tema = Provider.of<TemaAplicacao>(context);
    final Size telaTamanho = MediaQuery.of(context).size;

    void salvarDocumento() async{
      bool res = await _documento!.salvarImagem('ImgLayout${DateTime.now().toString()}');
      if(res){
        showDialog(builder: (context) => AlertDialog(
              backgroundColor: tema.corDefundo,
              title: Text("Imagem salva na geleria do seu celular", style: TextStyle(color: tema.corDaFonte)),
              actions: [
                Center(child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: tema.corIconeBototesClaro,
                        backgroundColor: tema.corBotoes,
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
        _exibirTelaErro("Erro inesperado ao tentar salvar a imagem na galeria.\nTente novamente mais tarde.", context);
      }
    }

    return Scaffold(
      backgroundColor: tema.corDefundo,
      appBar: AppBar(
        title: Text("Inserir Imagens", style: TextStyle(fontSize: telaTamanho.width*0.05)),
        elevation: 0.0,
        backgroundColor: tema.corBotoes,
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
                if(_documento!.getIndice() > 0){
                  bool ret = await _exibirTelaConfirmacaoVoltarParaHome(context);
                  if(ret){
                    _voltarParaHome();
                  }
                }
                else{
                  _voltarParaHome();
                }
              },
            icon: const Icon(Icons.home)
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: tema.corBotoes,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Configurações da\nferramenta de inserção",
              style: TextStyle(color: tema.corDaFonte, fontWeight: FontWeight.bold, fontSize: telaTamanho.height*0.03),
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.only(top: telaTamanho.height*0.03)),
            Row(children: [
              IconButton(onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: tema.corBotoes,
                      title: Text('Proporção do recorte', style: TextStyle(color: tema.corDaFonte)),
                      content: Text('A proporção do recorte define o comportamento da ferramenta de recorte de imagem ao inserir uma nova imagem no layout. A proporção livre, permite você recortar a imagem da forma que quiser, mas poderá perder a qualidade da imagem. A proporção travada, garante que o formato de recorte da imagem obedeça às proporções da imagem ao inseri-la no espaço do layout.'
                      '\n\nEm outras palavras, o recorte livre pode gerar o efeito de “esticar sua imagem”, caso seja feito um recorte incondizente com o espaço onde a imagem deve ser inserida.',
                        style: TextStyle(color: tema.corDaFonte),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Fechar', style: TextStyle(color: tema.corIconeBototesClaro),),
                        ),
                      ],
                    );
                  },
                );
                }, icon: Icon(Icons.info_outline, color: tema.corFonteSecundaria,)),
              Text("  Proporção do recorte:", style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.width*0.05)),
            ],),

            Container(
                padding: EdgeInsets.only(left: telaTamanho.width*0.15),
                child: Column(children: [
                  Row(children: [
                    IconButton(
                        onPressed: (){
                          setState(() {
                            _documento!.travarProporcaoCroper();
                          });
                        },
                        icon: _documento == null? const Icon(Icons.access_alarm) :
                          Icon(_documento!.getTravaProporcao()? Icons.radio_button_checked: Icons.radio_button_off, color: tema.corIconeBototesClaro)
                    ),
                    Text('Travada', style: TextStyle(color: tema.corDaFonte)),
                  ],),
                  Row(children: [
                    IconButton(
                        onPressed: (){
                          setState(() {
                            _documento!.destravarProporcaoCroper();
                          });
                        },
                        icon: _documento == null? const Icon(Icons.access_alarm) :
                          Icon(!_documento!.getTravaProporcao()? Icons.radio_button_checked: Icons.radio_button_off, color: tema.corIconeBototesClaro)
                    ),
                    Text('Livre', style: TextStyle(color: tema.corDaFonte)),
                  ],),
                ],)
            ),

            Padding(padding: EdgeInsets.all(telaTamanho.height*0.01)),

            Row(children: [
              IconButton(onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: tema.corBotoes,
                      title: Text('Qualidade das imagens', style: TextStyle(color: tema.corDaFonte)),
                      content: Text("Aqui você define o comportamento do editor ao abrir uma imagem da sua galeria. No momento em que vai ser adicionado uma nova imagem, você pode preferir que a imagem seja aberta em sua máxima qualidade ou em qualidade reduzida. \nEssa opção pode ser útil caso seu aparelho não tenha bom desempenho ou caso seja antigo,a  medida que quanto maior a qualidade de imagem, mais o aplicativo irá demorar para abrir a imagem, recortá-la e inseri-la em seu layout.",

                        style: TextStyle(color: tema.corDaFonte),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Fechar', style: TextStyle(color: tema.corIconeBototesClaro),),
                        ),
                      ],
                    );
                  },
                );
                }, icon: Icon(Icons.info_outline, color: tema.corFonteSecundaria,)),
              Text("Qualidade das imagens:", style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.width*0.05)),
            ],),
            Container(
                padding: EdgeInsets.only(left: telaTamanho.width*0.15),
                child: Column(children: [
                  Row(children: [
                    IconButton(
                        onPressed: (){
                          setState(() {
                            _documento!.setQualidadeDocumento(Qualidade.alta);
                          });
                        },
                        icon: _documento == null? const Icon(Icons.access_alarm) :
                          Icon(_documento!.getQualidadeImagemGaleria() == Qualidade.alta ? Icons.radio_button_checked: Icons.radio_button_off, color: tema.corIconeBototesClaro)
                    ),
                    Text('Muito Alta', style: TextStyle(color: tema.corDaFonte)),
                  ],),
                  Row(children: [
                    IconButton(
                        onPressed: (){
                          setState(() {
                            _documento!.setQualidadeDocumento(Qualidade.media);
                          });
                        },
                        icon: _documento == null? const Icon(Icons.access_alarm) :
                          Icon(_documento!.getQualidadeImagemGaleria() == Qualidade.media ? Icons.radio_button_checked: Icons.radio_button_off, color: tema.corIconeBototesClaro)
                    ),
                    Text('Alta', style: TextStyle(color: tema.corDaFonte)),
                  ],),
                  Row(children: [
                    IconButton(
                        onPressed: (){
                          setState(() {
                            _documento!.setQualidadeDocumento(Qualidade.baixa);
                          });
                        },
                        icon: _documento == null? const Icon(Icons.access_alarm) :
                          Icon(_documento!.getQualidadeImagemGaleria() == Qualidade.baixa ? Icons.radio_button_checked: Icons.radio_button_off, color: tema.corIconeBototesClaro)
                    ),
                    Text('Média', style: TextStyle(color: tema.corDaFonte)),
                  ],),
                  Row(children: [
                    IconButton(
                        onPressed: (){
                          setState(() {
                            _documento!.setQualidadeDocumento(Qualidade.muitoBaixa);
                          });
                        },
                        icon: _documento == null? const Icon(Icons.access_alarm) :
                          Icon(_documento!.getQualidadeImagemGaleria() == Qualidade.muitoBaixa ? Icons.radio_button_checked: Icons.radio_button_off, color: tema.corIconeBototesClaro)
                    ),
                    Text('Baixa', style: TextStyle(color: tema.corDaFonte)),
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
            if(_documento!.getIndice() > 0){
              bool ret = await _exibirTelaConfirmacaoVoltarParaHome(context);
              if(ret){
                _voltarParaHome();
              }
            }
            else{
              _voltarParaHome();
            }
          }
        ),
        documentoImageView(),
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

      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(0),
        color: tema.corBotoes,
        elevation: 0,
        height: telaTamanho.height*0.07,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton( //ADD FOTO
              icon: const Icon(Icons.add_photo_alternate, size: 30),
              color: _corBotoesAdd,
              onPressed: (){
                _addImagemGaleria(tema);
              }
            ),
            IconButton(
                onPressed: ()=> mudarCorDeFundo(tema), icon: const Icon(Icons.space_dashboard_outlined, color: Colors.white,)
            ),
            IconButton(
                onPressed: () => _preencherEspacoAtualComCor(tema),
                icon: Icon(Icons.format_color_fill_outlined, size: 28, color: _corBotoesAdd)
            ),
            IconButton(
              icon: const Icon(Icons.undo, color: Colors.white),
              onPressed: _desfazerUmaAcao,
            ),
            IconButton(
                icon: const Icon(Icons.delete_forever_rounded, color: Colors.white),
                onPressed: _removerTodasAsFotos
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

  void mudarCorDeFundo(TemaAplicacao tema)async{
    tituloSeletorCor = 'Mudar cor de fundo:';
    corSelecionada = _documento!.getCorDeFundo();
    Color cor = await colorPicker(tema);
    if(cor != Colors.transparent){
      await Future.delayed(const Duration(milliseconds: 150));
      setState(() {
        load = true;
      });
      corSelecionada = cor;
      _documento!.setCorDeFundo(corSelecionada);
      await _documento!.mudarCorDeFundo(argumentos!.listaComPosicoesParaFotos, corSelecionada);
      imagemView = _documento!.getImagemView();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          load = false;
        });
      });
    }
  }

  Widget documentoImageView(){
    if(load){
      return const Text('');
    }else{
      return ListView( //Exibicao do documento sendo criado
        shrinkWrap: true,
        padding: const EdgeInsets.all(4),
        children: [Image.memory(imagemView!)]
      );
    }
  }

  Future<Color> colorPicker(TemaAplicacao tema) async{
    final Color newColor = await showColorPickerDialog( // TODO dando erro aqui
      context,
      corSelecionada,
      title: Text(tituloSeletorCor,
          style: TextStyle(color: tema.corDaFonte)),
      backgroundColor: tema.corDefundo,
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

    if(corSelecionada == newColor){
      return Colors.transparent;
    }else{
      return newColor;
    }

  }


  void _addImagemGaleria(TemaAplicacao tema) async{
    if(_documento!.possuiEspaco()){
      setState(() {
        load = true;
      });
      bool ret = await _documento!.addImagemGaleria(argumentos!.listaComPosicoesParaFotos[_documento!.getIndice()], tema);

      if(ret == true){
        setState(() {
          imagemView = _documento!.getImagemView();
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            load = false;
          });
        });
        //se acabaram os espacos, o botao deve ficar desabilitado
        if(!_documento!.possuiEspaco()){_corBotoesAdd = Colors.white10;}
      }else{
        await Future.delayed(const Duration(milliseconds: 100)); //tempo para sair do menu do croper para o editor
        setState(() {
          load = false;
        });
      }
    }
  }

  void _preencherEspacoAtualComCor(TemaAplicacao tema)async {
    if(_documento!.possuiEspaco()){
      await showDialog(context: context, builder: (context){

        addComCorDeFundo()async{
          Navigator.of(context).pop();
          setState(() {
            load = true;
          });
          await Future.delayed(const Duration(milliseconds: 200)); //tempo para abrir loading
          setState(() {
            _documento!.preencherEspacoAtualComCor(argumentos!.listaComPosicoesParaFotos[_documento!.getIndice()], _documento!.getCorDeFundo());
            imagemView = _documento!.getImagemView();
            load = false;
          });
          if(!_documento!.possuiEspaco()){//acabaram os espacos, botao fica desabilitado
            _corBotoesAdd = Colors.white10;
          }
        }

        addEscolhendoCor()async{
          Navigator.of(context).pop();
          tituloSeletorCor = 'Escolha uma cor:';
          corSelecionada = Colors.transparent;
          Color cor = await colorPicker(tema);
          if(cor != Colors.transparent){
            setState(() {
              load = true;
            });
            await Future.delayed(const Duration(milliseconds: 200)); //tempo para fechar tela e abrir loading
            corSelecionada = cor;
            setState(() {
              _documento!.preencherEspacoAtualComCor(argumentos!.listaComPosicoesParaFotos[_documento!.getIndice()], cor);
              imagemView = _documento!.getImagemView();
              load = false;
            });
            if(!_documento!.possuiEspaco()){//acabaram os espacos, botao fica desabilitado
              _corBotoesAdd = Colors.white10;
            }
          }
        }

        return AlertDialog(
          backgroundColor: tema.corDefundo,
          title: Text("Preencher espaço atual:", style: TextStyle(color: tema.corDaFonte)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(onPressed: addComCorDeFundo,
                style: ElevatedButton.styleFrom(foregroundColor: tema.corDaFonte, backgroundColor: tema.corBotoes),
                child: const Text("Pintar com cor de fundo"),
              ),
              ElevatedButton(onPressed: addEscolhendoCor,
                style: ElevatedButton.styleFrom(foregroundColor: tema.corDaFonte, backgroundColor: tema.corBotoes),
                child: const Text("Pintar com outra cor"),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(foregroundColor: tema.corDaFonte, backgroundColor: tema.corBotoes), child: const Text("Cancelar"),
              ),
            ),
          ],
        );
      });
    }
  }

  void _removerTodasAsFotos(){
    if(_documento!.getIndice() != 0){
      showDialog(context: context, barrierDismissible: true ,builder: (context){
        return SubTelaConfirmacao(
          texto: "Deseja realmente deletar todas as imagens inseridas?\nEssa ação é irreversível.",
          subtexto: "Deseja realmente prosseguir com a escolha?",
          funcaoConfirmar: ()async{
            Navigator.of(context).pop();
            if(_documento!.possuiEspaco() == false){
              _corBotoesAdd = Colors.white;
            }
            setState(() {
              load = true;
            });
            await Future.delayed(const Duration(milliseconds: 200)); //tempo para abrir loading
            _documento!.clearAllRedesenhar(argumentos!.listaComPosicoesParaFotos);
            imagemView = _documento!.getImagemView();
            setState(() {
              load = false;
            });

          },
        );
      },);
    }
  }


  void _desfazerUmaAcao()async{
    if(_documento!.getIndice() != 0){ //ha alteracoes para serem desfeitas
      setState(() {
        load = true;
      });
      await Future.delayed(const Duration(milliseconds: 200)); //tempo para abrir loading
      if(_documento!.possuiEspaco()){//caso o indice for para proxima posicao
        _documento!.desfazerUmaAcao(argumentos!.listaComPosicoesParaFotos[_documento!.getIndice()-1]);
        imagemView = _documento!.getImagemView();
      }
      else {//indice ja aponta para ultima posicao pois tinha acabado o espaco
        _documento!.desfazerUmaAcao(argumentos!.listaComPosicoesParaFotos[_documento!.getIndice()]);
        _corBotoesAdd = Colors.white;
        imagemView = _documento!.getImagemView();
      }
      if(_documento!.possuiEspaco() == false){ //tinha acabado o espaco, agora tem mais 1
        _corBotoesAdd = Colors.white;
      }
      setState(() {
        load = false;
      });
    }
  }


  void _exibirTelaErro(String textoErro, context){
    showDialog(context: context, builder: (context){
      return AlertaErroDialogBox(
        texto: textoErro,
      );
    },);
  }

  void _voltarParaHome(){
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  Future<bool> _exibirTelaConfirmacaoVoltarParaHome(context) async{
    bool ret = false;
    await showDialog(context: context, builder: (context){
      return SubTelaConfirmacao(
        texto: "Existem fotos inseridas no documento. Não será possível recuparar depois as modificações feita no documento.",
        subtexto: "Deseja voltar para a página inicial mesmo assim?",
        funcaoConfirmar: (){
          Navigator.of(context).pop();
          ret = true;
        }
      );
    },);
    return ret;
  }
}
