import 'package:flutter/material.dart';

final _primaryColor = Colors.teal.shade300;

final _elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: _primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
    minimumSize: const Size(64, 64),
  ),
);

final appTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(seedColor: _primaryColor),
).copyWith(
  primaryColor: _primaryColor,
  scaffoldBackgroundColor: Colors.white,
  elevatedButtonTheme: _elevatedButtonThemeData,
);

final appDarkTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primaryColor,
    brightness: Brightness.dark,
    primary: _primaryColor,
  ),
).copyWith(
  primaryColor: _primaryColor,
  elevatedButtonTheme: _elevatedButtonThemeData,
);
