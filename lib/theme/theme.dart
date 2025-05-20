import 'package:flutter/material.dart';

final appTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF0367A6),         // Safiirin sininen
    secondary: Color(0xFF2AA876),       // Safiirin vihreä
    surface: Colors.white,
    background: Color(0xFFF5F9FC),      // Vaalean sinertävä tausta
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: Color(0xFFF5F9FC),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0367A6),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.all(8),
    color: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFDEE8F2)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFDEE8F2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF0367A6), width: 1.5),
    ),
    hintStyle: TextStyle(color: Colors.grey[500]),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFF2AA876),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(fontSize: 16),
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 14),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  ),
);

