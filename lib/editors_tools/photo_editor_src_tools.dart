import 'dart:typed_data';  //para usar o unit8list para visualização
import 'package:flutter/material.dart';

import 'package:image_layout/application_theme_pers.dart';
import 'package:image_layout/utils/enum_app_values.dart';

import "package:image/image.dart" as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
//import "package:image_gallery_saver/image_gallery_saver.dart";


class ImagensLayoutEditor {
  ///Atributos de configuracao do documento
  int _positionsIndexList = 0;
  int _amtSupportedPhotos = 0;
  bool _documentIsFull = false;
  Quality _openedImageQuality = Quality.medium;
  num _color = 20;
  bool _invert = false;
  Color _bkgColor = Colors.white;

  /// atributos para dados finais
  img.Image? _imagemLayout;
  img.Image? _openedImage;

  ///Atributos para controle do cabecote de colagem de imagem e modulos
  int? _posX0;
  int? _posX1;
  int? _posY0;
  int? _posY1;
  bool _proportionLock = true;

  //constructor
  ImagensLayoutEditor({required int height, required int width, required int amtPhotos}) {
    _imagemLayout = img.Image(width: width, height: height); //criando a imagem(matriz)
    paintBackground(250, 250, 250);
    _amtSupportedPhotos = amtPhotos;
  }


  int getQtdFotosSuportadas(){
    return _amtSupportedPhotos;
  }


  void paintBackground(num r, num g, num b){
    for (var pixel in _imagemLayout!) {
      pixel.r = r;
      pixel.g = g;
      pixel.b = b;
    }
  }


  void setBkgColor(Color cor){
    _bkgColor = cor;
  }


  Color getBkgColor(){
    return _bkgColor;
  }


  void setDocumentQuality(Quality valor){
    _openedImageQuality = valor;
  }


  int getCompressionRatio(){
    return _openedImageQuality.getGalleryCompressionValue();
  }


  Quality getGaleryImageQuality(){
    return _openedImageQuality;
  }


  //Método para exibir a imagem montada em tela
  Uint8List getImageView(){
    return img.encodeJpg(_imagemLayout!);
  }


  int getIndex(){
    return _positionsIndexList;
  }


  bool canInsert(){
    return !_documentIsFull;
  }


  void clearAll(List espacosDeImagens){
    _positionsIndexList = 0;
    _color = 20;
    _invert = false;
    _documentIsFull = false;
    drawLayoutByPositions(espacosDeImagens);
  }


  bool getProportionLock(){
    return _proportionLock;
  }


  void lockProportionCroper(){
    _proportionLock = true;
  }


  void unlockProportionCroper(){
    _proportionLock = false;
  }


  Future<void> changeBackgroundColor(List espacosDeImagens, Color color) async{
    List current = [];
    img.Image copia = _imagemLayout!.clone();

    for (var pixel in _imagemLayout!) { ///pintando a cor do fundo
      pixel.r = color.red;
      pixel.g = color.green;
      pixel.b = color.blue;
    }

    for(int i=0; i < espacosDeImagens.length; i++){ ///colando as fotos ou espacos para fotos
      current = espacosDeImagens[i];

      for(int x = current[0]; x < current[2]; x++){

        for(int y = current[1]; y < current[3]; y++){
          img.Pixel a = copia.getPixel(x, y);
          _imagemLayout!.setPixelRgb(x, y, a[0], a[1], a[2]);
        }

      }
    }

  }


  Future<void> drawLayoutByPositions(List espacosDeImagens) async{
    if(espacosDeImagens.isNotEmpty){
      List current = [];

      for(int i=0; i < espacosDeImagens.length; i++){
        current = espacosDeImagens[i];

        for(int x = current[0]; x < current[2]; x++){
          for(int y = current[1]; y < current[3]; y++){
            _imagemLayout!.setPixelRgb(x, y, _color, _color, _color);
          }
        }

        if(!_invert){
          _color += 20;
          if(_color > 255){
            _invert = true;
            _color = 240;
          }
        }else{
          _color -= 20;
          if(_color < 20){
            _color = 20;
            _invert = false;
          }
        }

      }
    }
  }


  Future<bool> addGaleryImage(List currentPos, AppThemePers tema) async{
    _posX0 = currentPos[0];
    _posY0 = currentPos[1];
    _posX1 = currentPos[2];
    _posY1 = currentPos[3];
    int propX = _posX1! - _posX0!;
    int propY = _posY1! - _posY0!;
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    CroppedFile? croppedFile;
    
    if (pickedFile != null) {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: _openedImageQuality.getGalleryCompressionValue(), //100 qualidade maxima |---| 0 qualidade baixa
        aspectRatio: CropAspectRatio(ratioX: double.parse(propX.toString()), ratioY: double.parse(propY.toString())),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Recorte de Imagem',
              toolbarColor: tema.buttonColor,
              toolbarWidgetColor: Colors.white, //cor da fonte e icones appbar
              backgroundColor: tema.buttonColor,
              activeControlsWidgetColor: Colors.black, //itens selecionados
              statusBarColor: tema.buttonColor,
              lockAspectRatio: _proportionLock
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      if(croppedFile != null){
        //Carregando imagem para trabalhar como matriz img.Image
        _openedImage = await _pathToImgImage(croppedFile.path);
        
        if(_openedImage != null){
          await _pasteLoadedImageIntoLayout();
          
          if(_positionsIndexList < _amtSupportedPhotos - 1){
            _positionsIndexList++;
          }
          else{
            _documentIsFull = true;
          }
        
        }
      }
    
      return true;
    }
    
    return false;
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
    }
    catch(e){
      return null;
    }
  }


  Future<void> _pasteLoadedImageIntoLayout()async{
    if(_openedImage != null){
      int xpos = _posX0!; //posicoes referentes a foto sendo gerada
      int ypos = _posY0!;
      num r,g,b; //variaveis temporarias para armazenar os valores rgb de cada pixel

      for(int y = 0; y < _openedImage!.height; y++){  //altura  Eixo Y
        for(int x = 0; x < _openedImage!.width; x++){ //largura Eixo X
          r = _openedImage!.getPixel(x, y)[0];
          g = _openedImage!.getPixel(x, y)[1];
          b = _openedImage!.getPixel(x, y)[2];
          _imagemLayout?.setPixelRgb(xpos, ypos, r, g, b); //copiando os pixels da imagem na imagem de fundo
          xpos++;
        }
        xpos = _posX0!;
        ypos++;
      }
    }
  }

  void fillCurrentSpaceWithColor(List currentPos, Color color){
    _posX0 = currentPos[0];
    _posY0 = currentPos[1];
    _posX1 = currentPos[2];
    _posY1 = currentPos[3];

    for(int x =_posX0!; x < _posX1!; x++){
      
      for(int y = _posY0!; y < _posY1!; y++){
        _imagemLayout!.setPixelRgb(x, y, color.red, color.green, color.blue);
      }

    }

    if(_positionsIndexList < _amtSupportedPhotos - 1){
      _positionsIndexList++;
    }

    else{
      _documentIsFull = true;
    }

  }


  void undoOneAction(List posicoesXYDaUltimaAdicao){
    if(_positionsIndexList > 0){ //há alterações que podem ser desfeitas
      _posX0 = posicoesXYDaUltimaAdicao[0];
      _posY0 = posicoesXYDaUltimaAdicao[1];
      _posX1 = posicoesXYDaUltimaAdicao[2];
      _posY1 = posicoesXYDaUltimaAdicao[3];

      if(!_invert){
        _color += 20;
        if(_color > 255){
          _invert = true;
          _color = 240;
        }
      }

      else{
        _color -= 20;
        if(_color < 20){
          _color = 20;
          _invert = false;
        }
      }

      for(int x =_posX0!; x < _posX1!; x++){
        for(int y = _posY0!; y < _posY1!; y++){
          _imagemLayout!.setPixelRgb(x, y, _color, _color, _color);
        }
      }

      if(_documentIsFull){
        _documentIsFull = false;
      }
      else{
        _positionsIndexList--;
      }

    }
  }
  

  Future<bool> saveImage(String nomeArquivo) async{
    //configurando arquivo a ser gerado
    if(_imagemLayout == null){
      return false;
    }
    //salvar na galeria em formato jpg
    //final png = img.encodePng(_imagemLayout!); 
    // TODO
    //final result = await ImageGallerySaver.saveImage(png, name: nomeArquivo, quality: 100);
    print("Era para salvar");
    //return result['isSuccess'];
    return true; // TODO remover dps
  }

}
