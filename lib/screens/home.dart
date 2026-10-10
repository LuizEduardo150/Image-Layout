import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:image_layout/application_theme_pers.dart';
import 'package:image_layout/persistence/config_app.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  bool loaded = false;
  
  void startF(AppThemePers theme) async{
    if(!loaded){
      String themeName = await ConfigApp.loadTheme();
      if(themeName == 'claro'){
        theme.setLightTheme();
      }else if(themeName == 'escuro'){
        theme.setDarkTheme();
      }
      else if(themeName == 'escuropadrao'){
        theme.setDarkThemeDefault();
      }
      else if(themeName == 'claropadrao'){
        theme.setLightThemeDefault();
      }
      loaded = true;
    }
  }


  @override
  Widget build(context) {
    final theme = Provider.of<AppThemePers>(context);
    final Size telaTamanho = MediaQuery.of(context).size;
    startF(theme);

    final List<Widget> carouselItems = [
      Image.asset("assets/images/ly1.png"),
      Image.asset("assets/images/op1.png"),
      Image.asset("assets/images/ly2.png"),
      Image.asset("assets/images/op2.png"),
      Image.asset("assets/images/ly3.png"),
      Image.asset("assets/images/op3.png"),
      Image.asset("assets/images/ly4.png"),
      Image.asset("assets/images/op4.png"),
    ];

    return Scaffold(
      backgroundColor: theme.bkgColor,
      appBar: AppBar(
        title: const Text("Image Layout"),
        foregroundColor: Colors.white,
        backgroundColor: theme.buttonColor,
      ),
      drawer: Drawer(
        backgroundColor: theme.buttonColor,
        child: ListView(children: [
          Padding(padding: EdgeInsets.all(telaTamanho.height*0.02)),
          Image.asset('assets/images/logo.png'),
          Padding(padding: EdgeInsets.all(telaTamanho.height*0.01)),
          Container(color: theme.iconsColor, padding: const EdgeInsets.only(top: 1),),
          ListTile(
            tileColor: Colors.white10,
            onTap: ()async {
              await Navigator.pushNamed(context, "/configuracaoTheme");
              ConfigApp.setTheme(theme.currentTheme);
            },
            title: Column(children: [
                  Icon(Icons.format_paint, color: theme.iconsColor, size: 50,),
                  Text("Mudar o theme da aplicação", style: TextStyle(color: theme.fontColor, fontSize: 20, fontWeight: FontWeight.bold),)
            ],),
          ),

          Container(color: theme.iconsColor, padding: const EdgeInsets.only(top: 1),),
        
          Padding(padding: EdgeInsets.all(telaTamanho.height*0.01)),
          
          Container(color: theme.iconsColor, padding: const EdgeInsets.only(top: 1),),

          ListTile(
              tileColor: Colors.white10,
              onTap: (){
                SystemNavigator.pop();
                }, // fecha o aplicativo, funciona apenas no Android,
              title: Column(children: [
                Icon(Icons.exit_to_app, color: theme.iconsColor, size: 50,),
                Text("Sair do aplicativo", style: TextStyle(color: theme.fontColor, fontSize: 20, fontWeight: FontWeight.bold))
              ])
          ),

          Container(color: theme.iconsColor, padding: const EdgeInsets.only(top: 1))
        ])
      ),

      body: ListView(children: [
          Image.asset("assets/images/logo.png", alignment: Alignment.center,),
          Padding(padding: EdgeInsets.only(left: telaTamanho.width*0.02, right: telaTamanho.width*0.02),
            child: Column(children: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, "/criarNovoLayout");
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: theme.iconsColor,
                      backgroundColor: theme.buttonColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: telaTamanho.width*0.22, color: theme.iconsColor, ),
                        Icon(Icons.space_dashboard_sharp, size: telaTamanho.width*0.22, color: theme.iconsColor,),
                      ],
                    ),
                    const Text('Criar novo layout',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ],)
              ),

              Padding(padding: EdgeInsets.all(telaTamanho.height*0.015)),

              ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, "/editarComlayoutsExistentes");
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: theme.iconsColor,
                      backgroundColor: theme.buttonColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo, size: telaTamanho.width*0.22, color: theme.iconsColor,),
                        Icon(Icons.space_dashboard_outlined, size: telaTamanho.width*0.22, color: theme.iconsColor,)
                      ],
                    ),
                    const Text('Editar com layouts existentes',textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ],)
              ),

              Padding(padding: EdgeInsets.all(telaTamanho.height*0.015)),

              ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, "/gerenciarLayouts");
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: theme.iconsColor,
                      backgroundColor: theme.buttonColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save_as_rounded, size: telaTamanho.width*0.22, color: theme.iconsColor,),
                        Icon(Icons.space_dashboard_outlined, size: telaTamanho.width*0.22, color: theme.iconsColor,)
                      ],),
                    const Text('Gerenciar layouts salvos',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ],)
              ),

              Padding(padding: EdgeInsets.only(top: telaTamanho.height*0.03),
                child: Text("Construa diversas configurações de layout para criar suas fotos",
                    style: TextStyle(
                      color: theme.fontColor,
                      fontSize: telaTamanho.width*0.06,
                      fontWeight: FontWeight.bold,
                    )
                ),
              ),
            ],),
          ),

          CarouselSlider( //Mostrando as imagens
            items: carouselItems,
            options: CarouselOptions(
              viewportFraction: 1, // Apenas um item visível por vez
              autoPlay: true,
              enableInfiniteScroll: true,
              autoPlayInterval: const Duration(seconds: 5), // Intervalo entre as imagens
              autoPlayCurve: Curves.easeInOutBack,
            )
          ),

          const Padding(padding: EdgeInsets.all(30))
      ])
    );
  } //final build method
}
