bool stringIsNumeric(String? valor){
  if(valor == null) {return false;}
  if(valor == '') {return true;}
  int qtdPt = 0;
  for(int i=0; i<valor.length; i++){
    if(valor[i] == '0' || valor[i] == '1' || valor[i] == '2'){}
    else if(valor[i] == '3' || valor[i] == '4' || valor[i] == '5'){}
    else if(valor[i] == '6' || valor[i] == '7' || valor[i] == '8' || valor[i] == '9'){}
    else{
      if(valor[i] == '.'){
        qtdPt++;
      }else {
        return false;
      }
    }
  }
  if(qtdPt >= 2) {
    return false;
  }

  return true;
}

bool stringIsInt(String? valor){
  if(valor == null) {
    return false;
  }
  if(valor == ''){return true;}

  if(stringIsNumeric(valor)){
    for(int i=0; i<valor.length; i++){
      if(valor[i] == '.'){
        return false;
      }
    }
  }else{
    return false;
  }
  return true;
}

///>> Parseia string para int, independetemente se o número
///   possui casa decimal. Se tiver, ele desconsidera
///   a primeira parte decimal for maior que 4.
///>> Se a string for vazia, vira 0.
int? stringParseInt(String conteudo){
  if(conteudo == ''){return 0;}
  conteudo = conteudo.replaceAll(',', '.');
  if(stringIsNumeric(conteudo) && stringIsInt(conteudo)) {
    return int.parse(conteudo);
  } else if(stringIsNumeric(conteudo) && !(stringIsInt(conteudo))){
    List partes = conteudo.split('.');
    int comp = int.parse(partes[1][0]);
    int add = 0;
    if(comp >= 5){
      add = 0;
    }
    int retorno = int.parse(partes[0]);
    return retorno + add;
  }else {
    return null;
  }
}

List<List<int>>? parseSharedPrefsToIntList(List<dynamic> l){

  List<List<int>>? listaRetorno = [];

  for(int i =0; i<l.length;i++){
    List<int> aux = [];
    for(int j =0; j<l[i].length;j++){
      aux.add(l[i][j]);
    }
    listaRetorno.add(aux);
  }
  return listaRetorno;
}

num pxToCm(int ppi, num valPX){
  return (2.54 * valPX) / ppi;
}

///testar
int? cmToPx(int ppi, String valCM){
  valCM = valCM.replaceAll(',', '.');
  if(valCM == ''){valCM = '0';}
  if(stringIsNumeric(valCM)){ //valor com ou sem ponto flutuante valido
    num cm = num.parse(valCM);
    num valPx = (ppi * cm) / 2.54;
    int? result = stringParseInt(valPx.toString());
    return result;
  }
  else{ //nao representa um valor numerico real
    return null;
  }
}