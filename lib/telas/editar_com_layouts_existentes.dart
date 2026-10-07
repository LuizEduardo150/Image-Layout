import 'dart:typed_data';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:image_layout/persistence/layout_persistence.dart';
import 'package:image_layout/telas/editor_imagens.dart';
import 'package:image_layout/utils/funcoes_cast.dart';
import 'package:image_layout/tema_cores.dart';


class NovoLayoutPredefinido extends StatefulWidget {
  const NovoLayoutPredefinido({super.key});

  @override
  State<NovoLayoutPredefinido> createState() => _NovoLayoutPredefinidoState();
}

class _NovoLayoutPredefinidoState extends State<NovoLayoutPredefinido> {

  ///controle da pagina
  int _selecionarItem = -1; // índice do item selecionado
  bool load = true;
  LayoutPersistence? persistence;
  bool vazio = false;

  ///elementos visuais
  List<Uint8List> tumbnails = [];
  List dimencoes = [];
  List qtdImagensSuportadas = [];

  @override
  void initState(){
    super.initState();
    persistence = LayoutPersistence();
    inicializar();
  }

  void inicializar() async{
    await persistence!.carregarChaves();
    Uint8List retGetThumb;
    List alturaLargura;
    List cordenadas;

    inserirThumbnails()async{
      for(int i=0; i< persistence!.chaves.length; i++){
        persistence!.nome = persistence!.chaves[i];
        alturaLargura = await persistence!.getTamanhoDocumento();
        dimencoes.add([alturaLargura[1], alturaLargura[0]]);
        cordenadas = await persistence!.getCoordenadasImg();
        qtdImagensSuportadas.add(cordenadas.length);
        retGetThumb = await persistence!.getThumbnailLayout();
        tumbnails.add(retGetThumb);
      }
    }

    await Future.delayed(const Duration(milliseconds: 500)); //tempo para troca de paginas
    await inserirThumbnails();
    load = false;
    if(tumbnails.isEmpty){
      vazio = true;
    }
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<TemaAplicacao>(context);
    final Size telaTamanho = MediaQuery.of(context).size;

    void confirmarEscolha() async{
      if (_selecionarItem != -1) {
        persistence!.nome = persistence!.chaves[_selecionarItem];
        List coordenadas = await persistence!.getCoordenadasImg();
        irParaEditor(coordenadas);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: tema.corBotoes,
              title: const Text('Erro', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
              content: Text('Selecione um layout antes de continuar.', style: TextStyle(color: tema.corDaFonte)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK', style: TextStyle(color: tema.corDaFonte)),
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      backgroundColor: tema.corDefundo,
      appBar: AppBar(
        backgroundColor: tema.corBotoes,
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
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(child: GridView.count(
                  crossAxisCount: 1,
                  children: List.generate(persistence!.getQtdDeLayoutsSalvos(), (index) {
                    final isSelecionado = _selecionarItem == index;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selecionarItem = index;
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
                              height: telaTamanho.height*0.3,
                              child: Image.memory(tumbnails[index], fit: BoxFit.contain),
                            ),
                          ],)
                        ),
                        Text(
                          '${persistence!.chaves[index]}',
                          style: TextStyle(fontSize: 20.0, color: tema.corDaFonte),
                        ),
                        const Padding(padding: EdgeInsets.all(3)),
                        Text("${dimencoes[index][0]} x ${dimencoes[index][1]} px \n"
                            "~${(pxToCm(300, dimencoes[index][0])).toStringAsFixed(2)} x ${(pxToCm(300, dimencoes[index][1])).toStringAsFixed(2)} cm (300ppi)",
                            style: TextStyle(fontSize: telaTamanho.width*0.02, color: tema.corDaFonte),
                            textAlign: TextAlign.center,
                        ),
                        Text("Suporte para até ${qtdImagensSuportadas[index]} imagens", style: TextStyle(color: tema.corDaFonte),),
                    ],),
                    );
                  }),
                ),),
              ],
            ),
          ),
        Visibility(
          visible: vazio,
          child: Container(
              padding:  EdgeInsets.all(telaTamanho.height*0.06),
              child: Column(
                children: [
                  Text("Não há layouts salvos aqui por enquanto.", style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.width*0.1),),
                  TextButton(
                      child: Text("Criar um layout?", style: TextStyle(color: tema.corDosIcones, fontSize: telaTamanho.width*0.09, decoration: TextDecoration.underline)),
                      onPressed: ()=> Navigator.pushNamed(context, '/criarNovoLayout')
                  )
                ],
              )
          ),
        ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: confirmarEscolha,
        backgroundColor: tema.corBotoes,
        foregroundColor: tema.corDosIcones,
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  void irParaEditor(List posicoes){
    EditorImagemArgs argumentos = EditorImagemArgs(dimencoes[_selecionarItem][0], dimencoes[_selecionarItem][1], posicoes);
    Navigator.pushNamed(context, "/editorImagens", arguments: argumentos);
  }

}
