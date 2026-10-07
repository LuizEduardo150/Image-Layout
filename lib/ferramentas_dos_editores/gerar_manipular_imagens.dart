import 'dart:typed_data';  //para usar o unit8list para visualização
import 'package:flutter/material.dart';

import 'package:image_layout/tema_cores.dart';
import 'package:image_layout/utils/enumarator_qualidade_foto_e_unidade_medida.dart';

import "package:image/image.dart" as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
//import "package:image_gallery_saver/image_gallery_saver.dart";


class ImagensLayoutEditor {
  ///Atributos de configuracao do documento
  int _indiceListaPosicoes = 0;
  int _qtdFotosSuportadas = 0;
  bool _documentoCheio = false;
  Qualidade _qualidadeImagemAberta = Qualidade.media;
  num _color = 20;
  bool _inverter = false;
  Color _corDeFundo = Colors.white;

  /// atributos para dados finais
  img.Image? _imagemLayout;
  img.Image? _imagemAberta;

  ///Atributos para controle do cabecote de colagem de imagem e modulos
  int? _posX0;
  int? _posX1;
  int? _posY0;
  int? _posY1;
  bool _travarProporcao = true;

  //constructor
  ImagensLayoutEditor({required int altura, required int largura, required int qtdFotos}) {
    _imagemLayout = img.Image(width: largura, height: altura); //criando a imagem(matriz)
    pintarFundo(250, 250, 250);
    _qtdFotosSuportadas = qtdFotos;
  }

  int getQtdFotosSuportadas(){
    return _qtdFotosSuportadas;
  }

  void pintarFundo(num r, num g, num b){
    for (var pixel in _imagemLayout!) {
      pixel.r = r;
      pixel.g = g;
      pixel.b = b;
    }
  }

  void setCorDeFundo(Color cor){
    _corDeFundo = cor;
  }

  Color getCorDeFundo(){
    return _corDeFundo;
  }

  void setQualidadeDocumento(Qualidade valor){
    _qualidadeImagemAberta = valor;
  }

  int getTaxaCompressao(){
    return _qualidadeImagemAberta.getValorCompressaoImagemGaleria();
  }

  Qualidade getQualidadeImagemGaleria(){
    return _qualidadeImagemAberta;
  }

  //Método para exibir a imagem montada em tela
  Uint8List getImagemView(){
    return img.encodeJpg(_imagemLayout!);
  }

  int getIndice(){
    return _indiceListaPosicoes;
  }

  bool possuiEspaco(){
    if(_documentoCheio == false){return true;}
    else{return false;}
  }

  void clearAllRedesenhar(List espacosDeImagens){
    _indiceListaPosicoes = 0;
    _color = 20;
    _inverter = false;
    _documentoCheio = false;
    desenharLayoutPorPosicoes(espacosDeImagens);
  }

  bool getTravaProporcao(){
    return _travarProporcao;
  }

  void travarProporcaoCroper(){
    _travarProporcao = true;
  }

  void destravarProporcaoCroper(){
    _travarProporcao = false;
  }

  mudarCorDeFundo(List espacosDeImagens, Color cor) async{
    List atual = [];
    img.Image copia = _imagemLayout!.clone();

    for (var pixel in _imagemLayout!) { ///pintando a cor do fundo
      pixel.r = cor.red;
      pixel.g = cor.green;
      pixel.b = cor.blue;
    }

    for(int i=0; i < espacosDeImagens.length; i++){ ///colando as fotos ou espacos para fotos
      atual = espacosDeImagens[i];

      for(int x = atual[0]; x < atual[2]; x++){
        for(int y = atual[1]; y < atual[3]; y++){
          img.Pixel a = copia.getPixel(x, y);
          _imagemLayout!.setPixelRgb(x, y, a[0], a[1], a[2]);
        }
      }
    }

  }


  desenharLayoutPorPosicoes(List espacosDeImagens)async{
    if(espacosDeImagens.isNotEmpty){
      List atual = [];

      for(int i=0; i < espacosDeImagens.length; i++){
        atual = espacosDeImagens[i];

        for(int x = atual[0]; x < atual[2]; x++){
          for(int y = atual[1]; y < atual[3]; y++){
            _imagemLayout!.setPixelRgb(x, y, _color, _color, _color);
          }
        }

        if(!_inverter){
          _color += 20;
          if(_color > 255){
            _inverter = true;
            _color = 240;
          }
        }else{
          _color -= 20;
          if(_color < 20){
            _color = 20;
            _inverter = false;
          }
        }

      }
    }
  }

  Future<bool> addImagemGaleria(List posAtual, TemaAplicacao tema) async{
    _posX0 = posAtual[0];
    _posY0 = posAtual[1];
    _posX1 = posAtual[2];
    _posY1 = posAtual[3];
    int propX = _posX1! - _posX0!;
    int propY = _posY1! - _posY0!;

    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    CroppedFile? croppedFile;
    if (pickedFile != null) {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: _qualidadeImagemAberta.getValorCompressaoImagemGaleria(), //100 qualidade maxima |---| 0 qualidade baixa
        aspectRatio: CropAspectRatio(ratioX: double.parse(propX.toString()), ratioY: double.parse(propY.toString())),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Recorte de Imagem',
              toolbarColor: tema.corBotoes,
              toolbarWidgetColor: Colors.white, //cor da fonte e icones appbar
              backgroundColor: tema.corBotoes,
              activeControlsWidgetColor: Colors.black, //itens selecionados
              statusBarColor: tema.corBotoes,
              lockAspectRatio: _travarProporcao
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if(croppedFile != null){
        //Carregando imagem para trabalhar como matriz img.Image
        _imagemAberta = await _pathToImgImage(croppedFile.path);
        if(_imagemAberta != null){
          await _colarImagemCarregadaNoLayout();
          if(_indiceListaPosicoes < _qtdFotosSuportadas - 1){
            _indiceListaPosicoes++;
          }else{_documentoCheio = true;}
        }
      }
      return true;
    }
    else{
      return false;
    }
  }

  Future<img.Image?> _pathToImgImage(String path) async{
    final cmd = img.Command();
    int largura = _posX1! - _posX0!;
    int altura = _posY1! - _posY0!;

    try{
      cmd.decodeImageFile(path);
      cmd.copyResize(width: largura, height: altura); //redimencionando para as dimecoes do espaco atual
      await cmd.executeThread();
      return cmd.outputImage;
    }catch(e){
      return null;
    }
  }

  _colarImagemCarregadaNoLayout()async{
    if(_imagemAberta != null){
      int xpos = _posX0!; //posicoes referentes a foto sendo gerada
      int ypos = _posY0!;
      num r,g,b; //variaveis temporarias para armazenar os valores rgb de cada pixel

      for(int y = 0; y < _imagemAberta!.height; y++){  //altura  Eixo Y
        for(int x = 0; x < _imagemAberta!.width; x++){ //largura Eixo X
          r = _imagemAberta!.getPixel(x, y)[0];
          g = _imagemAberta!.getPixel(x, y)[1];
          b = _imagemAberta!.getPixel(x, y)[2];
          _imagemLayout?.setPixelRgb(xpos, ypos, r, g, b); //copiando os pixels da imagem na imagem de fundo
          xpos++;
        }
        xpos = _posX0!;
        ypos++;
      }
    }
  }

  void preencherEspacoAtualComCor(List posAtual, Color cor){
    _posX0 = posAtual[0];
    _posY0 = posAtual[1];
    _posX1 = posAtual[2];
    _posY1 = posAtual[3];

    for(int x =_posX0!; x < _posX1!; x++){
      for(int y = _posY0!; y < _posY1!; y++){
        _imagemLayout!.setPixelRgb(x, y, cor.red, cor.green, cor.blue);
      }
    }
    if(_indiceListaPosicoes < _qtdFotosSuportadas - 1){
      _indiceListaPosicoes++;
    }else{_documentoCheio = true;}
  }

  void desfazerUmaAcao(List posicoesXYDaUltimaAdicao){
    if(_indiceListaPosicoes > 0){ //há alterações que podem ser desfeitas
      _posX0 = posicoesXYDaUltimaAdicao[0];
      _posY0 = posicoesXYDaUltimaAdicao[1];
      _posX1 = posicoesXYDaUltimaAdicao[2];
      _posY1 = posicoesXYDaUltimaAdicao[3];

      if(!_inverter){
        _color += 20;
        if(_color > 255){
          _inverter = true;
          _color = 240;
        }
      }else{
        _color -= 20;
        if(_color < 20){
          _color = 20;
          _inverter = false;
        }
      }

      for(int x =_posX0!; x < _posX1!; x++){
        for(int y = _posY0!; y < _posY1!; y++){
          _imagemLayout!.setPixelRgb(x, y, _color, _color, _color);
        }
      }

      if(_documentoCheio){
        _documentoCheio = false;
      }else{
        _indiceListaPosicoes--;
      }

    }
  }

  Future<bool> salvarImagem(String nomeArquivo) async{
    //configurando arquivo a ser gerado
    if(_imagemLayout == null){
      return false;
    }
    //salvar na galeria em formato jpg
    final png = img.encodePng(_imagemLayout!); 
    // TODO
    //final result = await ImageGallerySaver.saveImage(png, name: nomeArquivo, quality: 100);
    print("Era para salvar");
    //return result['isSuccess'];
    return true; // TODO remover dps
  }

}
