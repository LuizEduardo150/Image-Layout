import 'package:flutter/material.dart';

class TemaAplicacao extends ChangeNotifier{

  Color _corFundo = const Color.fromRGBO(130, 205, 202, 1);
  Color _corBotoes = const Color.fromRGBO(65, 179, 163, 1);
  Color _corFonte = const Color.fromRGBO(30, 90, 90, 1);
  Color _corIconesBotoes = const Color.fromRGBO(0, 80, 70, 1);
  Color _corIconeBotoesClaro = const Color.fromRGBO(0, 58, 60, 1);
  Color _corFonteSecundaria = Colors.black54;
  String _temaAtual = 'claro';

  Color get corDefundo => _corFundo;
  Color get corBotoes => _corBotoes;
  Color get corDaFonte => _corFonte;
  Color get corDosIcones => _corIconesBotoes;
  Color get corFonteSecundaria => _corFonteSecundaria;
  Color get corIconeBototesClaro => _corIconeBotoesClaro;
  String get temaAtual => _temaAtual;

  void setTemaEscuro(){
    _corFundo = const Color.fromRGBO(11, 12, 16, 1); //
    _corBotoes = const Color.fromRGBO(31, 40, 51, 1); //
    _corFonte = const Color.fromRGBO(197, 198, 199, 1); //
    _corIconesBotoes = const Color.fromRGBO(69, 162, 158, 1);
    _corIconeBotoesClaro =  const Color.fromRGBO(102, 252, 241, 1);
    _corFonteSecundaria = Colors.white54;
    _temaAtual = 'escuro';
    notifyListeners();
  }

  void setTemaClaro(){
    _corFundo = const Color.fromRGBO(130, 205, 202, 1);
    _corBotoes = const Color.fromRGBO(65, 179, 163, 1);
    _corFonte = const Color.fromRGBO(30, 90, 90, 1);
    _corIconesBotoes = const Color.fromRGBO(0, 80, 70, 1);
    _corIconeBotoesClaro = const Color.fromRGBO(0, 58, 60, 1);
    _corFonteSecundaria = Colors.black54;
    _temaAtual = 'claro';
    notifyListeners();
  }

  void setTemaClaroPadrao(){
    _corFundo = const Color.fromRGBO(200, 200, 255, 1);
    _corBotoes = const Color.fromRGBO(100, 100, 225, 1);
    _corFonte = Colors.black;
    _corIconesBotoes = const Color.fromRGBO(0, 0, 100, 1);
    _corIconeBotoesClaro = const Color.fromRGBO(0, 0, 200, 1);
    _corFonteSecundaria = Colors.black54;
    _temaAtual = 'claropadrao';
    notifyListeners();
  }

  void setTemaEscuroPadrao(){
    _corFundo = const Color.fromRGBO(50, 50, 50, 1);
    _corBotoes = const Color.fromRGBO(10, 10, 10, 1);
    _corFonte = Colors.white;
    _corIconesBotoes = const Color.fromRGBO(255, 255, 255, 1);
    _corIconeBotoesClaro = const Color.fromRGBO(200, 200, 200, 1);
    _corFonteSecundaria = Colors.white54;
    _temaAtual = 'escuropadrao';
    notifyListeners();
  }

}



