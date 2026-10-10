import 'dart:typed_data';  //para usar o unit8list para visualização
import "package:image/image.dart" as img;

import "package:image_layout/persistence/layout_persistence.dart";
import "package:image_layout/utils/enum_app_values.dart";
import "package:image_layout/utils/utils.dart";


class LayoutMaker{
  /// atributos de configuracao do documento
  int? _documentWidth;
  int? _documentHeight;
  int _border = 0;
  int _paddingX = 0;
  int _paddingY = 0;
  UnitOfMeasurement _unit = UnitOfMeasurement.pixels;
   
  /// atributos para dados finais
  img.Image? _layoutDoc; // visualizacao do layout criado
  List _imagesSpacesList = [];  // Lista que deve ser usada para definir posicao das imagens [x0, y0, x1, y1]

  /// atributos de controle do módulo
  Quality _documentQuality = Quality.medium;
  List<int> printhead = [0,0]; //onde se encontra a posição para comecar a preencher a matriz'imagem'
  List stackActions = [];
  int _remainingX = 0;
  int _remainingY = 0;
  int _currentLineHeight = 0;
  int _nextValueY = 0;
  int _nextValueX = 0;
  int _returnToCurrentLineHeight = 0;
  int _currLineRecommendedHeight = 0;
  int _spaceColor = 20;
  bool _invertVariantColor = false;


  ///constructor
  LayoutMaker(UnitOfMeasurement unitOfMeasurement, int altura, int largura, int borda, Quality qualidadeDoc) {
    _documentQuality = qualidadeDoc;
    _unit = unitOfMeasurement;
    _border = borda;
    _documentHeight = altura;
    _documentWidth = largura;
    _layoutDoc = img.Image(width: largura, height: altura); //criando a imagem(matriz)
    setBkgColor('white');

    printhead[0] = _border;
    printhead[1] = _border;
    _remainingX = _documentWidth! - 2*_border;
    _remainingY = _documentHeight! - 2*_border;
  }


  void setDocumentQuality(Quality qualidade){
    _documentQuality = qualidade;
  }


  void setUnitOfMeasurement(UnitOfMeasurement valor){
    _unit = valor;
  }


  void setBkgColor([String cor = 'white']){
    if(cor == 'white'){
      for (var pixel in _layoutDoc!) {
        pixel.r = 250;
        pixel.g = 250;
        pixel.b = 250;
      }
    }
    else if (cor == 'black'){
      for (var pixel in _layoutDoc!) {
        pixel.r = 0;
        pixel.g = 0;
        pixel.b = 0;
      }
    }else if (cor == 'blue'){
      for (var pixel in _layoutDoc!) {
        pixel.r = 0;
        pixel.g = 0;
        pixel.b = 255;
      }
    }
  }


  void setHeight(int valor){
    if(valor < 0) {
      valor = valor * -1;
    }
    _documentHeight = valor;
  }


  void setWidth(int valor){
    if(valor < 0) {
      valor = valor * -1;
    }
    _documentWidth = valor;
  }


  String setVerticalSpace(int value){
    if(value < (_documentHeight! -_border*2)){
      if(value > _remainingY && _currentLineHeight != 0){//mudar valor de espacamento antes da quebra de linha
        return "O espaçamento entre linhas não pode ser um valor maior que o tamanho restante do documento";
      }
      if(_imagesSpacesList.isNotEmpty && _currentLineHeight == 0 && value > _paddingY){//troca de espacamento entre linhas no momento da quebra de linha
        int diferenca = value - _paddingY;
        if((_nextValueY + diferenca) > (_documentHeight! - 2*_border)){
          return "Impossível trocar por esse valor, ele ultrapassa os limites do documento";
        }
        _paddingY = value;
        _nextValueY += diferenca;
        _remainingY = _documentHeight! - _nextValueY - _border;
        printhead[1] += diferenca;
      }
      else if(_imagesSpacesList.isNotEmpty && _currentLineHeight == 0 && value < _paddingY && _paddingY > 0){//reduziu o espacamento no momento da quebra de linha
        int diferenca = _paddingY - value;
        _paddingY = value;
        _nextValueY -= diferenca;
        _remainingY = _documentHeight! - _nextValueY - _border;
        printhead[1] -= diferenca;
      }
      else if((_imagesSpacesList.isEmpty) || (_imagesSpacesList.isNotEmpty && _currentLineHeight > 0)){ //trocar espacamento no inicio da edicao ou antes da quebra de linha, mudar apenas padding
        _paddingY = value;
      }

      return 'ok';
    }
    else {
      return "O espaçamento vertical entre fotos deve ser menor que o própio tamanho do documento";
    }
  }


  String setHorizontalSpace(int value){
    if(value >= _documentWidth! - _border*2) {
      return "O espaçamento horizontal entre fotos deve ser menor que o própio tamanho do documento";
    }

    if(_currentLineHeight == 0){ //apenas setar o valor pois está no início de uma linha
      _paddingX = value;
      return "ok";
    }
    //Valores trocados enquanto o printhead permanece na mesma linha

    else if(value < _paddingX){ //diminui o espacamento
      int diferenca = _paddingX - value;
      _paddingX = value;
      printhead[0] -= diferenca;
      _remainingX += diferenca;
      return 'ok';
    }
    else if(value > _paddingX){ //aumenta o espacamento
      int diferenca = value - _paddingX;
      if(value >= _remainingX){
        return "Impossível usar esse valor de espacamento, pois ultrapassaria os limites do documento";
      }
      _paddingX = value;
      printhead[0] += diferenca;//n sei se tem q manipular o cabeçote aq.... fazer teste
      _remainingX -= diferenca;
      return "ok";
    }
    else { //não fez alteracoes alguma
      return 'ok';
    }
  }


  //Método deve ser usado apenas no início, antes da edição começar
  String setBorder(int value){
    if(!(value > _documentWidth! || value > _documentHeight!)){
      _border = value;
      printhead[0] = value;
      printhead[1] = value;
      _remainingX = _documentWidth! - _border*2;
      _remainingY = _documentHeight! - _border*2;
      return "ok";
    }
    return "O tamanho da borda deve ser menor que o tamanho do própio documento.";
  }


  Quality getDocumentQuality(){
    return _documentQuality;
  }


  UnitOfMeasurement getunitOfMeasurementDocument(){
    return _unit;
  }


  int getRemainingX(){
    return _remainingX;
  }


  int getRemainingY(){
    return _remainingY;
  }


  int getWidth(){
    if(_documentWidth != null) {return _documentWidth!;}
    else {return 0;}
  }


  int getQTDespacosParaFotos(){
    return _imagesSpacesList.length;
  }


  int getEspacamentoHorizontal(){
    return _paddingX;
  }


  int getEspacamentoVertical(){
    return _paddingY;
  }


  int getHeight(){
    if(_documentHeight != null) {
      return _documentHeight!;
    }
    else {
      return 0;
    }
  }

  int getCurrentLineHeight(){
    return _currentLineHeight;
  }

  int getCurrLineRecommendedHeight(){
    return _currLineRecommendedHeight;
  }

  List getPositionsToImages(){
    return _imagesSpacesList;
  }

  //Método para exibir o layout montado em tela
  Uint8List getImageView(){
      return img.encodeJpg(_layoutDoc!);
  }

  void clearAll(){
    setBkgColor("black");
    printhead[0] = _border;
    printhead[1] = _border;
    _remainingX = _documentWidth! - 2*_border;
    _remainingY = _documentHeight! - 2*_border;
    _imagesSpacesList = [];
    _currentLineHeight = 0;
    stackActions = [];
    _currLineRecommendedHeight = 0;
    _returnToCurrentLineHeight = 0;
    _spaceColor = 50;
    _invertVariantColor = false;
    _nextValueX = _border;
  }

  void undoAction(){
    if(_imagesSpacesList.isNotEmpty){
      List posDeletar = _imagesSpacesList.removeLast();
      stackActions.removeLast();

      int x,y;
      for(x = posDeletar[0]; x < posDeletar[2]; x++){ //remover marcacao do layout
        for(y = posDeletar[1]; y < posDeletar[3]; y++){
          _layoutDoc!.setPixelRgb(x, y, 255, 255, 255);
        }
      }
      printhead[0] = posDeletar[0];
      printhead[1] = posDeletar[1];

      if(stackActions.isNotEmpty){
        _currentLineHeight = stackActions.last[0];
        _nextValueY = stackActions.last[1];
        _remainingX = stackActions.last[2];
        _remainingY = stackActions.last[3];
        _currLineRecommendedHeight = stackActions.last[4];
      }else{
        _currentLineHeight = 0;
        _nextValueY = 0;
        _remainingX = _documentWidth! - _border*2;
        _remainingY = _documentHeight! - _border*2;
        _currLineRecommendedHeight = 0;
      }
    }
  }

  Future<String> createSpaceToImage(int altura, int largura)async{ //casos de erro são entregues na hora

    // __ Tratamento de entradas
    if(largura > _documentWidth! - _border*2 || altura > _documentHeight! - _border*2) {
      return "As dimenções informadas são maiores que a própria área editável do documento";
    }
    else if(altura > _remainingY) {
      return "não há espaco suficiente de altura para a medida informada";
    }
    else if(largura > _remainingX) {
      return "não há espaco suficiente de largura para essa medida";
    }
    else if(altura <= 0 || largura <= 0){return 'ok';} //não executa nada, mas tambem nao gera erro

    /// _______execucao do metodo...
    if(_currentLineHeight == 0){ //troca de linha ou inicio, setar valores de controle
      _currentLineHeight = altura;
      _nextValueY = altura+printhead[1];
      _returnToCurrentLineHeight = printhead[1];
      _currLineRecommendedHeight = altura;

      //backup: if(altura > _currentLineHeight)
    }else if(altura > _currLineRecommendedHeight){ // Mesma linha, porem valores maiores podem ser inseridos exigindo mudanca
      altura - _currentLineHeight > 0 ? _currentLineHeight += (altura - _currentLineHeight) : _currentLineHeight += (altura-_currLineRecommendedHeight);

      _nextValueY = altura+printhead[1];
    }

    ///ADICIONANDO espaco de imagem
    int x = 0;
    int y = 0;
    for(x=printhead[0]; x<largura+printhead[0]; x++){
      for(y=printhead[1]; y<altura+printhead[1]; y++){
        _layoutDoc?.setPixelRgb(x, y, _spaceColor, _spaceColor, _spaceColor); //pintando a area de imagem
      }
    }

    ///salvando posicao XY inicial e final do espaco atual, destinado a uma imagem
    _imagesSpacesList.add([printhead[0], printhead[1], x, y]);

    /// Movimentacao dos printheads:
    //Nao chegou nos limites de largura
    if (_currLineRecommendedHeight != 0){
      if(_currLineRecommendedHeight != 0 && altura <= _currLineRecommendedHeight){//não ocupou a altura da linha toda. Cabe mais espacos.
        _currLineRecommendedHeight = _currLineRecommendedHeight - altura;
        if(_currLineRecommendedHeight != 0){ //Continua sobrando espaco embaixo de um espaco adicionado
          _currLineRecommendedHeight -= _paddingY;
        }
        printhead[1] = y + _paddingY;
        if(_nextValueX < x){ //printhead deve ser colocado onde nao conflite com os outros espacos
          _nextValueX = x;
        }
      }else if(_currLineRecommendedHeight != 0 && altura > _currLineRecommendedHeight){ //usuario quer inserir algo maior, deve-se pular pro lado o printhead
        if(_remainingX > 0){//ainda há espaco na mesma linha
          if(_nextValueX < x){ //printhead deve ser colocado onde nao conflite com os outros espacos
            _nextValueX = x;
          }

          _currLineRecommendedHeight = 0; //irá passar na proxima condicao para movimentar o printhead
        }
      }

      if(_currLineRecommendedHeight == 0 && x != _documentWidth! - _border){ //primeira insercao na linha ou acabou espacos em baixo, deve pular pra direita
        printhead[0] = _nextValueX + _paddingX;
        printhead[1] = _returnToCurrentLineHeight;
        _remainingX = _documentWidth! -_border - printhead[0];
        _currLineRecommendedHeight = _currentLineHeight;
        _nextValueX = 0;
      }

      if(_invertVariantColor){ //Mudar a cor dos espacos para vezualisar os limites de cada espaco
        _spaceColor - 20 <= 20 ? _spaceColor = 230 : _spaceColor -= 20;
      }else{
        _spaceColor + 20 >= 230 ? _spaceColor = 20 : _spaceColor += 20;
      }

    }
    //chegou nos limites de largura e não há mais espaços sobrando na mesma linha. Deve pular de linha
    if(_currLineRecommendedHeight == 0 || (_remainingY > 0 && _remainingX == 0)){
      _nextValueX = 0;
      _nextValueY += _paddingY;
      printhead[0] = _border;
      printhead[1] = _nextValueY;
      _remainingX = _documentWidth! - _border*2;
      _currentLineHeight = 0;
      _remainingY = _documentHeight! - _nextValueY - _border;

      _spaceColor = 230;
      if(!_invertVariantColor){
        _invertVariantColor = true;
      }else{
        _invertVariantColor = false;
        _spaceColor = 20;
      }
    }

    ///armazenando acao do usuario (para funcao desfazer)
    _currentLineHeight == _currLineRecommendedHeight ?
    stackActions.add([_currentLineHeight, _nextValueY, _remainingX, _remainingY, _currentLineHeight])
        :
    stackActions.add([_currentLineHeight, _nextValueY, _remainingX, _remainingY, _currLineRecommendedHeight]);

    return 'ok';
  }

  void jumpLine(){
    _nextValueY += _paddingY;
    printhead[0] = _border;
    printhead[1] = _nextValueY;
    _remainingX = _documentWidth! - _border*2;
    _currentLineHeight = 0;
    _remainingY = _documentHeight! - _nextValueY - _border;
  }

  Future<bool> saveConfigurationLayoutSHPREF(String key) async {
    LayoutPersistence persistence = LayoutPersistence();
    persistence.name = key;
    List chaves = await persistence.getAllKeys();

    if(chaves.contains(key)){
      return false;
    }
    else{
      num alturaThumb = _documentHeight!;
      num larguraThumb = _documentWidth!;

      while(alturaThumb > 100 || larguraThumb > 100){
        alturaThumb = alturaThumb / 2;
        larguraThumb = larguraThumb/ 2;
      }
      ///criando thumbnail
      img.Image thumbnail = img.copyResize(_layoutDoc!, height: stringParseInt(alturaThumb.toString()), width: stringParseInt(larguraThumb.toString()));
      String thumString = img.encodeJpg(thumbnail).toList().toString();
      thumString = thumString.substring(1, thumString.length - 1); //removendo [] da stirng

      persistence.saveCoordinatesImg(getPositionsToImages());
      persistence.saveDocumentSize(_documentWidth!, _documentHeight!);
      persistence.saveThumbnailLayout(stringNumerosUint8List: thumString);
      return true;
    }

  }

}