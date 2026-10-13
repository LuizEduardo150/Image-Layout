import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/application_theme_pers.dart';

class HelpEditorLayout extends StatelessWidget {
  const HelpEditorLayout({super.key});

  @override
  Widget build(context) {
    final theme = Provider.of<AppThemePers>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      
      backgroundColor: theme.bkgColor,

      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text("Manual Editor de Layouts", style: TextStyle(fontSize: screenSize.width*0.05)),
        backgroundColor: theme.buttonColor,
      ),

      body: ListView(
        padding: const EdgeInsets.only(right: 10, left: 10),
        
        children: [
          Text(
            "O editor de layouts permite a criação de layouts personalizados, através da inserção manual de espaços destinados a imagens "
            "informando as dimensões desejadas."
            "\nOs layouts criados podem ser salvos para serem usados novamente em um outro documento futuro."
            '\n\nO editor de layout consiste na área de exibição em tempo real do layout sendo criado e uma barra inferior, que possui as funções do editor. '
            'Essas funções são:',
            softWrap: true,
            style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor),
            textAlign: TextAlign.justify,
          ),
          
          const Padding(padding: EdgeInsets.all(15)),
          
          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.add_box_sharp, color: Colors.white,))
            ),
            
            const Padding(padding: EdgeInsets.only(right: 10)),

            Text("ADICIONAR ESPAÇO\nPARA IMAGEM", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ]),
          
          Text(
            'Essa função adiciona um espaço destinado a uma imagem, de acordo com a dimensão informada.',
            
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),
          
          const Padding(padding: EdgeInsets.all(15)),
          
          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.space_dashboard_sharp, color: Colors.white,))
            ),

            const Padding(padding: EdgeInsets.only(right: 10)),
            
            Text("DEFINIR ESPAÇAMENTO", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ]),
          
          Text(
            'Essa função define espaçamentos: Horizontal e Vertical, entre um espaço de foto e outro.'
            '\nO espaçamento pode ser alterado durante a edição para obter diferentes espaçamentos. Para isso, '
            'basta alterá-los antes de adicionar um novo espaço.\n(Espaçamento Horizontal não aplicará o espaçamento na esquerda '
            'de um espaço caso seja o primeiro da linha, também não aplicará espaçamento na direita caso seja o último da linha)',
              style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
            ),
          
          const Padding(padding: EdgeInsets.all(15)),
          
          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_downward_outlined, color: Colors.white,))
            ),
            
            const Padding(padding: EdgeInsets.only(right: 10)),

            Text("IR PARA PRÓXIMA LINHA", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ]),
          
          Text(
            'Essa função faz uma quebra de linha, mesmo que ainda tenha espaço livre na linha atual.'
            '\n(A quebra de linha obedece o espaçamento vertical informado)',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),

          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.undo, color: Colors.white,))
            ),
            
            const Padding(padding: EdgeInsets.only(right: 10)),

            Text("DESFAZER UMA AÇÃO", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ],),
          
          Text(
            'Essa função retorna a configuração anterior do layout.'
            '\n(Use com cuidado, pois essa ação é irreversível. Será solicitado antes uma confirmação)',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),
          
          const Padding(padding: EdgeInsets.all(15)),
          
          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.delete_forever_rounded, color: Colors.white,))
            ),
            
            const Padding(padding: EdgeInsets.only(right: 10)),
            
            Text("LIMPAR TODO DOCUMENTO", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ]),
          
          Text('Essa função deleta todo layout construído.\n(Use com cuidado, uma vez deletado, não terá como desfazer a ação. '
          'Antes de acionar a função, será solicitado uma confirmação, se realmente deseja deletar tudo)',
              style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),
          
          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.save, color: Colors.white,))
            ),
            
            const Padding(padding: EdgeInsets.only(right: 10)),

            Text("SALVAR LAYOUT", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ]),

          Text(
            'Salva o layout criado na galeria de layouts do aplicativo, para ser utilizado quando desejado para criar novas fotos.',
              style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(30)),
          
          Text('Na parte superior da tela também há botões de opções, e são eles:',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(10)),
          
          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.home, color: Colors.white,))
            ),
            
            const Padding(padding: EdgeInsets.only(right: 10)),

            Text("Voltar Para Home", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ]),

          Text('Permite voltar para a tela inicial do aplicativo.\n(Você deverá confirmar a escolha)',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(10)),
          
          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios_sharp, color: Colors.white,))
            ),
          
            const Padding(padding: EdgeInsets.only(right: 10)),

            Text("Próxima Página", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ]),
          
          Text(
            'Vai para a página de inserção de imagens. Será sempre perguntado se deseja prosseguir com a ação, '
            'uma vez que deve-se certificar que o layout foi salvo caso seja de interesse usar novamente esse '
            'layout mais tarde.\nCaso não seja necessário salvar, basta pular para a inserção de imagens.'
            '\n(Essa opção apenas fica disponível quando há pelo menos um espaço de imagem)',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(10)),
          
          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: const Icon(Icons.menu, color: Colors.white),
            ),
           
            const Padding(padding: EdgeInsets.only(right: 10)),
            
            Text("Configuração da página", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ]),

          Text('Abre um menu para configurar a unidade de medida a ser usada no editor. Também é possível ver as especificações do layout.',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon: Text("Voltar para editor", style: TextStyle(fontSize: screenSize.width*0.08, decoration: TextDecoration.underline, color: theme.secondFontColor)),
          ),

          const Padding(padding: EdgeInsets.all(30))
        
        ]),
    );
  }
}

