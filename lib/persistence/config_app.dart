import 'package:shared_preferences/shared_preferences.dart';

class ConfigApp{

  static Future<String> loadTheme() async{
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ret = prefs.getString('tema');
    
    if(ret == null){
      await prefs.setString('tema', 'claro');
    
      return 'no';
    }
    
    else{
      return ret;
    }
  
  }

  static void setTheme(String tema)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tema', tema);
  }

}