# image_layout (BR)
Aplicativo para Android utilizando o framework Flutter, para criação de layouts
de fotos personalizadas. Esse programa foi desenvolvido como um trabalho de faculdade
e continuado a fim de resolver uma necessidade pessoal.

Esse aplicativo resolve problemas relacionados a impressão de fotos em uma mesma folha, as soluções atuais  disponibilizam layouts predefinidos para inserir as imagens em documento único, que podem não ter o layout com a quantidade de espaços desejado, além de não permitirem o recorte das imagens inseridas. Dado esse problema, foi desenvolvido esse aplicativo, permitindo criar um layout para gerar um documento único com várias fotos, e reutilizar esse layout sempre que desejado, salvando-o na galeria de layouts do app.

A criação do layout é feita adicionando espaços destinados a imagens em um documento vazio. A inserção é feita sempre com espaços retangulares com dimensões informadas pelo usuário, são inseridos sempre de cima para baixo, da esquerda para direita. O primeiro espaço de imagem de uma linha define a altura recomendada para a linha em questão. Adicionar espaços de imagens com altura inferior pode ser usado para gerar uma linha delimitada por uma imagem grande, e outras menores ocupando a mesma coluna, como no exemplo abaixo.
 
```
 _____________________________ 
|        |          |         |	      
|        |     2    |         |       
|   1    |----------|    4    |       
|        |     3    |         |       
|________|__________|_________|       
|        |          |         |	   
|        |     6    |    8    |
|   5    |----------|---------|
|        |     7    |    9    |
 --------|----------|--------- 

```

# image_layout (US)

An Android application built using the Flutter framework, designed for creating custom photo layouts. This program originated as a college project and was further developed to address a personal need.

The application solves issues related to printing multiple photos on a single sheet. Existing solutions typically offer only predefined layouts, which may not provide the desired number of slots and often lack the ability to crop the images being added. To overcome these limitations, this application was developed; it allows users to create custom layouts—generating a single document containing multiple photos—and save these layouts within the app’s gallery for future reuse.

Layouts are created by adding image placeholders to a blank document. These placeholders are rectangular, with dimensions specified by the user, and are added sequentially from top to bottom, left to right. The first image placeholder in a row determines the recommended height for that row. It is possible to add placeholders with a smaller height, allowing for a layout where a larger image defines the row, while smaller images occupy the same vertical space—as shown in the example below.

``` 
 _____________________________ 
|        |          |         |	      
|        |     2    |         |       
|   1    |----------|    4    |       
|        |     3    |         |       
|________|__________|_________|       
|        |          |         |	   
|        |     6    |    8    |
|   5    |----------|---------|
|        |     7    |    9    |
 --------|----------|--------- 

```

## Informações / Information

>> development environment (ambiente de desenvolvimento):
 - Flutter 3.47.6 
 - Dart 3.13.5
 - DevTools 2.60.0
  Tested on Android 17 emulator (Testado em Android 17 emulator)

>> Dependencies (dependências):
 - image: ^4.10.1
 - image_cropper: ^12.2.1 # need manifest
 - image_picker: ^1.2.4
 - shared_preferences: ^2.5.6
 - provider: ^6.1.5+1
 - carousel_slider: ^5.1.2
 - saver_gallery: ^5.0.0
 - path_provider: ^2.1.6
 - flex_color_picker: ^4.0.0
 - permission_handler: ^13.0.2 # need gradle.properties and android/app/build.gradle
 - device_info_plus: ^13.3.0
 - material_ui: ^1.6.0

