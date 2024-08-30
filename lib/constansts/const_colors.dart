import 'package:flutter/material.dart';

class ConstColors {
  //primary color
  static const Color primaryColor = Color(0xFF6F47EB);
  static const Color secondaryColor = Color(0xFFEEE9FD);
  static const Color grey = Color(0xFFEDEDED);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color darkGrey = Color(0xFF595D61);
  static const Color textColor = Color(0xFFC5C5C5);
  static const Color lightred = Color(0xFFFBE4E1);
  static const Color black1 = Colors.black;
  static const Color red = Color.fromARGB(255, 255, 0, 0);
  static const shadowColor = Color.fromARGB(255, 196, 196, 196);
  static const Color countColor = Color(0xFF800080);
  static const Color black = Colors.black;
  static const Color backgroundColor = Colors.white;
}

//Light Theme
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF6F47EB),
  onPrimary: Color(0xFFEEE9FD),
  primaryContainer: Color.fromARGB(255, 224, 224, 224),
  onPrimaryContainer:ConstColors.grey,
  secondary: Color(0xFFEDEDED),
  onSecondary: Color(0xFFF9F9F9),
  secondaryContainer: Color(0xFF595D61),
  onSecondaryContainer: Color(0xFFC5C5C5),
  tertiary: Colors.black,
  error: Color.fromARGB(255, 255, 0, 0),
  onError: Color(0xFFEEE9FD),
  tertiaryContainer: Color(0xFFEEE9FD),
  surface: Color(0xFFF9F9F9),
  onSurface: Color(0xFF1C1B1F),
  shadow: Color.fromARGB(255, 196, 196, 196),
  surfaceTint: Colors.white,
);

//Dark Theme 
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF6F47EB),
  onPrimary: Color(0xFFEEE9FD),
  primaryContainer: Color(0xFF222223),
  onPrimaryContainer: Color.fromARGB(255, 48, 46, 46),
  secondary: Colors.white,
  onSecondary: Colors.white,
  secondaryContainer: Colors.white,
  onSecondaryContainer: Colors.white,
  tertiary: Color(0xFFF9F9F9),
  tertiaryContainer: Color.fromARGB(255, 64, 0, 255),
  error: Color.fromARGB(255, 255, 0, 0),
  onError: Colors.black54,
  surface: Color(0xFF333639),
  onSurface: Color.fromARGB(255, 201, 8, 8),
  shadow: Color.fromARGB(255, 100, 100, 100),
  surfaceTint: Colors.black,
);
