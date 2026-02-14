import 'package:flutter/material.dart';

class CustomerTheme {
 
   
  static const Color cream = Color.fromARGB(255, 226, 226, 226);
  static const Color sand  = Color(0xFFCCC5B9);
  static const Color dark1 = Color(0xFF403D39);
  static const Color dark2 = Color(0xFF252422);
  static const Color accent = Color(0xFFEB5E28);

  // 🌕 Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,

    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: accent, //use this
      onPrimary: Colors.white, //usethis

      secondary: Colors.grey, //use this
      onSecondary: dark2, //use this

      background: Colors.white,
      onBackground: dark1,

      surface: Colors.white,
      onSurface: dark2,

      error: Colors.red,
      onError: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: accent,
      foregroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF252422)),
      titleLarge: TextStyle(
        color: Color(0xFF252422),
        fontWeight: FontWeight.bold,
      ),
    ),
  );


  static final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

  scaffoldBackgroundColor: dark2,

  colorScheme: const ColorScheme(
    brightness: Brightness.dark,

    // Same semantic usage as light theme
    primary: accent,            // use this
    onPrimary: Colors.white,    // use this

    secondary: dark2,             // use this (neutral secondary)
    onSecondary: dark2,          // use this (dark text/icons)

    background: dark2,
    onBackground: cream,

    surface: dark1,
    onSurface: cream,

    error: Colors.red,
    onError: Colors.white,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: dark1,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 1,
  ),

  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: cream),
    titleLarge: TextStyle(
      color: cream,
      fontWeight: FontWeight.bold,
    ),
  ),
);

}