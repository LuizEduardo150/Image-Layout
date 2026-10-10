import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:image_layout/application_theme_pers.dart';

class ErrorAlertDialogBox extends StatelessWidget{
  final String text;
  const ErrorAlertDialogBox({super.key, required this.text});

  @override
  Widget build(BuildContext context){

    final theme = Provider.of<AppThemePers>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return AlertDialog(
      scrollable: true,
      backgroundColor: theme.buttonColor,
      
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cancel, color: Colors.red, size: 50),
          Text('     ERRO!', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red))
        ],
      ),
      titlePadding: const EdgeInsets.all(10),
      
      content: Text(
        text,
        style: TextStyle(fontSize: screenSize.height*0.04, color: theme.fontColor),
        textAlign: TextAlign.left,
        softWrap: true,
      ),
        
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.buttonColor,
              foregroundColor: theme.lightButtonIconsColor
            ),
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text("sair", style: TextStyle(fontSize: 30))
            
          )
      ],
    );
  }
}
