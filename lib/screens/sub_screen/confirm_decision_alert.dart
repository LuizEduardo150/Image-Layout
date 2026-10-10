import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import 'package:image_layout/application_theme_pers.dart';

class ConfirmDecisionDialog extends StatelessWidget{
  final String text;
  final String subtext;
  final VoidCallback confirmFunction;
  const ConfirmDecisionDialog({super.key, required this.subtext, required this.text ,required this.confirmFunction});

  @override
  Widget build(context){
    final theme = Provider.of<AppThemePers>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return AlertDialog(
      scrollable: true,
      backgroundColor: theme.buttonColor,
      contentPadding: const EdgeInsets.all(5),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, color: Colors.amber, size: screenSize.height*0.05,),
          const Text("  Atenção", style: TextStyle(fontSize: 30, color: Colors.amber), textAlign: TextAlign.center),
        ],
      ),
      titlePadding: const EdgeInsets.all(10),
      
      content: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: theme.bkgColor),
        padding: EdgeInsets.only(left: screenSize.width*0.03, right: screenSize.width*0.03),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding: EdgeInsets.all(4)),
            Text(text,
              softWrap: true,
              style: TextStyle(fontSize: 20, color: theme.fontColor),
              textAlign: TextAlign.justify,
            ),
            const Padding(padding: EdgeInsets.all(4)),
            Text(subtext,
              softWrap: true,
              style: TextStyle(fontSize: 20, color: theme.fontColor),
            ),
            const Padding(padding: EdgeInsets.all(4)),
          ],
        )
      ),

        actions: [Row(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [

              ElevatedButton(onPressed: confirmFunction,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    backgroundColor: theme.buttonColor,
                    elevation: 0, // Removendo a sombra
                  ),
                  child: Text("SIM", style: TextStyle(fontSize: 18, color: theme.iconsColor)),
                ),

                const Padding(padding: EdgeInsets.only(right: 25)),
                
                ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    backgroundColor: theme.buttonColor,
                    elevation: 0, // Removendo a sombra
                  ),
                  child: Text("NÃO", style: TextStyle(fontSize: 18, color: theme.lightButtonIconsColor)),
                ),
            ]
        )],
        
    );
  }
}