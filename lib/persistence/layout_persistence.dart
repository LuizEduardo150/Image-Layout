import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class LayoutPersistence{
  String? nome;
  List chaves = [];

  carregarChaves()async{
    chaves = await getTodasAsChaves();
    chaves.removeWhere((element) =>
      (element.length > 7 && (element.split('-')[0] == 'tamanho' )) ||
      (element == 'tema') ||
      (element.length > 7 && (element.split('-')[0] == 'THUMB' ))
    );
  }

  removerTudo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<List> getCoordenadasImg() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(nome == null){
      return [];
    }

    try{
      List posicoes;
      posicoes = jsonDecode(prefs.getString(nome!)!);
      return posicoes;
    }catch(e){
      return [];
    }
  }

  saveCoordenadasImg(List posicoes) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(nome != null || nome != ''){
      await prefs.setString(nome!, jsonEncode(posicoes));
    }
  }

  saveTamanhoDocumento(int altura, int largura) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? chave;
    if(nome != null){
      chave = 'tamanho-${nome!}';
      await prefs.setString(chave, jsonEncode([altura,largura]));
    }
  }

  saveThumbnailLayout({required String stringNumerosUint8List}) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('THUMB-${nome!}', stringNumerosUint8List);
  }

  Future<Uint8List> getThumbnailLayout()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? conteudoArmazenado = prefs.getString('THUMB-$nome');
    if(conteudoArmazenado == null){
      return Uint8List(0);
    }else{
      return Uint8List.fromList(conteudoArmazenado.split(',').map((e) => int.parse(e)).toList());
    }
  }

  Future<List> getTamanhoDocumento() async{
    if(nome == null){
      return [];
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try{ //pode gerar erros se inserido nome invalido
      return await jsonDecode(prefs.getString("tamanho-$nome")!);
    }
    catch(e){ //caso não encontre a chave
      return [];
    }
  }

  Future<List<String>> getTodasAsChaves() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().toList();
  }

  deletarPorChave(String chave) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(chave);
    await prefs.remove('tamanho-$chave');
    await prefs.remove('THUMB-$chave');
  }

  int getQtdDeLayoutsSalvos(){
    return chaves.length;
  }

  Future<bool> mudarNomeChave ({required String chave, required String novoNomeChave}) async{
    List chaves = await getTodasAsChaves();
    if(chaves.contains(novoNomeChave)){
      return false;
    }
    nome = chave;
    List posicoes = await getCoordenadasImg();
    List tamanho = await getTamanhoDocumento();
    Uint8List tumbnail = await getThumbnailLayout();
    String tumbnailString = tumbnail.toString();
    tumbnailString = tumbnailString.substring(1, tumbnailString.length-1);

    deletarPorChave(nome!);
    nome = novoNomeChave;
    await saveCoordenadasImg(posicoes);
    await saveTamanhoDocumento(tamanho[0], tamanho[1]);
    await saveThumbnailLayout(stringNumerosUint8List: tumbnailString);
    return true;
  }

}