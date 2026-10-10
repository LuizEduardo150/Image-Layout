import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';


class LayoutPersistence{
  String? name;
  List keys = [];

  Future<void> loadKeys()async{
    keys = await getAllKeys();
    keys.removeWhere((element) =>
      (element.length > 7 && (element.split('-')[0] == 'tamanho' )) ||
      (element == 'tema') ||
      (element.length > 7 && (element.split('-')[0] == 'THUMB' ))
    );
  }


  Future<void> removeAll() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }


  Future<List> getCoordinatesImg() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(name == null){
      return [];
    }

    try{
      List posicoes;
      posicoes = jsonDecode(prefs.getString(name!)!);
      return posicoes;
    }catch(e){
      return [];
    }
  }


  Future<void> saveCoordinatesImg(List posicoes) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(name != null || name != ''){
      await prefs.setString(name!, jsonEncode(posicoes));
    }
  }


  Future<void> saveDocumentSize(int altura, int largura) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? key;
    if(name != null){
      key = 'tamanho-${name!}';
      await prefs.setString(key, jsonEncode([altura,largura]));
    }
  }


  Future<void> saveThumbnailLayout({required String stringNumerosUint8List}) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('THUMB-${name!}', stringNumerosUint8List);
  }


  Future<Uint8List> getThumbnailLayout()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedContent = prefs.getString('THUMB-$name');
    if(storedContent == null){
      return Uint8List(0);
    }else{
      return Uint8List.fromList(storedContent.split(',').map((e) => int.parse(e)).toList());
    }
  }


  Future<List> getDocumentSize() async{
    if(name == null){
      return [];
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try{ //pode gerar erros se inserido name invalido
      return await jsonDecode(prefs.getString("tamanho-$name")!);
    }
    catch(e){ //caso não encontre a chave
      return [];
    }
  }


  Future<List<String>> getAllKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().toList();
  }


  Future<void> deleteByKey(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    await prefs.remove('tamanho-$key');
    await prefs.remove('THUMB-$key');
  }


  int getAmtSavedLayouts(){
    return keys.length;
  }


  Future<bool> changeKeyName ({required String chave, required String newKeyName}) async{
    List keys = await getAllKeys();
    if(keys.contains(newKeyName)){
      return false;
    }
    name = chave;
    List posicoes = await getCoordinatesImg();
    List tamanho = await getDocumentSize();
    Uint8List tumbnail = await getThumbnailLayout();
    String tumbnailString = tumbnail.toString();
    tumbnailString = tumbnailString.substring(1, tumbnailString.length-1);

    deleteByKey(name!);
    name = newKeyName;
    await saveCoordinatesImg(posicoes);
    await saveDocumentSize(tamanho[0], tamanho[1]);
    await saveThumbnailLayout(stringNumerosUint8List: tumbnailString);
    return true;
  }

}