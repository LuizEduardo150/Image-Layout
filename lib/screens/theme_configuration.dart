import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/application_theme_pers.dart';


class ThemeConfiguration extends StatefulWidget {
  const ThemeConfiguration({super.key});

  @override
  State<ThemeConfiguration> createState() => _ThemeConfigurationState();
}

class _ThemeConfigurationState extends State<ThemeConfiguration> {

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppThemePers>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.bkgColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0.0,
        backgroundColor: theme.buttonColor,
        title: const Text('Defina o theme:'),
      ),
      body: ListView(children: [
        ListTile(
          title: Text('Claro (Img Layout)', style: TextStyle(color: theme.fontColor)),
          leading: theme.currentTheme == 'claro'? Icon(Icons.radio_button_checked, color: theme.lightButtonIconsColor) : Icon(Icons.radio_button_off, color: theme.lightButtonIconsColor),
          onTap: (){
            setState(() {
              theme.setLightTheme();
            });
          },
        ),
        ListTile(
          title: Text('Escuro (Img Layout)', style: TextStyle(color: theme.fontColor)),
          leading: theme.currentTheme == 'escuro'? Icon(Icons.radio_button_checked, color: theme.lightButtonIconsColor) : Icon(Icons.radio_button_off, color: theme.lightButtonIconsColor),
          onTap: (){
            setState(() {
              theme.setDarkTheme();
            });
          },
        ),
        ListTile(
          title: Text('Claro (padrão)', style: TextStyle(color: theme.fontColor)),
          leading: theme.currentTheme == 'claropadrao'? Icon(Icons.radio_button_checked, color: theme.lightButtonIconsColor) : Icon(Icons.radio_button_off, color: theme.lightButtonIconsColor),
          onTap: (){
            setState(() {
              theme.setLightThemeDefault();
            });
          },
        ),
        ListTile(
          title: Text('Escuro (padrão)', style: TextStyle(color: theme.fontColor)),
          leading: theme.currentTheme == 'escuropadrao'? Icon(Icons.radio_button_checked, color: theme.lightButtonIconsColor) : Icon(Icons.radio_button_off, color: theme.lightButtonIconsColor),
          onTap: (){
            setState(() {
              theme.setDarkThemeDefault();
            });
          },
        ),

        Padding(padding: EdgeInsets.all(screenSize.height*0.03)),

        Text("Exemplo de visual da aplicação:", style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.05),),

        Padding(padding: EdgeInsets.all(screenSize.height*0.01)),

        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                color: theme.buttonColor,
                borderRadius: BorderRadius.circular(40)
            ),
            child: Center(child: Text("Um Botão", style: TextStyle(color: theme.iconsColor, fontSize: screenSize.width*0.1),)),
          ),
        ),

        Padding(padding: EdgeInsets.all(screenSize.height*0.01)),

        Column(children: [
              Container(
                height: screenSize.height*0.06,
                color: theme.buttonColor,
                child: Row(children: [
                  Text('  <-  Uma página', style: TextStyle(color: Colors.white, fontSize: screenSize.width*0.04),),
                ],)
              ),
        ],),

        Padding(padding: EdgeInsets.all(screenSize.height*0.01)),

        Container(
            height: screenSize.height*0.07,
            color: theme.buttonColor,
            child: Row(children: [
              const Icon(Icons.home, color: Colors.white),
              Padding(padding: EdgeInsets.only(left: screenSize.width*0.1)),
              const Icon(Icons.add_box_rounded, color: Colors.white),
              Padding(padding: EdgeInsets.only(left: screenSize.width*0.1)),
              const Icon(Icons.square_outlined, color: Colors.white),
              Padding(padding: EdgeInsets.only(left: screenSize.width*0.1)),
              const Icon(Icons.square_outlined, color: Colors.white),
            ],)
        ),

      ],),
    );
  }
}
