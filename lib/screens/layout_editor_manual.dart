import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/application_theme_pers.dart';

class HelpEditorLayout extends StatelessWidget {
  const HelpEditorLayout({super.key});

  @override
  Widget build(context) {
    final theme = Provider.of<AppThemePers>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text("Manual Editor de Layouts", style: TextStyle(fontSize: screenSize.width*0.05)),
        backgroundColor: theme.buttonColor,
      ),
      backgroundColor: theme.bkgColor,
      body: ListView(
        padding: const EdgeInsets.only(right: 10, left: 10),
        children: [
          Text("\t\t\t\tO editor de layouts permite a criação de um layout personalizado, inserindo espaços para imagens de acordo com a configuração escolhida. Layouts criados podem ser salvos para serem usados novamente em um outro documento futuro.",
            softWrap: true,
            style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor),
            textAlign: TextAlign.justify,
          ),
          Text("\t\t\t\tQuando a edição da configuração de layout estiver pronta, haverá duas opções: Salvar o layout para usar mais tarde, ou salvar e também inserir imagens no layout. Caso a segunda opção for a escolhida, assim que terminar de salvar a configuração de layout, a aplicação será movida para a tela de inserção de imagens nos espaços de imagens do layout.",
            softWrap: true,
            style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor),
            textAlign: TextAlign.justify,
          ),
          Text('\t\t\t\tO editor de layout consiste na área de exibição em tempo real do layout sendo criado e uma barra na parte inferior da página, que possui as funções a serem usadas para criação do layout. Essas funções são:',
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
            Text("ADICIONAR ESPAÇO\nPARA IMAGEM", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ],),
          Text('- Essa função adiciona um espaçamento entre linhas.\n- O espaçamento pode ser alterado durante a edição, para obter diferentes espaçamentos, basta alterá-lo antes de adicionar um novo espaço, mas só será aplicado o espaçamento no momento que for necessário ou solicitado uma quebra de linha.',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),
          const Padding(padding: EdgeInsets.all(15)),
          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.space_dashboard_sharp, color: Colors.white,))
            ),
            Text("DEFINIR ESPAÇAMENTO", style: TextStyle(fontSize: screenSize.width*0.04, color: theme.fontColor)),
          ],),
          Text('- Essa função define espaçamentos: Horizontal e Vertical entre um espaço de foto e outro.\n- Os espaçamentos podem ser alterados durante a edição, para obter diferentes espaçamentos, basta alterá-los antes de adicionar um novo espaço.\n- Espaçamento Horizontal não aplicará o espaçamento na esquerda de um espaço caso seja o primeiro da linha, e não aplicará espaçamento na direita caso seja o último da linha.',
              style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
            ),
          const Padding(padding: EdgeInsets.all(15)),
          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_downward_outlined, color: Colors.white,))
            ),
            Text("IR PARA PRÓXIMA LINHA", style: TextStyle(fontSize: screenSize.width*0.04, color: theme.fontColor)),
          ],),
          Text('- Essa função faz uma quebra de linha, mesmo que ainda tenha espaços vazios na linha atual para adicionar mais espaços para fotos no layout.\n- A quebra de linha obedece o espaçamento vertical informado.',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),

          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.undo, color: Colors.white,))
            ),
            Text("DESFAZER UMA AÇÃO", style: TextStyle(fontSize: screenSize.width*0.04, color: theme.fontColor)),
          ],),
          Text('- Essa função retorna a configuração anterior do layout.',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),
          const Padding(padding: EdgeInsets.all(15)),
          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.delete_forever_rounded, color: Colors.white,))
            ),
           Text("LIMPAR TODO DOCUMENTO", style: TextStyle(fontSize: screenSize.width*0.04, color: theme.fontColor)),
          ],),
          Text('- Essa função deleta todas as modificações feitas no layout.\n- Use com cuidado, uma vez deletado, não terá como desfazer a ação.\n- Antes de acionar a função, será solicitado uma confirmação, se realmente deseja deletar tudo.',
              style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),
          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.save, color: Colors.white,))
            ),
            Text("SALVAR LAYOUT", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ],),

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
            Text("Voltar Para Home", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ],),
          Text('Permite voltar para a tela inicial do aplicativo. Você deverá confirmar a escolha, caso deseje voltar mesmo.',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(10)),
          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios_sharp, color: Colors.white,))
            ),
            Text("Próxima Página", style: TextStyle(fontSize: screenSize.width*0.06, color: theme.fontColor)),
          ],),
          Text('Vai para a página de inserção de imagens. Será sempre perguntado se deseja prosseguir com a ação, uma vez que deve-se certificar que o layout foi salvo caso seja de interesse usar novamente essa configuração de layout mais tarde.\nCaso não seja necessário salvar, basta pular para a inserção de imagens.\nEssa opção apenas fica disponível quando há pelo menos um espaço de imagem.',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(10)),
          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: theme.buttonColor),
                child: const Icon(Icons.menu, color: Colors.white),
            ),
            Text("Configuração da página", style: TextStyle(fontSize: screenSize.width*0.04, color: theme.fontColor)),
          ],),
          Text('Abre um menú, onde pode ser escolhida a unidade de medida sendo usada no editor, e também é possível ver as configurações do editor e do layout sendo criado',
            style: TextStyle(color: theme.fontColor, fontSize: screenSize.width*0.06),
          ),

          IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon: Text("Voltar para editor", style: TextStyle(fontSize: screenSize.width*0.08, decoration: TextDecoration.underline, color: theme.secondFontColor)),
          )
        ],),
    );
  }
}

