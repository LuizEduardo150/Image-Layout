import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/screens/layout_editor.dart';
import 'package:image_layout/utils/utils.dart';
import 'package:image_layout/utils/enum_app_values.dart';
import 'package:image_layout/application_theme_pers.dart';


class CreateNewLayoutPage extends StatefulWidget {
  const CreateNewLayoutPage({super.key});

  @override
  State<CreateNewLayoutPage> createState() => _CreateNewLayoutPageState();
}

class _CreateNewLayoutPageState extends State<CreateNewLayoutPage> {
  
  final TextEditingController _controllerWidth = TextEditingController(); // usado para controlar os valores de entrada de texto para a largura e altura
  final TextEditingController _controllerHeight = TextEditingController();
  final TextEditingController _controllerBorder = TextEditingController();
  String _selectUnit = 'px';
  bool _showQuality = false;
  String _selectQuality = 'Médio';

  @override
  void dispose() {
    // libera a memória e evitar vazamentos de recursos quando o widget é destruído
    _controllerWidth.dispose();
    _controllerHeight.dispose();
    _controllerBorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppThemePers>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.bkgColor,
      appBar: AppBar(
        foregroundColor: theme.fontColor,
        backgroundColor: theme.buttonColor,
        elevation: 0.0,
        title: const Text('Definições do novo Layout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectUnit,
              dropdownColor: theme.bkgColor,
              onChanged: (String? novoValor) {
                setState(() {
                  _selectUnit = novoValor!;
                  if (novoValor == 'px') {
                    _showQuality = false;
                  } else {
                    _showQuality = true;
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
                  child: Text(valor, style: TextStyle(color: theme.fontColor, fontSize: screenSize.height*0.02)),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Unidade',
                labelStyle: TextStyle(color: theme.fontColor),
                border: const OutlineInputBorder(),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Visibility(
                visible: _showQuality,
                child: DropdownButtonFormField(
                  initialValue: _selectQuality,
                  dropdownColor: theme.bkgColor,
                  onChanged: (String? novoValor) {
                    setState(() {
                      _selectQuality = novoValor!;
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: "Mínimo",
                      child: Text("Mínimo (100 PPI)", style: TextStyle(color: theme.fontColor)),
                    ),
                    DropdownMenuItem<String>(
                      value: "Médio",
                      child: Text("Médio (200 PPI)", style: TextStyle(color: theme.fontColor)),
                    ),
                    DropdownMenuItem<String>(
                      value: "Alto",
                      child: Text("Alto (300 PPI)", style: TextStyle(color: theme.fontColor)),
                    ),
                    DropdownMenuItem<String>(
                      value: "Muito Alto",
                      child: Text("Muito Alto (400PPI)", style: TextStyle(color: theme.fontColor)),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Qualidade (PPI)',
                    labelStyle: TextStyle(color: theme.fontColor, fontSize: 20),
                    border: const OutlineInputBorder(),
                  ),
                )
            ),
            Visibility( //padding extra ao adicionar mais um campo
                visible: _showQuality,
                child:const Padding(padding: EdgeInsets.all(10))
            ),
            TextField(
              controller: _controllerWidth,
              style: TextStyle(color: theme.fontColor, fontSize: 20),
              //  permite controlar o conteúdo do campo de texto e obter seu valor
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Largura',
                labelStyle: TextStyle(color: theme.fontColor, fontSize: 20),
                border: const OutlineInputBorder(), // define o estilo da borda ao redor do campo de texto
              ),
              textInputAction: TextInputAction.next,
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: _controllerHeight,
              keyboardType: TextInputType.number,
              style: TextStyle(color: theme.fontColor, fontSize: 20),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Altura',
                labelStyle: TextStyle(color: theme.fontColor, fontSize: 20),
                border: const OutlineInputBorder(),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: _controllerBorder,
              keyboardType: TextInputType.number,
              style: TextStyle(color: theme.fontColor, fontSize: 20),
              decoration: InputDecoration(
                labelText: 'Borda (opcional)',
                labelStyle: TextStyle(color: theme.fontColor, fontSize: 20),
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _confirmarConfiguracoes,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                foregroundColor: theme.iconsColor,
                backgroundColor: theme.buttonColor,
              ),
              child: const Text('Confirmar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                )
              )
            )
          ]
        )
      )
    );
  }


  void _confirmarConfiguracoes() {
    UnitOfMeasurement unidadedoc = UnitOfMeasurement.pixels;
    Quality qualidadeDoc = Quality.medium;
    int? larguradoc;
    int? alturadoc;
    int? bordadoc;

    if (_selectQuality == 'Mínimo') {
      qualidadeDoc = Quality.verylow;
    
    } else if (_selectQuality == 'Médio') {
      qualidadeDoc = Quality.low;
    
    } else if (_selectQuality == 'Alto') {
      qualidadeDoc = Quality.medium;
    
    } else if (_selectQuality == 'Muito Alto') {
      qualidadeDoc = Quality.high;
    }

    if (_selectUnit == 'px') {
      //não é preciso fazer convercao para o editor de layouts
      unidadedoc = UnitOfMeasurement.pixels;
      larguradoc = stringParseInt(_controllerWidth.text.trim());
      alturadoc = stringParseInt(_controllerHeight.text.trim());
      bordadoc = stringParseInt(_controllerBorder.text.trim());
    } else if (_selectUnit == 'cm') {
      // é preciso fazer convercao para o editor de layouts
      unidadedoc = UnitOfMeasurement.centimeters;
      larguradoc =
          cmToPx(qualidadeDoc.getValorPPI(), _controllerWidth.text.trim());
      alturadoc =
          cmToPx(qualidadeDoc.getValorPPI(), _controllerHeight.text.trim());
      bordadoc =
          cmToPx(qualidadeDoc.getValorPPI(), _controllerBorder.text.trim());
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
            )
          ]
        )
      );
    } 
    else {
      _controllerBorder.text = '';
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
      }
      else{
        LayoutEditorPageArgs args = LayoutEditorPageArgs(alturadoc, larguradoc, bordadoc, qualidadeDoc, unidadedoc);
        Navigator.pushNamedAndRemoveUntil(context, '/editorLayouts', arguments: args, ModalRoute.withName('/'));
      }

    }
  }

}
