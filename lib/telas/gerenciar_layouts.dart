import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/tema_cores.dart';
import 'package:image_layout/persistence/layout_persistence.dart';
import 'package:image_layout/utils/funcoes_cast.dart';
import 'package:image_layout/telas/subtelas/alerta_confirmar_desicao.dart';
import 'package:image_layout/telas/subtelas/mudar_nome_layout_salvo.dart';
import 'package:image_layout/telas/subtelas/alerta_erro.dart';
import 'package:image_layout/telas/criar_novo_layout.dart';


class GerenciarLayouts extends StatefulWidget {
  const GerenciarLayouts({super.key});

  @override
  State<GerenciarLayouts> createState() => _GerenciarLayoutsState();
}

class _GerenciarLayoutsState extends State<GerenciarLayouts> {

  LayoutPersistence? persistence;

  ///gerenciamento da listview
  List<String> items = [];
  List<String> selectedItems = [];
  //itens da listview
  List<Uint8List> tumbnails = [];
  List dimencoes = [];
  List qtdImagens = [];

  ///gerenciamento da pagina
  TextEditingController nomeLayoutControler = TextEditingController();
  String titulo = 'Layouts salvos';
  bool vazio = false;
  bool load = true;

  void exibirTelaErro(String textoErro){
    showDialog(context: context, builder: (context){
      return AlertaErroDialogBox(
        texto: textoErro,
      );
    },);
  }
  
  @override
  void initState(){
    persistence = LayoutPersistence();
    super.initState();
    inicializar();
  }

  inicializar() async{
    await persistence!.carregarChaves();
    List alturaLargura;
    List cordenadas;
    Uint8List retGetThumb;

    inserirTumbnails()async{
      for(int i=0; i< persistence!.chaves.length; i++){
        persistence!.nome = persistence!.chaves[i];
        items.add(persistence!.nome!);
        alturaLargura = await persistence!.getTamanhoDocumento();
        dimencoes.add([alturaLargura[1], alturaLargura[0]]);
        cordenadas = await persistence!.getCoordenadasImg();
        qtdImagens.add(cordenadas.length);
        retGetThumb = await persistence!.getThumbnailLayout();
        tumbnails.add(retGetThumb);
      }
    }

    await Future.delayed(const Duration(milliseconds: 500)); //tempo para troca de paginas
    await inserirTumbnails();
    if(items.isEmpty){
      vazio = true;
    }
    load = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<TemaAplicacao>(context);
    final Size telaTamanho = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: tema.corDefundo,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: tema.corBotoes,
        title: Text(titulo),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: deletarSelecionado,
        backgroundColor: tema.corBotoes,
        foregroundColor: tema.corDosIcones,
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
                    Text("Um instante...", style: TextStyle(color: tema.corDosIcones, fontSize: telaTamanho.width*0.07)),
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
                  side: BorderSide(color: tema.corIconeBototesClaro),
                  contentPadding: const EdgeInsets.all(0),
                  secondary: IconButton(
                    onPressed: (){
                      mudarNome(index);
                    },
                    icon: Icon(Icons.edit, color: tema.corDaFonte,),
                  ),
                  title: Container(
                    color: isSelected? const Color.fromRGBO(0, 0, 200, 200) : tema.corDefundo,
                    margin: EdgeInsets.only(bottom: telaTamanho.height*0.05),
                    alignment: Alignment.center,
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected? Colors.blue : tema.corDefundo,  // Define a cor da borda
                            width: 4,          // Define a largura da borda
                          ),
                        ),
                        height: telaTamanho.height*0.3,
                        child: Image.memory(tumbnails[index], fit: BoxFit.contain),
                      ),
                      Text(
                        '${persistence!.chaves[index]}',
                        style: TextStyle(fontSize: 20.0, color: tema.corDaFonte),
                      ),
                      Text("${dimencoes[index][0]} x ${dimencoes[index][1]} px \n"
                          "~${(pxToCm(300, dimencoes[index][0])).toStringAsFixed(2)} x ${(pxToCm(300, dimencoes[index][1])).toStringAsFixed(2)} cm (300ppi)",
                        style: TextStyle(fontSize: 17, color: tema.corDaFonte),
                        textAlign: TextAlign.center,
                      ),
                      Text("Suporte para até ${qtdImagens[index]} imagen(s)", style: TextStyle(color: tema.corDaFonte),),
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
                        titulo = '${selectedItems.length} itens selecionados';
                      }else if(selectedItems.length == 1){
                        titulo = '1 item selecionado';
                      }else{
                        titulo = 'Layouts salvos';
                      }

                    });
                  },
                );
              },
            ),
          ),
        Visibility(
          visible: vazio,
          child: Container(
            padding:  EdgeInsets.all(telaTamanho.height*0.06),
              child: Column(
                children: [
                  Text("Não há layouts salvos aqui por enquanto.", style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.width*0.1),),
                  TextButton(onPressed: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CriarNovoLayoutPage())), child: Text("Criar um layout?", style: TextStyle(color: tema.corDosIcones, fontSize: telaTamanho.width*0.09, decoration: TextDecoration.underline,),))
                ],
              )
          ),
        ),
      ],),
    );
  }

  mudarNome(int index) async{
    bool mudou = false;
    if(selectedItems.isEmpty){
      await exibirTelaMudarNomeLayoutSalvo(
          controlerNomeLayout: nomeLayoutControler,
          context: context,
          funcaoConfirmar: ()async{
            if(nomeLayoutControler.text.trim() != '' && nomeLayoutControler.text.trim() != items[index]){
              load = true;
              mudou = await persistence!.mudarNomeChave(chave: items[index], novoNomeChave: nomeLayoutControler.text.trim());
              if(mudou){
                items = [];
                selectedItems = [];
                tumbnails = [];
                nomeLayoutControler.text = '';
                inicializar();
              }else{
                exibirTelaErro("Não foi possível alterar o nome do layout pelo especificado, pois já existem outros atributos com esse nome, ou foi inserido um nome inválido.");
                nomeLayoutControler.text = '';
              }
            }
          }
      );

    }
  }

  deletarSelecionado()async{
    bool deveDeletar = false;
    if(selectedItems.isNotEmpty){
      String texto;
      if(selectedItems.length > 1){
        texto = 'Deseja realmente deletar os layouts selecionados?\nEssa ação será irreversível.\n\n';
      }else{
        texto = 'Deseja realmente deletar o layout selecionado?\nEssa ação será irreversível.\n\n';
      }

      await showDialog(context: context, barrierDismissible: true ,builder: (context){
        return SubTelaConfirmacao(
          texto: texto,
          subtexto: "Deseja proseguir e deletar?",
          funcaoConfirmar: (){
            Navigator.of(context).pop();
            deveDeletar = true;
          },
        );
      },);

      if(deveDeletar){
        for(int i=0; i<selectedItems.length; i++){
          await persistence!.deletarPorChave(selectedItems[i]);
        }
        items = [];
        selectedItems = [];
        tumbnails = [];

        titulo = 'Layouts salvos';
        deveDeletar = false;
        inicializar();
      }
    }
  }

}