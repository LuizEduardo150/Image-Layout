bool stringIsNumeric(String? value){

  if(value == null) {return false;}
  if(value == '') {return true;}
  
  int amtDot = 0;
  
  for(int i=0; i<value.length; i++){
    
    if (['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(value[i])) {
      // OK
    }
    
    else if(value[i] == '.'){
      amtDot++;  
    }
    
    else {
        return false;
    }
    
  }

  if(amtDot >= 2) {
    return false;
  }

  return true;
}


bool stringIsInt(String? value){
  if(value == null) {
    return false;
  }
  if(value == ''){return true;}

  if(stringIsNumeric(value)){
    for(int i=0; i<value.length; i++){
      if(value[i] == '.'){
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
  }
  
  else if(stringIsNumeric(conteudo) && !(stringIsInt(conteudo))){
    List partes = conteudo.split('.');
    int comp = int.parse(partes[1][0]);
    int add = 0;
    
    if(comp >= 5){
      add = 0;
    }
    
    int returnVar = int.parse(partes[0]);
    return returnVar + add;
  
  }
  
  else {
    return null;
  }
}


List<List<int>>? parseSharedPrefsToIntList(List<dynamic> l){

  List<List<int>>? returnList = [];

  for(int i =0; i<l.length;i++){
    
    List<int> aux = [];
    
    for(int j =0; j<l[i].length;j++){
      aux.add(l[i][j]);
    }

    returnList.add(aux);
  }

  return returnList;
}


num pxToCm(int ppi, num valPX){
  return (2.54 * valPX) / ppi;
}


int? cmToPx(int ppi, String valCM){
  
  valCM = valCM.replaceAll(',', '.');
  if(valCM == ''){
    valCM = '0';
  }
  
  if(stringIsNumeric(valCM)){ //valor com ou sem ponto flutuante valido
    num cm = num.parse(valCM);
    num valPx = (ppi * cm) / 2.54;
    int? result = stringParseInt(valPx.toString());
    
    return result;

  }
  else{
    
    return null; //nao representa um valor numerico real
  }
}