import 'package:shared_preferences/shared_preferences.dart';

class ConfigApp{

  static Future<String> carergarTema() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? retorno = prefs.getString('tema');
    if(retorno == null){
      await prefs.setString('tema', 'claro');
      return 'no';
    }else{
      return retorno;
    }
  }

  static void setTema(String tema)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tema', tema);
  }

}