import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/screens/layout_editor.dart';
import 'package:image_layout/utils/utils.dart';
import 'package:image_layout/utils/enum_app_values.dart';
import 'package:image_layout/application_theme_pers.dart';


class CriarNovoLayoutPage extends StatefulWidget {
  const CriarNovoLayoutPage({super.key});

  @override
  State<CriarNovoLayoutPage> createState() => _CriarNovoLayoutPageState();
}

class _CriarNovoLayoutPageState extends State<CriarNovoLayoutPage> {
  final TextEditingController _larguraController =
  TextEditingController(); // usado para controlar os valores de entrada de texto para a largura e altura
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _bordaController = TextEditingController();
  String _selecionarUnidade = 'px';
  bool _mostrarQualidade = false;


  String _selecionarQualidade = 'Médio';

  @override
  void dispose() {
    // libera a memória e evitar vazamentos de recursos quando o widget é destruído
    _larguraController.dispose();
    _alturaController.dispose();
    _bordaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<TemaAplicacao>(context);
    final Size telaTamanho = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: tema.corDefundo,
      appBar: AppBar(
        foregroundColor: tema.corDaFonte,
        backgroundColor: tema.corBotoes,
        elevation: 0.0,
        title: const Text('Definições do novo Layout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selecionarUnidade,
              dropdownColor: tema.corDefundo,
              onChanged: (String? novoValor) {
                setState(() {
                  _selecionarUnidade = novoValor!;
                  if (novoValor == 'px') {
                    _mostrarQualidade = false;
                  } else {
                    _mostrarQualidade = true;
                  }
                });
              },
              items: [
                'cm',
                'px'
              ] // opções disponíveis como lista de String
                  .map<DropdownMenuItem<String>>((String valor) {
                return DropdownMenuItem<String>(
                  value: valor,
                  child: Text(valor, style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.height*0.02)),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Unidade',
                labelStyle: TextStyle(color: tema.corDaFonte),
                border: const OutlineInputBorder(),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Visibility(
                visible: _mostrarQualidade,
                child: DropdownButtonFormField(
                  initialValue: _selecionarQualidade,
                  dropdownColor: tema.corDefundo,
                  onChanged: (String? novoValor) {
                    setState(() {
                      _selecionarQualidade = novoValor!;
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: "Mínimo",
                      child: Text("Mínimo (100 PPI)", style: TextStyle(color: tema.corDaFonte)),
                    ),
                    DropdownMenuItem<String>(
                      value: "Médio",
                      child: Text("Médio (200 PPI)", style: TextStyle(color: tema.corDaFonte)),
                    ),
                    DropdownMenuItem<String>(
                      value: "Alto",
                      child: Text("Alto (300 PPI)", style: TextStyle(color: tema.corDaFonte)),
                    ),
                    DropdownMenuItem<String>(
                      value: "Muito Alto",
                      child: Text("Muito Alto (400PPI)", style: TextStyle(color: tema.corDaFonte)),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Qualidade (PPI)',
                    labelStyle: TextStyle(color: tema.corDaFonte, fontSize: 20),
                    border: const OutlineInputBorder(),
                  ),
                )
            ),
            Visibility( //padding extra ao adicionar mais um campo
                visible: _mostrarQualidade,
                child:const Padding(padding: EdgeInsets.all(10))
            ),
            TextField(
              controller: _larguraController,
              style: TextStyle(color: tema.corDaFonte, fontSize: 20),
              //  permite controlar o conteúdo do campo de texto e obter seu valor
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Largura',
                labelStyle: TextStyle(color: tema.corDaFonte, fontSize: 20),
                border: const OutlineInputBorder(), // define o estilo da borda ao redor do campo de texto
              ),
              textInputAction: TextInputAction.next,
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: _alturaController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: tema.corDaFonte, fontSize: 20),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Altura',
                labelStyle: TextStyle(color: tema.corDaFonte, fontSize: 20),
                border: const OutlineInputBorder(),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: _bordaController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: tema.corDaFonte, fontSize: 20),
              decoration: InputDecoration(
                labelText: 'Borda (opcional)',
                labelStyle: TextStyle(color: tema.corDaFonte, fontSize: 20),
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _confirmarConfiguracoes,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                foregroundColor: tema.corDosIcones,
                backgroundColor: tema.corBotoes,
              ),
              child: const Text('Confirmar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _confirmarConfiguracoes() {
    UnidadeDeMedida unidadedoc = UnidadeDeMedida.pixels;
    Qualidade qualidadeDoc = Qualidade.media;
    int? larguradoc;
    int? alturadoc;
    int? bordadoc;

    if (_selecionarQualidade == 'Mínimo') {
      qualidadeDoc = Qualidade.muitoBaixa;
    } else if (_selecionarQualidade == 'Médio') {
      qualidadeDoc = Qualidade.baixa;
    } else if (_selecionarQualidade == 'Alto') {
      qualidadeDoc = Qualidade.media;
    } else if (_selecionarQualidade == 'Muito Alto') {
      qualidadeDoc = Qualidade.alta;
    }


    if (_selecionarUnidade == 'px') {
      //não é preciso fazer convercao para o editor de layouts
      unidadedoc = UnidadeDeMedida.pixels;
      larguradoc = stringParseInt(_larguraController.text.trim());
      alturadoc = stringParseInt(_alturaController.text.trim());
      bordadoc = stringParseInt(_bordaController.text.trim());
    } else if (_selecionarUnidade == 'cm') {
      // é preciso fazer convercao para o editor de layouts
      unidadedoc = UnidadeDeMedida.centimetros;
      larguradoc =
          cmToPx(qualidadeDoc.getValorPPI(), _larguraController.text.trim());
      alturadoc =
          cmToPx(qualidadeDoc.getValorPPI(), _alturaController.text.trim());
      bordadoc =
          cmToPx(qualidadeDoc.getValorPPI(), _bordaController.text.trim());
    }

    if (larguradoc == null || larguradoc == 0 || alturadoc == null || alturadoc == 0 || bordadoc == null) {
      //condicao de ERRO altura ou largura vazios
      showDialog(
        context: context, // necessário para exibir o diálogo
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Por favor, preencha os campos de Largura e Altura.\nOs campos de digitação devem ser usados com números válidos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      _bordaController.text = '';
      if(bordadoc >= larguradoc || bordadoc >= alturadoc){
        showDialog(
          context: context, // necessário para exibir o diálogo
          builder: (context) => AlertDialog(
            title: const Text('Erro'),
            content: const Text('O valor da borda aplicado ao documento, deve ser um valor menor que o valor das dimensões do layout'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }else{
        EditorLayoutArgs args = EditorLayoutArgs(alturadoc, larguradoc, bordadoc, qualidadeDoc, unidadedoc);
        Navigator.pushNamedAndRemoveUntil(context, '/editorLayouts', arguments: args, ModalRoute.withName('/'));
      }

    }
  }

}
