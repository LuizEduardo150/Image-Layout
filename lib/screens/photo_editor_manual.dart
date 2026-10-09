import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_layout/application_theme_pers.dart';

class HelpEditorFotos extends StatelessWidget {
  const HelpEditorFotos({super.key});

  @override
  Widget build(context) {
    final Size telaTamanho = MediaQuery.of(context).size;
    final tema = Provider.of<TemaAplicacao>(context);

    return Scaffold(
      backgroundColor: tema.corDefundo,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("Manual Inserir Fotos"),
        elevation: 0.0,
        backgroundColor: Colors.black87,
      ),
      body: ListView(
        padding: const EdgeInsets.only(right: 10, left: 10),
        children: [
          Text("\t\t\t\tA função de inserir fotos, permite a inserção de fotos, ocupando os epaços para fotos dos layouts.",
            softWrap: true,
            style: TextStyle(fontSize: telaTamanho.width*0.06, color: tema.corDaFonte),
            textAlign: TextAlign.justify,
          ),
          Text('\t\t\t\t O formato do layout usado pode ser os padrões do aplicativo, ou então criados e salvos em seu aparelho.',
            softWrap: true,
            style: TextStyle(fontSize: telaTamanho.width*0.06, color: tema.corDaFonte),
            textAlign: TextAlign.justify,
          ),
          Text('\t\t\t\tO preenchimento do documento é feito da esquerda para a direita, do início ao fim, de forma automatica.',
            softWrap: true,
            style: TextStyle(fontSize: telaTamanho.width*0.06, color: tema.corDaFonte),
            textAlign: TextAlign.justify,
          ),

          const Padding(padding: EdgeInsets.all(15)),

          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: tema.corBotoes),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.space_dashboard_outlined, color: Colors.white,))
            ),
            Text("MUDAR COR DE FUNDO", style: TextStyle(fontSize: telaTamanho.width*0.04, color: tema.corDaFonte)),
          ],),
          Text('Essa função muda a cor de fundo de seu documento em edição.'
              '\nNote que essa função só fará efeito, caso exista em seu layout, espaços livres, por exemplo nos casos em que há espaçamento entre imagens, ou espaços não aproveitados.',
            style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),

          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: tema.corBotoes),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.add_photo_alternate, color: Colors.white,))
            ),
            Text("ADICIONAR IMAGEM", style: TextStyle(fontSize: telaTamanho.width*0.06, color: tema.corDaFonte)),
          ],),
          Text('- Essa função adiciona uma imagem no espaço atual\n- Quando acabarem os espaços, o botão ficará desabilitado.',
            style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),

          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: tema.corBotoes),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.format_color_fill_outlined, color: Colors.white,))
            ),
            Text("PINTAR ESPAÇO\nATUAL", style: TextStyle(fontSize: telaTamanho.width*0.06, color: tema.corDaFonte)),
          ],),
          Text('- Essa função permite pular um espaço de imagem, adicionado uma cor sólida no local onde era destinado a uma fotografia.\n-Pode ser colorido usando a cor de fundo atual do documento, ou com uma cor escolhida do mural de cores.',
            style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),

          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: tema.corBotoes),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.undo, color: Colors.white,))
            ),
            Text("DESFAZER UMA AÇÃO", style: TextStyle(fontSize: telaTamanho.width*0.05, color: tema.corDaFonte)),
          ],),
          Text('- Essa função retorna a configuração anterior do documento.',
            style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),

          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: tema.corBotoes),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.delete_forever_rounded, color: Colors.white,))
            ),
            Text("LIMPAR TODO DOCUMENTO", style: TextStyle(fontSize: telaTamanho.width*0.04, color: tema.corDaFonte)),
          ],),
          Text('- Essa função deleta todas as imagens inseridas.\n- Use com cuidado, uma vez deletadas, não terá possível desfazer a ação.\n- Antes de acionar a função, será solicitado uma confirmação, se realmente deseja deletar tudo.',
            style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(15)),

          Row(children: [
            Container(height: 35, width: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: tema.corBotoes),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.save, color: Colors.white,))
            ),
            Text("SALVAR IMAGEM\nNA GALERIA", style: TextStyle(fontSize: telaTamanho.width*0.06, color: tema.corDaFonte)),
          ],),

          const Padding(padding: EdgeInsets.all(30)),
          Text('Na parte superior da tela também há botões de opções, e são eles:',
            style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.width*0.06),
          ),
          const Padding(padding: EdgeInsets.all(15)),
          Row(children: [
            ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                  backgroundColor: tema.corBotoes,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.all(telaTamanho.height*0.01)
              ),
              child: Icon(Icons.menu, size: telaTamanho.height*0.035)

            ),
            Text("CONFIGURAÇÕES\nDO EDITOR", style: TextStyle(fontSize: telaTamanho.width*0.06, color: tema.corDaFonte)),
          ],),
          Text('\t\tEssa função permite você configurar o comportamento da ferramenta de recorte de imagem no momento em que é escolhida uma imagem da galeria para ser adicionado ao documento.',
            style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.width*0.06),
          ),
          Text('\t\tAo abrir o menu de opções, pode-se escolher como a área de seleção do recorte de imagem se comporta na opção: “Proporção do recorte”, podendo assumir os valores: “Travada” e “Livre”. Você poderá entender melhor o comportamento das mudanças no menu de informação da página de configuração.',
            style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.width*0.06),
          ),
          Text('\t\tA outra opção é referente a qualidade da imagem que vai ser aberta da galeria para ser adicionada ao documento. Lembrando que quanto maior a qualidade escolhida, maior pode ser o uso dos recursos de seu aparelho.',
            style: TextStyle(color: tema.corDaFonte, fontSize: telaTamanho.width*0.06),
          ),

          const Padding(padding: EdgeInsets.all(30)),

          IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Text("Voltar para editor", style: TextStyle(
                fontSize: telaTamanho.width*0.08,
                decoration: TextDecoration.underline,
                color: tema.corFonteSecundaria,
              )
            ),
          )
        ],),
    );
  }
}