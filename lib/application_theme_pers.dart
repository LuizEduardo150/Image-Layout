import 'package:flutter/material.dart';

class AppThemePers extends ChangeNotifier{

  Color _bkgColor = const Color.fromRGBO(130, 205, 202, 1);
  Color _buttonColor = const Color.fromRGBO(65, 179, 163, 1);
  Color _fontColor = const Color.fromRGBO(30, 90, 90, 1);
  Color _buttonIconsColor = const Color.fromRGBO(0, 80, 70, 1);
  Color _lightButtonIconsColor = const Color.fromRGBO(0, 58, 60, 1);
  Color _secondaryFontColor = Colors.black54;
  String _currentTheme = 'claro';

  Color get bkgColor => _bkgColor;
  Color get buttonColor => _buttonColor;
  Color get fontColor => _fontColor;
  Color get iconsColor => _buttonIconsColor;
  Color get secondFontColor => _secondaryFontColor;
  Color get lightButtonIconsColor =>  _lightButtonIconsColor;
  String get currentTheme => _currentTheme;

  void setDarkTheme(){
    _bkgColor = const Color.fromRGBO(11, 12, 16, 1); //
    _buttonColor = const Color.fromRGBO(31, 40, 51, 1); //
    _fontColor = const Color.fromRGBO(197, 198, 199, 1); //
    _buttonIconsColor = const Color.fromRGBO(69, 162, 158, 1);
    _lightButtonIconsColor =  const Color.fromRGBO(102, 252, 241, 1);
    _secondaryFontColor = Colors.white54;
    _currentTheme = 'escuro';
    notifyListeners();
  }

  void setLightTheme(){
    _bkgColor = const Color.fromRGBO(130, 205, 202, 1);
    _buttonColor = const Color.fromRGBO(65, 179, 163, 1);
    _fontColor = const Color.fromRGBO(30, 90, 90, 1);
    _buttonIconsColor = const Color.fromRGBO(0, 80, 70, 1);
    _lightButtonIconsColor = const Color.fromRGBO(0, 58, 60, 1);
    _secondaryFontColor = Colors.black54;
    _currentTheme = 'claro';
    notifyListeners();
  }

  void setLightThemeDefault(){
    _bkgColor = const Color.fromRGBO(200, 200, 255, 1);
    _buttonColor = const Color.fromRGBO(100, 100, 225, 1);
    _fontColor = Colors.black;
    _buttonIconsColor = const Color.fromRGBO(0, 0, 100, 1);
    _lightButtonIconsColor = const Color.fromRGBO(0, 0, 200, 1);
    _secondaryFontColor = Colors.black54;
    _currentTheme = 'claropadrao';
    notifyListeners();
  }

  void setDarkThemeDefault(){
    _bkgColor = const Color.fromRGBO(50, 50, 50, 1);
    _buttonColor = const Color.fromRGBO(10, 10, 10, 1);
    _fontColor = Colors.white;
    _buttonIconsColor = const Color.fromRGBO(255, 255, 255, 1);
    _lightButtonIconsColor = const Color.fromRGBO(200, 200, 200, 1);
    _secondaryFontColor = Colors.white54;
    _currentTheme = 'escuropadrao';
    notifyListeners();
  }

}



