import 'package:flutter/material.dart';

class AppConstants {
  static const double gridSize = 150.0;
  static const double mainAxisSpacing = 30.0;
  static const double crossAxisSpacing = 20.0;
  static const EdgeInsets padding =
      EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16);

  // keys
  static const kTestQuestion = 'kTestQuestion';
}


final lightTheme = ThemeData(
  colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: Colors.deepOrange,
        onSecondary: Colors.white,
      ),
);

final darkTheme = ThemeData.dark().copyWith(
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: Colors.blueGrey,
          onPrimary: Colors.white,
          secondary: Colors.blueGrey,
          onSecondary: Colors.white,
        ));
