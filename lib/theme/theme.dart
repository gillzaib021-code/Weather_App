import 'package:flutter/material.dart';

final lighttheme=ThemeData(brightness: Brightness.light,
primaryColor: Color(0xFF1a1a16),
colorScheme: ColorScheme.light(
    secondary: Colors.white,
    primary: Color.fromRGBO(26, 255, 255, 255),
    surface: Colors.white30,
    onPrimary: Colors.white70,
),
);
final darktheme=ThemeData(brightness: Brightness.dark,
primaryColor: Color(0xFFFAFAFA),
colorScheme: ColorScheme.dark(
    primary: Color.fromRGBO(31, 0, 0, 0),
     secondary: Colors.black,
     surface: Colors.black38,
      onPrimary: Colors.black,

)

);