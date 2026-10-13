import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/application_theme_pers.dart';

class HelpEditorFotos extends StatelessWidget {
  const HelpEditorFotos({super.key});

  @override
  Widget build(context) {
    final Size screenSize = MediaQuery.of(context).size;
    final theme = Provider.of<AppThemePers>(context);

    return Scaffold(
      backgroundColor: theme.bkgColor,
      
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("Manual Inserir Fotos"),
        elevation: 0.0,
        backgroundColor: Colors.black87,
      ),
      
      body: ListView(
        padding: const EdgeInsets.only(right: 10, left: 10),
        children: [
          
          Text(
            "A função de inserir fotos permite a inserção de fotos da galeria, nos epaços livres do layouts."
            "\nO layout a ser utilizado pode ser criado na hora ou utilizar um já salvo em seu aparelho."
            "\nO preenchimento do documento é feito da esquerda para a direita, do início ao fim, de forma automatica.",
            softWrap: true,
            style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor),
            textAlign: TextAlign.justify,
          ),

          const Padding(padding: EdgeInsets.all(15)),

          Row(children: [
            Container(
              height: 35, width: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
              child: IconButton(onPressed: (){}, icon: const Icon(Icons.space_dashboard_outlined, color: Colors.white,))
            ),

            Padding(padding: EdgeInsetsGeometry.only(right: 10)),
            
            Text("MUDAR COR DE FUNDO", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ]),

          Text('Essa função muda a cor de fundo nos espaçamentos entre uma foto e outra.'
              '\nNote que essa função só fará efeito caso exista em seu layout espaçamento entre imagens ou borda em todo documento.',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),

          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.add_photo_alternate, color: Colors.white,))
            ),

            Padding(padding: EdgeInsetsGeometry.only(right: 10)),

            Text("ADICIONAR IMAGEM", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ]),
          
          Text('Essa função adiciona uma imagem no espaço atual.\n(Quando acabarem os espaços, o botão ficará desabilitado)',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),

          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.format_color_fill_outlined, color: Colors.white,))
            ),
          
            Padding(padding: EdgeInsetsGeometry.only(right: 10)),

            Text("PINTAR ESPAÇO\nATUAL", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ]),

          Text(
            'Ocupa um espaço de imagem com apenas uma cor sólida.'
            '\nPode ser colorido usando a cor de fundo atual do documento ou com uma cor escolhida do mural de cores.',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),

          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.undo, color: Colors.white,))
            ),
            Padding(padding: EdgeInsetsGeometry.only(right: 10)),

            Text("DESFAZER UMA AÇÃO", style: TextStyle(fontSize: screenSize.width*0.05, color: theme.fontColor)),
          ]),
          
          Text('Essa função retorna a configuração anterior do documento.',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),

          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.delete_forever_rounded, color: Colors.white,))
            ),
            
            Padding(padding: EdgeInsetsGeometry.only(right: 10)),

            Text("LIMPAR TODO DOCUMENTO", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ]),

          Text(
            'Essa função deleta todas as imagens inseridas.\nUse com cuidado, pois uma vez deletadas, não será possível desfazer essa ação.'
            '\n(Ao clicar nessa função, será solicitado uma confirmação)',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),

          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.save, color: Colors.white,))
            ),
            
            Padding(padding: EdgeInsetsGeometry.only(right: 10)),

            Text("SALVAR IMAGEM\nNA GALERIA", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ]),

          Text(
            'Essa função salva a imagem montada em layout, na galeria do celular.'
            '\n(É possível continuar editando mesmo após clicar nessa opção)',
            
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),


          const Padding(padding: EdgeInsets.all(30)),

          Text('Na parte superior da tela também há botões de opções, e são eles:',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),
          
          Row(children: [
            ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                  backgroundColor: theme.buttonColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.all(screenSize.height*0.01)
              ),
              child: Icon(Icons.menu, size: screenSize.height*0.035)
            ),
            
            Padding(padding: EdgeInsets.only(right: 10)),

            Text("CONFIGURAÇÕES\nDO EDITOR", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ]),
          
          Text(
            'Essa função permite você configurar o comportamento da ferramenta de recorte de imagem.'
            '\nPode ser definido se o recorte da imagem possui proporção “Travada” ou “Livre”.'
            '\nA outra opção é a qualidade da imagem a ser adicionada no documento.'
            '\n(Lembre que quanto maior a qualidade escolhida, maior será o uso dos recursos de seu aparelho.',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),
          
          const Padding(padding: EdgeInsets.all(30)),

          IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Text("Voltar para editor", style: TextStyle(
                fontSize: screenSize.width*0.08,
                decoration: TextDecoration.underline,
                color: theme.secondFontColor,
              )
            )
          ),

          const Padding(padding: EdgeInsets.all(30)),

        ])
    );
  }
}