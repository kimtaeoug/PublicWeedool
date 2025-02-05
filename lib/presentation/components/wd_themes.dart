import 'package:flutter/material.dart';

class WDThemes {
  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: Colors.white,
        splashColor: Colors.white,
        appBarTheme: _appBarTheme,
        brightness: Brightness.light,
      );

  static ThemeData get dartTheme => ThemeData(
        splashColor: Colors.white,
        brightness: Brightness.dark,
      );
  static const AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
  );
}
