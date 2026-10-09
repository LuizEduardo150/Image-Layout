import 'dart:typed_data';  //para usar o unit8list para visualização
import "package:image/image.dart" as img;

import "package:image_layout/persistence/layout_persistence.dart";
import "package:image_layout/utils/enum_app_values.dart";
import "package:image_layout/utils/utils.dart";


class LayoutMaker{
  /// atributos de configuracao do documento
  int? _larguraDocumento;
  int? _alturaDocumento;
  int _borda = 0;
  int _paddingX = 0;
  int _paddingY = 0;
  UnidadeDeMedida _unidade = UnidadeDeMedida.pixels;

  /// atributos para dados finais
  img.Image? _layoutDoc; // visualizacao do layout criado
  List _espacosDeImagens = [];  // Lista que deve ser usada para definir posicao das imagens [x0, y0, x1, y1]

  /// atributos de controle do módulo
  Qualidade _qualidadeDocumento = Qualidade.media;
  List<int> cabecote = [0,0]; //onde se encontra a posição para comecar a preencher a matriz'imagem'
  List acoesPilha = [];
  int _restanteX = 0;
  int _restanteY = 0;
  int _alturaLinhaAtual = 0;
  int _proxValDeY = 0;
  int _proxValDeX = 0;
  int _retornarNaAlturaDaLinhaAtual = 0;
  int _alturaRecomendadaLinhaAtual = 0;
  int _corEspacos = 20;
  bool inverterVariacaoCor = false;

  ///constructor
  LayoutMaker(UnidadeDeMedida unidadeDeMedida, int altura, int largura, int borda, Qualidade qualidadeDoc) {
    _qualidadeDocumento = qualidadeDoc;
    _unidade = unidadeDeMedida;
    _borda = borda;
    _alturaDocumento = altura;
    _larguraDocumento = largura;
    _layoutDoc = img.Image(width: largura, height: altura); //criando a imagem(matriz)
    setCorDeFundo('white');

    cabecote[0] = _borda;
    cabecote[1] = _borda;
    _restanteX = _larguraDocumento! - 2*_borda;
    _restanteY = _alturaDocumento! - 2*_borda;
  }

  void setQualidadeDocumento(Qualidade qualidade){
    _qualidadeDocumento = qualidade;
  }

  void setUnidadeDeMedida(UnidadeDeMedida valor){
    _unidade = valor;
  }

  void setCorDeFundo([String cor = 'white']){
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

  void setAltura(int valor){
    if(valor < 0) {
      valor = valor * -1;
    }
    _alturaDocumento = valor;
  }

  void setLargura(int valor){
    if(valor < 0) {
      valor = valor * -1;
    }
    _larguraDocumento = valor;
  }

  String setEspacamentoVertical(int valor){
    if(valor < (_alturaDocumento! -_borda*2)){
      if(valor > _restanteY && _alturaLinhaAtual != 0){//mudar valor de espacamento antes da quebra de linha
        return "O espaçamento entre linhas não pode ser um valor maior que o tamanho restante do documento";
      }
      if(_espacosDeImagens.isNotEmpty && _alturaLinhaAtual == 0 && valor > _paddingY){//troca de espacamento entre linhas no momento da quebra de linha
        int diferenca = valor - _paddingY;
        if((_proxValDeY + diferenca) > (_alturaDocumento! - 2*_borda)){
          return "Impossível trocar por esse valor, ele ultrapassa os limites do documento";
        }
        _paddingY = valor;
        _proxValDeY += diferenca;
        _restanteY = _alturaDocumento! - _proxValDeY - _borda;
        cabecote[1] += diferenca;
      }
      else if(_espacosDeImagens.isNotEmpty && _alturaLinhaAtual == 0 && valor < _paddingY && _paddingY > 0){//reduziu o espacamento no momento da quebra de linha
        int diferenca = _paddingY - valor;
        _paddingY = valor;
        _proxValDeY -= diferenca;
        _restanteY = _alturaDocumento! - _proxValDeY - _borda;
        cabecote[1] -= diferenca;
      }
      else if((_espacosDeImagens.isEmpty) || (_espacosDeImagens.isNotEmpty && _alturaLinhaAtual > 0)){ //trocar espacamento no inicio da edicao ou antes da quebra de linha, mudar apenas padding
        _paddingY = valor;
      }

      return 'ok';
    }
    else {
      return "O espaçamento vertical entre fotos deve ser menor que o própio tamanho do documento";
    }
  }

  String setEspacamentoHorizontal(int valor){
    if(valor >= _larguraDocumento! - _borda*2) {
      return "O espaçamento horizontal entre fotos deve ser menor que o própio tamanho do documento";
    }

    if(_alturaLinhaAtual == 0){ //apenas setar o valor pois está no início de uma linha
      _paddingX = valor;
      return "ok";
    }
    //Valores trocados enquanto o cabecote permanece na mesma linha

    else if(valor < _paddingX){ //diminui o espacamento
      int diferenca = _paddingX - valor;
      _paddingX = valor;
      cabecote[0] -= diferenca;
      _restanteX += diferenca;
      return 'ok';
    }
    else if(valor > _paddingX){ //aumenta o espacamento
      int diferenca = valor - _paddingX;
      if(valor >= _restanteX){
        return "Impossível usar esse valor de espacamento, pois ultrapassaria os limites do documento";
      }
      _paddingX = valor;
      cabecote[0] += diferenca;//n sei se tem q manipular o cabeçote aq.... fazer teste
      _restanteX -= diferenca;
      return "ok";
    }
    else { //não fez alteracoes alguma
      return 'ok';
    }
  }

  //Método deve ser usado apenas no início, antes da edição começar
  String setBorda(int valor){
    if(!(valor > _larguraDocumento! || valor > _alturaDocumento!)){
      _borda = valor;
      cabecote[0] = valor;
      cabecote[1] = valor;
      _restanteX = _larguraDocumento! - _borda*2;
      _restanteY = _alturaDocumento! - _borda*2;
      return "ok";
    }
    return "O tamanho da borda deve ser menor que o tamanho do própio documento.";
  }

  Qualidade getQualidadeDocumento(){
    return _qualidadeDocumento;
  }

  UnidadeDeMedida getUnidadeDeMedidaDocumento(){
    return _unidade;
  }

  int getRestanteX(){
    return _restanteX;
  }

  int getRestanteY(){
    return _restanteY;
  }

  int getLargura(){
    if(_larguraDocumento != null) {return _larguraDocumento!;}
    else {return 0;}
  }

  int getQTDespacosParaFotos(){
    return _espacosDeImagens.length;
  }

  int getEspacamentoHorizontal(){
    return _paddingX;
  }

  int getEspacamentoVertical(){
    return _paddingY;
  }

  int getAltura(){
    if(_alturaDocumento != null) {
      return _alturaDocumento!;
    } else {
      return 0;
    }
  }

  int getAlturaLinhaAtual(){
    return _alturaLinhaAtual;
  }

  int getAlturaRecomendadaLinhaAtual(){
    return _alturaRecomendadaLinhaAtual;
  }

  List getPosicoesParaImagens(){
    return _espacosDeImagens;
  }

  //Método para exibir o layout montado em tela
  Uint8List getImagemView(){
      return img.encodeJpg(_layoutDoc!);
  }

  void clearAll(){
    setCorDeFundo("black");
    cabecote[0] = _borda;
    cabecote[1] = _borda;
    _restanteX = _larguraDocumento! - 2*_borda;
    _restanteY = _alturaDocumento! - 2*_borda;
    _espacosDeImagens = [];
    _alturaLinhaAtual = 0;
    acoesPilha = [];
    _alturaRecomendadaLinhaAtual = 0;
    _retornarNaAlturaDaLinhaAtual = 0;
    _corEspacos = 50;
    inverterVariacaoCor = false;
    _proxValDeX = _borda;
  }

  void desfazerUmaAcao(){
    if(_espacosDeImagens.isNotEmpty){
      List posDeletar = _espacosDeImagens.removeLast();
      acoesPilha.removeLast();

      int x,y;
      for(x = posDeletar[0]; x < posDeletar[2]; x++){ //remover marcacao do layout
        for(y = posDeletar[1]; y < posDeletar[3]; y++){
          _layoutDoc!.setPixelRgb(x, y, 255, 255, 255);
        }
      }
      cabecote[0] = posDeletar[0];
      cabecote[1] = posDeletar[1];

      if(acoesPilha.isNotEmpty){
        _alturaLinhaAtual = acoesPilha.last[0];
        _proxValDeY = acoesPilha.last[1];
        _restanteX = acoesPilha.last[2];
        _restanteY = acoesPilha.last[3];
        _alturaRecomendadaLinhaAtual = acoesPilha.last[4];
      }else{
        _alturaLinhaAtual = 0;
        _proxValDeY = 0;
        _restanteX = _larguraDocumento! - _borda*2;
        _restanteY = _alturaDocumento! - _borda*2;
        _alturaRecomendadaLinhaAtual = 0;
      }
    }
  }

  Future<String> criarEspacoDeImagem(int altura, int largura)async{ //casos de erro são entregues na hora

    // __ Tratamento de entradas
    if(largura > _larguraDocumento! - _borda*2 || altura > _alturaDocumento! - _borda*2) {
      return "As dimenções informadas são maiores que a própria área editável do documento";
    }
    else if(altura > _restanteY) {
      return "não há espaco suficiente de altura para a medida informada";
    }
    else if(largura > _restanteX) {
      return "não há espaco suficiente de largura para essa medida";
    }
    else if(altura <= 0 || largura <= 0){return 'ok';} //não executa nada, mas tambem nao gera erro

    /// _______execucao do metodo...
    if(_alturaLinhaAtual == 0){ //troca de linha ou inicio, setar valores de controle
      _alturaLinhaAtual = altura;
      _proxValDeY = altura+cabecote[1];
      _retornarNaAlturaDaLinhaAtual = cabecote[1];
      _alturaRecomendadaLinhaAtual = altura;

      //backup: if(altura > _alturaLinhaAtual)
    }else if(altura > _alturaRecomendadaLinhaAtual){ // Mesma linha, porem valores maiores podem ser inseridos exigindo mudanca
      altura - _alturaLinhaAtual > 0 ? _alturaLinhaAtual += (altura - _alturaLinhaAtual) : _alturaLinhaAtual += (altura-_alturaRecomendadaLinhaAtual);

      _proxValDeY = altura+cabecote[1];
    }


    ///ADICIONANDO espaco de imagem
    int x = 0;
    int y = 0;
    for(x=cabecote[0]; x<largura+cabecote[0]; x++){
      for(y=cabecote[1]; y<altura+cabecote[1]; y++){
        _layoutDoc?.setPixelRgb(x, y, _corEspacos, _corEspacos, _corEspacos); //pintando a area de imagem
      }
    }

    ///salvando posicao XY inicial e final do espaco atual, destinado a uma imagem
    _espacosDeImagens.add([cabecote[0], cabecote[1], x, y]);


    /// Movimentacao dos cabecotes:
    //Nao chegou nos limites de largura
    if (_alturaRecomendadaLinhaAtual != 0){
      if(_alturaRecomendadaLinhaAtual != 0 && altura <= _alturaRecomendadaLinhaAtual){//não ocupou a altura da linha toda. Cabe mais espacos.
        _alturaRecomendadaLinhaAtual = _alturaRecomendadaLinhaAtual - altura;
        if(_alturaRecomendadaLinhaAtual != 0){ //Continua sobrando espaco embaixo de um espaco adicionado
          _alturaRecomendadaLinhaAtual -= _paddingY;
        }
        cabecote[1] = y + _paddingY;
        if(_proxValDeX < x){ //cabecote deve ser colocado onde nao conflite com os outros espacos
          _proxValDeX = x;
        }
      }else if(_alturaRecomendadaLinhaAtual != 0 && altura > _alturaRecomendadaLinhaAtual){ //usuario quer inserir algo maior, deve-se pular pro lado o cabecote
        if(_restanteX > 0){//ainda há espaco na mesma linha
          if(_proxValDeX < x){ //cabecote deve ser colocado onde nao conflite com os outros espacos
            _proxValDeX = x;
          }

          _alturaRecomendadaLinhaAtual = 0; //irá passar na proxima condicao para movimentar o cabecote
        }
      }

      if(_alturaRecomendadaLinhaAtual == 0 && x != _larguraDocumento! - _borda){ //primeira insercao na linha ou acabou espacos em baixo, deve pular pra direita
        cabecote[0] = _proxValDeX + _paddingX;
        cabecote[1] = _retornarNaAlturaDaLinhaAtual;
        _restanteX = _larguraDocumento! -_borda - cabecote[0];
        _alturaRecomendadaLinhaAtual = _alturaLinhaAtual;
        _proxValDeX = 0;
      }

      if(inverterVariacaoCor){ //Mudar a cor dos espacos para vezualisar os limites de cada espaco
        _corEspacos - 20 <= 20 ? _corEspacos = 230 : _corEspacos -= 20;
      }else{
        _corEspacos + 20 >= 230 ? _corEspacos = 20 : _corEspacos += 20;
      }

    }
    //chegou nos limites de largura e não há mais espaços sobrando na mesma linha. Deve pular de linha
    if(_alturaRecomendadaLinhaAtual == 0 || (_restanteY > 0 && _restanteX == 0)){
      _proxValDeX = 0;
      _proxValDeY += _paddingY;
      cabecote[0] = _borda;
      cabecote[1] = _proxValDeY;
      _restanteX = _larguraDocumento! - _borda*2;
      _alturaLinhaAtual = 0;
      _restanteY = _alturaDocumento! - _proxValDeY - _borda;

      _corEspacos = 230;
      if(!inverterVariacaoCor){
        inverterVariacaoCor = true;
      }else{
        inverterVariacaoCor = false;
        _corEspacos = 20;
      }
    }

    ///armazenando acao do usuario (para funcao desfazer)
    _alturaLinhaAtual == _alturaRecomendadaLinhaAtual ?
    acoesPilha.add([_alturaLinhaAtual, _proxValDeY, _restanteX, _restanteY, _alturaLinhaAtual])
        :
    acoesPilha.add([_alturaLinhaAtual, _proxValDeY, _restanteX, _restanteY, _alturaRecomendadaLinhaAtual]);

    return 'ok';
  }

  void pularLinha(){
    _proxValDeY += _paddingY;
    cabecote[0] = _borda;
    cabecote[1] = _proxValDeY;
    _restanteX = _larguraDocumento! - _borda*2;
    _alturaLinhaAtual = 0;
    _restanteY = _alturaDocumento! - _proxValDeY - _borda;
  }

  Future<bool> salvarConfiguracaoLayoutSHPREF(String chave)async {
    LayoutPersistence persistence = LayoutPersistence();
    persistence.nome = chave;
    List chaves = await persistence.getTodasAsChaves();

    if(chaves.contains(chave)){
      return false;
    }else{
      num alturaThumb = _alturaDocumento!;
      num larguraThumb = _larguraDocumento!;

      while(alturaThumb > 100 || larguraThumb > 100){
        alturaThumb = alturaThumb / 2;
        larguraThumb = larguraThumb/ 2;
      }
      ///criando thumbnail
      img.Image thumbnail = img.copyResize(_layoutDoc!, height: stringParseInt(alturaThumb.toString()), width: stringParseInt(larguraThumb.toString()));
      String thumString = img.encodeJpg(thumbnail).toList().toString();
      thumString = thumString.substring(1, thumString.length - 1); //removendo [] da stirng

      persistence.saveCoordenadasImg(getPosicoesParaImagens());
      persistence.saveTamanhoDocumento(_larguraDocumento!, _alturaDocumento!);
      persistence.saveThumbnailLayout(stringNumerosUint8List: thumString);
      return true;
    }

  }

}