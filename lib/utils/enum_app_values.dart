enum UnidadeDeMedida{
  pixels,
  centimetros,
}

extension UnidadeDeMedidaExtensions on UnidadeDeMedida {
  String toStringReduzido() {
    switch (this) {
      case UnidadeDeMedida.centimetros:
        return 'cm';
      case UnidadeDeMedida.pixels:
        return 'px';
    }
  }


  String toStringExpandido(){
    switch (this) {
      case UnidadeDeMedida.centimetros:
        return 'Centímetros';
      case UnidadeDeMedida.pixels:
        return 'Pixels';
    }
  }

}


enum Qualidade{
  alta,
  media,
  baixa,
  muitoBaixa,
}

extension QualidadeExtensions on Qualidade {
  int getValorPPI() {
    switch (this) {
      case Qualidade.alta:
        return 400;
      case Qualidade.media:
        return 300;
      case Qualidade.baixa:
        return 200;
      case Qualidade.muitoBaixa:
        return 100;
    }
  }

  int getValorCompressaoImagemGaleria(){
    switch (this) {
      case Qualidade.alta:
        return 100;
      case Qualidade.media:
        return 80;
      case Qualidade.baixa:
        return 60;
      case Qualidade.muitoBaixa:
        return 40;
    }
  }

}